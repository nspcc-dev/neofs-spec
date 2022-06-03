### neofsid contract

NeoFSID contract is a contract deployed in NeoFS sidechain\.

NeoFSID contract is used to store connection between an OwnerID and its public keys\. OwnerID is a 25\-byte N3 wallet address that can be produced from a public key\. It is one\-way conversion\. In simple cases\, NeoFS verifies ownership by checking signature and relation between a public key and an OwnerID\.

In more complex cases\, a user can use public keys unrelated to the OwnerID to maintain secure access to the data\. NeoFSID contract stores relation between an OwnerID and arbitrary public keys\. Data owner can bind a public key with its account or unbind it by invoking Bind or Unbind methods of NeoFS contract in the mainchain\. After that\, Alphabet nodes produce multisigned AddKey and RemoveKey invocations of NeoFSID contract\.

#### Contract notifications

NeoFSID contract does not produce notifications to process\.

#### Contract methods

##### AddKey

```go
func AddKey(owner []byte, keys []interop.PublicKey)
```

AddKey binds a list of the provided public keys to the OwnerID\. It can be invoked only by Alphabet nodes\.

This method panics if the OwnerID is not an ownerSize byte or the public key is not 33 byte long\. If the key is already bound\, the method ignores it\.

##### Key

```go
func Key(owner []byte) [][]byte
```

Key method returns a list of 33\-byte public keys bound with the OwnerID\.

This method panics if the owner is not ownerSize byte long\.

##### RemoveKey

```go
func RemoveKey(owner []byte, keys []interop.PublicKey)
```

RemoveKey unbinds the provided public keys from the OwnerID\. It can be invoked only by Alphabet nodes\.

This method panics if the OwnerID is not an ownerSize byte or the public key is not 33 byte long\. If the key is already unbound\, the method ignores it\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. It can be invoked only by committee\.

##### Version

```go
func Version() int
```

Version returns the version of the contract\.


