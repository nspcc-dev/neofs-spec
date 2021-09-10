### Object Expiration

In NeoFS, Objects may have an "expiration date". When an Object expires, it is marked for deletion and isn't available anymore. There is a well-known `__NEOFS__EXPIRATION_EPOCH` attribute which specifies the expiration date. Only a Regular Object may expire.

A Tombstone object is created upon Regular Object or Storage Group deletion. Every Tombstone object has the `__NEOFS__EXPIRATION_EPOCH` attribute as well. Thereby Storage Engine is able to filter Tombstones and select ones for total cleanup.

This attribute for a Tombstone Object is set automatically upon its creation. In case of a Regular Object, a user sets it manually.
