## NeoFS Sidechain Governance

NeoFS uses the sidechain as a database to store meta-information about the
network: network map, audit results, containers, key mappings and network
settings. The sidechain works on the same principles as the main net: there are
no free transactions, and the committee chooses the consensus nodes, etc. To
operate with the sidechain we need to solve the following problems:

* How the mainnet committee can control Inner Ring nodes and the consensus nodes
  of the sidechain?

* How Storage Nodes and Inner Ring nodes get sidechain \Gls{GAS} to send
  transactions?

NeoFS Governance model solves these problems with seven "Alphabet" sidechain
contracts.

### Alphabet contracts

Alphabetic contracts are seven contracts deployed in the sidechain, named after
the first seven [Glagolitic](https://en.wikipedia.org/wiki/Glagolitic_script)
script letters: Az(Ⰰ), Buky(Ⰱ), Vedi(Ⰲ), Glagoli(Ⰳ), Dobro(Ⰴ), Jest(Ⰵ),
Zhivete(Ⰶ). These contracts hold 100,000,000 sidechain \Gls{NEO} on their
accounts (approximately 14,285,000 for each). By storing \Gls{NEO} on the
contract accounts, we protect it from unauthorized use by malicious sidechain
nodes. Contracts do not transfer NEO and use it to vote for sidechain
\Glspl{validator} and to emit \Gls{GAS}.

### Invocation by InnerRing

Contracts cannot distribute utility token or vote by themselves. To do these
operations, Inner Ring nodes invoke alphabetical contract methods. First seven
Inner Ring nodes from the Inner Ring list can invoke corresponding alphabetical
contracts. One node invokes one contract.

![InnerRing to Alphabet SC relation](pic/gov-scir)

Alphabetic contracts have hardcoded indexes. Contracts authenticate method
invoker by using the list of Inner Ring node keys from Netmap Smart Contract.

![Alphabet SC invocation by InnerRing nodes](pic/gov-invoke)

### Utility token distribution

Inner Ring nodes invoke `Emit()` method in corresponding alphabetical contracts.
This method transfers all it's \Gls{NEO} to its account, thereby producing utility
token emission. Within the same invocation context, the contract transfers a
share of the available \Gls{GAS} to all Inner Ring wallets.

$$
InnerRingNodeEmission =
\boldsymbol{G} \cdot \frac{7}{8} \cdot \frac{1}{\boldsymbol{N}}
$$

$G$ - contract's \Gls{GAS} amount \
$N$ - length of Inner Ring list

After receiving \Gls{GAS}, the nodes of the Inner Ring can periodically transfer
a share to all registered storage nodes and use the received utility token for
sidechain operations: change epochs, register new containers, save audit
results, etc.

### Changing sidechain validators

Beforehand, Inner Ring nodes register new validator keys in the list of
candidates for the sidechain committee. Then Inner Ring nodes invoke
`Vote([]keys)` method on corresponding alphabetical contracts. Contract votes for
the keys proposed in passed arguments by sending `VotesPerKey` votes for each
key.

$$
VotesPerKey = \frac{\boldsymbol{A}}{\boldsymbol{N}}
$$

$A$ - contract's NEO amount \
$N$ - length of proposed keys list

### InnerRing list control from Mainnet Committee

By using `Emit()` and `Vote()` methods, Inner Ring nodes take full control of
the sidechain. They control validator keys and utility token distribution. Thus,
if the main net committee will control list of Inner Ring nodes, then it will
control sidechain as well.

The standard scheme for updating Inner Ring is to add keys to the candidate
list with some deposit, and then Inner Ring nodes confirm list update.

![InnerRing list update](pic/gov-irup)

The committee should be able to change the list without accumulating signatures
of Inner Ring nodes. However, the new list must still hold "at least $2/3+1$
former nodes" property.

![InnerRing list update by Mainnet Committee](pic/gov-ircom)

`UpdateInnerRing()` method checks if the sender is a committee and does not
accumulate the signatures of the Inner Ring nodes.
