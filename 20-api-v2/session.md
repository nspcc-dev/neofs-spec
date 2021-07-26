## neo.fs.v2.session



### Service "SessionService"

`SessionService` allows to establish a temporary trust relationship between
two peer nodes and generate a `SessionToken` as the proof of trust to be
attached in requests for further verification. Please see corresponding
section of NeoFS Technical Specification for details.


### Method Create

Opens a new session between two peers.

 

__Request Body:__ CreateRequest.Body

Session creation request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Session initiating user's or node's key derived `OwnerID` |
| expiration | uint64 | Session expiration `Epoch` |
         

__Response Body__ CreateResponse.Body

Session creation response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | bytes | Identifier of a newly created session |
| session_key | bytes | Public key used for session |
          
### Message ContainerSessionContext

Context information for Session Tokens related to ContainerService requests.

| Field | Type | Description |
| ----- | ---- | ----------- |
| verb | Verb | Type of request for which the token is issued |
| wildcard | bool | Spreads the action to all owner containers. If set, container_id field is ignored. |
| container_id | ContainerID | Particular container to which the action applies. Ignored if wildcard flag is set. |
   
### Message ObjectSessionContext

Context information for Session Tokens related to ObjectService requests

| Field | Type | Description |
| ----- | ---- | ----------- |
| verb | Verb | Type of request for which the token is issued |
| address | Address | Related Object address |
   
### Message RequestMetaHeader

Meta information attached to the request. When forwarded between peers,
request meta headers are folded in matryoshka style.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Peer's API version used |
| epoch | uint64 | Peer's local epoch number. Set to 0 if unknown. |
| ttl | uint32 | Maximum number of intermediate nodes in the request route |
| x_headers | XHeader | Request X-Headers |
| session_token | SessionToken | Session token within which the request is sent |
| bearer_token | BearerToken | `BearerToken` with eACL overrides for the request |
| origin | RequestMetaHeader | `RequestMetaHeader` of the origin request |
   
### Message RequestVerificationHeader

Verification info for request signed by all intermediate nodes.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Request Body signature. Should be generated once by request initiator. |
| meta_signature | Signature | Request Meta signature is added and signed by each intermediate node |
| origin_signature | Signature | Signature of previous hops |
| origin | RequestVerificationHeader | Chain of previous hops signatures |
   
### Message ResponseMetaHeader

Information about the response

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Peer's API version used |
| epoch | uint64 | Peer's local epoch number |
| ttl | uint32 | Maximum number of intermediate nodes in the request route |
| x_headers | XHeader | Response X-Headers |
| origin | ResponseMetaHeader | `ResponseMetaHeader` of the origin request |
   
### Message ResponseVerificationHeader

Verification info for response signed by all intermediate nodes

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Response Body signature. Should be generated once by answering node. |
| meta_signature | Signature | Response Meta signature is added and signed by each intermediate node |
| origin_signature | Signature | Signature of previous hops |
| origin | ResponseVerificationHeader | Chain of previous hops signatures |
   
### Message SessionToken

NeoFS Session Token.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body | Body | Session Token contains the proof of trust between peers to be attached in requests for further verification. Please see corresponding section of NeoFS Technical Specification for details. |
| signature | Signature | Signature of `SessionToken` information |
   
### Message SessionToken.Body

Session Token body

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | bytes | Token identifier is a valid UUIDv4 in binary form |
| owner_id | OwnerID | Identifier of the session initiator |
| lifetime | TokenLifetime | Lifetime of the session |
| session_key | bytes | Public key used in session |
| object | ObjectSessionContext | ObjectService session context |
| container | ContainerSessionContext | ContainerService session context |
   
### Message SessionToken.Body.TokenLifetime

Lifetime parameters of the token. Field names taken from rfc7519.

| Field | Type | Description |
| ----- | ---- | ----------- |
| exp | uint64 | Expiration Epoch |
| nbf | uint64 | Not valid before Epoch |
| iat | uint64 | Issued at Epoch |
   
### Message XHeader

Extended headers for Request/Response. May contain any user-defined headers
to be interpreted on application level.

Key name must be unique valid UTF-8 string. Value can't be empty. Requests or
Responses with duplicated header names or headers with empty values will be
considered invalid.

There are some "well-known" headers starting with `__NEOFS__` prefix that
affect system behaviour:

* __NEOFS__NETMAP_EPOCH \
  Netmap epoch to use for object placement calculation. The `value` is string
  encoded `uint64` in decimal presentation. If set to '0' or not set, the
  current epoch only will be used.
* __NEOFS__NETMAP_LOOKUP_DEPTH \
  If object can't be found using current epoch's netmap, this header limits
  how many past epochs back the node can lookup. The `value` is string
  encoded `uint64` in decimal presentation. If set to '0' or not set, the
  current epoch only will be used.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Key of the X-Header |
| value | string | Value of the X-Header |
    
### Emun ContainerSessionContext.Verb

Container request verbs

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | VERB_UNSPECIFIED | Unknown verb |
| 1 | PUT | Refers to container.Put RPC call |
| 2 | DELETE | Refers to container.Delete RPC call |
| 3 | SETEACL | Refers to container.SetExtendedACL RPC call |

### Emun ObjectSessionContext.Verb

Object request verbs

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | VERB_UNSPECIFIED | Unknown verb |
| 1 | PUT | Refers to object.Put RPC call |
| 2 | GET | Refers to object.Get RPC call |
| 3 | HEAD | Refers to object.Head RPC call |
| 4 | SEARCH | Refers to object.Search RPC call |
| 5 | DELETE | Refers to object.Delete RPC call |
| 6 | RANGE | Refers to object.GetRange RPC call |
| 7 | RANGEHASH | Refers to object.GetRangeHash RPC call |
 
