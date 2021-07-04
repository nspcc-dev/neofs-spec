### audit contract

Audit contract is a contract deployed in NeoFS side chain\.

Inner Ring nodes perform an audit of the registered containers in every epoch\. If container contains StorageGroup objects\, then the Inner Ring node initializes a series of audit checks\. Based on the results of these checks\, the Inner Ring node creates a DataAuditResult structure for the container\. The content of this structure makes it possible to determine which storage nodes were examined and the status of these checks\. Based on this information\, container owner is charged for data storage\.

Audit contract is used as reliable and verifiable storage for all DataAuditResult structures\. At the end of the data audit routine\, the Inner Ring nodes send a stable marshaled version of the DataAuditResult structure to the contract\. When Alphabet nodes of the Inner Ring perform settlement operations\, they list and get these AuditResultStructures from the audit contract\.

#### Contract notifications

Alphabet contract does not produce notifications to process\.

#### Contract methods

##### Get

```go
func Get(id []byte) []byte
```

Get method returns stable marshaled DataAuditResult structure\.

ID of the DataAuditResult can be obtained from listing methods\.

##### List

```go
func List() [][]byte
```

List method returns list of all available DataAuditResult IDs from contract storage\.

##### ListByCID

```go
func ListByCID(epoch int, cid []byte) [][]byte
```

ListByCID method returns list of DataAuditResult IDs generated in specified epoch for specified container\.

##### ListByEpoch

```go
func ListByEpoch(epoch int) [][]byte
```

ListByEpoch method returns list of DataAuditResult IDs generated in specified epoch\.

##### ListByNode

```go
func ListByNode(epoch int, cid []byte, key interop.PublicKey) [][]byte
```

ListByNode method returns list of DataAuditResult IDs generated in specified epoch for specified container by specified Inner Ring node\.

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

Migrate method updates contract source code and manifest\. Can be invoked only by contract owner\.

##### Put

```go
func Put(rawAuditResult []byte)
```

Put method stores stable marshalled \`DataAuditResult\` structure\. Can be invoked only by Inner Ring nodes\.

Inner Ring nodes perform audit of the containers and produce \`DataAuditResult\` structures\. They are being stored in audit contract and used for settlements in later epochs\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


