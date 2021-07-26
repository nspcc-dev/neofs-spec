## Garbage Collector
Garbage Collector is a part of the Storage Engine. One GC instance runs per one shard.

GC should remove an object itself from Write Cache and Blobstor and the object's metadata from Metabase.

Upon a delete request, a Tombstone object is initialized. It contains all `ObjectID`s which the deleted Object was split into. A Tombstone belongs to the Container where the deleted Object is stored. Despite that the `__NEOFS__EXPIRATION_EPOCH` attribute is assigned to the Tombstone, its value is taken from the internal field that is specific to Tombstone object type. This action makes it easier for Storage Engine data scrubbers to search through the Tombstone indices and select ones for final physical deletion. By design, expiration epoch is strictly more than the current one and never equals to it. Once created, the Tombstone is put into the Container and thus is spread therein.

Since this moment, users cannot GET the object any more. Trying to GET object, they would get the error.

When a Tombstone is obtained, the Storage Engine produces some meta information about it, which helps it track object removal. The Graveyard entity is responsible for storing that metadata. It is a Metabase table consisting of key-value pairs. The key is the deleted Object's ID and the value depends on how much time this Tombstone has already spent in the Graveyard:
- it is a Tombstone Object ID when the Object has just (i.e., on the current epoch) been inhumed;
- it is a special GCMark flag evaluated to "True" if Garbage Collector has marked the inhumed Object for total deletion.

Garbage Collector's routine per epoch includes two jobs: invalid Objects check and marked Objects removal.

### Invalid Objects check

We consider an Object invalid if it is expired (i.e., `__NEOFS_EXPIRATION_EPOCH` well-known attribute value is equal to current epoch) or the Tombstone associated with this object is expired.

If an expired Object is found, GC leads it through the deletion procedure described above.

If an expired Tombstone is found, the associated Graveyard record is updated: the aforementioned GCMark toggles for inhumed Object.

### Marked Objects removal

GC searches through the Graveyard and deletes Objects which has been previously GCMark'ed for deletion. It first removes all metadata associated with this objectID and then removes the Object and the related Tombstone from Blobstor, Write Cache and filesystem.

This procedure is the same for any object type, i.e. a Storage Group removal goes through the mentioned stages as well as a Regular Object.
