## neo.fs.v2.netmap



### Service "NetmapService"

`NetmapService` provides methods to work with `Network Map` and information
required to build it. The resulting `Network Map` is stored in sidechain
`Netmap` smart contract, while related information can be obtained from other
NeoFS nodes.


### Method LocalNodeInfo

Get NodeInfo structure from the particular node directly. Node information
can be taken from `Netmap` smart contract, but in some cases the one may
want to get recent information directly, or to talk to the node not yet
present in `Network Map` to find out what API version can be used for
further communication. Can also be used to check if node is up and running.

 

__Request Body:__ LocalNodeInfoRequest.Body

LocalNodeInfo request body is empty.

        

__Response Body__ LocalNodeInfoResponse.Body

Local Node Info, including API Version in use.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Latest NeoFS API version in use |
| node_info | NodeInfo | NodeInfo structure with recent information from node itself |
          
### Message Filter

Filter will return the subset of nodes from `NetworkMap` or another filter's
results, that will satisfy filter's conditions.

| Field | Type | Description |
| ----- | ---- | ----------- |
| name | string | Name of the filter or a reference to the named filter. '*' means application to the whole unfiltered NetworkMap. At top level it's used as a filter name. At lower levels it's considered to be a reference to another named filter |
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
| attributes | Attribute | Carries list of the NeoFS node attributes in a key-value form. Key name must be a node-unique valid UTF-8 string. Value can't be empty. NodeInfo structures with duplicated attribute names or attributes with empty values will be considered invalid. |
| state | State | Carries state of the NeoFS node. |
   
### Message NodeInfo.Attribute

Administrator-defined Attributes of the NeoFS Storage Node.

`Attribute` is a Key-Value metadata pair. Key name must be a valid UTF-8
string. Value can't be empty.

Node's attributes are mostly used during Storage Policy evaluation to
calculate object's placement and find a set of nodes satisfying policy
requirements. There are some "well-known" node attributes common to all the
Storage Nodes in the network and used implicitly with default values if not
explicitly set:

* Capacity \
  Total available disk space in Gigabytes.
* Price \
  Price in GAS tokens for storing one GB of data during one Epoch. In node
  attributes it's a string presenting floating point number with comma or
  point delimiter for decimal part. In the Network Map it will be saved as
  64-bit unsigned integer representing number of minimal token fractions.
* Subnet \
  String ID of Node's storage subnet. There can be only one subnet served
  by the Storage Node.
* UN-LOCODE \
  Node's geographic location in
  [UN/LOCODE](https://www.unece.org/cefact/codesfortrade/codes_index.html)
  format approximated to the nearest point defined in the standard.
* CountryCode \
  Country code in
  [ISO 3166-1_alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
  format. Calculated automatically from `UN-LOCODE` attribute.
* Country \
  Country short name in English, as defined in
  [ISO-3166](https://www.iso.org/obp/ui/#search). Calculated automatically
  from `UN-LOCODE` attribute.
* Location \
  Place names are given, whenever possible, in their national language
  versions as expressed in the Roman alphabet using the 26 characters of
  the character set adopted for international trade data interchange,
  written without diacritics . Calculated automatically from `UN-LOCODE`
  attribute.
* SubDivCode \
  Country's administrative subdivision where node is located. Calculated
  automatically from `UN-LOCODE` attribute based on `SubDiv` field.
  Presented in [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2)
  format.
* SubDiv \
  Country's administrative subdivision name, as defined in
  [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2). Calculated
  automatically from `UN-LOCODE` attribute.
* Continent \
  Node's continent name according to the [Seven-Continent model]
  (https://en.wikipedia.org/wiki/Continent#Number). Calculated
  automatically from `UN-LOCODE` attribute.

For detailed description of each well-known attribute please see the
corresponding section in NeoFS Technical specification.

| Field | Type | Description |
| ----- | ---- | ----------- |
| key | string | Key of the node attribute. |
| value | string | Value of the node attribute. |
| parents | string | Parent keys, if any. For example for `City` it could be `Region` and `Country`. |
   
### Message PlacementPolicy

Set of rules to select a subset of nodes from `NetworkMap` able to store
container's objects. The format is simple enough to transpile from different
storage policy definition languages.

| Field | Type | Description |
| ----- | ---- | ----------- |
| replicas | Replica | Rules to set number of object replicas and place each one into a named bucket |
| container_backup_factor | uint32 | Container backup factor controls how deep NeoFS will search for nodes alternatives to include into container's nodes subset |
| selectors | Selector | Set of Selectors to form the container's nodes subset |
| filters | Filter | List of named filters to reference in selectors |
   
### Message Replica

Number of object replicas in a set of nodes from the defined selector. If no
selector set the root bucket containing all possible nodes will be used by
default.

| Field | Type | Description |
| ----- | ---- | ----------- |
| count | uint32 | How many object replicas to put |
| selector | string | Named selector bucket to put replicas |
   
### Message Selector

Selector chooses a number of nodes from the bucket taking the nearest nodes
to the provided `ContainerID` by hash distance.

| Field | Type | Description |
| ----- | ---- | ----------- |
| name | string | Selector name to reference in object placement section |
| count | uint32 | How many nodes to select from the bucket |
| clause | Clause | Selector modifier showing how to form a bucket |
| attribute | string | Attribute bucket to select from |
| filter | string | Filter reference to select from |
    
### Emun Clause

Selector modifier shows how the node set will be formed. By default selector
just groups nodes into a bucket by attribute, selecting nodes only by their
hash distance.

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
 
