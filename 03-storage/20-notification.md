## Notifications

Storage nodes can produce notifications about internal events for external listeners. The specification covers only basic concepts of notifications and their triggers and does not define implementation details such as message binary format or transport protocol. Such details may vary in storage nodes depending on external listeners. Notifications do not affect core protocol and can be disabled. Therefore, one can use it only in a controlled environment with access to storage node configuration.

Notification is the entity that consists of **topic** and **message**.

### Object notifications

Stored objects can trigger notifications. Object triggers notification if it contains valid well-known object header `__NEOFS__TICK_EPOCH`. Read more about well-known headers in the NeoFS API v2 section.

When the storage node processes a new epoch event with an epoch number specified in `__NEOFS__TICK_EPOCH`, it should produce a notification related to such objects. If `__NEOFS__TICK_EPOCH` header specifies zero epoch, then the notification should be produced immediately as an object saved in the storage engine.

Notification **message** should contain the address of the object. Notification **topic** is defined by valid well-known object header `__NEOFS__TICK_TOPIC`. If the header is omitted, the storage node should use the default topic. Default topic is defined by storage node implementation.
