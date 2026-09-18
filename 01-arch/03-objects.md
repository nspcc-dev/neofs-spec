## Objects

NeoFS stores all data in the form of objects, thus providing an object-based storage to the clients. These objects are placed in a flat environment (no hierarchy or directories). To access the required data, the identifying details (ID and metadata) are needed.

Object ID is a hash of its header (that includes payload hash). Any object
includes a header and a payload. Some header fields are mandatory and affect
system behavior (like container ID or payload hash). Users can also include
any number (fitting into the overall header size limit) of custom attributes
as a set of key-value pairs. Some attributes (starting with "__NEOFS" prefix)
are special and can affect object processing while some of these attributes
are defined in the API as well-known (like FilePath) and can be used for
application interoperability. NeoFS protocol provides search API that
operates on header data and can be used with custom attributes.

The maximum size of an object payload is fixed and can be changed only for
the whole network in the netmap contract. This means that if an object is too
heavy, it will be automatically divided into smaller objects. These smaller
parts are put into a container and placed onto storage nodes (like any other
objects according to configured container policy). Later, they can be
assembled to the original object. Such assembling is performed in storage
nodes upon a corresponding request. A similar split happens for
erasure-encoded policies where small objects are split into data and parity
parts according to EC settings.

Once an object is uploaded it cannot be changed since NeoFS is
content-addressable, changes in payload lead to differences in header and
different header yields a different object ID.

For more information on object structure, see [API Specification](https://github.com/nspcc-dev/neofs-api/tree/master/proto-docs).
