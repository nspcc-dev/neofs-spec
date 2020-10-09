## neo.fs.v2.container



### Service "ContainerService"

ContainerService provides API to access container smart-contract in morph chain
via NeoFS node.


### Method Put

Put invokes 'Put' method in container smart-contract and returns
response immediately. After new block in morph chain, request is verified
by inner ring nodes. After one more block in morph chain, container
added into smart-contract storage.

                 

__Request Body:__ PutRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Container to create in NeoFS. |
| signature | Signature | Signature of stable-marshalled container according to RFC-6979. |
                             

__Response Body__ PutResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | container_id carries identifier of the new container. |
        
### Method Delete

Delete invokes 'Delete' method in container smart-contract and returns
response immediately. After new block in morph chain, request is verified
by inner ring nodes. After one more block in morph chain, container
removed from smart-contract storage.

 

__Request Body:__ DeleteRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | container_id carries identifier of the container to delete from NeoFS. |
| signature | Signature | Signature of container id according to RFC-6979. |
                             

__Response Body__ DeleteResponse.Body

Response body

                       
### Method Get

Get returns container from container smart-contract storage.

         

__Request Body:__ GetRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | container_id carries identifier of the container to get. |
                             

__Response Body__ GetResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | Container | Container that has been requested. |
                
### Method List

List returns all owner's containers from container smart-contract
storage.

             

__Request Body:__ ListRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | owner_id carries identifier of the container owner. |
                             

__Response Body__ ListResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_ids | ContainerID | ContainerIDs carries list of identifiers of the containers that belong to the owner. |
            
### Method SetExtendedACL

SetExtendedACL invokes 'SetEACL' method in container smart-contract and
returns response immediately. After new block in morph chain,
Extended ACL added into smart-contract storage.

                     

__Request Body:__ SetExtendedACLRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL to set for the container. |
| signature | Signature | Signature of stable-marshalled Extended ACL according to RFC-6979. |
                             

__Response Body__ SetExtendedACLResponse.Body

Response body

   
### Method GetExtendedACL

GetExtendedACL returns Extended ACL table and signature from container
smart-contract storage.

     

__Request Body:__ GetExtendedACLRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | container_id carries identifier of the container that has Extended ACL. |
                             

__Response Body__ GetExtendedACLResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| eacl | EACLTable | Extended ACL that has been requested if it was set up. |
| signature | Signature | Signature of stable-marshalled Extended ACL according to RFC-6979. |
                                              
### Message Container

Container is a structure that defines object placement behaviour. Objects
can be stored only within containers. They define placement rule, attributes
and access control information. ID of the container is a 32 byte long
SHA256 hash of stable-marshalled container message.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Container format version. Effectively the version of API library used to create container |
| owner_id | OwnerID | OwnerID carries identifier of the container owner. |
| nonce | bytes | Nonce is a 16 byte UUID, used to avoid collisions of container id. |
| basic_acl | uint32 | BasicACL contains access control rules for owner, system, others groups and permission bits for bearer token and Extended ACL. |
| attributes | Attribute | Attributes define any immutable characteristics of container. |
| placement_policy | PlacementPolicy | Placement policy for the object inside the container. |
   
### Message Container.Attribute

Attribute is a key-value pair of strings.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Key of immutable container attribute. |
| value | string | Value of immutable container attribute. |
     
