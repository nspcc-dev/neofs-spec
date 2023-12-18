## neo.fs.v2.lock




### Message Lock

Lock objects protects a list of objects from being deleted. The lifetime of a
lock object is limited similar to regular objects in
`__NEOFS__EXPIRATION_EPOCH` attribute. Lock object MUST have expiration epoch.
It is impossible to delete a lock object via ObjectService.Delete RPC call.
Deleting a container containing lock/locked objects results in their removal
too, regardless of their expiration epochs.

| Field | Type | Description |
| ----- | ---- | ----------- |
| members | ObjectID | List of objects to lock. Must not be empty or carry empty IDs. All members must be of the `REGULAR` type. |
     
