## Containers

In NeoFS, objects are put into containers and stored therein.

From the user's point of view, there are six verbs applicable for a Container: `PUT`, `GET`, `DELETE`, `LIST`, `SetEACL` and `GetEACL`. Also, there is an `AnnounceUsedSpace` operation which is intended for internal NeoFS synchronization. On an existing Container, any user is allowed to make `GET`, `LIST` and `GetEACL`. `DELETE` and `SetEACL` are allowed only for a Container owner, disregarding of a Container basic or extended ACL.

Any container has attributes, which are actually Key-Value pairs containing metadata. There is a certain number of attributes set authomatically, but users can add attributes themselves. Note that attributes must be unique and have non-empty value. It means that it's not allowed to set
 - two or more attributes with the same key name (eg. `Size=small`, `Size=big`);
 - empty-value attributes (eg. `Size=''`).
Containers with duplicated attribute names or empty values will be considered invalid.
