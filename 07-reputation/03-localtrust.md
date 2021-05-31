## Local Trust

*Local Trust*
: trust of one node to another, calculated using *only* statistical information of their peer-to-peer network interactions. The Subject and Object of such a trust are peer-to-peer nodes.

### Subject and Object of a trust

Any node is the Subject of evaluation. The Object of trust is any node other than the Subject. In NeoFS, nodes do not evaluate their own performance because the default is “every node trusts itself”.

The evaluation criterion is successful (non error in sense of network interaction) execution of one of the RPC calls:

1. `Put`
2. `Get`
3. `Search`
4. `GetRange`
5. `GetRangeHash`
6. `Head`
7. `Delete`

A Subject of the Local Trust assessment stores an assessment of the experience of communication with the Objects in `LocalStorage` while interacting with them. Local reputation only makes sense in context with some epoch value, which should be taken into account when storing and transferring values.

### Calculating trust

Using all these formulations, terms and statements, we recognize that Local Trust is only applicable in the context of a certain epoch. It means that peer-to-peer interactions of nodes for an epoch `n` affect *only* Local Trusts calculated in the epoch `n`. That fact is not emphasized explicitly further.

Assessment of interactions with a node is a binary value, i.e. equals either `0(false)` or `1(true)`.

Let $sat(i, j)$ be a number of positive assessments of interactions with node `j` by node `i`.

Let $unsat(i, j)$ be a number of negative assessments of interactions with node `j` by node `i`.

Therefore, the total number of interactions between node `i` and node `j`:

$$
all(i,j) := sat(i, j) + unsat(i, j).
$$

Then:

$$
S_{ij} = \frac{sat(i, j)}{all(i,j)} \in [0, 1]
$$

is the averaged assessment of interactions with node `j` by node `i`.

Let us define $C_{i,j}$ as following:

$$
C_{i,j} := \left\{
\begin{aligned}
\frac{S_{i,j}}{\sum_{j}^{}S_{i,j}}, \sum_{j}^{}S_{i,j} \neq 0  \\
\frac{1}{N-1}, otherwise
\end{aligned}
\right., \in [0, 1],
$$

where $N$ is the number of network participants. $C_{i, j}$ according to the chapter 4.5 of the [EigenTrust article](http://ilpubs.stanford.edu:8090/562/1/2002-56.pdf) is normalized trust of node `i` to node `j`. This value is taken as the final Local reputation of node `j` for node `i`.

### Transport

At the end of each epoch, all child nodes must announce the accumulated statistics — the set of all Local Trusts for the epoch that has just finished — to their managers.

The transfer is made by calling manager's `AnnounceLocalTrust` [gRPC method](https://github.com/nspcc-dev/neofs-api/blob/master/reputation/service.proto#L18).

Each node should not only collect and transmit its local Trusts, but also be ready to accept (act as a server) and correctly process similar data from another node, i.e. act as a manager.
