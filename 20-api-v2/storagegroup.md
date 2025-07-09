## neo.fs.v2.storagegroup




### Message StorageGroup

StorageGroup keeps verification information for Data Audit sessions. Objects
that require paid storage guarantees are gathered in `StorageGroups` with
additional information used for the proof of storage. `StorageGroup` only
contains objects from the same container.

Being an object payload, StorageGroup may have expiration Epoch set with
`__NEOFS__EXPIRATION_EPOCH` well-known attribute. When expired, StorageGroup
will be ignored by InnerRing nodes during Data Audit cycles and will be
deleted by Storage Nodes.

DEPRECATED: storage groups are no longer used for audit since 2.18.

| Field | Type | Description |
| ----- | ---- | ----------- |
| validation_data_size | uint64 | Total size of the payloads of objects in the storage group |
| validation_hash | Checksum | Homomorphic hash from the concatenation of the payloads of the storage group members. The order of concatenation is the same as the order of the members in the `members` field. |
| expiration_epoch | uint64 | DEPRECATED. Last NeoFS epoch number of the storage group lifetime |
| members | ObjectID | Strictly ordered list of storage group member objects. Members MUST be unique |
     
