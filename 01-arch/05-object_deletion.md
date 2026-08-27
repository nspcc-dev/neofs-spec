## Object Deletion

It's hard to guarantee complete and immediate object removal in a distributed system with eventual consistency. If some nodes are offline at the time of `DELETE` request processing, the object may still be available there and would be replicated to other nodes.

To address this issue, NeoFS Storage nodes don't remove objects immediately, but place a removal mark in a form of a Tombstone object. Being an object this mark would get replicated to all nodes and to new nodes as well once they join the network. Tombstones can't be kept forever to avoid storing useless data, so once they expire they'll be removed by Garbage Collector.

### Tombstone Object

Along with a Regular Object, there is a Tombstone object type. It is like a regular object, but it has no payload, only a special `__NEOFS__ASSOCIATE` attribute pointing to object being deleted. This entity is intended to synchronize object removal in a distributed system working in an unreliable environment. When one removes an Object, NeoFS Storage node actually creates a Tombstone alongside it and replicates the Tombstone among the Container nodes.

A Tombstone indicates that the given `ObjectID` does not exist any more and all requests to it must fail. Storage nodes may keep the data for a while until the Garbage Collector reaps it; though, it's up to the node's settings and implementation.

After several Epochs, we assume that deletion event has been properly spread among all Storage Nodes serving the Container, including those which haven't received it "in time" because of outage or lack of network connectivity.

The time to keep the tombstone may be varying, it is set in `__NEOFS__EXPIRATION_EPOCH` object attribute. It may be set by a user directly or by an intermediate NeoFS Storage node using the default value. While the `__NEOFS__EXPIRATION_EPOCH` attribute is optional for Regular Objects, it is obligatory for Tombstone Object type.
