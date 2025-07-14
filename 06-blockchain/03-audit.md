### audit contract



Package audit implements Audit contract which is deployed to FS chain.

Inner Ring nodes perform audit of the registered containers during every epoch. If a container contains StorageGroup objects, an Inner Ring node initializes a series of audit checks. Based on the results of these checks, the Inner Ring node creates a DataAuditResult structure for the container. The content of this structure makes it possible to determine which storage nodes have been examined and see the status of these checks. Regarding this information, the container owner is charged for data storage.

Audit contract is used as a reliable and verifiable storage for all DataAuditResult structures. At the end of data audit routine, Inner Ring nodes send a stable marshaled version of the DataAuditResult structure to the contract. When Alphabet nodes of the Inner Ring perform settlement operations, they make a list and get these AuditResultStructures from the audit contract.

#### Contract notifications

Audit contract does not produce notifications to process.

#### Contract methods

##### Get

```go
func Get(id []byte) []byte
```

Get method returns a stable marshaled DataAuditResult structure.

The ID of the DataAuditResult can be obtained from listing methods.

##### List

```go
func List() [][]byte
```

List method returns a list of all available DataAuditResult IDs from the contract storage.

##### ListByCID

```go
func ListByCID(epoch int, cid []byte) [][]byte
```

ListByCID method returns a list of DataAuditResult IDs generated during the specified epoch for the specified container.

##### ListByEpoch

```go
func ListByEpoch(epoch int) [][]byte
```

ListByEpoch method returns a list of DataAuditResult IDs generated during the specified epoch.

##### ListByNode

```go
func ListByNode(epoch int, cid []byte, key interop.PublicKey) [][]byte
```

ListByNode method returns a list of DataAuditResult IDs generated in the specified epoch for the specified container by the specified Inner Ring node.

##### Put

```go
func Put(rawAuditResult []byte)
```

Put method stores a stable marshalled \`DataAuditResult\` structure. It can be invoked only by Inner Ring nodes.

Inner Ring nodes perform audit of containers and produce \`DataAuditResult\` structures. They are stored in audit contract and used for settlements in later epochs.

##### Update

```go
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by committee.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

