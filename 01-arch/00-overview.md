\newpage
# Architecture overview

## Design and components

NeoFS heavily relies on the Neo Blockchain and its features. This allows NeoFS nodes to focus on their primary tasks --- data storage and processing, while asset management and distributed system coordination are left to Neo and a set of Smart Contracts. Under this approach, the Blockchain is mainly used as a trusted source of truth and coordination data.

![Architecture overview](pic/overview-sc2)

The \Gls{mainnet} hosts a NeoFS [Native Contract](https://medium.com/neo-smart-economy/native-contracts-in-neo-3-0-e786100abf6e) concerned with user deposits and withdrawals, network settings, and other maintenance operations such as listing the keys of trusted nodes.

To simplify accounting operations, lessen Main Net burden, and reduce the overall network maintenance costs, NeoFS utilizes an N3-based [sidechain](https://en.wikipedia.org/wiki/Blockchain#Types). The NeoFS Sidechain runs Smart Contracts which control the NeoFS network structure, user settlements, balances, and other frequently changing data.

There are two types of NeoFS nodes. They are Storage nodes and Inner Ring nodes.

The first type is responsible for receiving data from a user, reliably storing it as required by the storage policy, and providing access to the data according to the applicable \glspl{acl}. Such storage nodes are coordinated with Smart Contracts from the Side Chain.

The second type does not store user data. Inner Ring nodes monitor the NeoFS network health, aggregate Storage Nodes reputation ratings, and perform data
auditing, issuing penalties and bounties depending on the audit results. Inner Ring nodes listen for both Main Net and Sidechain, providing a trusted and
reliable way of data synchronization between the two Blockchains.

Each Storage node in the system has a set of key-value attributes describing node properties such as it's geographical location, reputation rating, number of replicas, number of nodes, presence of SSD drives, etc. Inner Ring nodes generate a Network Map --- a multi-graph structure which enables Storage nodes to be selected and grouped based on those attributes.

In NeoFS, a user puts files in a container. This container is similar to a folder in a file system or a bucket in AWS S3, but with a storage policy attached. The Storage Policy is defined by the user in an SQL-like language (NetmapQL), specifying how and where objects in the container have to be stored by selecting nodes based on their attributes. Storage nodes keep data in accordance with the policy, otherwise they do not get paid for their service.

All storage nodes service fees are paid in \gls{GAS}. After receiving GAS, a node operator may spend them to pay for their own data backups on other NeoFS nodes, or simply withdraw it for use with other services provided by the Neo Blockchain ecosystem.

An innovative feature of NeoFS is that it can be accessed directly from NeoVM on the smart contract code level. Thanks to the N3 Oracle protocol and the integration between NeoFS and Neo Blockchain, dApps are not limited to on-chain storage and can manipulate large amounts of data without paying a prohibitive price for it.

NeoFS provides native gRPC API and supports the most popular protocol gateways, allowing easy integration with other systems and applications without requiring code rewrites.

Such an architecture makes it possible to implement a dApp's smart contract to manage digital assets and data access permissions on NeoFS and lets users access that data via regular Web Browsers or mobile applications. In the long term, we plan to add more ecosystem components that will facilitate the development of truly decentralized applications, solving almost any problems that are nowadays only possible in a centralized manner.
