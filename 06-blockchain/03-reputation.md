### reputation contract



Package reputation contains implementation of Reputation contract deployed in NeoFS sidechain.

Storage nodes collect reputation data while communicating with other nodes. This data is exchanged and the end result \(global trust values\) is stored in the contract as opaque data.

#### Contract notifications

Reputation contract does not produce notifications to process.

#### Contract methods

##### Get

```go
func Get(epoch int, peerID []byte) [][]byte
```

Get method returns a list of all stable marshaled GlobalTrust structures known for the given peer during the specified epoch.

##### GetByID

```go
func GetByID(id []byte) [][]byte
```

GetByID method returns a list of all stable marshaled GlobalTrust with the specified id. Use ListByEpoch method to obtain the id.

##### ListByEpoch

```go
func ListByEpoch(epoch int) [][]byte
```

ListByEpoch returns a list of IDs that may be used to get reputation data with GetByID method.

##### Put

```go
func Put(epoch int, peerID []byte, value []byte)
```

Put method saves global trust data in contract storage. It can be invoked only by storage nodes with Alphabet assistance \(multisignature witness\).

Epoch is the epoch number when GlobalTrust structure was generated. PeerID contains public key of the storage node that is the subject of the GlobalTrust. Value contains a stable marshaled structure of GlobalTrust.

##### Update

```go
func Update(script []byte, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by committee.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

