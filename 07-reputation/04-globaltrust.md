## Global Trust

*Global Trust*
: the result of the EigenTrust algorithm is the trust in the network participant, which has been obtained regarding *all* Local Trusts of *all* nodes.

### Subject and Object of a trust

The Subject of the assessment is the entire system. Any node in the network is an Object of trust.

The evaluation criterion is the aggregate of Local Trust of *all* network participants to the current node, but adjusted for similar Local Trust to each participant from the rest of the network.

### Calculating trust

Each manager retrieves the Local Trust value of its child at the end of each epoch and stores it in the `DaughterStorage`. The further task of each manager is to calculate the Global Trust of the system in its child node, and also to transfer all the information it has to other managers so that they, in turn, can perform a similar task.

Global Trust is calculated iteratively. While calculating `GlobalTrust`, according to the EigenTrust algorithm, managers should exchange “intermediate” trust values, the so-called `IntermediateTrust`. With the help of these values, managers at each iteration approximate (recalculate the results of the previous iteration) the value of the Global Trust to the common Global Value Limit: $T = [t_0, ..., t_n]$, where $t_i$ is the limiting Global Trust value in node `i`.

Using all these formulations, terms and statements, we recognize that Local Trust is only applicable in the context of a certain epoch. It means that peer-to-peer interactions of nodes for an epoch `n` affect *only* Global Trusts calculated in the epoch `n`. `IntermediateTrust` values, likewise, only make sense when used in the context of some epoch **and iteration number**. That fact is not emphasized explicitly further.

The iterative formula:

$$
t_{j}^{k+1} =(1-\alpha) \sum_{j=0}^{n} C_{ij}t_i^k + \alpha t_j^0
$$,

where $C_{ij}$ is Local Trust of node `i` to node `j`; $\alpha$ is a value that determines the influence of the $t_i^0$ (“blind” trust in node `i`) - on the final result; $C_{i,j}t_i^k$, in the introduced terminology, is `IntermediateTrust` which has been transferred by the manager of node `i` to the manager of node `j`. In order for the algorithm to work synchronously, the number of iterations and $\alpha$ is read by all nodes from the Global Configuration of the `Netmap` contract at the beginning of each epoch.

Actually, blind trust $t_i^0$ can be different for different nodes. It can take into account how long ago a node joined the network, whether the node belongs to the developers of the network, etc. In the current implementation $t_i^0 = \frac{1}{N}, \forall i$, where $N$ is the number of network participants in the current epoch.

### Transport

In order for the manager of node `j` to be able to calculate $t_j^{k+1}$, which is the intermediate Global Trust (this is *not* `IntermediateTrust`) to its child node, the following is essential:

1. The manager must have all the existing `IntermediateTrust`s - $C_{ij}t_i^k, \forall i \neq j$.
2. The manager must calculate and transfer all `IntermediateTrust`s, according to the information received from its child node, that is, calculate and transfer all existing $C_{ji}t_j^k, \forall i \neq j$.

To do this, the manager must act both as a client and a server. The transfer itself is run by calling the `AnnounceIntermediateResult` [gRPC method](https://github.com/nspcc-dev/neofs-api/blob/master/reputation/service.proto#L22).

The manager should store intermediate `IntermediateTrust` values in `ConsumerStorage` considering both the epoch and the iteration numbers. Each manager must transmit them based on the number of iterations and the number of blocks in the current epoch.
