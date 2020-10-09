## neo.fs.v2.refs




### Message Address

Address of object (container id + object id)

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | container_id carries container identifier. |
| object_id | ObjectID | object_id carries object identifier. |
   
### Message Checksum

Checksum message

| Field | Type | Description |
| ----- | ---- | ----------- |
| type | ChecksumType | Checksum algorithm type |
| sum | bytes | Checksum itself |
   
### Message ContainerID

NeoFS container identifier.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | value carries the container identifier in a binary format. |
   
### Message ObjectID

NeoFS object identifier.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | value carries the object identifier in a binary format. |
   
### Message OwnerID

OwnerID group information about the owner of the NeoFS container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | value carries the identifier of the container owner in a binary format. |
   
### Message Signature

Signature of something in NeoFS

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | bytes | Public key used for signing. |
| sign | bytes | Signature |
   
### Message Version

Represents API version used by node.

| Field | Type | Description |
| ----- | ---- | ----------- |
| major | uint32 | Major API version. |
| minor | uint32 | Minor API version. |
    
### Emun ChecksumType

Checksum algorithm type

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | CHECKSUM_TYPE_UNSPECIFIED | Unknown. Not used |
| 1 | TZ | Tillich-Zemor homomorphic hash funciton |
| 2 | SHA256 | SHA-256 |
 
