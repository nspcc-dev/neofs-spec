\newpage

# Blockchain components

## Role of blockcahin in the storage system

NeoFS stores data off-chain, on Storage Nodes. Clients access it directly in a peer-to-peer fashion. This allows to maintain the quality of service (read\write speed, big data volumes) at the level of traditional storage systems. That said, NeoFS is a global-scale decentralized network and it needs a proven mechanism to serve as a source of truth and global state and remain at that scale. That's what we use the Neo blockchain for.

The Inner Ring nodes take care of the entire network health. They control the network map of Storage Nodes, manage user containers and access control lists, regulate financial operations and data audit. Therefore, Inner Ring should do the following:

- make decisions according to consensus;
- be fault-tolerant;
- have synchronized global state available to Storage Nodes;
- minimize the amount of p2p connections to protect from direct attacks.

All these requirements can be fulfilled by using the blockchain as a distributed database with business logic implemented in smart contracts. Inner Ring operations must be confirmed and audited, which makes it reasonable to use smart contract memory to store the global state of the storage system. It's what makes Inner Ring applications stateless, lightweight, and scalable.

Meanwhile, NeoFS contracts:

- store the state of the current epoch, network map, audit results, reputation estimations, and container-related data;
- manage the economy;
- control the governance of the NeoFS network.

## Mainchain and sidechain

Business logic of smart contracts is executed at contract method invocations from Inner Ring nodes. They are either multisigned transactions or regular transactions. However, these invocations are paid and require \Gls{GAS} for computation. If data owners are charged for these computations, it will be economically impractical for them to use NeoFS.

To solve this problem, we divide smart contract operations into two types:

- financial transactions and governance,
- storage system associated operations.

The first type of operations should be executed in the mainchain. These operations are quite rare and they require GAS as a payment asset. The mainchain for NeoFS is \Gls{mainnet}. Thus, `NeoFS` contract is deployed in the mainchain. It allows to make a deposit, update network config, and reregister the Inner Ring candidate node. The mainchain also manages \Gls{AlphabetNodes} of the Inner Ring using the \Gls{RoleManagement}.

The second type of operations can be executed on an additional chain that we call the sidechain. Sidechain is the Neo blockchain with a different network configuration. Validator nodes of the sidechain are Alphabet nodes of the Inner Ring. Sidechain GAS is managed by Alphabet contracts and should be used only for network maintenance and NeoFS contract execution. Sidechain has `Alphabet`, `Audit`, `Balance`, `Container`, `NeoFSID`, `Netmap`, `Reputation` contracts. No other contracts unrelated to NeoFS can be deployed in the sidechain.

Inner Ring nodes synchronize states of mainchain and sidechain contracts by listening to the notification events and reacting to them.

## Notary service

To make decisions according to the consensus, transactions must be multisigned by Alphabet nodes of the Inner Ring. Inner Ring nodes, however, do not have a p2p connection to each other. Therefore, multi-signature check is replaced with on-chain invocation accumulation. NeoFS contracts await for 5 out of 7 method invocations from Alphabet nodes of the Inner Ring. It leads to:

- increased number of transactions in the network;
- inability to calculate the exact price of a transaction, which leads to an increased cost of execution;
- the contract logic complication.

While in the sidechainб GAS is used only for utility purposes and invocation prices can be mostly ignored, Alphabet nodes of the Inner Ring in the mainchain use a real GAS asset to do withdrawal operation. High execution cost of such operation leads to high withdrawal commissions.

To solve this issue, NeoFS supports [notary service](https://github.com/neo-project/neo/issues/1573#issuecomment-704874472). The notary service allows to build multisigned transactions natively in the blockchain. Thus, the number of transactions and their costs are reduced, contract source code is simplified. Special `proxy` (in the sidechain) and `processing` (in the mainchain) contracts can pay for invocation instead of Alphabet nodes of the Inner Ring. With these contracts, it becomes easier to monitor and control the NeoFS economy.
