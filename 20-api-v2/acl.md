## neo.fs.v2.acl




### Message BearerToken

BearerToken has information about request ACL rules with limited lifetime

| Field | Type | Description |
| ----- | ---- | ----------- |
| body | Body | Bearer Token body |
| signature | Signature | Signature of BearerToken body |
    
### Message BearerToken.Body.TokenLifetime

Lifetime parameters of the token. Filed names taken from rfc7519.

| Field | Type | Description |
| ----- | ---- | ----------- |
| exp | uint64 | Expiration Epoch |
| nbf | uint64 | Not valid before Epoch |
| iat | uint64 | Issued at Epoch |
   
### Message EACLRecord

EACLRecord groups information about extended ACL rule.

| Field | Type | Description |
| ----- | ---- | ----------- |
| operation | Operation | Operation carries type of operation. |
| action | Action | Action carries ACL target action. |
| filters | Filter | filters carries set of filters. |
| targets | Target | targets carries information about extended ACL target list. |
   
### Message EACLRecord.Filter

Filter definition

| Field | Type | Description |
| ----- | ---- | ----------- |
| header_type | HeaderType | Header carries type of header. |
| match_type | MatchType | MatchType carries type of match. |
| header_name | string | header_name carries name of filtering header. |
| header_val | string | header_val carries value of filtering header. |
   
### Message EACLRecord.Target

Information about extended ACL target.

| Field | Type | Description |
| ----- | ---- | ----------- |
| role | Role | target carries target of ACL rule. |
| key_list | bytes | key_list carries public keys of ACL target. |
   
### Message EACLTable

EACLRecord carries the information about extended ACL rules.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | eACL format version. Effectively the version of API library used to create eACL Table |
| container_id | ContainerID | Carries identifier of the container that should use given access control rules. |
| records | EACLRecord | Records carries list of extended ACL rule records. |
    
### Emun Action

Action is an enumeration of EACL actions.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ACTION_UNSPECIFIED | Unspecified action, default value. |
| 1 | ALLOW | Allow action |
| 2 | DENY | Deny action |

### Emun HeaderType

Header is an enumeration of filtering header types.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | HEADER_UNSPECIFIED | Unspecified header, default value. |
| 1 | REQUEST | Filter request headers |
| 2 | OBJECT | Filter object headers |

### Emun MatchType

MatchType is an enumeration of match types.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | MATCH_TYPE_UNSPECIFIED | Unspecified match type, default value. |
| 1 | STRING_EQUAL | Return true if strings are equal |
| 2 | STRING_NOT_EQUAL | Return true if strings are different |

### Emun Operation

Operation is an enumeration of operation types.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | OPERATION_UNSPECIFIED | Unspecified operation, default value. |
| 1 | GET | Get |
| 2 | HEAD | Head |
| 3 | PUT | Put |
| 4 | DELETE | Delete |
| 5 | SEARCH | Search |
| 6 | GETRANGE | GetRange |
| 7 | GETRANGEHASH | GetRangeHash |

### Emun Role

Target role of the access control rule in access control list.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | ROLE_UNSPECIFIED | Unspecified role, default value. |
| 1 | USER | User target rule is applied if sender is the owner of the container. |
| 2 | SYSTEM | System target rule is applied if sender is the storage node within the container or inner ring node. |
| 3 | OTHERS | Others target rule is applied if sender is not user or system target. |
 
