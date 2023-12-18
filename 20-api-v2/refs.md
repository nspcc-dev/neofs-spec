## neo.fs.v2.refs




### Message Address

Objects in NeoFS are addressed by their ContainerID and ObjectID.

String presentation of `Address` is a concatenation of string encoded
`ContainerID` and `ObjectID` delimited by '/' character.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Container identifier |
| object_id | ObjectID | Object identifier |
   
### Message Checksum

Checksum message.
Depending on checksum algorithm type, the string presentation may vary:

* TZ \
  Hex encoded string without `0x` prefix
* SHA256 \
  Hex encoded string without `0x` prefix

| Field | Type | Description |
| ----- | ---- | ----------- |
| type | ChecksumType | Checksum algorithm type |
| sum | bytes | Checksum itself |
   
### Message ContainerID

NeoFS container identifier. Container structures are immutable and
content-addressed.

`ContainerID` is a 32 byte long
[SHA256](https://csrc.nist.gov/publications/detail/fips/180/4/final) hash of
stable-marshalled container message.

String presentation is a
[base58](https://tools.ietf.org/html/draft-msporny-base58-02) encoded string.

JSON value will be data encoded as a string using standard base64
encoding with paddings. Either
[standard](https://tools.ietf.org/html/rfc4648#section-4) or
[URL-safe](https://tools.ietf.org/html/rfc4648#section-5) base64 encoding
with/without paddings are accepted.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Container identifier in a binary format. |
   
### Message ObjectID

NeoFS Object unique identifier. Objects are immutable and content-addressed.
It means `ObjectID` will change if the `header` or the `payload` changes.

`ObjectID` is a 32 byte long
[SHA256](https://csrc.nist.gov/publications/detail/fips/180/4/final) hash of
the object's `header` field, which, in it's turn, contains the hash of the object's
payload.

String presentation is a
[base58](https://tools.ietf.org/html/draft-msporny-base58-02) encoded string.

JSON value will be data encoded as a string using standard base64
encoding with paddings. Either
[standard](https://tools.ietf.org/html/rfc4648#section-4) or
[URL-safe](https://tools.ietf.org/html/rfc4648#section-5) base64 encoding
with/without paddings are accepted.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Object identifier in a binary format |
   
### Message OwnerID

`OwnerID` is a derivative of a user's main public key. The transformation
algorithm is the same as for Neo3 wallet addresses. Neo3 wallet address can
be directly used as `OwnerID`.

`OwnerID` is a 25 bytes sequence starting with Neo version prefix byte
followed by 20 bytes of ScrptHash and 4 bytes of checksum.

String presentation is a [Base58
Check](https://en.bitcoin.it/wiki/Base58Check_encoding) Encoded string.

JSON value will be data encoded as a string using standard base64
encoding with paddings. Either
[standard](https://tools.ietf.org/html/rfc4648#section-4) or
[URL-safe](https://tools.ietf.org/html/rfc4648#section-5) base64 encoding
with/without paddings are accepted.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | bytes | Identifier of the container owner in a binary format |
   
### Message Signature

Signature of something in NeoFS.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | bytes | Public key used for signing |
| sign | bytes | Signature |
| scheme | SignatureScheme | Scheme contains digital signature scheme identifier |
   
### Message SignatureRFC6979

RFC 6979 signature.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | bytes | Public key used for signing |
| sign | bytes | Deterministic ECDSA with SHA-256 hashing |
   
### Message SubnetID

NeoFS subnetwork identifier.

String representation of a value is base-10 integer.

JSON representation is an object containing a single `value` number field.

DEPRECATED. Kept for compatibility only.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | fixed32 | 4-byte integer subnetwork identifier. |
   
### Message Version

API version used by a node.

String presentation is a Semantic Versioning 2.0.0 compatible version string
with 'v' prefix. i.e. `vX.Y`, where `X` is the major number, `Y` is the minor number.

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

### Emun SignatureScheme

Signature scheme describes digital signing scheme used for (key, signature) pair.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ECDSA_SHA512 | ECDSA with SHA-512 hashing (FIPS 186-3) |
| 1 | ECDSA_RFC6979_SHA256 | Deterministic ECDSA with SHA-256 hashing (RFC 6979) |
| 2 | ECDSA_RFC6979_SHA256_WALLET_CONNECT | Deterministic ECDSA with SHA-256 hashing using WalletConnect API. Here the algorithm is the same, but the message format differs. |
 
