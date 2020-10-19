## neo.fs.v2.refs




### Message Address

Object in NeoFS can be addressed by it's ContainerID and ObjectID. In string
format there MUST be a '/' delimeter between them.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Container identifier |
| object_id | ObjectID | Object identifier |
   
### Message Checksum

Checksum message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| type | ChecksumType | Checksum algorithm type |
| sum | bytes | Checksum itself |
   
### Message ContainerID

NeoFS container identifier. Container structures are immutable and
content-addressed. `ContainerID` is a 32 byte long SHA256 hash of
stable-marshalled container message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Container identifier in a binary format. |
   
### Message ObjectID

NeoFS Object unique identifier. Objects are immutable and content-addressed.
It means `ObjectID` will change if `header` or `payload` changes. `ObjectID`
is calculated as a hash of `header` field, which contains hash of object's
payload.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Object identifier in a binary format |
   
### Message OwnerID

OwnerID is a derivative of a user's main public key. The transformation
algorithm is the same as for Neo3 wallet addresses. Neo3 wallet address can
be directly used as `OwnerID`.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Identifier of the container owner in a binary format |
   
### Message Signature

Signature of something in NeoFS.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | bytes | Public key used for signing |
| sign | bytes | Signature |
   
### Message Version

API version used by a node.

| Field | Type | Description |
| ----- | ---- | ----------- |
| major | uint32 | Major API version |
| minor | uint32 | Minor API version |
    
### Emun ChecksumType

Checksum algorithm type.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | CHECKSUM_TYPE_UNSPECIFIED | Unknown. Not used |
| 1 | TZ | Tillich-Zemor homomorphic hash function |
| 2 | SHA256 | SHA-256 |
 
