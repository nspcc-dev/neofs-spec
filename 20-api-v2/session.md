## neo.fs.v2.session



### Service "SessionService"

`SessionService` allows to establish a temporary trust relationship between
two peer nodes and generate a `SessionToken` as the proof of trust to be
attached in requests for further verification. Please see corresponding
section of NeoFS Technical Specification for details.


### Method Create

Open a new session between two peers.

Statuses:
- **OK** (0, SECTION_SUCCESS):
session has been successfully opened;
- Common failures (SECTION_FAILURE_COMMON).

 

__Request Body:__ CreateRequest.Body

Session creation request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Session initiating user's or node's key derived `OwnerID` |
| expiration | uint64 | Session expiration epoch, the last epoch when session is valid. |
         

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
| target | Target | Object session target. MUST be correctly formed and set. If `objects` field is not empty, then the session applies only to these elements, otherwise, to all objects from the specified container. |
   
### Message ObjectSessionContext.Target

Carries objects involved in the object session.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | ContainerID | Indicates which container the session is spread to. Field MUST be set and correct. |
| objects | ObjectID | Indicates which objects the session is spread to. Objects are expected to be stored in the NeoFS container referenced by `container` field. Each element MUST have correct format. |
   
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
| session_token_v2 | SessionTokenV2 | Session token v2 with delegation chain support. Requests are invalid if both session_token and session_token_v2 are set. |
| bearer_token | BearerToken | `BearerToken` with eACL overrides for the request |
| origin | RequestMetaHeader | `RequestMetaHeader` of the origin request |
| magic_number | uint64 | NeoFS network magic. Must match the value for the network that the server belongs to. |
   
### Message RequestVerificationHeader

Verification info for the request signed by all intermediate nodes.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Request Body signature. Should be generated once by the request initiator. |
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
| status | Status | Status return |
   
### Message ResponseVerificationHeader

Verification info for the response signed by all intermediate nodes

DEPRECATED: was eliminated from the protocol starting from version `v2.22`.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Response Body signature. Should be generated once by an answering node. |
| meta_signature | Signature | Response Meta signature is added and signed by each intermediate node |
| origin_signature | Signature | Signature of previous hops |
| origin | ResponseVerificationHeader | Chain of previous hops signatures |
   
### Message SessionContextV2

SessionContextV2 carries unified context for both ObjectService and ContainerService requests.

| Field | Type | Description |
| ----- | ---- | ----------- |
| container | ContainerID | Container where operation is allowed. For container operations, this is the container being operated on. For object operations, this is the container holding the objects. Empty container ID means wildcard (applies to all containers). |
| verbs | Verb | Operations authorized for this context. Must contain at least one verb (empty list is invalid). Verbs must be sorted in ascending order. Maximum number of verbs: 12. |
   
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
| exp | uint64 | Expiration epoch, the last epoch when token is valid. |
| nbf | uint64 | Not valid before epoch, the first epoch when token is valid. |
| iat | uint64 | Issued at Epoch |
   
### Message SessionTokenV2

SessionTokenV2 represents NeoFS Session Token with delegation support.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body | Body | Session token body. |
| signature | Signature | Signature of the body by the issuer. |
| origin | SessionTokenV2 | Origin token that was delegated to create this token. This creates a chain of trust through token embedding. When B receives a token from A and wants to delegate to C, B creates a new SessionTokenV2 and embeds A's token here.

Delegation validation rules: 1. Lifetime must be within origin's lifetime (exp >= origin.exp, nbf <= origin.nbf). 2. Contexts must be narrowed (see contexts field validation rules). 3. If origin.final is true, delegation is forbidden. 4. Maximum chain depth: 4 tokens. |
    
### Message Target

Target account for SessionTokenV2.
It can be either direct (OwnerID) or indirect (NNS domain).

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Direct account reference via OwnerID (hash of verification script). |
| nns_name | string | Indirect account reference via NeoFS Name Service. NNS name is a domain name that resolves to an OwnerID through the NeoFS Name Service. The name must be a valid DNS-like domain name (e.g., "example.neofs") that is registered in the NNS contract on the Neo blockchain. The NNS record should contain a string record with the corresponding OwnerID value in NEP-18 address format. |
   
### Message TokenLifetime

Lifetime parameters of the token v2. Field names taken from rfc7519.

| Field | Type | Description |
| ----- | ---- | ----------- |
| exp | uint64 | Expiration, the last valid Unix timestamp. |
| nbf | uint64 | Not valid before, the first valid Unix timestamp. |
| iat | uint64 | Issued at, the Unix timestamp when the token was issued. |
   
### Message XHeader

Extended headers for Request/Response. They may contain any user-defined headers
to be interpreted on application level.

Key name must be a unique valid UTF-8 string. Value can't be empty. Requests or
Responses with duplicated header names or headers with empty values will be
considered invalid.

There are some "well-known" headers starting with `__NEOFS__` prefix that
affect system behaviour:

* __NEOFS__NETMAP_EPOCH \
  Netmap epoch to use for object placement calculation. The `value` is string
  encoded `uint64` in decimal presentation. If set to '0' or not set, the
  current epoch only will be used. DEPRECATED: header ignored by servers.
* __NEOFS__NETMAP_LOOKUP_DEPTH \
  If object can't be found using current epoch's netmap, this header limits
  how many past epochs the node can look up through. The `value` is string
  encoded `uint64` in decimal presentation. If set to '0' or not set, only the
  current epoch will be used. DEPRECATED: header ignored by servers.

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
| 4 | SETATTRIBUTE | Refers to container.SetAttribute RPC call |
| 5 | REMOVEATTRIBUTE | Refers to container.RemoveAttribute RPC call |

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

### Emun Verb

Verb represents all possible operations in NeoFS that can be authorized
via session tokens or delegation chains. This enum covers both object and
container service operations.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | VERB_UNSPECIFIED | Unknown verb |
| 1 | OBJECT_PUT | Refers to object.Put RPC call |
| 2 | OBJECT_GET | Refers to object.Get RPC call |
| 3 | OBJECT_HEAD | Refers to object.Head RPC call |
| 4 | OBJECT_SEARCH | Refers to object.Search RPC call |
| 5 | OBJECT_DELETE | Refers to object.Delete RPC call |
| 6 | OBJECT_RANGE | Refers to object.GetRange RPC call |
| 7 | OBJECT_RANGEHASH | Refers to object.GetRangeHash RPC call |
| 8 | CONTAINER_PUT | Refers to container.Put RPC call |
| 9 | CONTAINER_DELETE | Refers to container.Delete RPC call |
| 10 | CONTAINER_SETEACL | Refers to container.SetExtendedACL RPC call |
| 11 | CONTAINER_SETATTRIBUTE | Refers to container.SetAttribute RPC call |
| 12 | CONTAINER_REMOVEATTRIBUTE | Refers to container.RemoveAttribute RPC call |
 
