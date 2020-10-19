## neo.fs.v2.container



### Service "ContainerService"

`ContainerService` provides API to interact with `Container` smart contract
in NeoFS sidechain via other NeoFS nodes. All of those actions can be done
equivalently by directly issuing transactions and RPC calls to sidechain
nodes.


### Method Put

`Put` invokes `Container` smart contract's `Put` method and returns
response immediately. After a new block is issued in sidechain, request is
verified by Inner Ring nodes. After one more block in sidechain, container
is added into smart contract storage.

                 

__Request Body:__ PutRequest.Body

Container creation request has container structure's signature as a
separate field. It's not stored in sidechain, just verified on container
creation by `Container` smart contract. `ContainerID` is a SHA256 hash of
the stable-marshalled container strucutre, hence there is no need for
additional signature checks.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Container structure to register in NeoFS |
| signature | Signature | Signature of a stable-marshalled container according to RFC-6979 |
                             

__Response Body__ PutResponse.Body

Container put response body contains information about the newly registered
container as seen by `Container` smart contract. `ContainerID` can be
calculated beforehand from the container structure and compared to the one
returned here to make sure everything was done as expected.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Unique identifier of the newly created container |
        
### Method Delete

`Delete` invokes `Container` smart contract's `Delete` method and returns
response immediately. After a new block is issued in sidechain, request is
verified by Inner Ring nodes. After one more block in sidechain, container
is added into smart contract storage.

 

__Request Body:__ DeleteRequest.Body

Container removal request body has a signed `ContainerID` as a proof of
container owner's intent. The signature will be verified by `Container`
smart contract, so signing algorithm must be supported by NeoVM.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to delete from NeoFS |
| signature | Signature | `ContainerID` signed with the container owner's key according to RFC-6979 |
                             

__Response Body__ DeleteResponse.Body

`DeleteResponse` has an empty body because delete operation is asynchronous
and done via consensus in Inner Ring nodes.

                       
### Method Get

Returns container structure from `Container` smart contract storage.

         

__Request Body:__ GetRequest.Body

Get container structure request body.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container to get |
                             

__Response Body__ GetResponse.Body

Get container response body does not have container structure signature. It
was already verified on container creation.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Requested container structure |
                
### Method List

Returns all owner's containers from 'Container` smart contract' storage.

             

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
immediately. After one more block in sidechain, Extended ACL changes are
added into smart contract storage.

                     

__Request Body:__ SetExtendedACLRequest.Body

Set Extended ACL request body does not have separate `ContainerID`
reference. It will be taken from `EACLTable.container_id` field.

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL table to set for container |
| signature | Signature | Signature of stable-marshalled Extended ACL table according to RFC-6979 |
                             

__Response Body__ SetExtendedACLResponse.Body

`SetExtendedACLResponse` has an empty body because the operation is
asynchronous and update should be reflected in `Container` smart contract's
storage after next block is issued in sidechain.

   
### Method GetExtendedACL

Returns Extended ACL table and signature from `Container` smart contract
storage.

     

__Request Body:__ GetExtendedACLRequest.Body

Get Extended ACL request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Identifier of the container having Extended ACL |
                             

__Response Body__ GetExtendedACLResponse.Body

Get Extended ACL Response body can be empty if the requested container did
not have Extended ACL Table attached or Extended ACL was not allowed at
container creation.

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL requested, if available |
| signature | Signature | Signature of stable-marshalled Extended ACL according to RFC-6979 |
                                              
### Message Container

Container is a structure that defines object placement behaviour. Objects can
be stored only within containers. They define placement rule, attributes and
access control information. ID of the container is a 32 byte long SHA256 hash
of stable-marshalled container message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Container format version. Effectively the version of API library used to create container. |
| owner_id | OwnerID | Identifier of the container owner |
| nonce | bytes | Nonce is a 16 byte UUID, used to avoid collisions of container id |
| basic_acl | uint32 | `BasicACL` contains access control rules for owner, system, others groups and permission bits for `BearerToken` and `Extended ACL` |
| attributes | Attribute | Attributes represent immutable container's meta data |
| placement_policy | PlacementPolicy | Placement policy for the object inside the container |
   
### Message Container.Attribute

`Attribute` is a user-defined Key-Value metadata pair attached to the
container. Container attribute are immutable. They are set at container
creation and cna never be added or updated.

There are some "well-known" attributes affecting system behaviour:

* Subnet \
  String ID of container's storage subnet. Container can be attached to
  only one subnet.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Attribute name key |
| value | string | Attribute value |
     
