## Reputation system

NeoFS reputation system is a subsystem for calculating trust in a node. It is based on a reputation model for assessing trust, which is, in turn, based on the \Gls{EigenTrust} algorithm designed for peer-to-peer reputation management. The algorithm ensures that there is a uniquely defined manager (parent node) for each network participant at each specified time (epoch). Based on the information received from its child node and other managers, it iteratively puts a complex general (Global) Trust of the entire network into the applicable child node.

The reputation system allows introducing nodes performance quality metric (trust). In a situation when most of the nodes make an honest assessment of the actions of other nodes, the system lets you calculate this metric quite accurately. This metric can be used for:

1. Filtering the list of nodes where the user intends to store information. For example, one can use only those nodes whose scores are higher than the minimum acceptable for the user.
2. Making a decision to exclude untrusted hosts from the network. For example, one can suspend a node in case it comes to the minimum level of quality in the network.

### Trust

Trust in a NeoFS node is its quantitative (numerical) assessment based on the experience of interacting with that node. The higher the score is, the higher is the trust in the node and vice versa. Since the system uses a reputation-based trust model, the terms “trust” and “reputation” are considered synonymous in this document.

*The Subject of trust assessment*
: is the one who calculates trust.

*The Object of trust assessment*
: is the one whose trust is being calculated.

Reputation models are based on the nature of social media reputation. Thus, trust in a node is built up both by the estimates of the behavior of the node by another node and by the reputation of the node evaluating its behavior.

Trust in a NeoFS in a node is formed based on its interactions with the Subjects of trust assessment. Therefore, the reputation of a node changes during the NeoFS network working cycle when both the behavior of the node itself, and the behavior of other nodes change.

### Algorithm

*General problem statement:* the Subject of assessment needs to calculate the reputation of the Object of trust assessment at a specific point of time (specific epoch).

\Gls{EigenTrust} is based on the notion of transitive trust: peer `i` will have a high opinion of those peers who have provided it with authentic information. Moreover, peer `i` is likely to trust the opinions of those peers, since peers who are honest about the information they provide are also likely to be honest in reporting their \Gls{LocalTrust} values.

\Gls{GlobalTrust} is calculated in 3 main stages:

1. Each network member collects local statistics of network interactions with other peers, acting as the Subject of reputation assessment.
2. At the end of an epoch, each node announces its local statistics to its manager.
3. Managers exchange received information iteratively and, based on the updated data, make adjustments to the trust obtained in the previous iteration.

The algorithm uses configuration parameters that affect the result of the \Gls{GlobalTrust} calculation. To synchronize all network participants in terms of the values of these parameters, the nodes "read" these parameters from the `Netmap` contract.

### Subjects and Objects of Trust in NeoFS

In NeoFS, the reputation system is used to calculate the trust in Storage Node. Thus, the Object of trust is always a Storage Node (and it is also the Subject in the local case). The Subject of Global Trust is the entire ring of Storage Nodes.
