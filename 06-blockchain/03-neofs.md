### neofs contract

NeoFS contract description\.

#### Contract methods

##### AlphabetAddress

```go
func AlphabetAddress() interop.Hash160
```

AlphabetAddress returns 2\\3n\+1 multi signature address of alphabet nodes\.

##### AlphabetList

```go
func AlphabetList() []common.IRNode
```

AlphabetList returns array of alphabet node keys\.

##### AlphabetUpdate

```go
func AlphabetUpdate(id []byte, args []interop.PublicKey)
```

AlphabetUpdate updates list of alphabet nodes with provided list of public keys\.

##### Bind

```go
func Bind(user []byte, keys []interop.PublicKey)
```

Bind public key with user's account to use it in NeoFS requests\.

##### Cheque

```go
func Cheque(id []byte, user interop.Hash160, amount int, lockAcc []byte)
```

Cheque sends gas assets back to the user if they were successfully locked in NeoFS balance contract\.

##### Config

```go
func Config(key []byte) interface{}
```

Config returns value of NeoFS configuration with provided key\.

##### InitConfig

```go
func InitConfig(args [][]byte)
```

InitConfig set up initial NeoFS key\-value configuration\.

##### InnerRingCandidateAdd

```go
func InnerRingCandidateAdd(key interop.PublicKey)
```

InnerRingCandidateAdd adds key to the list of inner ring candidates\.

##### InnerRingCandidateRemove

```go
func InnerRingCandidateRemove(key interop.PublicKey)
```

InnerRingCandidateRemove removes key from the list of inner ring candidates\.

##### InnerRingCandidates

```go
func InnerRingCandidates() []common.IRNode
```

InnerRingCandidates returns array of inner ring candidate node keys\.

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

Migrate updates smart contract execution script and manifest\.

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data interface{})
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS contract\.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value\.

##### Unbind

```go
func Unbind(user []byte, keys []interop.PublicKey)
```

Unbind public key from user's account

##### Version

```go
func Version() int
```

Version of contract\.

##### Withdraw

```go
func Withdraw(user interop.Hash160, amount int)
```

Withdraw initialize gas asset withdraw from NeoFS balance\.


