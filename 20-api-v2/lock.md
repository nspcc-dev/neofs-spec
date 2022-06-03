## neo.fs.v2.lock




### Message Lock

Lock objects protects a list of objects from being deleted. The lifetime of a
lock object is limited similar to regular objects in
`__NEOFS__EXPIRATION_EPOCH` attribute.

| Field | Type | Description |
| ----- | ---- | ----------- |
| members | ObjectID | List of objects to lock. Must not be empty or carry empty IDs. All members must be of the `REGULAR` type. |
     
