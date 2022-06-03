### subnet contract

Subnet contract is a contract deployed in NeoFS sidechain\.

Subnet contract stores and manages NeoFS subnetwork states\. It allows registering and deleting subnetworks\, limiting access to them\, and defining a list of the Storage Nodes that can be included in them\.

#### Contract notifications

Put notification\. This notification is produced when a new subnetwork is registered by invoking Put method\.

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

AddClientAdmin adds a new client administrator of the specified group in the specified subnetwork\. Must be called by the owner only\.

##### AddNode

```go
func AddNode(subnetID []byte, node interop.PublicKey)
```

AddNode adds a node to the specified subnetwork\. Must be called by the subnet's owner or the node administrator only\.

##### AddNodeAdmin

```go
func AddNodeAdmin(subnetID []byte, adminKey interop.PublicKey)
```

AddNodeAdmin adds a new node administrator to the specified subnetwork\.

##### AddUser

```go
func AddUser(subnetID []byte, groupID []byte, userID []byte)
```

AddUser adds user to the specified subnetwork and group\. Must be called by the owner or the group's admin only\.

##### Delete

```go
func Delete(id []byte)
```

Delete deletes the subnet with the specified id\.

##### Get

```go
func Get(id []byte) []byte
```

Get returns info about the subnet with the specified id\.

##### NodeAllowed

```go
func NodeAllowed(subnetID []byte, node interop.PublicKey) bool
```

NodeAllowed checks if a node is included in the specified subnet\.

##### Put

```go
func Put(id []byte, ownerKey interop.PublicKey, info []byte)
```

Put creates a new subnet with the specified owner and info\.

##### RemoveClientAdmin

```go
func RemoveClientAdmin(subnetID []byte, groupID []byte, adminPublicKey interop.PublicKey)
```

RemoveClientAdmin removes client administrator from the specified group in the specified subnetwork\. Must be called by the owner only\.

##### RemoveNode

```go
func RemoveNode(subnetID []byte, node interop.PublicKey)
```

RemoveNode removes a node from the specified subnetwork\. Must be called by the subnet's owner or the node administrator only\.

##### RemoveNodeAdmin

```go
func RemoveNodeAdmin(subnetID []byte, adminKey interop.PublicKey)
```

RemoveNodeAdmin removes node administrator from the specified subnetwork\. Must be called by the subnet owner only\.

##### RemoveUser

```go
func RemoveUser(subnetID []byte, groupID []byte, userID []byte)
```

RemoveUser removes a user from the specified subnetwork and group\. Must be called by the owner or the group's admin only\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. It can be invoked only by committee\.

##### UserAllowed

```go
func UserAllowed(subnetID []byte, user []byte) bool
```

UserAllowed returns bool that indicates if a node is included in the specified subnet\.

##### Version

```go
func Version() int
```

Version returns the version of the contract\.


