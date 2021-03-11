## Network Map

Network map (or just "netmap") is a structured representation of all nodes in NeoFS network.
Each node has multiple key-value pairs called "attributes".
Attribute values are strings on the low level, however, some of them may be treated as integers.
Here is an example of a simple node:
```
Continent=Europe
Country=Germany
Price=1000
Capacity=1000
```

Some node attributes can be grouped (e.g. [geographical ones]()), thus creating
a graph representation for the network map.
Strictly speaking it is a forest of rooted trees where leaves (single nodes) are shared.
Every tree represents a single attribute group.
For example, geographical attributes can be naturally ordered:
`Continent`, `Country`, `City`, `DC` (data center) or any other place identifier.

### Epoch
For NeoFS network to work properly nodes should have the same view of network.
This is why network map changes in regular time periods called epochs.
During an epoch netmap is immutable; however, new nodes can be registered and bad (offline) ones can be removed. 
All these changes signed by Inner Ring are propagated to the network when a new epoch starts.

### Predefined attributes
Some of the attributes such as [`UN-LOCODE`](https://en.wikipedia.org/wiki/UN/LOCODE)
 are reserved and follow specific validation rules.
If some of them are not specified they can be restored. For example, based on combination
of `Continent`, `Country` and `City` attributes
it can be possible to deduce `UN-LOCODE` and sometimes vice-versa.
#### Price and Storage
`Price` and `Capacity` attributes denote price and storage capacity, respectively.
The units of both price and capacity are specified by the network.
For public NeoFS network with Neo blockchain they can be `0.00000001 GAS` and `Mebibytes` respectively.

`Price` attribute is used to determine how much money a node will receive per stored unit every epoch.
If it is not specified, default value can be used.

`Capacity` attribute is verified when node joins the network. It is mandatory and must be numerical.
#### TODO Geographical attributes
#### TODO Subnet

### Custom attributes
User attributes can have any name and value.
They are used primarily for specifying [storage policy](./02-policy.md).
As an example one may want to designate one's own nodes with some specific attribute
to be sure (with the help of storage policy) that at least one copy is always stored
locally on the nodes one controls.

### Node identifiers
Each node has some parameters which are used by the network itself, namely `PublicKey` and `Address`.
The former is public key used for proving identity in inter-network communication, the latter is
node's network address (e.g. IP).
