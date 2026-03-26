## neo.fs.v2.container



### Service "ContainerService"

`ContainerService` provides API to interact with `Container` smart contract
in FS chain via other NeoFS nodes. All of those actions can be done
equivalently by directly issuing transactions and RPC calls to FS chain
nodes.


### Method Put

Sends transaction calling contract method to create container, and waits
for the transaction to be executed. Deadline is determined by the
transport protocol (e.g. `grpc-timeout` header). If the deadline is not
set, server waits 15s after submitting the transaction.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container successfully created;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_AWAIT_TIMEOUT** (3075, SECTION_CONTAINER): \
  transaction was sent but not executed within the deadline.

                      

__Request Body:__ PutRequest.Body

Container creation request has container structure's signature as a
separate field. It's not stored in FS chain, just verified on container
creation by `Container` smart contract. `ContainerID` is a SHA256 hash of
the stable-marshalled container strucutre, hence there is no need for
additional signature checks.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Container structure to register in NeoFS |
| signature | SignatureRFC6979 | Signature of a stable-marshalled container according to RFC-6979. |
                                          

__Response Body__ PutResponse.Body

Container put response body contains information about the newly registered
container as seen by `Container` smart contract. `ContainerID` can be
calculated beforehand from the container structure and compared to the one
returned here to make sure everything has been done as expected.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Unique identifier of the newly created container |
                
### Method Delete

Sends transaction calling contract method to delete container, and waits
for the transaction to be executed. Deadline is determined by the
transport protocol (e.g. `grpc-timeout` header). If the deadline is not
set, server waits 15s after submitting the transaction.
NOTE: a container deletion leads to the removal of every object in that
container, regardless of any restrictions on the object removal (e.g. lock/locked
object would be also removed).

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container successfully removed;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_LOCKED** (3074, SECTION_CONTAINER): \
  deleting a locked container is prohibited;
- **CONTAINER_AWAIT_TIMEOUT** (3075, SECTION_CONTAINER): \
  transaction was sent but not executed within the deadline.

      

__Request Body:__ DeleteRequest.Body

Container removal request body has signed `ContainerID` as a proof of
the container owner's intent. The signature will be verified by `Container`
smart contract, so signing algorithm must be supported by NeoVM.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to delete from NeoFS |
| signature | SignatureRFC6979 | `ContainerID` signed with the container owner's key according to RFC-6979. |
                                          

__Response Body__ DeleteResponse.Body

`DeleteResponse` has an empty body because delete operation is asynchronous
and done via consensus in Inner Ring nodes.

                               
### Method Get

Returns container structure from `Container` smart contract storage.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container has been successfully read;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  requested container not found.

              

__Request Body:__ GetRequest.Body

Get container structure request body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to get |
                                          

__Response Body__ GetResponse.Body

Get container response body does not have container structure signature. It
has been already verified upon container creation.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Requested container structure |
| signature | SignatureRFC6979 | Signature of a stable-marshalled container according to RFC-6979. |
| session_token | SessionToken | Session token if the container has been created within the session |
                        
### Method List

Returns all owner's containers from 'Container` smart contract' storage.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container list has been successfully read;
- Common failures (SECTION_FAILURE_COMMON).

                  

__Request Body:__ ListRequest.Body

List containers request body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Identifier of the container owner |
                                          

__Response Body__ ListResponse.Body

List containers response body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_ids | ContainerID | List of `ContainerID`s belonging to the requested `OwnerID` |
                    
### Method SetExtendedACL

Sends transaction calling contract method to set container's extended ACL,
and waits for the transaction to be executed. Deadline is determined by
the transport protocol (e.g. `grpc-timeout` header). If the deadline is
not set, server waits 15s after submitting the transaction.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container eACL successfully set;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_AWAIT_TIMEOUT** (3075, SECTION_CONTAINER): \
  transaction was sent but not executed within the deadline.

                                  

__Request Body:__ SetExtendedACLRequest.Body

Set Extended ACL request body does not have separate `ContainerID`
reference. It will be taken from `EACLTable.container_id` field.

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL table to set for the container |
| signature | SignatureRFC6979 | Signature of stable-marshalled Extended ACL table according to RFC-6979. |
                                          

__Response Body__ SetExtendedACLResponse.Body

`SetExtendedACLResponse` has an empty body because the operation is
asynchronous and the update should be reflected in `Container` smart contract's
storage after next block is issued in FS chain.

   
### Method GetExtendedACL

Returns Extended ACL table and signature from `Container` smart contract
storage.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  container eACL has been successfully read;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_NOT_FOUND** (3072, SECTION_CONTAINER): \
  container not found;
- **EACL_NOT_FOUND** (3073, SECTION_CONTAINER): \
  eACL table not found.

          

__Request Body:__ GetExtendedACLRequest.Body

Get Extended ACL request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container having Extended ACL |
                                          

__Response Body__ GetExtendedACLResponse.Body

Get Extended ACL Response body can be empty if the requested container does
not have Extended ACL Table attached or Extended ACL has not been allowed at
the time of container creation.

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL requested, if available |
| signature | SignatureRFC6979 | Signature of stable-marshalled Extended ACL according to RFC-6979. |
| session_token | SessionToken | Session token if Extended ACL was set within a session |
                            
### Method AnnounceUsedSpace

Announces the space values used by the container for P2P synchronization.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  estimation of used space has been successfully announced;
- Common failures (SECTION_FAILURE_COMMON).

DEPRECATED: every storage node must send storage load directly to `container`
contract.

 

__Request Body:__ AnnounceUsedSpaceRequest.Body

Container used space announcement body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| announcements | Announcement | List of announcements. If nodes share several containers, announcements are transferred in a batch. |
                                           

__Response Body__ AnnounceUsedSpaceResponse.Body

`AnnounceUsedSpaceResponse` has an empty body because announcements are
one way communication.

                                   
### Method SetAttribute

Sends transaction calling contract method to set container attribute, and
waits for the transaction to be executed. Deadline is determined by the
transport protocol (e.g. `grpc-timeout` header). If the deadline is not
set, server waits 15s after submitting the transaction.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  attribute successfully set;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_AWAIT_TIMEOUT** (3075, SECTION_CONTAINER): \
  transaction was sent but not executed within the deadline.

                              

__Request Body:__ SetAttributeRequest.Body

Request payload message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| parameters | Parameters | Op parameters. |
| signature | SignatureRFC6979 | N3 witness of stable-marshalled `parameters` field. The signature must authenticate either container owner or one of subjects in the `session_token` field if any. Signature according to `ECDSA_RFC6979_SHA256` scheme is also supported. |
| session_token | SessionTokenV2 | Optional session token. The token must be issued by the container owner. The token must have at least one subject authenticated by `signature` field. The token must have at least one context with this container and `CONTAINER_SETATTRIBUTE` verb. |
| session_token_v1 | SessionToken | Optional session token (V1). It must not be set together with `session_token` field that is highly recommended to be used instead. Requirements are the same for both. |
                                                
### Method RemoveAttribute

Sends transaction calling contract method to remove container attribute,
and waits for the transaction to be executed. Deadline is determined by
the transport protocol (e.g. `grpc-timeout` header). If the deadline is
not set, server waits 15s after submitting the transaction.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  attribute successfully removed;
- Common failures (SECTION_FAILURE_COMMON);
- **CONTAINER_AWAIT_TIMEOUT** (3075, SECTION_CONTAINER): \
  transaction was sent but not executed within the deadline.

                          

__Request Body:__ RemoveAttributeRequest.Body

Request payload message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| parameters | Parameters | Op parameters. |
| signature | SignatureRFC6979 | N3 witness of stable-marshalled `parameters` field. The signature must authenticate either container owner or one of subjects in the `session_token` field if any. Signature according to `ECDSA_RFC6979_SHA256` scheme is also supported. |
| session_token | SessionTokenV2 | Optional session token. The token must be issued by the container owner. The token must have at least one subject authenticated by `signature` field. The token must have at least one context with this container and `CONTAINER_REMOVEATTRIBUTE` verb. |
| session_token_v1 | SessionToken | Optional session token (V1). It must not be set together with `session_token` field that is highly recommended to be used instead. Requirements are the same for both. |
                                                      
### Message AnnounceUsedSpaceRequest.Body.Announcement

Announcement contains used space information for a single container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| epoch | uint64 | Epoch number for which the container size estimation was produced. |
| container_id | ContainerID | Identifier of the container. |
| used_space | uint64 | Used space is a sum of object payload sizes of a specified container, stored in the node. It must not include inhumed objects. |
                           
### Message RemoveAttributeRequest.Body.Parameters

Op parameters message.

If container does not have the `attribute`, nothing is done and status
`OK` is returned.

`valid_until` is required request expiration time in Unix Timestamp
format.

`attribute` must be one of:
 - `CORS`;
 - `S3_TAGS`;
 - `S3_SETTINGS`;
 - `S3_NOTIFICATIONS`;
 - `__NEOFS__LOCK_UNTIL`.

Attribute-specific requirements:
 - `__NEOFS__LOCK_UNTIL`: current timestamp must have already passed if any

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to remove attribute from. |
| attribute | string | Attribute to be removed. |
| valid_until | uint64 | Request expiration time. |
      
### Message SetAttributeRequest.Body.Parameters

Op parameters message.

If container does not have the `attribute`, it is added. Otherwise, its
value is swapped.

`valid_until` is required request expiration time in Unix Timestamp
format.

`attribute` must be one of:
 - `CORS`;
 - `S3_TAGS`;
 - `S3_SETTINGS`;
 - `S3_NOTIFICATIONS`;
 - `__NEOFS__LOCK_UNTIL`.

In general, requirements for `value` are the same as for container
creation. Attribute-specific requirements:
 - `__NEOFS__LOCK_UNTIL`: new timestamp must be after the current one if any
 - `S3_TAGS`: must be a valid JSON object
 - `S3_SETTINGS`: must be a valid JSON object
 - `S3_NOTIFICATIONS`: must be a valid JSON object

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to set attribute for. |
| attribute | string | Attribute to be set. |
| value | string | New attribute value. |
| valid_until | uint64 | Request expiration time. |
          
### Message Container

Container is a structure that defines object placement behaviour. Objects can
be stored only within containers. They define placement rule, attributes and
access control information. An ID of a container is a 32 byte long SHA256 hash
of stable-marshalled container message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Container format version. Effectively, the version of API library used to create the container. |
| owner_id | OwnerID | Identifier of the container owner |
| nonce | bytes | Nonce is a 16 byte UUIDv4, used to avoid collisions of `ContainerID`s |
| basic_acl | uint32 | `BasicACL` contains access control rules for the owner, system and others groups, as well as permission bits for `BearerToken` and `Extended ACL` |
| attributes | Attribute | Attributes represent immutable container's meta data |
| placement_policy | PlacementPolicy | Placement policy for the object inside the container |
   
### Message Container.Attribute

`Attribute` is a user-defined Key-Value metadata pair attached to the
container.

Key name must be a container-unique valid UTF-8 string. Value can't be
empty. Containers with duplicated attribute names or attributes with empty
values will be considered invalid. Zero byte is also forbidden in UTF-8
strings.

There are some "well-known" attributes affecting system behaviour:

* __NEOFS__SUBNET \
  DEPRECATED. Was used for a string ID of a container's storage subnet.
  Currently doesn't affect anything.
* __NEOFS__NAME \
  String of a human-friendly container name registered as a domain in
  NNS contract.
* __NEOFS__ZONE \
  String of a zone for `__NEOFS__NAME`. Used as a TLD of a domain name in NNS
  contract. If no zone is specified, use default zone: `container`.
* __NEOFS__DISABLE_HOMOMORPHIC_HASHING \
  Disables homomorphic hashing for the container if the value equals "true" string.
  Any other values are interpreted as missing attribute. Container could be
  accepted in a NeoFS network only if the global network hashing configuration
  value corresponds with that attribute's value. After container inclusion, network
  setting is ignored.
* __NEOFS__METAINFO_CONSISTENCY \
  Policy rule that defines the condition under which an object is considered
  processed. Acceptable values and meanings:
    1. "strict": SN processes objects' meta information, it is validated,
      indexed and signed accordingly by a required minimal number of nodes
      that are included in the container, a corresponding object inclusion
      notification can be caught
    2. "optimistic": the same as "strict" but a successful PUT operation
      does not mean objects' meta information has been multi signed and
      indexed correctly, however, SNs will try to do it asynchronously;
      in general PUT operations are expected to be faster than in the
      "strict" case
    3. <other cases>: SN does not process objects' meta
      information, it is not indexed and object presence/number of copies
      is not proven after a successful object PUT operation; the behavior
      is the same as it was before this attribute introduction
* __NEOFS__LOCK_UNTIL \
  Timestamp until which the container cannot be deleted in Unix Timestamp format

And some well-known attributes used by applications only:

* Name \
  Human-friendly name
* Timestamp \
  User-defined local time of container creation in Unix Timestamp format
* CORS \
  It is used to configure your container to allow cross-origin requests (CORS). The rules are represented as a JSON
  array of objects with the following fields:
    1. "AllowedMethods": In this element, you specify allowed HTTP methods: GET, PUT, POST, DELETE, HEAD.
    2. "AllowedOrigins": In this element, you specify the origins that you want to allow cross-domain requests from,
    for example, http://www.example.com. The origin string can contain only one "*" wildcard character,
    such as http://*.example.com. You can optionally specify "*" as the origin to enable all the origins to send
    cross-origin requests. You can also specify https to enable only secure origins.
    3. "AllowedHeaders": The element specifies which headers are allowed in a preflight request through the
    "Access-Control-Request-Headers" request header. Each AllowedHeaders string in your configuration can contain
    at most one "*" wildcard character. For example, x-app-*.
    4. "ExposeHeaders": Each ExposeHeader element identifies a header in the response that you want customers
    to be able to access from their applications (for example, from a JavaScript XMLHttpRequest object).
    5. "MaxAgeSeconds": The element specifies the time in seconds that your browser can cache the response for a
    preflight request as identified by the resource, the HTTP method, and the origin.
    
    The CORS schema is based on Amazon S3 CORS (https://docs.aws.amazon.com/AmazonS3/latest/userguide/cors.html)
    configuration.
* S3_TAGS \
  It is used to store S3 gate-specific container tags. The value is controlled by the gate itself.
  Despite it, the value must be valid JSON object.
* S3_SETTINGS \
  It is used to store S3 gate-specific container settings. The value is controlled by the gate itself.
  Despite it, the value must be valid JSON object.
* S3_NOTIFICATIONS \
  It is used to store S3 gate-specific container notification settings. The value is controlled by the gate itself.
  Despite it, the value must be valid JSON object.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Attribute name key |
| value | string | Attribute value |
     
