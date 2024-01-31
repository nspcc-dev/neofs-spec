### balance contract



Package balance contains implementation of Balance contract deployed in NeoFS sidechain.

Balance contract stores all NeoFS account balances. It is a NEP\-17 compatible contract, so it can be tracked and controlled by N3 compatible network monitors and wallet software.

This contract is used to store all micro transactions in the sidechain, such as data audit settlements or container fee payments. It is inefficient to make such small payment transactions in the mainchain. To process small transfers, balance contract has higher \(12\) decimal precision than native GAS contract.

NeoFS balances are synchronized with mainchain operations. Deposit produces minting of NEOFS tokens in Balance contract. Withdraw locks some NEOFS tokens in a special lock account. When NeoFS contract transfers GAS assets back to the user, the lock account is destroyed with burn operation.

#### Contract notifications

Transfer notification. This is a NEP\-17 standard notification.

```
Transfer:
  - name: from
    type: Hash160
  - name: to
    type: Hash160
  - name: amount
    type: Integer
```

TransferX notification. This is an enhanced transfer notification with details.

```
TransferX:
  - name: from
    type: Hash160
  - name: to
    type: Hash160
  - name: amount
    type: Integer
  - name: details
    type: ByteArray
```

Lock notification. This notification is produced when a lock account is created. It contains information about the mainchain transaction that has produced the asset lock, the address of the lock account and the NeoFS epoch number until which the lock account is valid. Alphabet nodes of the Inner Ring catch notification and initialize Cheque method invocation of NeoFS contract.

```
Lock:
  - name: txID
    type: ByteArray
  - name: from
    type: Hash160
  - name: to
    type: Hash160
  - name: amount
    type: Integer
  - name: until
    type: Integer
```

#### Contract methods

##### BalanceOf

```go
func BalanceOf(account interop.Hash160) int
```

BalanceOf is a NEP\-17 standard method that returns NeoFS balance of the specified account.

##### Burn

```go
func Burn(from interop.Hash160, amount int, txDetails []byte)
```

Burn is a method that transfers assets from a user account to an empty account. It can be invoked only by Alphabet nodes of the Inner Ring.

It produces Transfer and TransferX notifications.

Burn method is invoked by Alphabet nodes of the Inner Ring when they process Cheque notification from NeoFS contract. It means that locked assets have been transferred to the user in the mainchain, therefore the lock account should be destroyed. Before that, Alphabet nodes should synchronize precision of mainchain GAS contract and Balance contract. Burn decreases total supply of NEP\-17 compatible NeoFS token.

##### Decimals

```go
func Decimals() int
```

Decimals is a NEP\-17 standard method that returns precision of NeoFS balances.

##### Lock

```go
func Lock(txDetails []byte, from, to interop.Hash160, amount, until int)
```

Lock is a method that transfers assets from a user account to the lock account related to the user. It can be invoked only by Alphabet nodes of the Inner Ring.

It produces Lock, Transfer and TransferX notifications.

Lock method is invoked by Alphabet nodes of the Inner Ring when they process Withdraw notification from NeoFS contract. This should transfer assets to a new lock account that won't be used for anything beside Unlock and Burn.

##### Mint

```go
func Mint(to interop.Hash160, amount int, txDetails []byte)
```

Mint is a method that transfers assets to a user account from an empty account. It can be invoked only by Alphabet nodes of the Inner Ring.

It produces Transfer and TransferX notifications.

Mint method is invoked by Alphabet nodes of the Inner Ring when they process Deposit notification from NeoFS contract. Before that, Alphabet nodes should synchronize precision of mainchain GAS contract and Balance contract. Mint increases total supply of NEP\-17 compatible NeoFS token.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch is a method that checks timeout on lock accounts and returns assets if lock is not available anymore. It can be invoked only by NewEpoch method of Netmap contract.

It produces Transfer and TransferX notifications.

##### Symbol

```go
func Symbol() string
```

Symbol is a NEP\-17 standard method that returns NEOFS token symbol.

##### TotalSupply

```go
func TotalSupply() int
```

TotalSupply is a NEP\-17 standard method that returns total amount of main chain GAS in NeoFS network.

##### Transfer

```go
func Transfer(from, to interop.Hash160, amount int, data any) bool
```

Transfer is a NEP\-17 standard method that transfers NeoFS balance from one account to another. It can be invoked only by the account owner.

It produces Transfer and TransferX notifications. TransferX notification will have empty details field.

##### TransferX

```go
func TransferX(from, to interop.Hash160, amount int, details []byte)
```

TransferX is a method for NeoFS balance to be transferred from one account to another. It can be invoked by the account owner or by Alphabet nodes.

It produces Transfer and TransferX notifications.

TransferX method expands Transfer method by having extra details argument. TransferX method also allows to transfer assets by Alphabet nodes of the Inner Ring with multisignature.

##### Update

```go
func Update(script []byte, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by committee.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

