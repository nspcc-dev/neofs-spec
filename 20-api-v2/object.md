## neo.fs.v2.object



### Service "ObjectService"

Object service provides API for manipulating with the object.


### Method Get

Get the object from container. Response uses gRPC stream. First response
message carry object of requested address. Chunk messages are parts of
the object's payload if it is needed. All messages except first carry
chunks. Requested object can be restored by concatenation of object
message payload and all chunks keeping receiving order.

             

__Request Body:__ GetRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the requested object. |
| raw | bool | Carries the raw option flag of the request. Raw request is sent to receive only the objects that are physically stored on the server. |
                                      

__Response Body__ GetResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| init | Init | Initialization parameters of the object stream. |
| chunk | bytes | Part of the object payload. |
                     
### Method Put

Put the object into container. Request uses gRPC stream. First message
SHOULD BE type of PutHeader. Container id and Owner id of object SHOULD
BE set. Session token SHOULD BE obtained before put operation (see
session package). Chunk messages considered by server as part of object
payload. All messages except first SHOULD BE chunks. Chunk messages
SHOULD BE sent in direct order of fragmentation.

                       

__Request Body:__ PutRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| init | Init | Carries the initialization parameters of the object stream. |
| chunk | bytes | Carries part of the object payload. |
                                       

__Response Body__ PutResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Carries identifier of the saved object. It is used to access an object in the container. |
          
### Method Delete

Delete the object from a container

 

__Request Body:__ DeleteRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Carries the address of the object to be deleted. |
                                      

__Response Body__ DeleteResponse.Body

Response body

                                
### Method Head

Head returns the object without data payload. Object in the
response has system header only. If full headers flag is set, extended
headers are also present.

                  

__Request Body:__ HeadRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address of the object with the requested header. |
| main_only | bool | Return only minimal header subset |
| raw | bool | Carries the raw option flag of the request. Raw request is sent to receive only the headers of the objects that are physically stored on the server. |
                                      

__Response Body__ HeadResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| header | HeaderWithSignature | Full object header with object ID signature |
| short_header | ShortHeader | Short object header |
                
### Method Search

Search objects in container. Version of query language format SHOULD BE
set to 1. Search query represented in serialized format (see query
package).

                             

__Request Body:__ SearchRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| container_id | ContainerID | Carries search container identifier. |
| version | uint32 | Version of the Query Language used |
| filters | Filter | List of search expressions |
                                       

__Response Body__ SearchResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| id_list | ObjectID | Carries list of object identifiers that match the search query |
    
### Method GetRange

GetRange of data payload. Range is a pair (offset, length).
Requested range can be restored by concatenation of all chunks
keeping receiving order.

         

__Request Body:__ GetRangeRequest.Body

Request Body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Address carries address of the object that contains the requested payload range. |
| range | Range | Range carries the parameters of the requested payload range. |
                                      

__Response Body__ GetRangeResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| chunk | bytes | Carries part of the object payload. |
                         
### Method GetRangeHash

GetRangeHash returns homomorphic hash of object payload range after XOR
operation. Ranges are set of pairs (offset, length). Hashes order in
response corresponds to ranges order in request. Homomorphic hash is
calculated for XORed data.

     

__Request Body:__ GetRangeHashRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| address | Address | Carries address of the object that contains the requested payload range. |
| ranges | Range | Carries the list of object payload range to calculate homomorphic hash. |
| salt | bytes | Carries binary salt to XOR object payload ranges before hash calculation. |
| type | ChecksumType | Checksum algorithm type |
                                      

__Response Body__ GetRangeHashResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| type | ChecksumType | Checksum algorithm type |
| hash_list | bytes | List of range hashes in a binary format. |
                                             
### Message GetResponse.Body.Init

Initialization parameters of the object got from NeoFS.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Object ID |
| signature | Signature | Object signature |
| header | Header | Object header. |
       
### Message HeaderWithSignature

Tuple of full object header and signature of object ID.

| Field | Type | Description |
| ----- | ---- | ----------- |
| header | Header | Full object header |
| signature | Signature | Signed object_id to verify full header's authenticity through following steps: 1. Calculate SHA-256 of marshalled Headers structure. 2. Check if the resulting hash matched ObjectID 3. Check if ObjectID's signature in signature field is correct. |
     
### Message PutRequest.Body.Init

Groups initialization parameters of object placement in NeoFS.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Object ID, where available |
| signature | Signature | Object signature, were available |
| header | Header | Header of the object to save in the system. |
| copies_number | uint32 | Number of the object copies to store within the RPC call. Default zero value is processed according to the container placement rules. |
     
### Message Range

Range groups the parameters of object payload range.

| Field | Type | Description |
| ----- | ---- | ----------- |
| offset | uint64 | Carries the offset of the range from the object payload start. |
| length | uint64 | Carries the length of the object payload range. |
     
### Message SearchRequest.Body.Filter

Filter structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| match_type | MatchType | Match type to use |
| name | string | Header name to match |
| value | string | Header value to match |
       
### Message Header

Object Headers

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Object format version. Effectively the version of API library used to create particular object |
| container_id | ContainerID | Object's container |
| owner_id | OwnerID | Object's owner |
| creation_epoch | uint64 | Object creation Epoch |
| payload_length | uint64 | Size of payload in bytes. 0xFFFFFFFFFFFFFFFF means `payload_length` is unknown |
| payload_hash | Checksum | Hash of payload bytes |
| object_type | ObjectType | Special object type |
| homomorphic_hash | Checksum | Homomorphic hash of the object payload. |
| session_token | SessionToken | Session token, if it was used during Object creation. Need it to verify integrity and authenticity out of Request scope. |
| attributes | Attribute | User-defined object attributes |
| split | Split | Position of the object in the split hierarchy. |
   
### Message Header.Attribute

Attribute groups the user-defined Key-Value pairs attached to the object

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | string key to the object attribute |
| value | string | string value of the object attribute |
   
### Message Header.Split

Information about spawning the objects through a payload splitting.

| Field | Type | Description |
| ----- | ---- | ----------- |
| parent | ObjectID | Identifier of the origin object. Parent and children objects must be within the same container. Parent object_id is known only to the minor child. |
| previous | ObjectID | Previous carries identifier of the left split neighbor. |
| parent_signature | Signature | `signature` field of the parent object. Used to reconstruct parent. |
| parent_header | Header | `header` field of the parent object. Used to reconstruct parent. |
| children | ObjectID | Children carries list of identifiers of the objects generated by splitting the current. |
   
### Message Object

Object structure.

| Field | Type | Description |
| ----- | ---- | ----------- |
| object_id | ObjectID | Object's unique identifier. Object is content-addressed. It means id will change if header or payload changes. It's calculated as a hash of header field, which contains hash of object's payload |
| signature | Signature | Signed object_id |
| header | Header | Object metadata headers |
| payload | bytes | Payload bytes. |
   
### Message ShortHeader

Short header fields

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Object format version. |
| creation_epoch | uint64 | Epoch when the object was created |
| owner_id | OwnerID | Object's owner |
| object_type | ObjectType | Type of the object payload content |
| payload_length | uint64 | Size of payload in bytes. 0xFFFFFFFFFFFFFFFF means `payload_length` is unknown |
    
### Emun MatchType

Type of match expression

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | MATCH_TYPE_UNSPECIFIED | Unknown. Not used |
| 1 | STRING_EQUAL | Full string match |

### Emun ObjectType

Type of the object payload content

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | REGULAR | Just a normal object |
| 1 | TOMBSTONE | Used internally to identify deleted objects |
| 2 | STORAGE_GROUP | Identifies that the object holds StorageGroup information |
 
