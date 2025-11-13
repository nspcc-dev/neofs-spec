## neo.fs.v2.object



### Service "ObjectService"

`ObjectService` provides API for manipulating objects. Object operations do
not affect FS chain and are only served by nodes in P2P style.


### Method Get

Receive full object structure, including Headers and payload. Response uses
gRPC stream. First response message carries the object with the requested address.
Chunk messages are parts of the object's payload if it is needed. All
messages, except the first one, carry payload chunks. The requested object can
be restored by concatenation of object message payload and all chunks
keeping the receiving order.

Extended headers can change `Get` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation. DEPRECATED: header ignored by servers.
* __NEOFS__NETMAP_LOOKUP_DEPTH \
  Will try older versions (starting from `__NEOFS__NETMAP_EPOCH` if specified or
  the latest one otherwise) of Network Map to find an object until the depth
  limit is reached. DEPRECATED: header ignored by servers.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  object has been successfully read;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  read access to the object is denied;
- **OBJECT_NOT_FOUND** (2049, SECTION_OBJECT): \
  object not found in container;
- **OBJECT_ALREADY_REMOVED** (2052, SECTION_OBJECT): \
  the requested object has been marked as deleted;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

             

__Request Body:__ GetRequest.Body

GET Object request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the requested object |
| raw | bool | If `raw` flag is set, request will work only with objects that are physically stored on the peer node |
                                            

__Response Body__ GetResponse.Body

GET Object Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| init | Init | Initial part of the object stream |
| chunk | bytes | Chunked object payload |
| split_info | SplitInfo | Meta information of split hierarchy for object assembly. |
                           
### Method Put

Put the object into container. Request uses gRPC stream. First message
SHOULD be of PutHeader type. `ContainerID` and `OwnerID` of an object
SHOULD be set. Session token SHOULD be obtained before `PUT` operation (see
session package). Chunk messages are considered by server as a part of an
object payload. All messages, except first one, SHOULD be payload chunks.
Chunk messages SHOULD be sent in the direct order of fragmentation.

Extended headers can change `Put` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation. DEPRECATED: header ignored by servers.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  object has been successfully saved in the container;
- **INCOMPLETE** (1, SECTION_SUCCESS): \
  object was put to some nodes, but the number of replicas is not sufficient
  to satisfy placement policy;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  write access to the container is denied;
- **LOCKED** (2050, SECTION_OBJECT): \
  placement of an object of type TOMBSTONE that includes at least one locked
  object is prohibited;
- **LOCK_NON_REGULAR_OBJECT** (2051, SECTION_OBJECT): \
  placement of an object of type LOCK that includes at least one object of
  type other than REGULAR is prohibited;
- **QUOTA_EXCEEDED** (2054, SECTION_OBJECT): \
  size quota set by user was exceeded;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object storage container not found;
- **TOKEN_NOT_FOUND** (4096, SECTION_SESSION): \
  (for trusted object preparation) session private key does not exist or has
been deleted;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

                       

__Request Body:__ PutRequest.Body

PUT request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| init | Init | Initial part of the object stream |
| chunk | bytes | Chunked object payload |
                                             

__Response Body__ PutResponse.Body

PUT Object response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Identifier of the saved object |
                
### Method Delete

Delete the object from a container. There is no immediate removal
guarantee. Object will be marked for removal and deleted eventually.
Notice that some types of objects (see ObjectType) can not be removed,
currently it's Tombstone and Lock.

Extended headers can change `Delete` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation. DEPRECATED: header ignored by servers.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  object has been successfully marked to be removed from the container;
- **INCOMPLETE** (1, SECTION_SUCCESS): \
  some nodes have accepted the deletion mark, but some may still store
  the object;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  delete access to the object is denied;
- **LOCKED** (2050, SECTION_OBJECT): \
  deleting a locked object is prohibited;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

 

__Request Body:__ DeleteRequest.Body

Object DELETE request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the object to be deleted |
                                            

__Response Body__ DeleteResponse.Body

Object DELETE Response has an empty body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| tombstone | Address | Address of the tombstone created for the deleted object |
                                       
### Method Head

Returns the object Headers without data payload. By default full header is
returned. If `main_only` request field is set, the short header with only
the very minimal information will be returned instead.

Extended headers can change `Head` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  object header has been successfully read;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  access to operation HEAD of the object is denied;
- **OBJECT_NOT_FOUND** (2049, SECTION_OBJECT): \
  object not found in container;
- **OBJECT_ALREADY_REMOVED** (2052, SECTION_OBJECT): \
  the requested object has been marked as deleted;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

                  

__Request Body:__ HeadRequest.Body

Object HEAD request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the object with the requested Header |
| main_only | bool | Return only minimal header subset.

DEPRECATED. This field is ignored. |
| raw | bool | If `raw` flag is set, request will work only with objects that are physically stored on the peer node |
                                            

__Response Body__ HeadResponse.Body

Object HEAD response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| header | HeaderWithSignature | Full object's `Header` with `ObjectID` signature |
| short_header | ShortHeader | Short object header.

DEPRECATED. Use HeaderWithSignature instead. |
| split_info | SplitInfo | Meta information of split hierarchy. |
                      
### Method Search

Search objects in container. Search query allows to match by Object
Header's filed values. Please see the corresponding NeoFS Technical
Specification section for more details.

DEPRECATED: please use SearchV2.

Extended headers can change `Search` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  objects have been successfully selected;
- **INCOMPLETE** (1, SECTION_SUCCESS): \
  some nodes were unable to process the request, so the result may
  not contain all data;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  access to operation SEARCH of the object is denied;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  search container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

                               

__Request Body:__ SearchRequest.Body

Object Search request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Container identifier were to search |
| version | uint32 | Version of the Query Language used |
| filters | SearchFilter | List of search expressions |
                                            

__Response Body__ SearchResponse.Body

Object Search response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| id_list | ObjectID | List of `ObjectID`s that match the search query |
         
### Method SearchV2

Search for objects in a container. Similar to Search, but:
* sorted
* limited in amount of returned data
* single message
* allows for additional header fields to be returned

Result is ordered by the 1st requested attribute (if any) and object ID.

                                   

__Request Body:__ SearchV2Request.Body

Object Search request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Container where the search is being performed. |
| version | uint32 | Version of the Query Language used. |
| filters | SearchFilter | List of search expressions. Limited to 8. If additional attributes are requested (see attributes below) then the first filter's key MUST be the first requested attribute. '$Object:containerID' and '$Object:objectID' filters are prohibited. Numeric filters' values MUST be in range [-MaxUint256, MaxUint256]. |
| cursor | string | Cursor to continue search. Can be omitted or empty for the new search. |
| count | uint32 | Limits the number of responses to the specified number. Can't be more than 1000. |
| attributes | string | List of attribute names (including special ones as defined by SearchFilter key) to include into the reply. Limited to 8, these attributes also affect result ordering (result is ordered by the 1st one and then by OID). If additional attributes are requested, then the first filter's key (see filters above) MUST be the first requested attribute. '$Object:containerID' and '$Object:objectID' attributes are prohibited. If meta_header.ttl = 1 and the first filter is not STRING_EQUAL, values of the first filtered attribute are requested automatically. |
                                            

__Response Body__ SearchV2Response.Body

Main result structure.

| Field | Type | Description |
| ----- | ---- | ----------- |
| result | OIDWithMeta | List of object IDs with additional requested attributes. |
| cursor | string | Cursor that can be used for subsequent requests. For users it's an opaque string that is omitted or empty when there are no more results to list. For nodes to interoperate this is defined as the latest OID for queries without filters and primary (first) attribute value plus OID. Values are encoded in base64. |
     
### Method GetRange

Get byte range of data payload. Range is set as an (offset, length) tuple.
Like in `Get` method, the response uses gRPC stream. Requested range can be
restored by concatenation of all received payload chunks keeping the receiving
order.

Extended headers can change `GetRange` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation. DEPRECATED: header ignored by servers.
* __NEOFS__NETMAP_LOOKUP_DEPTH \
  Will try older versions of Network Map to find an object until the depth
  limit is reached. DEPRECATED: header ignored by servers.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  data range of the object payload has been successfully read;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  access to operation RANGE of the object is denied;
- **OBJECT_NOT_FOUND** (2049, SECTION_OBJECT): \
  object not found in container;
- **OBJECT_ALREADY_REMOVED** (2052, SECTION_OBJECT): \
  the requested object has been marked as deleted.
- **OUT_OF_RANGE** (2053, SECTION_OBJECT): \
  the requested range is out of bounds;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

         

__Request Body:__ GetRangeRequest.Body

Byte range of object's payload request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the object containing the requested payload range |
| range | Range | Requested payload range |
| raw | bool | If `raw` flag is set, request will work only with objects that are physically stored on the peer node. |
                                            

__Response Body__ GetRangeResponse.Body

Get Range response body uses streams to transfer the response. Because
object payload considered a byte sequence, there is no need to have some
initial preamble message. The requested byte range is sent as a series
chunks.

| Field | Type | Description |
| ----- | ---- | ----------- |
| chunk | bytes | Chunked object payload's range. |
| split_info | SplitInfo | Meta information of split hierarchy. |
                               
### Method GetRangeHash

Returns homomorphic or regular hash of object's payload range after
applying XOR operation with the provided `salt`. Ranges are set of (offset,
length) tuples. Hashes order in response corresponds to the ranges order in
the request. Note that hash is calculated for XORed data.

Extended headers can change `GetRangeHash` behaviour:
* __NEOFS__NETMAP_EPOCH \
  Will use the requsted version of Network Map for object placement
  calculation. DEPRECATED: header ignored by servers.
* __NEOFS__NETMAP_LOOKUP_DEPTH \
  Will try older versions of Network Map to find an object until the depth
  limit is reached. DEPRECATED: header ignored by servers.

Please refer to detailed `XHeader` description.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  data range of the object payload has been successfully hashed;
- Common failures (SECTION_FAILURE_COMMON);
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  access to operation RANGEHASH of the object is denied;
- **OBJECT_NOT_FOUND** (2049, SECTION_OBJECT): \
  object not found in container;
- **OUT_OF_RANGE** (2053, SECTION_OBJECT): \
  the requested range is out of bounds;
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  object container not found;
- **TOKEN_EXPIRED** (4097, SECTION_SESSION): \
  provided session token has expired.

     

__Request Body:__ GetRangeHashRequest.Body

Get hash of object's payload part request body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the object that containing the requested payload range |
| ranges | Range | List of object's payload ranges to calculate homomorphic hash |
| salt | bytes | Binary salt to XOR object's payload ranges before hash calculation |
| type | ChecksumType | Checksum algorithm type |
                                            

__Response Body__ GetRangeHashResponse.Body

Get hash of object's payload part response body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| type | ChecksumType | Checksum algorithm type |
| hash_list | bytes | List of range hashes in a binary format |
                                   
### Method Replicate

Save replica of the object on the NeoFS storage node. Both client and
server must authenticate NeoFS storage nodes matching storage policy of
the container referenced by the replicated object. Thus, this operation is
purely system: regular users should not pay attention to it but use Put.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  the object has been successfully replicated;
- **INTERNAL_SERVER_ERROR** (1024, SECTION_FAILURE_COMMON): \
  internal server error described in the text message;
- **ACCESS_DENIED** (2048, SECTION_OBJECT): \
  the client does not authenticate any NeoFS storage node matching storage
  policy of the container referenced by the replicated object
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  the container to which the replicated object is associated was not found.

                                                                                                
### Message GetResponse.Body.Init

Initial part of the `Object` structure stream. Technically it's a
set of all `Object` structure's fields except `payload`.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Object's unique identifier. |
| signature | Signature | Signed `ObjectID` |
| header | Header | Object metadata headers |
       
### Message HeaderWithSignature

Tuple of a full object header and signature of an `ObjectID`. \
Signed `ObjectID` is present to verify full header's authenticity through the
following steps:

1. Calculate `SHA-256` of the marshalled `Header` structure
2. Check if the resulting hash matches `ObjectID`
3. Check if `ObjectID` signature in `signature` field is correct

| Field | Type | Description |
| ----- | ---- | ----------- |
| header | Header | Full object header |
| signature | Signature | Signed `ObjectID` to verify full header's authenticity |
     
### Message PutRequest.Body.Init

Newly created object structure parameters. If some optional parameters
are not set, they will be calculated by a peer node.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | ObjectID if available. |
| signature | Signature | Object signature if available |
| header | Header | Object's Header. The maximum length is 16KB. |
| copies_number | uint32 | Number of the object copies to store within the RPC call. By default object is processed according to the container's placement policy. |
     
### Message Range

Object payload range. Ranges of zero length SHOULD be considered as invalid
except for the special 0:0 request which is interpreted as "get whole
payload" and allows to receive payload only when its size is not known.

| Field | Type | Description |
| ----- | ---- | ----------- |
| offset | uint64 | Offset of the range from the object payload start |
| length | uint64 | Length in bytes of the object payload range |
             
### Message SearchV2Response.OIDWithMeta

OID with additional requested metadata.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | ObjectID | Object ID that matches search criteria. |
| attributes | string | List of attribute data from the respective object, fields strictly follow requested ones. The only exception are attribute-less requests with TTL = 1 and the first non-STRING_EQUAL filter: this field carry value of the first filtered attribute. |
     
### Message Header

Object Header

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Object format version. Effectively, the version of API library used to create particular object |
| container_id | ContainerID | Object's container |
| owner_id | OwnerID | Object's owner |
| creation_epoch | uint64 | Object creation Epoch |
| payload_length | uint64 | Size of payload in bytes. `0xFFFFFFFFFFFFFFFF` means `payload_length` is unknown. |
| payload_hash | Checksum | SHA256 hash of payload bytes |
| object_type | ObjectType | Type of the object payload content |
| homomorphic_hash | Checksum | Homomorphic hash of the object payload (Tillich-Zemor). |
| session_token | SessionToken | Session token, if it was used during Object creation. Need it to verify integrity and authenticity out of Request scope. |
| attributes | Attribute | User-defined object attributes. Attributes vary in length from object to object, so keep an eye on the entire Header limit depending on the context. |
| split | Split | Position of the object in the split hierarchy |
   
### Message Header.Attribute

`Attribute` is a user-defined Key-Value metadata pair attached to an
object.

Key name must be an object-unique valid UTF-8 string. Value can't be empty.
Objects with duplicated attribute names or attributes with empty values
will be considered invalid. Keys and values can't contain zero bytes as
well.

There are some "well-known" attributes starting with `__NEOFS__` prefix
that affect system behaviour:

* __NEOFS__EXPIRATION_EPOCH \
  Tells GC to delete object after that epoch (but object is available
  throughout the epoch specified in this attribute).
* __NEOFS__ASSOCIATE \
  Associated object. For TOMBSTONE, LOCK object types it defines object
  to delete and to lock accordingly. For objects of 2.18+ API version, it
  is the only way to delete/lock objects. It MUST be a single stringified
  (according to [refs.ObjectID] message) object ID with no leading or
  trailing spaces.
* __NEOFS__TICK_EPOCH \
  Decimal number that defines what epoch must produce
  object notification with UTF-8 object address in a
  body (`0` value produces notification right after
  object put).
  DEPRECATED: attribute ignored by servers.
* __NEOFS__TICK_TOPIC \
  UTF-8 string topic ID that is used for object notification.
  DEPRECATED: attribute ignored by servers.
* __NEOFS__EC_RULE_IDX \
  Index of EC rule in container's `PlacementPolicy.ec_rules` according to
  which the part was created. Base-10 integer.
* __NEOFS__EC_PART_IDX \
  Index in the EC parts into which the parent object is divided according
  to `__NEOFS__EC_RULE_IDX` EC rule. Base-10 integer.
* __NEOFS__EC_PART_HASHES \
  Ordered list of payload hashes of EC parts into which this object is
  divided. Hash function is SHA-256. Items are comma-separated, each item
  is hex-encoded.

And some well-known attributes used by applications only:

* Name \
  Human-friendly name
* FileName \
  File name to be associated with the object on saving
* FilePath \
  Full path to be associated with the object on saving. Should start with a
  '/' and use '/' as a delimiting symbol. Trailing '/' should be
  interpreted as a virtual directory marker. If an object has conflicting
  FilePath and FileName, FilePath should have higher priority, because it
  is used to construct the directory tree. FilePath with trailing '/' and
  non-empty FileName attribute should not be used together.
* Timestamp \
  User-defined local time of object creation in Unix Timestamp format
* Content-Type \
  MIME Content Type of object's payload

For detailed description of each well-known attribute please see the
corresponding section in NeoFS Technical Specification.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | string key to the object attribute |
| value | string | string value of the object attribute |
   
### Message Header.Split

Bigger objects can be split into a chain of smaller objects. Information
about inter-dependencies between spawned objects and how to re-construct
the original one is in the `Split` headers. Parent and children objects
must be within the same container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| parent | ObjectID | Identifier of the origin object. If the origin object is split to comply with the object size limit, `parent` is known only to the minor child. |
| previous | ObjectID | Identifier of the left split neighbor |
| parent_signature | Signature | `signature` field of the parent object. Used to reconstruct parent. |
| parent_header | Header | `header` field of the parent object. Used to reconstruct parent. |
| children | ObjectID | DEPRECATED. Was used before creating the separate LINK object type. Keep child objects list in the LINK object's payload. List of identifiers of the objects generated by splitting current one. |
| split_id | bytes | DEPRECATED. Was used as an identifier of a split chain. Use the first part ID instead. 16 byte UUIDv4 used to identify the split object hierarchy parts. Must be unique inside container. All objects participating in the split must have the same `split_id` value. |
| first | ObjectID | Identifier of the first part of the origin object. Known to all the split parts except the first one. Identifies the split and allows to differ them. |
   
### Message Object

Object structure. Object is immutable and content-addressed. It means
`ObjectID` will change if the header or the payload changes. It's calculated as a
hash of header field which contains hash of the object's payload.

For non-regular object types payload format depends on object type specified
in the header.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Object's unique identifier. |
| signature | Signature | Signed object_id |
| header | Header | Object metadata headers |
| payload | bytes | Payload bytes |
   
### Message SearchFilter

Filter structure checks if the object header field or the attribute content
matches a value.

If no filters are set, search request will return all objects of the
container, including Regular object, Tombstones and Storage Group
objects. Most human users expect to get only object they can directly
work with. In that case, `$Object:ROOT` filter should be used.

If `match_type` field is numerical, both `value` field and object
attribute MUST be base-10 integers.

By default `key` field refers to the corresponding object's `Attribute`.
Some Object's header fields can also be accessed by adding `$Object:`
prefix to the name. Here is the list of fields available via this prefix:

* $Object:version \
  version
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
* $Object:split.parent \
  object_id of parent
* $Object:split.splitID \
  16 byte UUIDv4 used to identify the split object hierarchy parts
* $Object:split.first \
  object_id of the first part in split chain; non-acceptable for deprecated V1 split scheme

There are some well-known filter aliases to match objects by certain
properties:

* $Object:ROOT \
  Returns only `REGULAR` type objects that are not split or that are the top
  level root objects in a split hierarchy. This includes objects not
  present physically, like large objects split into smaller objects
  without a separate top-level root object. Objects of other types like
  StorageGroups and Tombstones will not be shown. This filter may be
  useful for listing objects like `ls` command of some virtual file
  system. This filter is activated if the `key` exists, disregarding the
  value and matcher type.
* $Object:PHY \
  Returns only objects physically stored in the system. This filter is
  activated if the `key` exists, disregarding the value and matcher type.

Following filters are deprecated:

* $Object:objectID \
  object_id
* $Object:containerID \
  container_id

Note: using filters with a key with prefix `$Object:` and match type
`NOT_PRESENT `is not recommended since this is not a cross-version approach.
Behavior when processing this kind of filters is undefined.

| Field | Type | Description |
| ----- | ---- | ----------- |
| match_type | MatchType | Match type to use |
| key | string | Attribute or Header fields to match |
| value | string | Value to match |
   
### Message ShortHeader

Short header fields

DEPRECATED. It is not supported in practice and should not be used. Use full
Header instead.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Object format version. Effectively, the version of API library used to create particular object. |
| creation_epoch | uint64 | Epoch when the object was created |
| owner_id | OwnerID | Object's owner |
| object_type | ObjectType | Type of the object payload content |
| payload_length | uint64 | Size of payload in bytes. `0xFFFFFFFFFFFFFFFF` means `payload_length` is unknown |
| payload_hash | Checksum | SHA256 hash of payload bytes. |
| homomorphic_hash | Checksum | Homomorphic hash of the object payload (Tillich-Zemor). |
   
### Message SplitInfo

Meta information of split hierarchy for object assembly. With the last part
one can traverse linked list of split hierarchy back to the first part and
assemble the original object. With a linking object one can assemble an object
right from the object parts.

| Field | Type | Description |
| ----- | ---- | ----------- |
| split_id | bytes | DEPRECATED. Was used as an identifier of a split chain. Use the first part ID instead. 16 byte UUID used to identify the split object hierarchy parts. |
| last_part | ObjectID | The identifier of the last object in split hierarchy parts. It contains split header with the original object header. |
| link | ObjectID | The identifier of a linking object for split hierarchy parts. It contains split header with the original object header and a sorted list of object parts. |
| first_part | ObjectID | Identifier of the first part of the origin object. Known to all the split parts except the first one. Identifies the split and allows to differ them. |
    
### Emun MatchType

Type of match expression

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | MATCH_TYPE_UNSPECIFIED | Unknown. Not used |
| 1 | STRING_EQUAL | Full string match |
| 2 | STRING_NOT_EQUAL | Full string mismatch |
| 3 | NOT_PRESENT | Lack of key |
| 4 | COMMON_PREFIX | String prefix match |
| 5 | NUM_GT | Numerical 'greater than' |
| 6 | NUM_GE | Numerical 'greater or equal than' |
| 7 | NUM_LT | Numerical 'less than' |
| 8 | NUM_LE | Numerical 'less or equal than' |

### Emun ObjectType

Type of the object payload content. Only `REGULAR` type objects can be split,
hence `TOMBSTONE`, `STORAGE_GROUP` and `LOCK` payload is limited by the maximum
object size.

String presentation of object type is the same as definition:
* REGULAR
* TOMBSTONE
* STORAGE_GROUP
* LOCK
* LINK

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | REGULAR | Just a normal object |
| 1 | TOMBSTONE | Used internally to identify deleted objects |
| 2 | STORAGE_GROUP | StorageGroup information. DEPRECATED: no longer used for audit since 2.18. |
| 3 | LOCK | Object lock |
| 4 | LINK | Object that stores child object IDs for the split objects. |
 
