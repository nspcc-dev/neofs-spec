## neo.fs.v2.tombstone




### Message Tombstone

Tombstone keeps record of deleted objects for a few epochs until they are
purged from the NeoFS network.

| Field | Type | Description |
| ----- | ---- | ----------- |
| expiration_epoch | uint64 | Last NeoFS epoch number of the tombstone lifetime. It's set by the tombstone creator depending on the current NeoFS network settings. A tombstone object must have the same expiration epoch value in `__NEOFS__EXPIRATION_EPOCH` attribute. Otherwise, the tombstone will be rejected by a storage node. |
| split_id | bytes | 16 byte UUID used to identify the split object hierarchy parts. Must be unique inside a container. All objects participating in the split must have the same `split_id` value. |
| members | ObjectID | List of objects to be deleted. |
     
