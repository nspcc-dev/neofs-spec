### Object Expiration

In NeoFS, Objects may have an "expiration date". When the Object expires, it is marked for deletion and isn't available anymore. There is a well-known `__NEOFS__EXPIRATION_EPOCH` attribute which specifies the expiration date. Only a Regular Object might be expired.

A Tombstone object is created upon Regular Object or Storage Group deletion. Every Tombstone object has the `__NEOFS__EXPIRATION_EPOCH` attribute as well. Thereby Storage Engine is able to filter Tombstones and select ones for total cleanup.

This attribute for Tombstone Object sets automatically on its creation. In case with a Regular Object, a user sets it manually.
