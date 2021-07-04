### neofs contract

NeoFS contract is a contract deployed in NeoFS main chain\.

NeoFS contract is an entry point to NeoFS users\. This contract stores all NeoFS related GAS\, registers new Inner Ring candidates and produces notifications to control side chain\.

While main chain committee controls list of Alphabet nodes in native RoleManagement contract\, NeoFS can't change more than 1\\3 keys at a time\. NeoFS contract contains actual list of Alphabet nodes in the side chain\.

Network configuration also stored in NeoFS contract\. All the changes in configuration are mirrored in side chain with notifications\.

#### Contract notifications

Deposit notification\. This notification is produced when user transfers native GAS to the NeoFS contract address\. The same amount of NEOFS token will be minted in Balance contract in the side chain\.

```
Deposit:
  - name: from
    type: Hash160
  - name: amount
    type: Integer
  - name: receiver
    type: Hash160
  - name: txHash
    type: Hash256
```

Withdraw notification\. This notification is produced when user wants to withdraw GAS from internal NeoFS balance and has payed fee for that\.

```
Withdraw:
  - name: user
    type: Hash160
  - name: amount
    type: Integer
  - name: txHash
    type: Hash256
```

Cheque notification\. This notification is produced when NeoFS contract successfully transferred assets back to the user after withdraw\.

```
Cheque:
  - name: id
    type: ByteArray
  - name: user
    type: Hash160
  - name: amount
    type: Integer
  - name: lockAccount
    type: ByteArray
```

Bind notification\. This notification is produced when user wants to bind public keys with user account \(OwnerID\)\. Keys argument is array of ByteArray\.

```
Bind:
  - name: user
    type: ByteArray
  - name: keys
    type: Array
```

Unbind notification\. This notification is produced when user wants to unbind public keys with user account \(OwnerID\)\. Keys argument is an array of ByteArray\.

```
Unbind:
  - name: user
    type: ByteArray
  - name: keys
    type: Array
```

AlphabetUpdate notification\. This notification is produced when Alphabet nodes updated it's list in the contract\. Alphabet argument is an array of ByteArray\. It contains public keys of new alphabet nodes\.

```
AlphabetUpdate:
  - name: id
    type: ByteArray
  - name: alphabet
    type: Array
```

SetConfig notification\. This notification is produced when Alphabet nodes update NeoFS network configuration value\.

```
SetConfig
  - name: id
    type: ByteArray
  - name: key
    type: ByteArray
  - name: value
    type: ByteArray
```

#### Contract methods

##### AlphabetAddress

```go
func AlphabetAddress() interop.Hash160
```

AlphabetAddress returns 2\\3n\+1 multi signature address of alphabet nodes\. Used in side chain notary disabled environment\.

##### AlphabetList

```go
func AlphabetList() []common.IRNode
```

AlphabetList returns array of alphabet node keys\. Use in side chain notary disabled environment\.

##### AlphabetUpdate

```go
func AlphabetUpdate(id []byte, args []interop.PublicKey)
```

AlphabetUpdate updates list of alphabet nodes with provided list of public keys\. Can be invoked only by alphabet nodes\.

This method used in notary disabled side chain environment\. In this case actual alphabet list should be stored in the NeoFS contract\.

##### Bind

```go
func Bind(user []byte, keys []interop.PublicKey)
```

Bind method produces notification to bind specified public keys in NeoFSID contract in side chain\. Can be invoked only by specified user\.

This method produces Bind notification\. Method panics if keys are not 33 byte long\. User argument must be valid 20 byte script hash\.

##### Cheque

```go
func Cheque(id []byte, user interop.Hash160, amount int, lockAcc []byte)
```

Cheque transfers GAS back to the user from contract account\, if assets were successfully locked in NeoFS balance contract\. Can be invoked only by Alphabet nodes\.

This method produces Cheque notification to burn assets in side chain\.

##### Config

```go
func Config(key []byte) interface{}
```

Config returns configuration value of NeoFS configuration\. If key does not exists\, returns nil\.

##### InitConfig

```go
func InitConfig(args [][]byte)
```

InitConfig method sets up initial key\-value configuration pair\. Can be invoked only once\.

Arguments should contain even number of byte arrays\. First byte array is a configuration key and the second is configuration value\.

##### InnerRingCandidateAdd

```go
func InnerRingCandidateAdd(key interop.PublicKey)
```

InnerRingCandidateAdd adds key to the list of Inner Ring candidates\. Can be invoked only by candidate itself\.

This method transfers fee from candidate to contract account\. Fee value specified in NeoFS network config with the key InnerRingCandidateFee\.

##### InnerRingCandidateRemove

```go
func InnerRingCandidateRemove(key interop.PublicKey)
```

InnerRingCandidateRemove removes key from the list of Inner Ring candidates\. Can be invoked by Alphabet nodes or candidate itself\.

Method does not return fee back to the candidate\.

##### InnerRingCandidates

```go
func InnerRingCandidates() []common.IRNode
```

InnerRingCandidates returns array of structures that contain Inner Ring candidate node key\.

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

Migrate method updates contract source code and manifest\. Can be invoked only by contract owner\.

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data interface{})
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS contract\. It takes no more than 9000\.0 GAS\. Native GAS has precision 8 and NeoFS balance contract has precision 12\. Values bigger than 9000\.0 can break JSON limits for integers when precision is converted\.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value\. Can be invoked only by Alphabet nodes\.

##### Unbind

```go
func Unbind(user []byte, keys []interop.PublicKey)
```

Unbind method produces notification to unbind specified public keys in NeoFSID contract in side chain\. Can be invoked only by specified user\.

This method produces Unbind notification\. Method panics if keys are not 33 byte long\. User argument must be valid 20 byte script hash\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.

##### Withdraw

```go
func Withdraw(user interop.Hash160, amount int)
```

Withdraw initialize gas asset withdraw from NeoFS\. Can be invoked only by the specified user\.

This method produces Withdraw notification to lock assets in side chain and transfers withdraw fee from user account to each Alphabet node\. If notary is enabled in main chain\, fee is transferred to Processing contract\. Fee value specified in NeoFS network config with the key WithdrawFee\.


