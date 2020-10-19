## neo.fs.v2.storagegroup




### Message StorageGroup

StorageGroup keeps verification information for Data Audit sessions. Objects
that require payed storage guaranties are gathered in `StorageGroups` with
additional information used for proof of storage. `StorageGroup` only
contains objects from the same container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| validation_data_size | uint64 | Total size of the payloads of objects in the storage group |
| validation_hash | Checksum | Homomorphic hash from the concatenation of the payloads of the storage group members. The order of concatenation is the same as the order of the members in the `members` field. |
| expiration_epoch | uint64 | Last NeoFS epoch number of the storage group lifetime |
| members | ObjectID | Strictly ordered list of storage group member objects |
     
