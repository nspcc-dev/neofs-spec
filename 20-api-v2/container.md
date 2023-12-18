## neo.fs.v2.container



### Service "ContainerService"

`ContainerService` provides API to interact with `Container` smart contract
in NeoFS sidechain via other NeoFS nodes. All of those actions can be done
equivalently by directly issuing transactions and RPC calls to sidechain
nodes.


### Method Put

`Put` invokes `Container` smart contract's `Put` method and returns
response immediately. After a new block is issued in sidechain, request is
verified by Inner Ring nodes. After one more block in sidechain, the container
is added into smart contract storage.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  request to save the container has been sent to the sidechain;
- Common failures (SECTION_FAILURE_COMMON).

                      

__Request Body:__ PutRequest.Body

Container creation request has container structure's signature as a
separate field. It's not stored in sidechain, just verified on container
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

`Delete` invokes `Container` smart contract's `Delete` method and returns
response immediately. After a new block is issued in sidechain, request is
verified by Inner Ring nodes. After one more block in sidechain, the container
is added into smart contract storage.
NOTE: a container deletion leads to the removal of every object in that
container, regardless of any restrictions on the object removal (e.g. lock/locked
object would be also removed).

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  request to remove the container has been sent to the sidechain;
- Common failures (SECTION_FAILURE_COMMON).

      

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

Invokes 'SetEACL' method of 'Container` smart contract and returns response
immediately. After one more block in sidechain, changes in an Extended ACL are
added into smart contract storage.

Statuses:
- **OK** (0, SECTION_SUCCESS): \
  request to save container eACL has been sent to the sidechain;
- Common failures (SECTION_FAILURE_COMMON).

                          

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
storage after next block is issued in sidechain.

   
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

 

__Request Body:__ AnnounceUsedSpaceRequest.Body

Container used space announcement body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| announcements | Announcement | List of announcements. If nodes share several containers, announcements are transferred in a batch. |
                                   

__Response Body__ AnnounceUsedSpaceResponse.Body

`AnnounceUsedSpaceResponse` has an empty body because announcements are
one way communication.

                             
### Message AnnounceUsedSpaceRequest.Body.Announcement

Announcement contains used space information for a single container.

| Field | Type | Description |
| ----- | ---- | ----------- |
| epoch | uint64 | Epoch number for which the container size estimation was produced. |
| container_id | ContainerID | Identifier of the container. |
| used_space | uint64 | Used space is a sum of object payload sizes of a specified container, stored in the node. It must not include inhumed objects. |
                               
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
container. Container attributes are immutable. They are set at the moment of
container creation and can never be added or updated.

Key name must be a container-unique valid UTF-8 string. Value can't be
empty. Containers with duplicated attribute names or attributes with empty
values will be considered invalid.

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

And some well-known attributes used by applications only:

* Name \
  Human-friendly name
* Timestamp \
  User-defined local time of container creation in Unix Timestamp format

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Attribute name key |
| value | string | Attribute value |
     
