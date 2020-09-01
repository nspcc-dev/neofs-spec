\newpage
# Architecture overview

## Design and components

NeoFS heavily relies on Neo Blockchain and its features. This allows NeoFS nodes
to focus on their primary tasks --- data storage and processing, while
assets management and distributed system coordination are left to Neo and a set of Smart
Contracts. Under such approach, Blockchain is mainly used as a trusted source of
truth and coordination data.

![Architecture overview](pic/overview-sc2)

\Gls{mainnet} contains a NeoFS [Native
Contract](https://medium.com/neo-smart-economy/native-contracts-in-neo-3-0-e786100abf6e) concerning user's deposits and withdrawals, network settings, and some
other maintenance operations such as trusted nodes' key listing.

To simplify
accounting operations, lessen Main Net burden, and reduce the overall network
maintenance costs, NeoFS utilizes Neo 3.0-based
[sidechain](https://en.wikipedia.org/wiki/Blockchain#Types). NeoFS Sidechain runs Smart Contracts controlling NeoFS
network structure, users settlements, balances, and other frequently changing
data.

There are two types of NeoFS nodes. They are Storage nodes and Inner Ring nodes.

The first type is responsible for receiving data from a user, reliably
storing it as required by the storage policy, and providing access to the data
according to applicable \glspl{acl}. Such storage nodes are coordinated with Smart Contracts
from the Side Chain.

The second type does not store user data. Inner Ring nodes monitor the NeoFS
network health, aggregate Storage Nodes reputation ratings, and perform data
audit, giving out penalties and bounties depending on the audit results. Inner
Ring nodes listen for both Main Net and Sidechain, providing a trusted and
reliable way of data synchronization between two Blockchains.

Each Storage node in the system has a set of key-value attributes describing
node properties such as geographical location, reputation rating, number of
replicas, number of nodes, presence of SSD drives, etc. Inner Ring nodes
generate a Network Map --- a multi-graph structure allowing to select
Storage nodes and group them together based on those attributes.

In NeoFS, a user puts files in a container. This container is similar to a
folder in a file system or a bucket in AWS S3 but with a storage policy
attached. Storage Policy is defined by the user in SQL-like language (NetmapQL)
and tells how and where objects in the container have to be stored by selecting
nodes regarding their attributes. Storage nodes keep data in accordance with the
policy, or otherwise, they do not get paid for their service.

All storage nodes service fees are paid in \gls{GAS}. After receiving GAS, a node operator may spend them on paying for storage of
his backups on other NeoFS nodes in the network and other services provided by the Neo
Blockchain ecosystem.

An innovative feature of NeoFS is that it can be accessed directly from NeoVM on the
smart contract code level. Thanks to the Neo 3.0 Oracles protocol and the integration
between NeoFS and Neo Blockchain, dApps are not limited to on-chain storage and
can manipulate large amounts of data without paying a prohibitive price for it.

NeoFS provides native gRPC API and supports popular protocol gateways allowing easy
integration with other systems and applications without rewriting their code.

Such an architecture makes it possible to implement dApp's smart
contract to manage digital assets and data access permissions on NeoFS and lets
users access that data via regular Web Browsers or mobile applications.

In the long term, we plan to add more ecosystem components that will facilitate
development of truly decentralized applications solving almost any problems that are
nowadays solved in a centralized manner only.


