## neo.fs.v2.status




### Message Status

Declares the general format of the status returns of the NeoFS RPC protocol.
Status is present in all response messages. Each RPC of NeoFS protocol
describes the possible outcomes and details of the operation.

Each status is assigned a one-to-one numeric code. Any unique result of an
operation in NeoFS is unambiguously associated with the code value.

Numerical set of codes is split into 1024-element sections. An enumeration
is defined for each section. Values can be referred to in the following ways:

* numerical value ranging from 0 to 4,294,967,295 (global code);

* values from enumeration (local code). The formula for the ratio of the
  local code (`L`) of a defined section (`S`) to the global one (`G`):
  `G = 1024 * S + L`.

All outcomes are divided into successful and failed, which corresponds
to the success or failure of the operation. The definition of success
follows from the semantics of RPC and the description of its purpose.
The server must not attach code that is the opposite of outcome type.

See the set of return codes in the description for calls.

Each status can carry developer-facing error message. It should be human
readable text in English. The server should not transmit (and the client
should not expect) useful information in the message. Field `details`
should make the return more detailed.

| Field | Type | Description |
| ----- | ---- | ----------- |
| code | uint32 | The status code |
| message | string | Developer-facing error message |
| details | Detail | Data detailing the outcome of the operation. Must be unique by ID. |
   
### Message Status.Detail

Return detail. It contains additional information that can be used to
analyze the response. Each code defines a set of details that can be
attached to a status. Client should not handle details that are not
covered by the code.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | uint32 | Detail ID. The identifier is required to determine the binary format of the detail and how to decode it. |
| value | bytes | Binary status detail. Must follow the format associated with ID. The possibility of missing a value must be explicitly allowed. |
    
### Emun CommonFail

Section of failed statuses independent of the operation.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | INTERNAL | [**1024**] Internal server error, default failure. Not detailed. If the server cannot match failed outcome to the code, it should use this code. |
| 1 | WRONG_MAGIC_NUMBER | [**1025**] Wrong magic of the NeoFS network. Not detailed. |

### Emun Section

Section identifiers.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | SECTION_SUCCESS | Successful return codes. |
| 1 | SECTION_FAILURE_COMMON | Failure codes regardless of the operation. |

### Emun Success

Section of NeoFS successful return codes.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | OK | [**0**] Default success. Not detailed. If the server cannot match successful outcome to the code, it should use this code. |
 
