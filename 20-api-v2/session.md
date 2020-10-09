## neo.fs.v2.session



### Service "SessionService"

Create Session record on Node side


### Method Create

Create opens new session between the client and the server.

 

__Request Body:__ CreateRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Carries an identifier of a session initiator. |
| expiration | uint64 | Expiration Epoch |
         

__Response Body__ CreateResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | bytes | id carries an identifier of session token. |
| session_key | bytes | session_key carries a session public key. |
          
### Message ObjectSessionContext

Context information for Session Tokens related to ObjectService requests

| Field | Type | Description |
| ----- | ---- | ----------- |
| verb | Verb | Verb is a type of request for which the token is issued |
| address | Address | Related Object address |
   
### Message RequestMetaHeader

Information about the request

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Client API version. |
| epoch | uint64 | Client local epoch number. Set to 0 if unknown. |
| ttl | uint32 | Maximum number of nodes in the request route. |
| x_headers | XHeader | Request X-Headers. |
| session_token | SessionToken | Token is a token of the session within which the request is sent |
| bearer_token | BearerToken | Bearer is a Bearer token of the request |
| origin | RequestMetaHeader | RequestMetaHeader of the origin request. |
   
### Message RequestVerificationHeader

Verification info for request signed by all intermediate nodes

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Request Body signature. Should be generated once by request initiator. |
| meta_signature | Signature | Request Meta signature is added and signed by any intermediate node |
| origin_signature | Signature | Sign previous hops |
| origin | RequestVerificationHeader | Chain of previous hops signatures |
   
### Message ResponseMetaHeader

Information about the response

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Server API version. |
| epoch | uint64 | Server local epoch number. |
| ttl | uint32 | Maximum number of nodes in the response route. |
| x_headers | XHeader | Response X-Headers. |
| origin | ResponseMetaHeader | Carries response meta header of the origin response. |
   
### Message ResponseVerificationHeader

Verification info for response signed by all intermediate nodes

| Field | Type | Description |
| ----- | ---- | ----------- |
| body_signature | Signature | Response Body signature. Should be generated once by answering node. |
| meta_signature | Signature | Response Meta signature is added and signed by any intermediate node |
| origin_signature | Signature | Sign previous hops |
| origin | ResponseVerificationHeader | Chain of previous hops signatures |
   
### Message SessionToken

NeoFS session token.

| Field | Type | Description |
| ----- | ---- | ----------- |
| body | Body | Session Token body |
| signature | Signature | Signature is a signature of session token information |
    
### Message SessionToken.Body.TokenLifetime

Lifetime parameters of the token. Filed names taken from rfc7519.

| Field | Type | Description |
| ----- | ---- | ----------- |
| exp | uint64 | Expiration Epoch |
| nbf | uint64 | Not valid before Epoch |
| iat | uint64 | Issued at Epoch |
   
### Message XHeader

Extended headers for Request/Response

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Key of the X-Header. |
| value | string | Value of the X-Header. |
    
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
 
