### netmap contract

Netmap contract is a contract deployed in NeoFS sidechain\.

Netmap contract stores and manages NeoFS network map\, Storage node candidates and epoch number counter\. In notary disabled environment\, contract also stores a list of Inner Ring node keys\.

#### Contract notifications

AddPeer notification\. This notification is produced when a Storage node sends a bootstrap request by invoking AddPeer method\.

```
AddPeer
  - name: nodeInfo
    type: ByteArray
```

UpdateState notification\. This notification is produced when a Storage node wants to change its state \(go offline\) by invoking UpdateState method\. Supported states: \(2\) \-\- offline\.

```
UpdateState
  - name: state
    type: Integer
  - name: publicKey
    type: PublicKey
```

NewEpoch notification\. This notification is produced when a new epoch is applied in the network by invoking NewEpoch method\.

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

AddPeer method adds a new candidate to the next network map if it was invoked by Alphabet node\. If it was invoked by a node candidate\, it produces AddPeer notification\. Otherwise\, the method throws panic\.

If the candidate already exists\, its info is updated\. NodeInfo argument contains a stable marshaled version of netmap\.NodeInfo structure\.

##### AddPeerIR

```go
func AddPeerIR(nodeInfo []byte)
```

AddPeerIR method tries to add a new candidate to the network map\. It should only be invoked in notary\-enabled environment by the alphabet\.

##### Config

```go
func Config(key []byte) interface{}
```

Config returns configuration value of NeoFS configuration\. If key does not exists\, returns nil\.

##### Epoch

```go
func Epoch() int
```

Epoch method returns the current epoch number\.

##### InnerRingList

```go
func InnerRingList() []common.IRNode
```

InnerRingList method returns a slice of structures that contains the public key of an Inner Ring node\. It should be used in notary disabled environment only\.

If notary is enabled\, look to NeoFSAlphabet role in native RoleManagement contract of the sidechain\.

##### LastEpochBlock

```go
func LastEpochBlock() int
```

LastEpochBlock method returns the block number when the current epoch was applied\.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method changes the epoch number up to the provided epochNum argument\. It can be invoked only by Alphabet nodes\. If provided epoch number is less than the current epoch number or equals it\, the method throws panic\.

When epoch number is updated\, the contract sets storage node candidates as the current network map\. The contract also invokes NewEpoch method on Balance and Container contracts\.

It produces NewEpoch notification\.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value\. It can be invoked only by Alphabet nodes\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. It can be invoked only by committee\.

##### UpdateInnerRing

```go
func UpdateInnerRing(keys []interop.PublicKey)
```

UpdateInnerRing method updates a list of Inner Ring node keys\. It should be used only in notary disabled environment\. It can be invoked only by Alphabet nodes\.

If notary is enabled\, update NeoFSAlphabet role in native RoleManagement contract of the sidechain\. Use notary service to collect multisignature\.

##### UpdateSnapshotCount

```go
func UpdateSnapshotCount(count int)
```

UpdateSnapshotCount updates the number of the stored snapshots\. If a new number is less than the old one\, old snapshots are removed\. Otherwise\, history is extended with empty snapshots\, so \`Snapshot\` method can return invalid results for \`diff = new\-old\` epochs until \`diff\` epochs have passed\.

##### UpdateState

```go
func UpdateState(state int, publicKey interop.PublicKey)
```

UpdateState method updates the state of a node from the network map candidate list\. For notary\-ENABLED environment\, tx must be signed by both storage node and alphabet\. To force update without storage node signature\, see \`UpdateStateIR\`\.

For notary\-DISABLED environment\, the behaviour depends on who signed the transaction: 1\. If it was signed by alphabet\, go into voting\. 2\. If it was signed by a storage node\, emit \`UpdateState\` notification\. 2\. Fail in any other case\.

The behaviour can be summarized in the following table: | notary \\ Signer | Storage node | Alphabet | Both                  | | ENABLED         | FAIL         | FAIL     | OK                    | | DISABLED        | NOTIFICATION | OK       | OK \(same as alphabet\) | State argument defines node state\. The only supported state now is \(2\) \-\- offline state\. Node is removed from the network map candidate list\.

Method panics when invoked with unsupported states\.

##### UpdateStateIR

```go
func UpdateStateIR(state nodeState, publicKey interop.PublicKey)
```

UpdateStateIR method tries to change the node state in the network map\. Should only be invoked in notary\-enabled environment by alphabet\.

##### Version

```go
func Version() int
```

Version returns the version of the contract\.


