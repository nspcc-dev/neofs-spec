### netmap contract



Package netmap contains implementation of the Netmap contract for NeoFS systems.

Netmap contract stores and manages NeoFS network map, Storage node candidates and epoch number counter. In notary disabled environment, contract also stores a list of Inner Ring node keys.

#### Contract notifications

AddPeer notification. This notification is produced when a Storage node sends a bootstrap request by invoking AddPeer method.

```
AddPeer
  - name: nodeInfo
    type: ByteArray
```

UpdateState notification. This notification is produced when a Storage node wants to change its state \(go offline\) by invoking UpdateState method. Supported states: \(2\) \-\- offline.

```
UpdateState
  - name: state
    type: Integer
  - name: publicKey
    type: PublicKey
```

NewEpoch notification. This notification is produced when a new epoch is applied in the network by invoking NewEpoch method.

```
NewEpoch
  - name: epoch
    type: Integer
```

#### Contract methods

##### AddPeer

```go
func AddPeer(nodeInfo []byte)
```

AddPeer proposes a node for consideration as a candidate for the next\-epoch network map. Information about the node is accepted in NeoFS API binary format. Call transaction MUST be signed by the public key sewn into the parameter \(compressed 33\-byte array starting from 3rd byte\), i.e. by candidate itself. If the signature is correct, the Notary service will submit a request for signature by the NeoFS Alphabet. After collecting a sufficient number of signatures, the node will be added to the list of candidates for the next\-epoch network map \('AddPeerSuccess' notification is thrown after that\).

Note that if the Alphabet needs to complete information about the candidate, it will be added with AddPeerIR.

##### AddPeerIR

```go
func AddPeerIR(nodeInfo []byte)
```

AddPeerIR is called by the NeoFS Alphabet instead of AddPeer when signature of the network candidate is inaccessible. For example, when information about the candidate proposed via AddPeer needs to be supplemented. In such cases, a new transaction will be required and therefore the candidate's signature is not verified by AddPeerIR. Besides this, the behavior is similar.

##### Config

```go
func Config(key []byte) any
```

Config returns configuration value of NeoFS configuration. If key does not exist, returns nil.

##### Epoch

```go
func Epoch() int
```

Epoch method returns the current epoch number.

##### InnerRingList

```go
func InnerRingList() []common.IRNode
```

InnerRingList method returns a slice of structures that contains the public key of an Inner Ring node. It should be used in notary disabled environment only.

If notary is enabled, look to NeoFSAlphabet role in native RoleManagement contract of the sidechain.

Deprecated: since non\-notary settings are no longer supported, refer only to the RoleManagement contract only. The method will be removed in one of the future releases.

##### LastEpochBlock

```go
func LastEpochBlock() int
```

LastEpochBlock method returns the block number when the current epoch was applied.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method changes the epoch number up to the provided epochNum argument. It can be invoked only by Alphabet nodes. If provided epoch number is less than the current epoch number or equals it, the method throws panic.

When epoch number is updated, the contract sets storage node candidates as the current network map. The contract also invokes NewEpoch method on Balance and Container contracts.

It produces NewEpoch notification.

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
func Update(script []byte, manifest []byte, data any)
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

##### Version

```go
func Version() int
```

Version returns the version of the contract.

