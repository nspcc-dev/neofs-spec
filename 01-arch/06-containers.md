## Containers

In NeoFS, objects are put into containers and stored therein. Container has
an owner and defines storage policy for its objects. Owner has special
container-level permissions for container like he can change some of its
attributes or delete it, the same entity is known as "user" in object ACL.
Storage policy limits the number of storage nodes used for a container and
defines redundancy/location properties.

Container service provided by storage nodes defines several operations (verbs)
for a container: `Put` (creates a new container), `Get` (fetches container
metadata), `Delete` (removes container), `List` (enumerates owner's containers),
`SetExtendedACL` (changes EACL), `GetExtendedACL` (fetches EACL), `SetAttribute`
(changes attributes) and `RemoveAttribute` (removes attributes). For an existing
container, any user is allowed to make `Get`, `List` and `GetExtendedACL` calls,
other operations are only allowed for container owner or another account that
has a session token with appropriate permissions. Container-level operations
are not limited by basic or extended ACLs.

Any container has attributes, which are actually Key-Value pairs containing
metadata. Some attributes (with "__NEOFS" prefix) can affect system behavior,
some are well-known and can be used for application interoperability (like
CORS), but in general users can add any key-value pairs. There are just two
main limits here: key uniqueness (can't have `Size=small` and `Size=big`
defined for the same container) and value non-emptiness (`Size=''` isn't
allowed). Container creation requires IR multisignature and invalid requests
won't be signed, so incorrect containers can't be created.

Some subset of well-known container attributes can be changed as well as
container owner (the mechanism of owner change is out of NeoFS API scope,
internally it's implemented as [NEP-11](https://github.com/neo-project/proposals/blob/462436528f9fe71993a1ffd0fa7df76cdb7f9641/nep-11.mediawiki)
token transfer in blockhain components).
