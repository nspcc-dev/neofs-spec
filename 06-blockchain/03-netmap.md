### netmap contract



Package netmap contains implementation of the Netmap contract for NeoFS systems.

Netmap contract stores and manages NeoFS network map, storage node candidates and epoch number counter. Currently it maintains two lists simultaneously, both in old BLOB\-based format and new structured one. Nodes and IR are encouraged to use both during transition period, old format will eventually be discontinued.

#### Contract notifications

AddNode notification. This notification is emitted when a storage node joins the candidate list via AddNode method \(using new format\).

```
AddNode
  - name: publicKey
    type: PublicKey
  - name: addresses
    type: Array
  - name: attributes
    type: Map
```

AddPeer notification. This notification is produced when a Storage node sends a bootstrap request by invoking AddPeer method.

```
AddPeer
  - name: nodeInfo
    type: ByteArray
```

UpdateStateSuccess notification. This notification is produced when a storage node or Alphabet changes node state by invoking UpdateState or DeleteNode methods. Supported states: online/offline/maintenance.

```
UpdateStateSuccess
  - name: publicKey
    type: PublicKey
  - name: state
    type: Integer
```

NewEpoch notification. This notification is produced when a new epoch is applied in the network by invoking NewEpoch method.

```
NewEpoch
  - name: epoch
    type: Integer
```

#### Contract methods

##### AddNode

```go
func AddNode(n Node2)
```

AddNode adds a new node into the candidate list for the next epoch. Node must have \[nodestate.Online\] state to be considered and the request must be signed by both the node and Alphabet. AddNode event is emitted upon success.

##### AddPeer

```go
func AddPeer(nodeInfo []byte)
```

AddPeer proposes a node for consideration as a candidate for the next\-epoch network map. Information about the node is accepted in NeoFS API binary format. Call transaction MUST be signed by the public key sewn into the parameter \(compressed 33\-byte array starting from 3rd byte\), i.e. by candidate itself. If the signature is correct, the Notary service will submit a request for signature by the NeoFS Alphabet. After collecting a sufficient number of signatures, the node will be added to the list of candidates for the next\-epoch network map \('AddPeerSuccess' notification is thrown after that\).

Deprecated: migrate to [AddNode](<#AddNode>).

##### AddPeerIR

```go
func AddPeerIR(nodeInfo []byte)
```

AddPeerIR is called by the NeoFS Alphabet instead of AddPeer when signature of the network candidate is inaccessible. For example, when information about the candidate proposed via AddPeer needs to be supplemented. In such cases, a new transaction will be required and therefore the candidate's signature is not verified by AddPeerIR. Besides this, the behavior is similar.

Deprecated: currently unused, to be removed in future.

##### CleanupThreshold

```go
func CleanupThreshold() int
```

CleanupThreshold returns the cleanup threshold configuration. Nodes that do not update their state for this number of epochs get kicked out of the network map. Zero means cleanups are disabled.

##### Config

```go
func Config(key []byte) any
```

Config returns configuration value of NeoFS configuration. If key does not exist, returns nil.

##### DeleteNode

```go
func DeleteNode(pkey interop.PublicKey)
```

DeleteNode removes a node with the given public key from candidate list. It must be signed by Alphabet nodes and doesn't require node witness. See [UpdateState](<#UpdateState>) as well, this method emits UpdateStateSuccess upon success with state \[nodestate.Offline\].

##### Epoch

```go
func Epoch() int
```

Epoch method returns the current epoch number.

##### GetEpochBlock

```go
func GetEpochBlock(epoch int) int
```

GetEpochBlock returns block index when given epoch came. Returns 0 if the epoch is missing. Do not confuse with [GetEpochTime](<#GetEpochTime>).

Use [LastEpochBlock](<#LastEpochBlock>) if you are interested in the current epoch.

##### GetEpochTime

```go
func GetEpochTime(epoch int) int
```

GetEpochTime returns block time when given epoch came. Returns 0 if the epoch is missing. Do not confuse with [GetEpochBlock](<#GetEpochBlock>).

Use [LastEpochTime](<#LastEpochTime>) if you are interested in the current epoch.

##### InnerRingList

```go
func InnerRingList() []common.IRNode
```

InnerRingList method returns a slice of structures that contains the public key of an Inner Ring node. It should be used in notary disabled environment only.

If notary is enabled, look to NeoFSAlphabet role in native RoleManagement contract of FS chain.

Deprecated: since non\-notary settings are no longer supported, refer only to the RoleManagement contract only. The method will be removed in one of the future releases.

##### IsStorageNode

```go
func IsStorageNode(key interop.PublicKey) bool
```

IsStorageNode allows to check for the given key presence in the current network map.

##### IsStorageNodeInEpoch

```go
func IsStorageNodeInEpoch(key interop.PublicKey, epoch int) bool
```

IsStorageNodeInEpoch is the same as [IsStorageNode](<#IsStorageNode>), but allows to do the check for previous epochs if they're still stored in the contract. If this epoch is no longer stored \(or too new\) it will return false.

##### LastEpochBlock

```go
func LastEpochBlock() int
```

LastEpochBlock method returns the block number when the current epoch was applied. Do not confuse with [LastEpochTime](<#LastEpochTime>).

Use [GetEpochBlock](<#GetEpochBlock>) for specific epoch.

##### LastEpochTime

```go
func LastEpochTime() int
```

LastEpochTime method returns the block time when the current epoch was applied. Do not confuse with [LastEpochBlock](<#LastEpochBlock>).

Use [GetEpochTime](<#GetEpochTime>) for specific epoch.

##### ListCandidates

```go
func ListCandidates() iterator.Iterator
```

ListCandidates returns an iterator for a set of current candidate nodes. Iterator values are [Candidate](<#Candidate>) structures.

##### ListNodes

```go
func ListNodes() iterator.Iterator
```

ListNodes provides an iterator to walk over current node set. It is similar to [Netmap](<#Netmap>) method, iterator values are [Node2](<#Node2>) structures.

##### ListNodesEpoch

```go
func ListNodesEpoch(epoch int) iterator.Iterator
```

ListNodesEpoch provides an iterator to walk over node set at the given epoch. It's the same as [ListNodes](<#ListNodes>) \(and exposed as listNodes from the contract via overload\), but allows to query a particular epoch data if it's still stored. If this epoch is already expired \(or not happened yet\) returns an empty iterator.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method changes the epoch number up to the provided epochNum argument. It can be invoked only by Alphabet nodes. If provided epoch number is less than the current epoch number or equals it, the method throws panic.

When epoch number is updated, the contract sets storage node candidates as the current network map. The contract also invokes NewEpoch method on Balance and Container contracts.

It produces NewEpoch notification.

##### SetCleanupThreshold

```go
func SetCleanupThreshold(val int)
```

SetCleanupThreshold sets cleanup threshold configuration. Negative values are not allowed. Zero disables stale node cleanups on epoch change.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value. It can be invoked only by Alphabet nodes.

##### SubscribeForNewEpoch

```go
func SubscribeForNewEpoch(contract interop.Hash160)
```

SubscribeForNewEpoch registers passed contract as a NewEpoch event subscriber. Such a contract must have a \`NewEpoch\` method with a single numeric parameter. Transactions that call SubscribeForNewEpoch must be witnessed by the Alphabet. Produces \`NewEpochSubscription\` notification event with a just registered recipient in a success case.

##### Update

```go
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by committee.

##### UpdateSnapshotCount

```go
func UpdateSnapshotCount(count int)
```

UpdateSnapshotCount updates the number of the stored snapshots. If a new number is less than the old one, old snapshots are removed. Otherwise, history is extended with empty snapshots, so \`Snapshot\` method can return invalid results for \`diff = new\-old\` epochs until \`diff\` epochs have passed.

Count MUST NOT be negative.

##### UpdateState

```go
func UpdateState(state nodestate.Type, publicKey interop.PublicKey)
```

UpdateState proposes a new state of candidate for the next\-epoch network map. The candidate is identified by the given public key. Call transaction MUST be signed by the provided public key, i.e. by node itself. If the signature is correct, the Notary service will submit a request for signature by the NeoFS Alphabet. After collecting a sufficient number of signatures, the candidate's state will be switched to the given one \('UpdateStateSuccess' notification is thrown after that\).

UpdateState panics if requested candidate is missing in the current candidate set. UpdateState drops candidate from the candidate set if it is switched to \[nodestate.Offline\].

State MUST be from the \[nodestate.Type\] enum. Public key MUST be interop.PublicKeyCompressedLen bytes.

##### UpdateStateIR

```go
func UpdateStateIR(state nodestate.Type, publicKey interop.PublicKey)
```

UpdateStateIR is called by the NeoFS Alphabet instead of UpdateState when signature of the network candidate is inaccessible. In such cases, a new transaction will be required and therefore the candidate's signature is not verified by UpdateStateIR. Besides this, the behavior is similar.

Deprecated: migrate to [UpdateState](<#UpdateState>) and [DeleteNode](<#DeleteNode>).

##### Version

```go
func Version() int
```

Version returns the version of the contract.

