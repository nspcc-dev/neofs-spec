### container contract

Container contract is a contract deployed in NeoFS sidechain\.

Container contract stores and manages containers\, extended ACLs and container size estimations\. Contract does not perform sanity or signature checks of containers or extended ACLs\, it is done by Alphabet nodes of the Inner Ring\. Alphabet nodes approve it by invoking the same Put or SetEACL methods with the same arguments\.

#### Contract notifications

containerPut notification\. This notification is produced when a user wants to create a new container\. Alphabet nodes of the Inner Ring catch the notification and validate container data\, signature and token if present\.

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

containerDelete notification\. This notification is produced when a container owner wants to delete a container\. Alphabet nodes of the Inner Ring catch the notification and validate container ownership\, signature and token if present\.

```
containerDelete:
  - name: containerID
    type: ByteArray
  - name: signature
    type: Signature
  - name: token
    type: ByteArray
```

setEACL notification\. This notification is produced when a container owner wants to update an extended ACL of a container\. Alphabet nodes of the Inner Ring catch the notification and validate container ownership\, signature and token if present\.

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

##### Count

```go
func Count() int
```

Count method returns the number of registered containers\.

##### Delete

```go
func Delete(containerID []byte, signature interop.Signature, token []byte)
```

Delete method removes a container from the contract storage if it has been invoked by Alphabet nodes of the Inner Ring\. Otherwise\, it produces containerDelete notification\.

Signature is a RFC6979 signature of the container ID\. Token is optional and should be a stable marshaled SessionToken structure from API\.

If the container doesn't exist\, it panics with NotFoundError\.

##### List

```go
func List(owner []byte) [][]byte
```

List method returns a list of all container IDs owned by the specified owner\.

##### ListContainerSizes

```go
func ListContainerSizes(epoch int) [][]byte
```

ListContainerSizes method returns the IDs of container size estimations that has been registered for the specified epoch\.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method removes all container size estimations from epoch older than epochNum \+ 3\. It can be invoked only by NewEpoch method of the Netmap contract\.

##### OnNEP11Payment

```go
func OnNEP11Payment(a interop.Hash160, b int, c []byte, d interface{})
```

OnNEP11Payment is needed for registration with contract as the owner to work\.

##### Owner

```go
func Owner(containerID []byte) []byte
```

Owner method returns a 25 byte Owner ID of the container\.

If the container doesn't exist\, it panics with NotFoundError\.

##### Put

```go
func Put(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

Put method creates a new container if it has been invoked by Alphabet nodes of the Inner Ring\. Otherwise\, it produces containerPut notification\.

Container should be a stable marshaled Container structure from API\. Signature is a RFC6979 signature of the Container\. PublicKey contains the public key of the signer\. Token is optional and should be a stable marshaled SessionToken structure from API\.

##### PutContainerSize

```go
func PutContainerSize(epoch int, cid []byte, usedSize int, pubKey interop.PublicKey)
```

PutContainerSize method saves container size estimation in contract memory\. It can be invoked only by Storage nodes from the network map\. This method checks witness based on the provided public key of the Storage node\.

If the container doesn't exist\, it panics with NotFoundError\.

##### PutNamed

```go
func PutNamed(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string)
```

PutNamed is similar to put but also sets a TXT record in nns contract\. Note that zone must exist\.

##### SetEACL

```go
func SetEACL(eACL []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

SetEACL method sets a new extended ACL table related to the contract if it was invoked by Alphabet nodes of the Inner Ring\. Otherwise\, it produces setEACL notification\.

EACL should be a stable marshaled EACLTable structure from API\. Signature is a RFC6979 signature of the Container\. PublicKey contains the public key of the signer\. Token is optional and should be a stable marshaled SessionToken structure from API\.

If the container doesn't exist\, it panics with NotFoundError\.

##### StartContainerEstimation

```go
func StartContainerEstimation(epoch int)
```

StartContainerEstimation method produces StartEstimation notification\. It can be invoked only by Alphabet nodes of the Inner Ring\.

##### StopContainerEstimation

```go
func StopContainerEstimation(epoch int)
```

StopContainerEstimation method produces StopEstimation notification\. It can be invoked only by Alphabet nodes of the Inner Ring\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. It can be invoked by committee only\.

##### Version

```go
func Version() int
```

Version returns the version of the contract\.


