## Managers

Exactly one manager is selected for each node in each epoch. Every manager is also a child node of another manager. Thus, each network participant plays two roles: a child node for one of the managers, and a manager for one of the child nodes.

Managers are required to assess the trust of a child node considering its reputation among other nodes. Also, managers are direct (and only) participants in the iterative part of the EigenTrust algorithm; in the late stage of the algorithm, they send Global Trust in their child node to the Reputation contract.

### Defining a manager for a node

To unambiguously determine the manager for the current node, the following rule is used:

1. For the current epoch, a network map (a list of active participants) is obtained from the `Netmap` of the contract.
2. The resulting array is sorted using [HRW](https://github.com/nspcc-dev/hrw) hashing, which takes into account the current epoch number.
3. The index of the current node is determined in a uniquely sorted array - `i`.
4. The `i+1`-th node is taken as a manager of the `i`-th node.

Thus, for the (`Netmap`, `Epoch`) pair (one for all) each network member can uniquely define a manager for any network node. In this case, forecasting a manager for node `i` at an epoch `n`, generally speaking, is a nontrivial task because of the variability of the network map. Also, the rule allows to select a manager for a node pseudo-randomly every epoch.

Taken together, all the above makes it difficult for rogue nodes to cluster for profit.
