### netmap contract

Netmap contract is a contract deployed in NeoFS side chain\.

Netmap contract stores and manages NeoFS network map\, Storage node candidates and epoch number counter\. In notary disabled environment\, contract also stores list of Inner Ring node keys\.

#### Contract notifications

AddPeer notification\. This notification is produced when Storage node sends bootstrap request by invoking AddPeer method\.

```
AddPeer
  - name: nodeInfo
    type: ByteArray
```

UpdateState notification\. This notification is produced when Storage node wants to change it's state \(go offline\) by invoking UpdateState method\. Supported states: \(2\) \-\- offline\.

```
UpdateState
  - name: state
    type: Integer
  - name: publicKey
    type: PublicKey
```

NewEpoch notification\. This notification is produced when new epoch is applied in the network by invoking NewEpoch method\.

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

AddPeer method adds new candidate to the next network map if it was invoked by Alphabet node\. If it was invoked by node candidate\, it produces AddPeer notification\. Otherwise method throws panic\.

If the candidate already exists\, it's info is updated\. NodeInfo argument contains stable marshaled version of netmap\.NodeInfo structure\.

##### Config

```go
func Config(key []byte) interface{}
```

Config returns configuration value of NeoFS configuration\. If key does not exists\, returns nil\.

##### Epoch

```go
func Epoch() int
```

Epoch method returns current epoch number\.

##### InnerRingList

```go
func InnerRingList() []common.IRNode
```

InnerRingList method returns slice of structures that contains public key of Inner Ring node\. Should be used only in notary disabled environment\.

If notary enabled\, then look to NeoFSAlphabet role in native RoleManagement contract of the side chain\.

##### LastEpochBlock

```go
func LastEpochBlock() int
```

LastEpochBlock method returns block number when current epoch was applied\.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method changes epoch number up to provided epochNum argument\. Can be invoked only by Alphabet nodes\. If provided epoch number is less or equal current epoch number\, method throws panic\.

When epoch number updated\, contract sets storage node candidates as current network map\. Also contract invokes NewEpoch method on Balance and Container contracts\.

Produces NewEpoch notification\.

##### Register

```go
func Register(nodeInfo []byte)
```

Register method tries to add new candidate to the network map by emitting AddPeer notification\. Should be invoked by the registree\.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value\. Can be invoked only by Alphabet nodes\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. Can be invoked only by committee\.

##### UpdateInnerRing

```go
func UpdateInnerRing(keys []interop.PublicKey)
```

UpdateInnerRing method updates list of Inner Ring node keys\. Should be used only in notary disabled environment\. Can be invoked only by Alphabet nodes\.

If notary enabled\, then update NeoFSAlphabet role in native RoleManagement contract of the side chain\. Use notary service to collect multi signature\.

##### UpdateState

```go
func UpdateState(state int, publicKey interop.PublicKey)
```

UpdateState method updates state of node from the network map candidate list if it was invoked by Alphabet node\. If it was invoked by public key owner\, then it produces UpdateState notification\. Otherwise method throws panic\.

State argument defines node state\. The only supported state now is \(2\) \-\- offline state\. Node is removed from network map candidate list\.

Method panics when invoked with unsupported states\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


