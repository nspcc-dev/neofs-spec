## neo.fs.v2.acl




### Message BearerToken

BearerToken allows to attach signed Extended ACL rules to the request in
`RequestMetaHeader`. If container's Basic ACL rules allow, the attached rule
set will be checked instead of one attached to the container itself. Just
like [JWT](https://jwt.io), it has a limited lifetime and scope, hence can be
used in the similar use cases, like providing authorisation to externally
authenticated party.

BearerToken can be issued only by the container's owner and must be signed using
the key associated with the container's `OwnerID`.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body | Body | Bearer Token body |
| signature | Signature | Signature of BearerToken body |
   
### Message BearerToken.Body

Bearer Token body structure contains Extended ACL table issued by the container
owner with additional information preventing token abuse.

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl_table | EACLTable | Table of Extended ACL rules to use instead of the ones attached to the container. If it contains `container_id` field, bearer token is only valid for this specific container. Otherwise, any container of the same owner is allowed. |
| owner_id | OwnerID | `OwnerID` defines to whom the token was issued. It must match the request originator's `OwnerID`. If empty, any token bearer will be accepted. |
| lifetime | TokenLifetime | Token expiration and valid time period parameters |
| issuer | OwnerID | Token issuer's user ID in NeoFS. It must equal to the related container's owner. |
   
### Message BearerToken.Body.TokenLifetime

Lifetime parameters of the token. Field names taken from
[rfc7519](https://tools.ietf.org/html/rfc7519).

| Field | Type | Description |
| ----- | ---- | ----------- |
| exp | uint64 | Expiration epoch, the last epoch when token is valid. |
| nbf | uint64 | Not valid before epoch, the first epoch when token is valid. |
| iat | uint64 | Issued at Epoch |
   
### Message EACLRecord

Describes a single eACL rule.

| Field | Type | Description |
| ----- | ---- | ----------- |
| operation | Operation | NeoFS request Verb to match |
| action | Action | Rule execution result. Either allows or denies access if filters match. |
| filters | Filter | List of filters to match and see if rule is applicable |
| targets | Target | List of target subjects to apply ACL rule to |
   
### Message EACLRecord.Filter

Filter to check particular properties of the request or the object.

The `value` field must be empty if `match_type` is an unary operator
(e.g. `NOT_PRESENT`). If `match_type` field is numeric (e.g. `NUM_GT`),
the `value` field must be a base-10 integer.

By default `key` field refers to the corresponding object's `Attribute`.
Some Object's header fields can also be accessed by adding `$Object:`
prefix to the name. For such attributes, field 'match_type' must not be
'NOT_PRESENT'. Here is the list of fields available via this prefix:

* $Object:version \
  version
* $Object:objectID \
  object_id
* $Object:containerID \
  container_id
* $Object:ownerID \
  owner_id
* $Object:creationEpoch \
  creation_epoch
* $Object:payloadLength \
  payload_length
* $Object:payloadHash \
  payload_hash
* $Object:objectType \
  object_type
* $Object:homomorphicHash \
  homomorphic_hash

Numeric `match_type` field can only be used with `$Object:creationEpoch`
and `$Object:payloadLength` system attributes.

Please note, that if request or response does not have object's headers of
full object (Range, RangeHash, Search, Delete), it will not be possible to
filter by object header fields or user attributes. From the well-known list
only `$Object:objectID` and `$Object:containerID` will be available, as
it's possible to take that information from the requested address.

| Field | Type | Description |
| ----- | ---- | ----------- |
| header_type | HeaderType | Define if Object or Request header will be used |
| match_type | MatchType | Match operation type |
| key | string | Name of the Header to use |
| value | string | Expected Header Value or pattern to match |
   
### Message EACLRecord.Target

Target to apply ACL rule. Can be a subject's role class or a list of public
keys to match.

| Field | Type | Description |
| ----- | ---- | ----------- |
| role | Role | Target subject's role class |
| keys | bytes | List of 25-byte accounts to identify target subjects. 33-byte public keys are also supported, however, they are deprecated and script hashes should be derived from them. |
   
### Message EACLTable

Extended ACL rules table. A list of ACL rules defined additionally to Basic
ACL. Extended ACL rules can be attached to a container and can be updated
or may be defined in `BearerToken` structure. Please see the corresponding
NeoFS Technical Specification section for detailed description.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | eACL format version. Effectively, the version of API library used to create eACL Table. |
| container_id | ContainerID | Identifier of the container that should use given access control rules |
| records | EACLRecord | List of Extended ACL rules |
    
### Emun Action

Rule execution result action. Either allows or denies access if the rule's
filters match.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ACTION_UNSPECIFIED | Unspecified action, default value |
| 1 | ALLOW | Allow action |
| 2 | DENY | Deny action |

### Emun HeaderType

Enumeration of possible sources of Headers to apply filters.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | HEADER_UNSPECIFIED | Unspecified header, default value. |
| 1 | REQUEST | Filter request headers |
| 2 | OBJECT | Filter object headers |
| 3 | SERVICE | Filter service headers. These are not processed by NeoFS nodes and exist for service use only. |

### Emun MatchType

MatchType is an enumeration of match types.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | MATCH_TYPE_UNSPECIFIED | Unspecified match type, default value. |
| 1 | STRING_EQUAL | Return true if strings are equal |
| 2 | STRING_NOT_EQUAL | Return true if strings are different |
| 3 | NOT_PRESENT | Absence of attribute |
| 4 | NUM_GT | Numeric 'greater than' |
| 5 | NUM_GE | Numeric 'greater or equal than' |
| 6 | NUM_LT | Numeric 'less than' |
| 7 | NUM_LE | Numeric 'less or equal than' |

### Emun Operation

Request's operation type to match if the rule is applicable to a particular
request.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | OPERATION_UNSPECIFIED | Unspecified operation, default value |
| 1 | GET | Get |
| 2 | HEAD | Head |
| 3 | PUT | Put |
| 4 | DELETE | Delete |
| 5 | SEARCH | Search |
| 6 | GETRANGE | GetRange |
| 7 | GETRANGEHASH | GetRangeHash |

### Emun Role

Target role of the access control rule in access control list.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ROLE_UNSPECIFIED | Unspecified role, default value |
| 1 | USER | User target rule is applied if sender is the owner of the container |
| 2 | SYSTEM | System target rule is applied if sender is a storage node within the container or an inner ring node |
| 3 | OTHERS | Others target rule is applied if sender is neither a user nor a system target |
 
