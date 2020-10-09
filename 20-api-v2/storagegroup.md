## neo.fs.v2.storagegroup




### Message StorageGroup

StorageGroup groups the information about the NeoFS storage group.
The storage group consists of objects from single container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| validation_data_size | uint64 | validation_data_size carries the total size of the payloads of the storage group members. |
| validation_hash | Checksum | validation_hash carries homomorphic hash from the concatenation of the payloads of the storage group members The order of concatenation is the same as the order of the members in the Members field. |
| expiration_epoch | uint64 | expiration_epoch carries last NeoFS epoch number of the storage group lifetime. |
| members | ObjectID | Members carries the list of identifiers of the object storage group members. The list is strictly ordered. |
     
