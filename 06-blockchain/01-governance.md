## FS chain Governance

NeoFS uses it's own chain as a database to store meta-information about the network: the network map, audit results, containers, key mappings, network settings, and several supplementary things.

FS chain operates on the same principles as the mainnet -- there are no free transactions, the committee chooses the consensus nodes, etc. This structure provides a number of advantages. For example, one can use the same N3 tool stack to work with FS chain information.

To effectively work with FS chain, we need to solve the following problems:

* How can the mainnet committee control Inner Ring nodes and the consensus nodes of FS chain?

* How do Storage Nodes and Inner Ring nodes get FS chain \Gls{GAS} to send transactions?

NeoFS Governance model solves these problems with seven "Alphabet" FS chain contracts and the first seven Inner Ring nodes bound to those contracts, acting as the FS chain committee.

### Alphabet contracts

Alphabet contracts are seven smart contracts deployed in FS chain. They are named after the first seven [Glagolitic](https://en.wikipedia.org/wiki/Glagolitic_script) script letters: Az(Ⰰ), Buky(Ⰱ), Vedi(Ⰲ), Glagoli(Ⰳ), Dobro(Ⰴ), Yest(Ⰵ), Zhivete(Ⰶ). These contracts hold 100,000,000 FS chain \Gls{NEO} on their accounts (approximately 14,285,000 for each). By storing \Gls{NEO} on the contract accounts, we protect it from unauthorized use by malicious FS chain nodes. Contracts do not transfer NEO and use it to vote for FS chain \Glspl{validator} and to emit \Gls{GAS}.

### Alphabet Inner Ring nodes

Alphabet Inner Ring nodes are the first seven nodes in the Inner Ring list that are logically bound with one-to-one relation to the Alphabet contracts. They are the voting nodes, tasked with making the decisions in the NeoFS network. All other Inner Ring nodes take care of Data Audit, Storage Node attribute verification, and other technical tasks.

Being an Alphabet node implies running FS chain Consensus Node using the same key pair as the NeoFS Inner Ring node instance. Hence, an Alphabet node candidate must:

- Setup a NeoFS Inner Ring node instance
- Setup an FS chain full node using same key pair
- Register the same key in mainnet NeoFS Inner Ring candidates list
- Register the same key in FS chain committee candidates list

### Alphabet contracts invocation

Contracts cannot distribute the utility token or vote by themselves. To perform these operations, Inner Ring nodes invoke alphabet contract methods. An Alphabet Inner Ring node can invoke its corresponding contract only. One node invokes one contract.

![Inner Ring to Alphabet SC relation](pic/gov-scir)

Alphabetic contracts have hardcoded indexes. Contracts authenticate the method invoker by using the list of Inner Ring node keys from the Netmap Smart Contract. This scheme helps to limit malicious Alphabet Inner Ring node actions and makes network more resiliant to Inner Ring nodes losses.

![Alphabet SC invocation by Inner Ring nodes](pic/gov-invoke)

### Utility token distribution

Inner Ring nodes invoke `Emit()` method in corresponding alphabetical contracts. This method transfers all it's \Gls{NEO} to it's account, thereby producing utility token emission. Within the same invocation context, the contract transfers a share of the available \Gls{GAS} to all Inner Ring wallets. Each contract will keep the $\frac{1}{8}$'th part on its balance as an emergency reserve.

$$
InnerRingNodeEmission =
\boldsymbol{G} \cdot \frac{7}{8} \cdot \frac{1}{\boldsymbol{N}}
$$

$G$ - contract's \Gls{GAS} amount \
$N$ - length of Inner Ring list

After receiving \Gls{GAS}, the nodes of the Inner Ring can periodically transfer a share to all registered Storage nodes and use the received utility token for FS chain operations: change epochs, register new containers, save data audit results, etc.

Storage nodes have a limited supply of \Gls{GAS} to prevent malicious actions and DoS attacks. Depending on Storage Node activity and reputation records, it will receive a different utility token amount, normally enough to perform all required operations. FS chain GAS and mainnet GAS are different tokens, hence Storage Nodes don't spend rewards for internal operations and can't convert FS chain utility token into mainnet \Gls{GAS} or vice versa.

### Changing FS chain validators

Beforehand, Alphabet Inner Ring node candidates register validator keys in the list of candidates for the FS chain committee. When FS chain Netmap smart contract sends a notification regarding Inner Ring node list updates, Alphabet Inner Ring nodes invoke the `Vote([]keys)` method of all Alphabet smart contracts in order to gather signatures and then make them vote for the FS chain Committee. Each Alphabet contract votes for the keys proposed by sending `VotesPerKey` votes for each key. Normally, there is just one key per node, hence `N` equals `1`.

$$
VotesPerKey = \frac{\boldsymbol{A}}{\boldsymbol{N}}
$$

$A$ - contract's NEO amount \
$N$ - length of proposed keys list

### Changing the Inner Ring list

Inner Ring nodes follow a self-regulation process, allowing them to vote to substitute dead or malfunctioning nodes with new ones from the candidate list. Only Alphabet nodes prepare new Inner Ring node lists and vote for it, but all nodes listed there must confirm their participation via the same voting mechanism.

The voting procedure uses FS chain `Voting` smart contract, but the list of candidates is taken from mainnet NeoFS contract. When Inner Ring nodes agree on the updated list, it's submitted to the mainnet NeoFS smart contract and then mirrored back to Netmap smart contract on FS chain.

By using the `Emit()` and `Vote()` methods of Alphabetic smart contracts, Inner Ring nodes take full control of FS chain. They control validator keys and utility token distribution. Thus, if the mainnet committee will control list of Inner Ring nodes, then it will control FS chain as well.

The mainnet Committee can set the list of priority candidates for Alphabet Inner Ring nodes in the mainnet `DesignationContract`. Nodes from that list will be voted for becoming Alphabet Inner Ring nodes and substitute current Alphabet nodes, if they confirm the following requirements:

- Node's key is registered as a candidate in mainnet NeoFS smart contract
- Node's key is registered as an FS chain committee candidate
- Node is not listed as inactive in FS chain `Netmap` contract

The `DesignationContract` list may contain any number of valid candidates, and the voting process will make sure as many of them as possible are in the first seven active inner Ring nodes. If there is not enough appropriate candidates, the rest will be taken from the regular candidates list. If there are too many, only the first seven suitable nodes will be used.

The voting algorithm is the same for each Inner Ring node and starts in the following cases:

- New Epoch
- Notification from mainnet DesignationContract on Inner Ring nodes list change
- Notification from FS chain Netmap contract on inactive Inner Ring nodes list change

All Inner Ring nodes listen for notifications from the Voting contract. If they see themselves in the new Inner Ring nodes list, they confirm their participation by sending the same list in the `Prepare()` method. Only newly added nodes need to confirm their participation with a transaction. If the node is already in the active Inner Ring list, it doesn't need to send a confirmation.

When there are enough Alphabet signatures and all required candidate signatures have been sent with the `Prepare()` method, the last invocation will update the list and finish voting round.

Active Alphabet Inner Ring nodes will be waiting for the round to end and locally test invoke the `EndRound()` method. When the voting round timeout occurs and the round has not finished successfully through agreement on a new list, one of the Alphabet nodes will invoke `EndRound()` and settle the round's results.

If by the end of the voting round some newly added nodes haven't confirmed their participation, they are added to the Netmap smart contract's inactive list. This will trigger a new voting round without those inactive nodes.

If there are not enough candidates, Inner Ring nodes will accept the best list they can gather.

When the new list is agreed, the `Voting` smart contract sends a notification. All Alphabet nodes react with invocation of `UpdateInnerRing()` on the mainnet NeoFS smart contract. When the majority of Alphabet nodes send the update and mainnet list is updated, it will be mirrored by Alphabet Inner Ring nodes in the FS chain `Netmap` smart contract.

![Inner Ring Alphabet node voting algorithm](pic/gov-irvote)

![Inner Ring list update in mainnet and FS chain](pic/gov-irvote2)
