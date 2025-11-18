## Erasure Coding

NeoFS applies erasure coding (further EC) to user data for its protection. Being an alternative to replication, EC also
provides fault tolerance through data recovery. The distinctive feature is storage efficiency: EC outturn uses less storage
space for the same reliability requirements in terms of number of parts that can be lost without affecting object availability.

### Overview

NeoFS leverages Reed–Solomon codes to provide data EC. Original unit of data, which is user object's payload, is divided
into smaller (data) parts. Coder calculates and creates additional parity parts based on the data ones. Both data and parity
parts are distributed across different storage nodes. If some data parts are lost, NeoFS uses the remaining chunks and the
parity information to reconstruct the missing data and rebuild the original payload.

### Settings

EC is enabled and configured in container storage [policy](02-policy.md) ([API](https://github.com/nspcc-dev/neofs-api/blob/fc8584b766d6b544337fc055dca34c29b0155d31/netmap/types.proto#L134-L180)). Once enabled, all container objects are encoded except

- **TOMBSTONE**;
- **LOCK**;
- **LINK**.

EC is enabled by a storage policy rule with the following parameters:
 1. number of data parts (**d**);
 2. number of parity parts (**p**);
 3. selector name to associate this rule with.

With this rule, each payload is transformed to **d+p** parts. The selector is used to select nodes for storage, similar to REP-rules.

There can be up to **4** EC rule in each container. Codes, or part payloads, are consistent for the same **d** and **p**.

### Object model

For each original (parent) object, the payload is split into **d** data and **p** parity parts. Each part has the same size.
Data parts contain the original payload. If its length is not divisible by **d**, the last part is aligned with zero bytes.

For each payload part, a part object is created. Following properties are inherited from the parent object:

- version;
- container ID;
- owner ID;
- creation epoch.

Then, the object is supplied with EC-specific properties:

- **`__NEOFS__EC_RULE_IDX`** attribute is an index of policy rule this part is created for;
- **`__NEOFS__EC_PART_IDX`** attribute is this part's index.

Parent header, ID and signature are set in corresponding fields of the split header.

As always, payload checksum(s), ID and signature are set last and seal the part object.

![Object EC split](pic/object_split_ec)

### Part placement

Each part object is stored in the container in one copy. Storage nodes are selected from the network map similar to REP rules.
The object for the **i**-th part is placed in the **i**-th node. If it is unavailable, the backup nodes with indexes **m * n + i**
(**n = d + p**, **m = 1, ..., CBF-1**). If all nodes for the **i**-th part are unavailable, nodes for the **i+1**-th (0 for the last)
part are tried, and so on.

### Reconstruction

Once part objects are stored in the container, the original object remains available if at least **d** of any part objects are
available. In other words, unavailability (including complete loss) of any **p** part objects does not violate availability of the
original one.

The source objects are available through the regular API. This also applies to part objects. However, simple read requests
require part addresses, while users request parent objects themselves.

When processing **i**-th policy rule (for assembling the original one in particular), in order to access **j**-th part object
locally stored on the server, following query is used:

- address the parent object;
- add **`__NEOFS__EC_RULE_IDX=i`** X-header;
- add **`__NEOFS__EC_PART_IDX=j`** X-header.

This extension is applicable to GET, HEAD and RANGE calls.

To collect a complete object by (parent) address, you need:

1. select container nodes by container ID;
2. sort results by parent object ID;
3. received data part objects by sending GET request with parent address and **`__NEOFS__EC_RULE_IDX=i`** (**i = 0,...,d**) X-header to sorted container nodes starting from the **i**-th. If all data parts received, goto 5;
4. when **k <= p** data parts are unreachable, try to GET **k** parity parts the same way. As soon as at least **d** parts are received, original object can be restored;
5. parent header can be fetched from [parent_header](https://github.com/nspcc-dev/neofs-api/blob/fc8584b766d6b544337fc055dca34c29b0155d31/object/types.proto#L288) field of any part object;
6. parent payload is calculated from parity parts using [Reed-Solomon](https://github.com/klauspost/reedsolomon) decoder.

### Split + EC

When splitting the original object by payload size, each split-part is subject to EC. As mentioned, the LINK is excluded.
