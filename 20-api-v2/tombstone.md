## neo.fs.v2.tombstone




### Message Tombstone

DEPRECATED: delete objects 1-to-1 with __NEOFS__ASSOCIATE object attribute in a
TOMBSTONE-typed object with no payload. For objects of 2.18+ API version, it is
prohibited to have TOMBSTONE objects with payload.

Tombstone keeps record of deleted objects for a few epochs until they are
purged from the NeoFS network. It is impossible to delete a tombstone object
via ObjectService.Delete RPC call.

| Field | Type | Description |
| ----- | ---- | ----------- |
| expiration_epoch | uint64 | Last NeoFS epoch number of the tombstone lifetime. It's set by the tombstone creator depending on the current NeoFS network settings. DEPRECATED. Field ignored by servers, set corresponding object attribute `__NEOFS__EXPIRATION_EPOCH` only. |
| split_id | bytes | 16 byte UUID used to identify the split object hierarchy parts. Must be unique inside a container. All objects participating in the split must have the same `split_id` value. DEPRECATED. The field is ignored by servers. |
| members | ObjectID | List of objects to be deleted. IDs should be either: 1. Root object IDs (objects that are not split OR parent objects) 2. Children IDs for unfinished objects that does not have LINK objects (garbage collecting). |
     
