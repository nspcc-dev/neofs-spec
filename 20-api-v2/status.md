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
follows the semantics of RPC and the description of its purpose.
The server must not attach code that is the opposite of the outcome type.

See the set of return codes in the description for calls.

Each status can carry a developer-facing error message. It should be a human
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
| 1 | WRONG_MAGIC_NUMBER | [**1025**] Wrong magic of the NeoFS network. Details: - [**0**] Magic number of the served NeoFS network (big-endian 64-bit unsigned integer). |
| 2 | SIGNATURE_VERIFICATION_FAIL | [**1026**] Signature verification failure. |
| 3 | NODE_UNDER_MAINTENANCE | [**1027**] Node is under maintenance. |

### Emun Container

Section of statuses for container-related operations.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | CONTAINER_NOT_FOUND | [**3072**] Container not found. |
| 1 | EACL_NOT_FOUND | [**3073**] eACL table not found. |

### Emun Object

Section of statuses for object-related operations.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ACCESS_DENIED | [**2048**] Access denied by ACL. Details: - [**0**] Human-readable description (UTF-8 encoded string). |
| 1 | OBJECT_NOT_FOUND | [**2049**] Object not found. |
| 2 | LOCKED | [**2050**] Operation rejected by the object lock. |
| 3 | LOCK_NON_REGULAR_OBJECT | [**2051**] Locking an object with a non-REGULAR type rejected. |
| 4 | OBJECT_ALREADY_REMOVED | [**2052**] Object has been marked deleted. |
| 5 | OUT_OF_RANGE | [**2053**] Invalid range has been requested for an object. |

### Emun Section

Section identifiers.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | SECTION_SUCCESS | Successful return codes. |
| 1 | SECTION_FAILURE_COMMON | Failure codes regardless of the operation. |
| 2 | SECTION_OBJECT | Object service-specific errors. |
| 3 | SECTION_CONTAINER | Container service-specific errors. |
| 4 | SECTION_SESSION | Session service-specific errors. |

### Emun Session

Section of statuses for session-related operations.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | TOKEN_NOT_FOUND | [**4096**] Token not found. |
| 1 | TOKEN_EXPIRED | [**4097**] Token has expired. |

### Emun Success

Section of NeoFS successful return codes.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | OK | [**0**] Default success. Not detailed. If the server cannot match successful outcome to the code, it should use this code. |
 
