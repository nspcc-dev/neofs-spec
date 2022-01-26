### subnet contract

Subnet contract is a contract deployed in NeoFS side chain\.

Subnet contract stores and manages NeoFS subnetwork states\. It allows registering and deleting subnetworks\, limiting access to them and defining a list of the Storage Nodes that can be included in them\.

#### Contract notifications

Put notification\. This notification is produced when new subnetwork is registered by invoking Put method\.

```
Put
  - name: id
    type: ByteArray
  - name: ownerKey
    type: PublicKey
  - name: info
    type: ByteArray
```

Delete notification\. This notification is produced when some subnetwork is deleted by invoking Delete method\.

```
Delete
  - name: id
    type: ByteArray
```

RemoveNode notification\. This notification is produced when some node is deleted by invoking RemoveNode method\.

```
RemoveNode
  - name: subnetID
    type: ByteArray
  - name: node
    type: PublicKey
```

#### Contract methods

##### AddClientAdmin

```go
func AddClientAdmin(subnetID []byte, groupID []byte, adminPublicKey interop.PublicKey)
```

AddClientAdmin adds new client administrator of the specified group in the specified subnetwork\. Must be called by owner only\.

##### AddNode

```go
func AddNode(subnetID []byte, node interop.PublicKey)
```

AddNode adds node to the specified subnetwork\. Must be called by subnet's owner or node administrator only\.

##### AddNodeAdmin

```go
func AddNodeAdmin(subnetID []byte, adminKey interop.PublicKey)
```

AddNodeAdmin adds new node administrator to the specified subnetwork\.

##### AddUser

```go
func AddUser(subnetID []byte, groupID []byte, userID []byte)
```

AddUser adds user to the specified subnetwork and group\. Must be called by the owner or the group's admin only\.

##### Delete

```go
func Delete(id []byte)
```

Delete deletes subnet with the specified id\.

##### Get

```go
func Get(id []byte) []byte
```

Get returns info about subnet with the specified id\.

##### NodeAllowed

```go
func NodeAllowed(subnetID []byte, node interop.PublicKey) bool
```

NodeAllowed checks if node is included in the specified subnet or not\.

##### Put

```go
func Put(id []byte, ownerKey interop.PublicKey, info []byte)
```

Put creates new subnet with the specified owner and info\.

##### RemoveClientAdmin

```go
func RemoveClientAdmin(subnetID []byte, groupID []byte, adminPublicKey interop.PublicKey)
```

RemoveClientAdmin removes client administrator from the specified group in the specified subnetwork\. Must be called by owner only\.

##### RemoveNode

```go
func RemoveNode(subnetID []byte, node interop.PublicKey)
```

RemoveNode removes node from the specified subnetwork\. Must be called by subnet's owner or node administrator only\.

##### RemoveNodeAdmin

```go
func RemoveNodeAdmin(subnetID []byte, adminKey interop.PublicKey)
```

RemoveNodeAdmin removes node administrator from the specified subnetwork\. Must be called by subnet owner only\.

##### RemoveUser

```go
func RemoveUser(subnetID []byte, groupID []byte, userID []byte)
```

RemoveUser removes user from the specified subnetwork and group\. Must be called by the owner or the group's admin only\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. Can be invoked only by committee\.

##### UserAllowed

```go
func UserAllowed(subnetID []byte, user []byte) bool
```

UserAllowed returns bool that indicates if node is included in the specified subnet or not\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


