### container contract

Container contract is a contract deployed in NeoFS side chain\.

Container contract stores and manages containers\, extended ACLs and container size estimations\. Contract does not perform sanity or signature checks of the containers or extended ACLs\, it is done by Alphabet nodes of the Inner Ring\. Alphabet nodes approve it by invoking the same Put or SetEACL methods with the same arguments\.

#### Contract notifications

containerPut notification\. This notification is produced when user wants to create new container\. Alphabet nodes of the Inner Ring catch notification and validate container data\, signature and token if it is present\.

```
containerPut:
  - name: container
    type: ByteArray
  - name: signature
    type: Signature
  - name: publicKey
    type: PublicKey
  - name: token
    type: ByteArray
```

containerDelete notification\. This notification is produced when container owner wants to delete container\. Alphabet nodes of the Inner Ring catch notification and validate container ownership\, signature and token if it is present\.

```
containerDelete:
  - name: containerID
    type: ByteArray
  - name: signature
    type: Signature
  - name: token
    type: ByteArray
```

setEACL notification\. This notification is produced when container owner wants to update extended ACL of the container\. Alphabet nodes of the Inner Ring catch notification and validate container ownership\, signature and token if it is present\.

```
setEACL:
  - name: eACL
    type: ByteArray
  - name: signature
    type: Signature
  - name: publicKey
    type: PublicKey
  - name: token
    type: ByteArray
```

StartEstimation notification\. This notification is produced when Storage nodes should exchange estimation values of container sizes among other Storage nodes\.

```
StartEstimation:
  - name: epoch
    type: Integer
```

StopEstimation notification\. This notification is produced when Storage nodes should calculate average container size based on received estimations and store it in Container contract\.

```
StopEstimation:
  - name: epoch
    type: Integer
```

#### Contract methods

##### Delete

```go
func Delete(containerID []byte, signature interop.Signature, token []byte)
```

Delete method removes container from contract storage if it was invoked by Alphabet nodes of the Inner Ring\. Otherwise it produces containerDelete notification\.

Signature is a RFC6979 signature of container ID\. Token is optional and should be stable marshaled SessionToken structure from API\.

##### List

```go
func List(owner []byte) [][]byte
```

List method returns list of all container IDs owned by specified owner\.

##### ListContainerSizes

```go
func ListContainerSizes(epoch int) [][]byte
```

ListContainerSizes method returns IDs of container size estimations that has been registered for specified epoch\.

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

Migrate method updates contract source code and manifest\. Can be invoked only by contract owner\.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method removes all container size estimations from epoch older than epochNum \+ 3\. Can be invoked only by NewEpoch method of the Netmap contract\.

##### Owner

```go
func Owner(containerID []byte) []byte
```

Owner method returns 25 byte Owner ID of the container\.

##### Put

```go
func Put(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

Put method creates new container if it was invoked by Alphabet nodes of the Inner Ring\. Otherwise it produces containerPut notification\.

Container should be stable marshaled Container structure from API\. Signature is a RFC6979 signature of Container\. PublicKey contains public key of the signer\. Token is optional and should be stable marshaled SessionToken structure from API\.

##### PutContainerSize

```go
func PutContainerSize(epoch int, cid []byte, usedSize int, pubKey interop.PublicKey)
```

PutContainerSize method saves container size estimation in contract memory\. Can be invoked only by Storage nodes from the network map\. Method checks witness based on the provided public key of the Storage node\.

##### SetEACL

```go
func SetEACL(eACL []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

SetEACL method sets new extended ACL table related to the contract if it was invoked by Alphabet nodes of the Inner Ring\. Otherwise it produces setEACL notification\.

EACL should be stable marshaled EACLTable structure from API\. Signature is a RFC6979 signature of Container\. PublicKey contains public key of the signer\. Token is optional and should be stable marshaled SessionToken structure from API\.

##### StartContainerEstimation

```go
func StartContainerEstimation(epoch int)
```

StartContainerEstimation method produces StartEstimation notification\. Can be invoked only by Alphabet nodes of the Inner Ring\.

##### StopContainerEstimation

```go
func StopContainerEstimation(epoch int)
```

StopContainerEstimation method produces StopEstimation notification\. Can be invoked only by Alphabet nodes of the Inner Ring\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


