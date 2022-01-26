## neo.fs.v2.reputation



### Service "ReputationService"

`ReputationService` provides mechanisms for exchanging trust values with
other NeoFS nodes. Nodes rate each other's reputation based on how good they
process requests and set a trust level based on that rating. The trust
information is passed to the next nodes to check and aggregate unless the
final result is recorded.


### Method AnnounceLocalTrust

Announce local client trust information to any node in NeoFS network.

Statuses:
- **OK** (0, SECTION_SUCCESS):
local trust has been successfully announced;
- Common failures (SECTION_FAILURE_COMMON).

     

__Request Body:__ AnnounceLocalTrustRequest.Body

Announce node's local trust information.

| Field | Type | Description |
| ----- | ---- | ----------- |
| epoch | uint64 | Trust assessment Epoch number |
| trusts | Trust | List of normalized local trust values to other NeoFS nodes. The value is calculated according to EigenTrust++ algorithm and must be a floating point number in the [0;1] range. |
             

__Response Body__ AnnounceLocalTrustResponse.Body

Response to the node's local trust information announce has an empty body
because the trust exchange operation is asynchronous. If Trust information
will not pass sanity checks it is silently ignored.

   
### Method AnnounceIntermediateResult

Announces the intermediate result of the iterative algorithm for
calculating the global reputation of the node in NeoFS network.

Statuses:
- **OK** (0, SECTION_SUCCESS):
intermediate trust estimation has been successfully announced;
- Common failures (SECTION_FAILURE_COMMON).

 

__Request Body:__ AnnounceIntermediateResultRequest.Body

Announce intermediate global trust information.

| Field | Type | Description |
| ----- | ---- | ----------- |
| epoch | uint64 | Iteration execution Epoch number |
| iteration | uint32 | Iteration sequence number |
| trust | PeerToPeerTrust | Current global trust value calculated at the specified iteration |
             

__Response Body__ AnnounceIntermediateResultResponse.Body

Response to the node's intermediate global trust information announce has
an empty body because the trust exchange operation is asynchronous. If
Trust information will not pass sanity checks it is silently ignored.

                 
### Message GlobalTrust

Global trust level to NeoFS node.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Message format version. Effectively the version of API library used to create the message. |
| body | Body | Message body |
| signature | Signature | Signature of the binary `body` field by the manager. |
   
### Message GlobalTrust.Body

Message body structure.

| Field | Type | Description |
| ----- | ---- | ----------- |
| manager | PeerID | Node manager ID |
| trust | Trust | Global trust level |
   
### Message PeerID

NeoFS unique peer identifier is 33 byte long compressed public key of the
node, the same as the one stored in the network map.

String presentation is
[base58](https://tools.ietf.org/html/draft-msporny-base58-02) encoded string.

JSON value will be the data encoded as a string using standard base64
encoding with paddings. Either
[standard](https://tools.ietf.org/html/rfc4648#section-4) or
[URL-safe](https://tools.ietf.org/html/rfc4648#section-5) base64 encoding
with/without paddings are accepted.

| Field | Type | Description |
| ----- | ---- | ----------- |
| public_key | bytes | Peer node's public key |
   
### Message PeerToPeerTrust

Trust level of a peer to a peer.

| Field | Type | Description |
| ----- | ---- | ----------- |
| trusting_peer | PeerID | Identifier of the trusting peer |
| trust | Trust | Trust level |
   
### Message Trust

Trust level to a NeoFS network peer.

| Field | Type | Description |
| ----- | ---- | ----------- |
| peer | PeerID | Identifier of the trusted peer |
| value | double | Trust level in [0:1] range |
     
