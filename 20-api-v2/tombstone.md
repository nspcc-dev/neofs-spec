## neo.fs.v2.tombstone




### Message Tombstone

Tombstone keeps record of deleted objects for few epochs until they are
purged from the NeoFS network.

| Field | Type | Description |
| ----- | ---- | ----------- |
| expiration_epoch | uint64 | Last NeoFS epoch number of the tombstone lifetime. It's set by tombstone creator depending on current NeoFS network settings. Tombstone object must have the same expiration epoch value in `__NEOFS__EXPIRATION_EPOCH` attribute. Otherwise tombstone will be rejected by storage node. |
| split_id | bytes | 16 byte UUID used to identify the split object hierarchy parts. Must be unique inside container. All objects participating in the split must have the same `split_id` value. |
| members | ObjectID | List of objects to be deleted. |
     
