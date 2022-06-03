### reputation contract

Reputation contract is a contract deployed in NeoFS sidechain\.

Inner Ring nodes produce data audit for each container during each epoch\. In the end\, nodes produce DataAuditResult structure that contains information about audit progress\. Reputation contract provides storage for such structures and simple interface to iterate over available DataAuditResults on specified epoch\.

During settlement process\, Alphabet nodes fetch all DataAuditResult structures from the epoch and execute balance transfers from data owners to Storage and Inner Ring nodes if data audit succeeds\.

#### Contract notifications

Reputation contract does not produce notifications to process\.

#### Contract methods

##### Get

```go
func Get(epoch int, peerID []byte) [][]byte
```

Get method returns a list of all stable marshaled DataAuditResult structures produced by the specified Inner Ring node during the specified epoch\.

##### GetByID

```go
func GetByID(id []byte) [][]byte
```

GetByID method returns a list of all stable marshaled DataAuditResult with the specified id\. Use ListByEpoch method to obtain the id\.

##### ListByEpoch

```go
func ListByEpoch(epoch int) [][]byte
```

ListByEpoch returns a list of IDs that may be used to get reputation data with GetByID method\.

##### Put

```go
func Put(epoch int, peerID []byte, value []byte)
```

Put method saves DataAuditResult in contract storage\. It can be invoked only by Inner Ring nodes\. It does not require multisignature invocations\.

Epoch is the epoch number when DataAuditResult structure was generated\. PeerID contains public keys of the Inner Ring node that has produced DataAuditResult\. Value contains a stable marshaled structure of DataAuditResult\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. It can be invoked only by committee\.

##### Version

```go
func Version() int
```

Version returns the version of the contract\.


