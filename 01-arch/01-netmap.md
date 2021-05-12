## Epoch

For the NeoFS network to work properly, all nodes should have the same view of the network. This snapshot view must be tied to some timestamp, but in the distributed environment for NeoFS there is no reliable common source of time other then monotonically increasing number of blocks in the Blockchain. It means we can only use [discrete time model](https://en.wikipedia.org/wiki/Discrete_time_and_continuous_time) and define some time period in blocks to snapshot the common view of the network. This period has to be small enough to keep the snapshot information fresh and big enough to let the information be distributed fast enough between network nodes. This regular time period is called Epoch.

During an Epoch all common information snapshots are immutable. New nodes can be registered, misbehaving nodes can be removed, some nodes can go offline, but those changes will be reflected only in the next version of the netmap issued for the next Epoch. All these changes signed by Inner Ring are propagated to the network only when the new Epoch starts.

## Network Map

NeoFS Network Map, or just "netmap", is a structured representation of all active storage nodes available in NeoFS network for the current Epoch.

Storage nodes in the netmap are identified by public key. Netmap also has additional information about each node, like network addresses and a list of attributes.

Attributes are key-value pairs with string values. Depending on the Attribute, the string value can be interpreted as a number or Hex or something else. For detailed information please see the API reference.

Here is how node information in netmap may look like:

```
key: 03e9c4847fb2f4d58161a808ff74363139c4e617cb233a2e96cc6c4c7f219dd9bf
address: /dns4/st1.storage.fs.neo.org/tcp/8080
state: ONLINE
attribute: Capacity=10000
attribute: Continent=Europe
attribute: Country=Germany
attribute: CountryCode=DE
attribute: Deployed=NSPCC
attribute: Location=Falkenstein
attribute: Price=0.00000042
attribute: SubDiv=Sachsen
attribute: SubDivCode=SN
attribute: UN-LOCODE=DE FKS
```

Some node attributes can be grouped (e.g. geographical ones), creating a graph representation for the network map. Strictly speaking it is a forest of rooted trees where leaves (single nodes) are shared. Every tree represents a single attribute group. For example, geographical attributes can be naturally ordered: `Continent`, `Country`, `SubDiv`, `Location`, `DC` (data center) or any other location identifier.

User attributes can have any name and value. They are used primarily for storage policy rules. For example, one may want to designate their own nodes with some specific attribute to be sure (with the help of storage policy) that at least one copy is always stored locally on the nodes one controls.
