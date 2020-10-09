## neo.fs.v2.netmap



### Service "NetmapService"

Methods to work with NetworkMap


### Method LocalNodeInfo

Return information about Node

 

__Request Body:__ LocalNodeInfoRequest.Body

Request body

        

__Response Body__ LocalNodeInfoResponse.Body

Response body

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | API version in use |
| node_info | NodeInfo | NodeInfo from node itself |
          
### Message Filter

Filter

| Field | Type | Description |
| ----- | ---- | ----------- |
| name | string | Name of the filter or a reference to the named filter. '*' means application to the whole unfiltered NetworkMap At top level it's used as a filter name. At lower levels it's considered to be a reference to another named filter |
| key | string | Key to filter |
| op | Operation | Filtering operation |
| value | string | Value to match |
| filters | Filter | List of inner filters. Top level operation will be applied to the whole list. |
   
### Message NodeInfo

NeoFS node description

| Field | Type | Description |
| ----- | ---- | ----------- |
| public_key | bytes | Public key of the NeoFS node in a binary format. |
| address | string | Ways to connect to a node |
| attributes | Attribute | Carries list of the NeoFS node attributes in a string key-value format. |
| state | State | Carries state of the NeoFS node. |
   
### Message NodeInfo.Attribute

Attributes of the NeoFS node.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Key of the node attribute. |
| value | string | Value of the node attribute. |
| parents | string | Parent keys, if any Example: For City it can be Region or Country |
   
### Message PlacementPolicy

Set of rules to select a subset of nodes able to store container's objects

| Field | Type | Description |
| ----- | ---- | ----------- |
| replicas | Replica | Rules to set number of object replicas and place each one into a particular bucket |
| container_backup_factor | uint32 | Container backup factor controls how deep NeoFS will search for nodes alternatives to include into container. |
| selectors | Selector | Set of Selectors to form the container's nodes subset |
| filters | Filter | List of named filters to reference in selectors |
   
### Message Replica

Exact bucket for each replica

| Field | Type | Description |
| ----- | ---- | ----------- |
| count | uint32 | How many object replicas to put |
| selector | string | Named selector bucket to put in |
   
### Message Selector

Selector

| Field | Type | Description |
| ----- | ---- | ----------- |
| name | string | Selector name to reference in object placement section |
| count | uint32 | How many nodes to select from bucket |
| clause | Clause | Selector modifier showing how to form a bucket |
| attribute | string | Attribute bucket to select from |
| filter | string | Filter reference to select from |
    
### Emun Clause

Selector modifier showing how the node set will be formed
By default selector just groups by attribute into a bucket selecting nodes
only by their hash distance.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | CLAUSE_UNSPECIFIED | No modifier defined. Will select nodes from bucket randomly. |
| 1 | SAME | SAME will select only nodes having the same value of bucket attribute |
| 2 | DISTINCT | DISTINCT will select nodes having different values of bucket attribute |

### Emun NodeInfo.State

Represents the enumeration of various states of the NeoFS node.

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | UNSPECIFIED | Unknown state. |
| 1 | ONLINE | Active state in the network. |
| 2 | OFFLINE | Network unavailable state. |

### Emun Operation

Operations on filters

| Number | Name | Description |
| ------ | ---- | ----------- |
| 0 | OPERATION_UNSPECIFIED | No Operation defined |
| 1 | EQ | Equal |
| 2 | NE | Not Equal |
| 3 | GT | Greater then |
| 4 | GE | Greater or equal |
| 5 | LT | Less then |
| 6 | LE | Less or equal |
| 7 | OR | Logical OR |
| 8 | AND | Logical AND |
 
