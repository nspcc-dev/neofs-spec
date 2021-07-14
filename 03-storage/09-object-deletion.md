### Object Deletion

We cannot guarantee permanent object removal in distributed system.

Instead, Storage Node designed to be self-cleaning. Object Garbage
Collector component is responsible for objects deletion physically
from Blobstors and Metabase. Object Garbage Collector also serves the
Control API endpoint for external data controllers and allows them make
decisions on object deletion basing on their specific criterias. It runs
periodically, classifies objects and selects them for removal.

### Tombstone Object

Along with Regular Object and Storage Group, there is a Tombstone
object type. This entity is intended to synchronize object removal in
distrubited system situated in unreliable environment.

When we remove Object, we actually cover it with Tombstone and
distribute it among the Container in the same way as a Regular Object.
The idea is to distribute information that the given Object does not
exist anymore.

After some time (=several epochs) we assume that this event is
advertised properly between all Storage Nodes in the Container,
including those which haven't recevied it "in time" because of
outage or lack of network connectivity.

While the __NEOFS__EXPIRATION_EPOCH attibute is optional for Regular
Object, it is obligatory for the Tombstone.


#### Object Garbage Collector in details
Garbage Collector is part of Storage Engine. One GC instance runs per
one shard.

GC must remove an object itself from Write Cache and Blobstor and
object's metadata from Metabase.

On delete request the Tombstone object is initialized. It contains all
objectIDs which the deleted Object was splitted on. Tombstone belongs
to the Container where the deleted Object is stored. Despite that,
the  __NEOFS__EXPIRATION_EPOCH attribute is assigned to the Tombstone.
Its value is taken from internal field that is specific for Tombstone
object type. This action makes easier for Storage Engine scrabbers to
search through the Tombstone indices and select ones for final, physical
deletion. By design, expiration epoch is strictly more than the current
one and never equals to it. Once created, the Tomstone is put into the
Container and thus is broadcasted among it.

Since this moment user cannot GET an object anymore. On object GET they
would be responded with the Tombstone covering the deleted object.

On Tombstone obtainment, Storage Engine produces some meta information
about it, which helps it track object removal. The Graveyard entity is
responsible for that metadata storing. It is a Metabase table and
consists of key-value pairs. The key is deleted Object's ID, the value
depends on how much time this Tombstone has spent on Graveyard:
- it is a Tombstone Object ID when Object has just (i.e., on the current
epoch) inhumed;
- it is a special GCMark flag evaluated to "True", if Garbage Collector
marked inhumed Object for total deletion.

Garbage Collector's routine per epoch includes two jobs: invalid Objects
check and marked Objects removal.

##### Invalid Objects check

We consider the Object is invalid, if it is expired
(i.e., `__NEOFS_EXPIRATION_EPOCH` well-known attribute value is equal
to current epoch) or the Tombstone associated with this object is
expired.

If an expired Object is found, GC leads it through the deletion
procedure described above.

If an expired Tombstone is found, the associated Graveyard record is
updated: the aforemetioned GCMark toggles for inhumed Object.

##### Marked Objects removal

GC searches through the Graveyard and deletes Objects which were
previously GCMark'ed for deletion. It first removes all metadata
associated with this objectID, and then removes Object and related
Tombstone from Blobstor, Write Cache and filesystem.




This procedure is the same for any object type, i.e. Storage Group
removal goes through mentioned stages as well as Regular Object.
