\newpage
# Data Audit

In the case of a large number of objects in a distributed network of untrusted nodes with an ever-changing topology, the classical approach with comparing objects' hashes with some sample in a central meta-data storage is not efficient. This causes unacceptable overhead and leads to data disclosure.

To solve this problem, NeoFS uses Homomorphic hashing. It is a special type of hashing algorithms that allows computing the hash of a composite block from the hashes of individual blocks. NeoFS has a focus on a probabilistic approach and homomorphic hashing to minimize the network load and avoid single points of failure.

NeoFS implements Data Audit as a unique zero-knowledge multi-stage game based on homomorphic hash calculation without data disclosure. Data Audit is independent of object storage procedures (recovery, replication, and migration) and respects ACL rules set by user.

For integrity checks, NeoFS calculates a composite homomorphic hash of all the objects in a group under control and puts it into a structure called Storage Group. During integrity checks, NeoFS nodes can ensure that hashes of stored objects are correct and are a part of that initially created composite hash. This can be done without moving the object's data over the network and no matter how many objects are in Storage Group, the hash size is the same.
