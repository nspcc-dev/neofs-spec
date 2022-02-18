## Storage Groups

The concept of a storage group has been introduced to reduce the dependence of the complexity of the check on the number of stored objects in the system.

The consistency and availability of multiple objects on the network are achieved by validating the storage group without saving meta information and performing validation on each object.

StorageGroup keeps verification information for Data Audit sessions. Objects that require paid storage guaranties are gathered in `StorageGroups` with additional information used for proof of storage checks. A `StorageGroup` can be created only for objects from the same container.

`StorageGroup` are objects of a special type with the payload containing the serialized protobuf structure. For the details on the format please refer to the API specification in the corresponding section.

StorageGroup structure has information about:

 - Total size of the payloads of objects in the storage group
 - Homomorphic hash from the concatenation of the payloads of the storage group members. The order of concatenation is the same as the order of the members in the `members` field.
 - Last NeoFS epoch number of the storage group lifetime
 - Alpha-numerically sorted list of member objects

