### neofsid contract

NeoFSID contract is a contract deployed in NeoFS side chain\.

NeoFSID contract used to store connection between OwnerID and it's public keys\. OwnerID is a 25\-byte N3 wallet address that can be produced from public key\. It is one\-way conversion\. In simple cases NeoFS verifies ownership by checking signature and relation between public key and OwnerID\.

In more complex cases\, user can use public keys unrelated to OwnerID to maintain secure access to the data\. NeoFSID contract stores relation between OwnerID and arbitrary public keys\. Data owner can bind or unbind public key with it's account by invoking Bind or Unbind methods of NeoFS contract in main chain\. After that\, Alphabet nodes produce multi signed AddKey and RemoveKey invocations of NeoFSID contract\.

#### Contract notifications

NeoFSID contract does not produce notifications to process\.

#### Contract methods

##### AddKey

```go
func AddKey(owner []byte, keys []interop.PublicKey)
```

AddKey binds list of provided public keys to OwnerID\. Can be invoked only by Alphabet nodes\.

This method panics if OwnerID is not 25 byte or public key is not 33 byte long\. If key is already bound\, ignores it\.

##### Key

```go
func Key(owner []byte) [][]byte
```

Key method returns list of 33\-byte public keys bound with OwnerID\.

This method panics if owner is not 25 byte long\.

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

Migrate method updates contract source code and manifest\. Can be invoked only by contract owner\.

##### RemoveKey

```go
func RemoveKey(owner []byte, keys []interop.PublicKey)
```

RemoveKey unbinds provided public keys from OwnerID\. Can be invoked only by Alphabet nodes\.

This method panics if OwnerID is not 25 byte or public key is not 33 byte long\. If key is already unbound\, ignores it\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


