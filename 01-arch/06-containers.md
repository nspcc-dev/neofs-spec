## Containers

In NeoFS, objects are put into containers and stored therein.

Any container has attributes, which are actually Key-Value pairs containing metadata. There is a certain number of attributes set authomatically, but users can add attributes themselves. Note that attributes must be unique and have non-empty value. It means that it's not allowed to set 
 - two or more attributes with the same key name (eg. `Size=small`, `Size=big`);
 - empty-value attributes (eg. `Size=''`). 
Containers with duplicated attribute names or empty values will be considered invalid. 
