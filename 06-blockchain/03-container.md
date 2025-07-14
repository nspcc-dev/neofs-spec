### container contract



Package container implements Container contract which is deployed to FS chain.

Container contract stores and manages containers, extended ACLs and container size estimations. Contract does not perform sanity or signature checks of containers or extended ACLs, it is done by Alphabet nodes of the Inner Ring. Alphabet nodes approve it by invoking the same Put or SetEACL methods with the same arguments.

#### Contract notifications

containerPut notification. This notification is produced when a user wants to create a new container. Alphabet nodes of the Inner Ring catch the notification and validate container data, signature and token if present.

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

containerDelete notification. This notification is produced when a container owner wants to delete a container. Alphabet nodes of the Inner Ring catch the notification and validate container ownership, signature and token if present.

```
containerDelete:
  - name: containerID
    type: ByteArray
  - name: signature
    type: Signature
  - name: token
    type: ByteArray
```

nodesUpdate notification. This notification is produced when a container roster is changed. Triggered only by the Alphabet at the beginning of epoch.

```
name: NodesUpdate
  - name: ContainerID
    type: hash256
```

setEACL notification. This notification is produced when a container owner wants to update an extended ACL of a container. Alphabet nodes of the Inner Ring catch the notification and validate container ownership, signature and token if present.

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

StartEstimation notification. This notification is produced when Storage nodes should exchange estimation values of container sizes among other Storage nodes.

```
StartEstimation:
  - name: epoch
    type: Integer
```

StopEstimation notification. This notification is produced when Storage nodes should calculate average container size based on received estimations and store it in Container contract.

```
StopEstimation:
  - name: epoch
    type: Integer
```

#### Contract methods

##### AddNextEpochNodes

```go
func AddNextEpochNodes(cID interop.Hash256, placementVector uint8, publicKeys []interop.PublicKey)
```

AddNextEpochNodes accumulates passed nodes as container members for the next epoch to be committed using [CommitContainerListUpdate](<#CommitContainerListUpdate>). Nodes must be grouped by selector index from placement policy \(SELECT clauses\). Results of the call operation can be received via [Nodes](<#Nodes>). This method must be called only when a container list is changed, otherwise nothing should be done. Call must be signed by the Alphabet nodes.

##### Alias

```go
func Alias(cid []byte) string
```

Alias method returns a string with an alias of the container if it's set \(Null otherwise\).

If the container doesn't exist, it panics with NotFoundError.

##### CommitContainerListUpdate

```go
func CommitContainerListUpdate(cID interop.Hash256, replicas []uint8)
```

CommitContainerListUpdate commits container list changes made by [AddNextEpochNodes](<#AddNextEpochNodes>) calls in advance. Replicas must correspond to ordered placement policy \(REP clauses\). If no [AddNextEpochNodes](<#AddNextEpochNodes>) have been made, it clears container list. Makes "ContainerUpdate" notification with container ID after successful list change. Call must be signed by the Alphabet nodes.

##### ContainersOf

```go
func ContainersOf(owner []byte) iterator.Iterator
```

ContainersOf iterates over all container IDs owned by the specified owner. If owner is nil, it iterates over all containers.

##### Count

```go
func Count() int
```

Count method returns the number of registered containers.

##### Create

```go
func Create(cnr []byte, invocScript, verifScript, sessionToken []byte, name, zone string, metaOnChain bool)
```

Create saves container descriptor serialized according to the NeoFS API binary protocol. Created containers are content\-addressed: they may be accessed by SHA\-256 checksum of their data. On success, Create throws 'Created' notification event.

Created containers are disposable: if they are deleted, they cannot be created again. Create throws \[cst.ErrorDeleted\] exception on recreation attempts.

Domain name is optional. If specified, it is used to register 'name.zone' domain for given container. Domain zone is optional: it defaults to the 6th contract deployment parameter which itself defaults to 'container'.

Meta\-on\-chain boolean flag specifies whether meta information about objects from this container can be collected for it.

The operation is paid. Container owner pays per\-container fee \(global chain configuration\) to each committee member. If domain registration is requested, additional alias fee \(also a configuration\) is added to each payment.

Create must have chain's committee multi\-signature witness. Invocation script, verification script and session token parameters are owner credentials. They are transmitted in notary transactions carrying original users' requests. IR verifies requests and approves them via multi\-signature. Once creation is approved, container is persisted and becomes accessible. Credentials are disposable and do not persist in the chain.

##### Delete

```go
func Delete(containerID []byte, signature interop.Signature, token []byte)
```

Delete method removes a container from the contract storage if it has been invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces containerDelete notification.

Signature is a RFC6979 signature of the container ID. Token is optional and should be a stable marshaled SessionToken structure from API.

If the container doesn't exist, it panics with NotFoundError. Deprecated: use [Remove](<#Remove>) instead.

##### GetContainerData

```go
func GetContainerData(id []byte) []byte
```

GetContainerData returns binary of the container it was created with by ID.

If the container is missing, GetContainerData throws \[cst.NotFoundError\] exception.

##### GetEACLData

```go
func GetEACLData(id []byte) []byte
```

GetEACLData returns binary of container eACL it was put with by the container ID.

If the container is missing, GetEACLData throws \[cst.NotFoundError\] exception.

##### IterateAllContainerSizes

```go
func IterateAllContainerSizes(epoch int) iterator.Iterator
```

IterateAllContainerSizes method returns iterator over all container size estimations that have been registered for the specified epoch. Items returned from this iterator are key\-value pairs with keys having container ID as a prefix and values being Estimation structures.

##### IterateContainerSizes

```go
func IterateContainerSizes(epoch int, cid interop.Hash256) iterator.Iterator
```

IterateContainerSizes method returns iterator over specific container size estimations that have been registered for the specified epoch. The iterator items are Estimation structures.

##### List

```go
func List(owner []byte) [][]byte
```

List method returns a list of all container IDs owned by the specified owner.

##### ListContainerSizes

```go
func ListContainerSizes(epoch int) [][]byte
```

ListContainerSizes method returns the IDs of container size estimations that have been registered for the specified epoch.

Deprecated: please use IterateAllContainerSizes API, this one is not convenient to use and limited in the number of items it can return. It will be removed in future versions.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch method removes all container size estimations from epoch older than epochNum \+ 3. It can be invoked only by NewEpoch method of the Netmap contract.

##### Nodes

```go
func Nodes(cID interop.Hash256, placementVector uint8) iterator.Iterator
```

Nodes returns iterator over members of the container. The list is handled by the Alphabet nodes and must be updated via [AddNextEpochNodes](<#AddNextEpochNodes>) and [CommitContainerListUpdate](<#CommitContainerListUpdate>) calls.

##### OnNEP11Payment

```go
func OnNEP11Payment(a interop.Hash160, b int, c []byte, d any)
```

OnNEP11Payment is needed for registration with contract as the owner to work.

##### Owner

```go
func Owner(containerID []byte) []byte
```

Owner method returns a 25 byte Owner ID of the container.

If the container doesn't exist, it panics with NotFoundError.

##### Put

```go
func Put(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

Put method creates a new container if it has been invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces containerPut notification.

Container should be a stable marshaled Container structure from API. Signature is a RFC6979 signature of the Container. PublicKey contains the public key of the signer. Token is optional and should be a stable marshaled SessionToken structure from API. Deprecated: use [Create](<#Create>) instead.

##### PutContainerSize

```go
func PutContainerSize(epoch int, cid []byte, usedSize int, pubKey interop.PublicKey)
```

PutContainerSize method saves container size estimation in contract memory. It can be invoked only by Storage nodes from the network map. This method checks witness based on the provided public key of the Storage node.

If the container doesn't exist, it panics with NotFoundError.

##### PutEACL

```go
func PutEACL(eACL []byte, invocScript, verifScript, sessionToken []byte)
```

PutEACL puts given eACL serialized according to the NeoFS API binary protocol for the container it is referenced to. Operation must be allowed in the container's basic ACL. If container does not exist, PutEACL throws \[cst.NotFoundError\] exception. On success, PutEACL throws 'EACLChanged' notification event.

See [Create](<#Create>) for details.

##### PutMeta

```go
func PutMeta(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string, metaOnChain bool)
```

PutMeta is the same as [Put](<#Put>) and [PutNamed](<#PutNamed>) \(and exposed as put from the contract via overload\), but allows named containers and container's meta\-information be handled and notified using the chain. If name and zone are non\-empty strings, it behaves the same as [PutNamed](<#PutNamed>); empty strings make a regular [Put](<#Put>) call. Deprecated: use [Create](<#Create>) instead.

##### PutNamed

```go
func PutNamed(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string)
```

PutNamed is similar to put but also sets a TXT record in nns contract. Note that zone must exist. DEPRECATED: use [Create](<#Create>) instead.

##### PutNamedOverloaded

```go
func PutNamedOverloaded(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string)
```

PutNamedOverloaded is the same as [Put](<#Put>) \(and exposed as put from the contract via overload\), but allows named container creation via NNS contract. Deprecated: use [Create](<#Create>) instead.

##### Remove

```go
func Remove(id []byte, invocScript, verifScript, sessionToken []byte)
```

Remove removes all data for the referenced container. Remove is no\-op if container does not exist. On success, Remove throws 'Removed' notification event.

See [Create](<#Create>) for details.

##### ReplicasNumbers

```go
func ReplicasNumbers(cID interop.Hash256) iterator.Iterator
```

ReplicasNumbers returns iterator over saved by [CommitContainerListUpdate](<#CommitContainerListUpdate>) container's replicas from placement policy.

##### SetEACL

```go
func SetEACL(eACL []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

SetEACL method sets a new extended ACL table related to the contract if it was invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces setEACL notification.

EACL should be a stable marshaled EACLTable structure from API. Protocol version and container reference must be set in 'version' and 'container\_id' fields respectively. Signature is a RFC6979 signature of the Container. PublicKey contains the public key of the signer. Token is optional and should be a stable marshaled SessionToken structure from API.

If the container doesn't exist, it panics with NotFoundError. Deprecated: use [PutEACL](<#PutEACL>) instead.

##### StartContainerEstimation

```go
func StartContainerEstimation(epoch int)
```

StartContainerEstimation method produces StartEstimation notification. It can be invoked only by Alphabet nodes of the Inner Ring.

##### StopContainerEstimation

```go
func StopContainerEstimation(epoch int)
```

StopContainerEstimation method produces StopEstimation notification. It can be invoked only by Alphabet nodes of the Inner Ring.

##### SubmitObjectPut

```go
func SubmitObjectPut(metaInformation []byte, sigs [][]interop.Signature)
```

SubmitObjectPut registers successful object PUT operation and notifies about it. metaInformation must be signed by container nodes according to container's placement, see [VerifyPlacementSignatures](<#VerifyPlacementSignatures>). metaInformation must contain information about an object placed to a container that was created using [Put](<#Put>) \([PutMeta](<#PutMeta>)\) with enabled meta\-on\-chain option.

##### Update

```go
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked by committee only.

##### VerifyPlacementSignatures

```go
func VerifyPlacementSignatures(cid interop.Hash256, msg []byte, sigs [][]interop.Signature) bool
```

VerifyPlacementSignatures verifies that message has been signed by container members according to container's placement policy: there should be at least REP number of signatures for every placement vector. sigs must be container's number of SELECTs length.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

