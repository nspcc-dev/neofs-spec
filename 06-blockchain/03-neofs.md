### neofs contract



Package neofs contains NeoFS contract which is deployed to main chain.

NeoFS contract is an entry point to NeoFS users. This contract stores all NeoFS related GAS, registers new Inner Ring candidates and produces notifications to control FS chain.

While main chain committee controls the list of Alphabet nodes in native RoleManagement contract, NeoFS can't change more than 1\\3 keys at a time. NeoFS contract contains the actual list of Alphabet nodes in FS chain.

Network configuration is also stored in NeoFS contract. All changes in configuration are mirrored in FS chain with notifications.

#### Contract notifications

Deposit notification. This notification is produced when user transfers native GAS to the NeoFS contract address. The same amount of NEOFS token will be minted in Balance contract in FS chain.

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

Withdraw notification. This notification is produced when a user wants to withdraw GAS from the internal NeoFS balance and has paid fee for that.

```
Withdraw:
  - name: user
    type: Hash160
  - name: amount
    type: Integer
  - name: txHash
    type: Hash256
```

Cheque notification. This notification is produced when NeoFS contract has successfully transferred assets back to the user after withdraw.

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

AlphabetUpdate notification. This notification is produced when Alphabet nodes have updated their lists in the contract. Alphabet argument is an array of ByteArray. It contains public keys of new alphabet nodes.

```
AlphabetUpdate:
  - name: id
    type: ByteArray
  - name: alphabet
    type: Array
```

SetConfig notification. This notification is produced when Alphabet nodes update NeoFS network configuration value.

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

AlphabetAddress returns 2\\3n\+1 multisignature address of alphabet nodes. It is used in notary\-disabled FS chain environment.

##### AlphabetList

```go
func AlphabetList() []common.IRNode
```

AlphabetList returns an array of alphabet node keys. It is used in notary\-disabled FS chain environment.

##### AlphabetUpdate

```go
func AlphabetUpdate(id []byte, args []interop.PublicKey)
```

AlphabetUpdate updates a list of alphabet nodes with the provided list of public keys. It can be invoked only by alphabet nodes.

This method is used in notary\-disabled FS chain environment. In this case, the actual alphabet list should be stored in the NeoFS contract.

##### Cheque

```go
func Cheque(id []byte, user interop.Hash160, amount int, lockAcc []byte)
```

Cheque transfers GAS back to the user from the contract account, if assets were successfully locked in NeoFS balance contract. It can be invoked only by Alphabet nodes.

This method produces Cheque notification to burn assets in FS chain.

##### Config

```go
func Config(key []byte) any
```

Config returns configuration value of NeoFS configuration. If the key does not exist, returns nil.

##### InnerRingCandidateAdd

```go
func InnerRingCandidateAdd(key interop.PublicKey)
```

InnerRingCandidateAdd adds a key to a list of Inner Ring candidates. It can be invoked only by the candidate itself.

This method transfers fee from a candidate to the contract account. Fee value is specified in NeoFS network config with the key InnerRingCandidateFee.

##### InnerRingCandidateRemove

```go
func InnerRingCandidateRemove(key interop.PublicKey)
```

InnerRingCandidateRemove removes a key from a list of Inner Ring candidates. It can be invoked by Alphabet nodes or the candidate itself.

This method does not return fee back to the candidate.

##### InnerRingCandidates

```go
func InnerRingCandidates() []common.IRNode
```

InnerRingCandidates returns an array of structures that contain an Inner Ring candidate node key.

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data any)
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS contract. It takes no more than 9000.0 GAS. Native GAS has precision 8, and NeoFS balance contract has precision 12. Values bigger than 9000.0 can break JSON limits for integers when precision is converted.

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

SetConfig key\-value pair as a NeoFS runtime configuration value. It can be invoked only by Alphabet nodes.

##### Update

```go
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by the FS chain committee.

##### Version

```go
func Version() int
```

Version returns version of the contract.

##### Withdraw

```go
func Withdraw(user interop.Hash160, amount int)
```

Withdraw initializes gas asset withdraw from NeoFS. It can be invoked only by the specified user.

This method produces Withdraw notification to lock assets in FS chain and transfers withdraw fee from a user account to each Alphabet node. If notary is enabled in main chain, fee is transferred to Processing contract. Fee value is specified in NeoFS network config with the key WithdrawFee.

