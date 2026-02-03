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

ContainerQuotaSet notification. This notification is produced when container's owner sets \(updates\) size limitation for storage used for all objects in this container.

```
ContainerQuotaSet
  - name: ContainerID
	type: Hash256
  - name: LimitValue
	type: Integer
  - name: Hard
	type: Boolean
```

UserQuotaSet notification. This notification is produced when container's owner sets \(updates\) size limitation for storage used for all objects in \_all\_ containers he owns.

```
UserQuotaSet
  - name: UserID
	type: ByteArray # 25 byte N3 address
  - name: LimitValue
	type: Integer
  - name: Hard
	type: Boolean
```

AttributeChanged notification. Produced on successful setAttribute or removeAttribute invocations when mentioned attribute is affected.

```
AttributeChanged
  - name: containerID
    type: Hash256
  - name: attribute
    type: String # Name of attribute
```

#### Contract methods

##### AddNextEpochNodes

```go
func AddNextEpochNodes(cID interop.Hash256, placementVector uint8, publicKeys []interop.PublicKey)
```

AddNextEpochNodes accumulates passed nodes as container members for the next epoch to be committed using [CommitContainerListUpdate](<#CommitContainerListUpdate>). Nodes must be grouped by selector index from placement policy \(SELECT clauses\). Results of the call operation can be received via [Nodes](<#Nodes>). This method must be called only when a container list is changed, otherwise nothing should be done. Call must be signed by the Alphabet nodes.

##### AddStructs

```go
func AddStructs() bool
```

AddStructs makes and saves structures for up to 10 existing containers. Returns true if not all stored containers have been structurized. Recall continues the process. Returning false means all containers have been processed.

AddStructs requires Alphabet witness.

AddStructs throws NEP\-11 'Transfer' event representing token mint for each handled container.

##### Alias

```go
func Alias(cid []byte) string
```

Alias method returns a string with an alias of the container if it's set \(Null otherwise\).

If the container doesn't exist, it panics with NotFoundError.

##### BalanceOf

```go
func BalanceOf(owner interop.Hash160) int
```

BalanceOf returns number of containers owner by given account.

BalanceOf implements NEP\-11 method.

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

Deprecated: use [TokensOf](<#TokensOf>) for non\-empty and [Tokens](<#Tokens>) for empty owner correspondingly.

##### Count

```go
func Count() int
```

Count method returns the number of registered containers.

Deprecated: use [TotalSupply](<#TotalSupply>) instead.

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

Deprecated: use [CreateV2](<#CreateV2>) with instead.

##### CreateV2

```go
func CreateV2(cnr Info, invocScript, verifScript, sessionToken []byte) interop.Hash256
```

CreateV2 creates container with given info in the contract. Created containers are content\-addressed: they may be accessed by SHA\-256 checksum of their data. On success, CreateV2 throws 'Created' notification event.

Created containers are disposable: if they are deleted, they cannot be created again. CreateV2 throws \[cst.ErrorDeleted\] exception on recreation attempts.

If '\_\_NEOFS\_\_NAME' and '\_\_NEOFS\_\_ZONE' attributes are set, they are used to register 'name.zone' domain for given container. Domain zone is optional: it defaults to the 6th contract deployment parameter which itself defaults to 'container'.

If '\_\_NEOFS\_\_METAINFO\_CONSISTENCY' attribute is set, meta information about objects from this container can be collected for it.

If cnr contains '\_\_NEOFS\_\_LOCK\_UNTIL' attribute, its value must be a valid Unix Timestamp later the current one. On success, referenced container becomes locked for removal until specified time.

The operation is paid. Container owner pays per\-container fee \(global chain configuration\) to each committee member. If domain registration is requested, additional alias fee \(also a configuration\) is added to each payment.

CreateV2 must have chain's committee multi\-signature witness. Invocation script, verification script and session token parameters are owner credentials. They are transmitted in notary transactions carrying original users' requests. IR verifies requests and approves them via multi\-signature. Once creation is approved, container is persisted and becomes accessible. Credentials are disposable and do not persist in the chain.

##### Decimals

```go
func Decimals() int
```

Decimals returns static zero meaning containers are Non\-divisible NFTs.

Decimals implements NEP\-11 method.

##### Delete

```go
func Delete(containerID []byte, signature interop.Signature, token []byte)
```

Delete method removes a container from the contract storage if it has been invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces containerDelete notification.

Signature is a RFC6979 signature of the container ID. Token is optional and should be a stable marshaled SessionToken structure from API.

If the container doesn't exist, it panics with NotFoundError.

Deprecated: use [Remove](<#Remove>) instead.

##### GetContainerData

```go
func GetContainerData(id []byte) []byte
```

GetContainerData returns binary of the container it was created with by ID.

If the container is missing, GetContainerData throws \[cst.NotFoundError\] exception.

Deprecated: use [GetInfo](<#GetInfo>) instead.

##### GetEACLData

```go
func GetEACLData(id []byte) []byte
```

GetEACLData returns binary of container eACL it was put with by the container ID.

If the container is missing, GetEACLData throws \[cst.NotFoundError\] exception.

##### GetTakenSpaceByUser

```go
func GetTakenSpaceByUser(user []byte) int
```

GetTakenSpaceByUser returns total load space in all containers user owns. If user have no containers, it returns 0.

##### IterateAllReportSummaries

```go
func IterateAllReportSummaries() iterator.Iterator
```

IterateAllReportSummaries method returns iterator over all total container sizes that have been registered for the specified epoch. Items returned from this iterator are key\-value pairs with keys having container ID as a prefix and values being [NodeReportSummary](<#NodeReportSummary>) structures.

##### IterateBillingStats

```go
func IterateBillingStats(cid interop.Hash256) iterator.Iterator
```

IterateBillingStats method returns iterator over container's billing statistics made based on [NodeReport](<#NodeReport>).

##### IterateReports

```go
func IterateReports(cid interop.Hash256) iterator.Iterator
```

IterateReports method returns iterator over nodes' reports that were claimed for specified epoch and container.

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

Deprecated: use [OwnerOf](<#OwnerOf>) instead.

##### OwnerOf

```go
func OwnerOf(tokenID []byte) interop.Hash160
```

OwnerOf returns owner of the container identified by tokenID.

If referenced container does not exist, OwnerOf throws \[cst.NotFoundError\] exception. If the container has already been removed, OwnerOf throws \[cst.ErrorDeleted\] exception.

OwnerOf implements NEP\-11 method.

##### Properties

```go
func Properties(tokenID []byte) map[string]any
```

Properties returns properties of referenced container. The properties are 'name' and all KV attributes.

The 'name' property is set to 'Name' attribute value if exists. In this case, 'Name' attribute itself is not included. Otherwise, if 'Name' attribute is missing, 'name' is set to Base58\-encoded tokenID. Note that container 'name' attribute is always overlapped if any.

If referenced container does not exist, OwnerOf throws \[cst.NotFoundError\] exception. If the container has already been removed, OwnerOf throws \[cst.ErrorDeleted\] exception.

Properties implements optional NEP\-11 method.

##### Put

```go
func Put(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

Put method creates a new container if it has been invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces containerPut notification.

Container should be a stable marshaled Container structure from API. Signature is a RFC6979 signature of the Container. PublicKey contains the public key of the signer. Token is optional and should be a stable marshaled SessionToken structure from API.

Deprecated: use [CreateV2](<#CreateV2>) instead.

##### PutEACL

```go
func PutEACL(eACL []byte, invocScript, verifScript, sessionToken []byte)
```

PutEACL puts given eACL serialized according to the NeoFS API binary protocol for the container it is referenced to. Operation must be allowed in the container's basic ACL. If container does not exist, PutEACL throws \[cst.NotFoundError\] exception. On success, PutEACL throws 'EACLChanged' notification event.

See [CreateV2](<#CreateV2>) for details.

##### PutMeta

```go
func PutMeta(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string, metaOnChain bool)
```

PutMeta is the same as [Put](<#Put>) and [PutNamed](<#PutNamed>) \(and exposed as put from the contract via overload\), but allows named containers and container's meta\-information be handled and notified using the chain. If name and zone are non\-empty strings, it behaves the same as [PutNamed](<#PutNamed>); empty strings make a regular [Put](<#Put>) call.

Deprecated: use [CreateV2](<#CreateV2>) instead.

##### PutNamed

```go
func PutNamed(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string)
```

PutNamed is similar to put but also sets a TXT record in nns contract. Note that zone must exist.

Deprecated: use [CreateV2](<#CreateV2>) instead.

##### PutNamedOverloaded

```go
func PutNamedOverloaded(container []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte, name, zone string)
```

PutNamedOverloaded is the same as [Put](<#Put>) \(and exposed as put from the contract via overload\), but allows named container creation via NNS contract.

Deprecated: use [CreateV2](<#CreateV2>) instead.

##### PutReport

```go
func PutReport(cid interop.Hash256, sizeBytes, objsNumber int, pubKey interop.PublicKey)
```

PutReport method saves container's state report in contract memory. It must be invoked only by Storage nodes that belong to reported container. This method checks witness based on the provided public key of the Storage node. sizeBytes is a total storage that is used by storage node for storing all marshaled objects that belong to the specified container. objsNumber is a total number of container's object storage node have.

If the container doesn't exist, it panics with \[cst.NotFoundError\].

##### Remove

```go
func Remove(id []byte, invocScript, verifScript, sessionToken []byte)
```

Remove removes all data for the referenced container. Remove is no\-op if container does not exist. On success, Remove throws 'Removed' notification event.

If the container has '\_\_NEOFS\_\_LOCK\_UNTIL' attribute with timestamp that has not passed yet, Remove throws exception containing \[cst.ErrorLocked\].

See [CreateV2](<#CreateV2>) for details.

##### RemoveAttribute

```go
func RemoveAttribute(cID interop.Hash256, name string, validUntil int, invocScript, verifScript, sessionToken []byte)
```

RemoveAttribute removes container attribute. Not all container attributes can be removed with RemoveAttribute. The supported list of attributes:



If name is '\_\_NEOFS\_\_LOCK\_UNTIL', current time must be later than the currently set one if any.

The validUntil must be Unix Timestamp which has not yet pass.

RemoveAttribute must have Alphabet witness. Invocation and verification scripts must authenticate either container owner or session subject if any. If session token is set, it must be issued by the container owner and have at least one context with referenced container and \`REMOVEATTRIBUTE\` verb. The sessionToken parameter must be encoded according to NeoFS API binary protocol.

If container is missing, RemoveAttribute throws \[cst.NotFoundError\] exception.

##### ReplicasNumbers

```go
func ReplicasNumbers(cID interop.Hash256) iterator.Iterator
```

ReplicasNumbers returns iterator over saved by [CommitContainerListUpdate](<#CommitContainerListUpdate>) container's replicas from placement policy.

##### SetAttribute

```go
func SetAttribute(cID interop.Hash256, name, value string, validUntil int, invocScript, verifScript, sessionToken []byte)
```

SetAttribute sets container attribute. Not all container attributes can be changed with SetAttribute. The supported list of attributes:



CORS attribute gets JSON encoded \`\[\]CORSRule\` as value.

If name is '\_\_NEOFS\_\_LOCK\_UNTIL', value must a valid Unix Timestamp later the current and already set \(if any\) ones. On success, referenced container becomes locked for removal until specified time.

If the name is 'S3\_TAGS', the value must be a valid JSON map, where the key is the tag name and the value is the tag value. It is an S3 gate\-specific attribute. For instance: \{"my\-tag":"my\-value"\}.

If the name is 'S3\_SETTINGS', the value is not validated by the contract, but must be valid JSON. It is an S3 gate\-specific attribute. The structure of it is controlled by the gate itself.

If the name is 'S3\_NOTIFICATIONS', the value is not validated by the contract, but must be valid JSON. It is an S3 gate\-specific attribute. The structure of it is controlled by the gate itself.

The validUntil must be Unix Timestamp which has not yet pass.

SetAttribute must have Alphabet witness. Invocation and verification scripts must authenticate either container owner or session subject if any. If session token is set, it must be issued by the container owner and have at least one context with referenced container and \`SETATTRIBUTE\` verb. The sessionToken parameter must be encoded according to NeoFS API binary protocol.

If container is missing, SetAttribute throws \[cst.NotFoundError\] exception.

##### SetEACL

```go
func SetEACL(eACL []byte, signature interop.Signature, publicKey interop.PublicKey, token []byte)
```

SetEACL method sets a new extended ACL table related to the contract if it was invoked by Alphabet nodes of the Inner Ring. Otherwise, it produces setEACL notification.

EACL should be a stable marshaled EACLTable structure from API. Protocol version and container reference must be set in 'version' and 'container\_id' fields respectively. Signature is a RFC6979 signature of the Container. PublicKey contains the public key of the signer. Token is optional and should be a stable marshaled SessionToken structure from API.

If the container doesn't exist, it panics with NotFoundError.

Deprecated: use [PutEACL](<#PutEACL>) instead.

##### SetHardContainerQuota

```go
func SetHardContainerQuota(cID interop.Hash256, size int)
```

SetHardContainerQuota sets hard size quota that limits all space used for storing objects in cID \(including object replicas\). Non\-positive size sets no limitation. After exceeding the limit nodes will refuse any further PUTs. Call must be signed by cID's owner. Limit can be changed with a repeated call. See also [SetSoftContainerQuota](<#SetSoftContainerQuota>). Panics if cID is incorrect or container does not exist.

##### SetHardUserQuota

```go
func SetHardUserQuota(user []byte, size int)
```

SetHardUserQuota sets size quota that limits all space used for storing objects in all containers that belong to user \(including object replicas\). Non\-positive size sets no limitation. After exceeding the limit nodes will refuse any further PUTs. Call must be signed by user. Limit can be changed with a repeated call. See also [SetSoftUserQuota](<#SetSoftUserQuota>). Panics if user is incorrect.

##### SetSoftContainerQuota

```go
func SetSoftContainerQuota(cID interop.Hash256, size int)
```

SetSoftContainerQuota sets soft size quota that limits all space used for storing objects in cID \(including object replicas\). Non\-positive size sets no limitation. After exceeding the limit nodes are instructed to warn only, without denial of service. Call must be signed by cID's owner. Limit can be changed with a repeated call. See also [SetHardContainerQuota](<#SetHardContainerQuota>). Panics if cID is incorrect or container does not exist.

##### SetSoftUserQuota

```go
func SetSoftUserQuota(user []byte, size int)
```

SetSoftUserQuota sets size quota that limits all space used for storing objects in all containers that belong to user \(including object replicas\). Non\-positive size sets no limitation. After exceeding the limit nodes are instructed to warn only, without denial of service. Call must be signed by user. Limit can be changed with a repeated call. See also [SetHardUserQuota](<#SetHardUserQuota>). Panics if user is incorrect.

##### SubmitObjectPut

```go
func SubmitObjectPut(metaInformation []byte, sigs [][]interop.Signature)
```

SubmitObjectPut registers successful object PUT operation and notifies about it. metaInformation must be signed by container nodes according to container's placement, see [VerifyPlacementSignatures](<#VerifyPlacementSignatures>). metaInformation must contain information about an object placed to a container that was created using [Put](<#Put>) \([PutMeta](<#PutMeta>)\) with enabled meta\-on\-chain option.

##### Symbol

```go
func Symbol() string
```

Symbol returns static 'FSCNTR'.

Symbol implements NEP\-11 method.

##### Tokens

```go
func Tokens() iterator.Iterator
```

Tokens returns iterator over IDs of all existing containers.

Tokens implements optional NEP\-11 method.

##### TokensOf

```go
func TokensOf(owner interop.Hash160) iterator.Iterator
```

TokensOf returns iterator over IDs of all containers owned by given account.

TokensOf implements NEP\-11 method.

##### TotalSupply

```go
func TotalSupply() int
```

TotalSupply returns total number of existing containers.

TotalSupply implements NEP\-11 method.

##### Transfer

```go
func Transfer(to interop.Hash160, tokenID []byte, data any) bool
```

Transfer makes to an owner of the container identified by tokenID.

If referenced container does not exist, Transfer throws \[cst.NotFoundError\] exception. If the container has already been removed, Transfer throws \[cst.ErrorDeleted\] exception.

Transfer implements NEP\-11 method.

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

