### Epoch

For the NeoFS network to work properly, all nodes should have the same view of
the network. This snapshot view must be tied to some timestamp, but in the
distributed environment for NeoFS there is no reliable common source of time
other then monotonically increasing number of block in the Blockchain. It means
we can only use [discrete time
model](https://en.wikipedia.org/wiki/Discrete_time_and_continuous_time) and
define some time period in blocks to snapshot the common view of the network.
This period has to be small enough to keep the snapshot information fresh and
big enough to let the information be distributed fast enough between network
nodes. This regular time period is called Epoch.

During an Epoch all common information snapshots are immutable. During the Epoch
new nodes can be registered, misbehaving nodes can be removed, some nodes can go
offline, but those changes will be reflected only in the next version of the
netmap issued for the next Epoch. All these changes signed by Inner Ring are
propagated to the network only when the new Epoch starts.

## Network Map

NeoFS Network Map, or just "netmap", is a structured representation of all
storage nodes available in NeoFS network for the current Epoch.

Each node has multiple key-value pairs called "attributes". Attribute values are
strings on the low level, however, some of them may be treated as integers. Here
is an example of a simple node:

```
Continent=Europe
Country=Germany
Price=1000
Capacity=1000
```

Some node attributes can be grouped (e.g. geographical ones), thus creating
a graph representation for the network map.
Strictly speaking it is a forest of rooted trees where leaves (single nodes) are shared.
Every tree represents a single attribute group.
For example, geographical attributes can be naturally ordered:
`Continent`, `Country`, `City`, `DC` (data center) or any other location identifier.


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
