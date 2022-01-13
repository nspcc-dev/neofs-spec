## Objects

NeoFS stores all data in the form of objects, thus providing an object-based storage to the clients. These objects are placed in a flat environment (no hierarchy or directories). To access the required data, the identifying details (ID and metadata) are needed.

ObjectID is a hash that equals Headers hashes plus Payload hashes. Any object includes a system header, extended headers, and a payload. A system header is an obligatory field, while extended headers may be omitted. However, any extended header should follow a particular structure (e.g. IntegrityHeader is a must). A user can add any extended header in the form of a key-value pair, though keeping in mind that it cannot be duplicated with several values. One attribute -- one value. Please note that any object initially has FileName, so that you cannot create an extended header with it as a key.

The maximum size for an object is fixed and can be changed only for the whole network in the main contract. It means that if a file is too heavy, it will be automatically divided into smaller objects. This smaller parts are put in a container and placed to a Storage Node. Later, they can be assembled to the initial object. Such assembling is performed in the storage nodes upon a corresponding request for a linking object. Once your file is converted into an object (or several objects), this object cannot be changed.

One can define the format of the object in an API Specification. For more information, see [API Specification](https://github.com/nspcc-dev/neofs-api/tree/master/proto-docs).
