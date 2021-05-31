## Configuration

To calculate reputation values using the EigenTrust algorithm, nodes need the values of the variable parameters of the algorithm. These parameters are constant but can be changed if one needs to adapt the algorithm. For synchronization and correct operation of all nodes, the values are moved to the `Netmap` contract and read from it at the beginning of each epoch.

Parameters and their keys in the global configuration of the `Netmap` contract are as follows:

| Key   | Type   | Description |
| :---- | :----: | ----------- |
| EigenTrustIterations | uint64 | A number of iterations required to calculate Global Trust. |
| EigenTrustAlpha      | string | A parameter responsible for the level of influence of the current node reputation used when calculating its trust in other nodes. |
