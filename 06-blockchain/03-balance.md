### balance contract

Balance contract is a contract deployed in NeoFS side chain\.

Balance contract stores all NeoFS account balances\. It is NEP\-17 compatible contract so in can be tracked and controlled by N3 compatible network monitors and wallet software\.

This contract is used to store all micro transactions in the sidechain\, such as data audit settlements or container fee payments\. It is inefficient to make such small payment transactions in main chain\. To process small transfers\, balance contract has higher \(12\) decimal precision than native GAS contract\.

NeoFS balances are synchronized with main chain operations\. Deposit produce minting of NEOFS tokens in Balance contract\. Withdraw locks some NEOFS tokens in special lock account\. When NeoFS contract transfers GAS assets back to the user\, lock account is destroyed with burn operation\.

#### Contract notifications

Transfer notification\. This is NEP\-17 standard notification\.

```
Transfer:
  - name: from
    type: Hash160
  - name: to
    type: Hash160
  - name: amount
    type: Integer
```

TransferX notification\. This is enhanced transfer notification with details\.

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

Lock notification\. This notification is produced when Lock account has been created\. It contains information about main chain transaction that produced asset lock\, address of lock account and NeoFS epoch number until lock account is valid\. Alphabet nodes of the Inner Ring catch notification and initialize Cheque method invocation of the NeoFS contract\.

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

Mint notification\. This notification is produced when user balance is replenished from deposit in the main chain\.

```
Mint:
 - name: to
   type: Hash160
 - name: amount
   type: Integer
```

Burn notification\. This notification is produced after user balance is reduced when NeoFS contract transferred GAS assets back to the user\.

```
Burn:
  - name: from
    type: Hash160
  - name: amount
    type: Integer
```

#### Contract methods

##### BalanceOf

```go
func BalanceOf(account interop.Hash160) int
```

BalanceOf is a NEP\-17 standard method that returns NeoFS balance of specified account\.

##### Burn

```go
func Burn(from interop.Hash160, amount int, txDetails []byte)
```

Burn is a method that transfers assets from user account to empty account\. Can be invoked only by Alphabet nodes of the Inner Ring\.

Produces Burn\, Transfer and TransferX notifications\.

Burn method invoked by Alphabet nodes of the Inner Ring when they process Cheque notification from NeoFS contract\. It means that locked assets were transferred to user in main chain\, therefore lock account should be destroyed\. Before that Alphabet nodes should synchronize precision of main chain GAS contract and Balance contract\. Burn decreases total supply of NEP\-17 compatible NeoFS token\.

##### Decimals

```go
func Decimals() int
```

Decimals is a NEP\-17 standard method that returns precision of NeoFS balances\.

##### Lock

```go
func Lock(txDetails []byte, from, to interop.Hash160, amount, until int)
```

Lock is a method that transfers assets from user account to lock account related to the user\. Can be invoked only by Alphabet nodes of the Inner Ring\.

Produces Lock\, Transfer and TransferX notifications\.

Lock method invoked by Alphabet nodes of the Inner Ring when they process Withdraw notification from NeoFS contract\. This should transfer assets to new lock account that won't be used for anything besides Unlock and Burn\.

##### Mint

```go
func Mint(to interop.Hash160, amount int, txDetails []byte)
```

Mint is a method that transfers assets to user account from empty account\. Can be invoked only by Alphabet nodes of the Inner Ring\.

Produces Mint\, Transfer and TransferX notifications\.

Mint method invoked by Alphabet nodes of the Inner Ring when they process Deposit notification from NeoFS contract\. Before that Alphabet nodes should synchronize precision of main chain GAS contract and Balance contract\. Mint increases total supply of NEP\-17 compatible NeoFS token\.

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

NewEpoch is a method that checks timeout on lock accounts and return assets if lock is not available anymore\. Can be invoked only by NewEpoch method of Netmap contract\.

Produces Transfer and TransferX notifications\.

##### Symbol

```go
func Symbol() string
```

Symbol is a NEP\-17 standard method that returns NEOFS token symbol\.

##### TotalSupply

```go
func TotalSupply() int
```

TotalSupply is a NEP\-17 standard method that returns total amount of main chain GAS in the NeoFS network\.

##### Transfer

```go
func Transfer(from, to interop.Hash160, amount int, data interface{}) bool
```

Transfer is a NEP\-17 standard method that transfers NeoFS balance from one account to other\. Can be invoked only by account owner\.

Produces Transfer and TransferX notifications\. TransferX notification will have empty details field\.

##### TransferX

```go
func TransferX(from, to interop.Hash160, amount int, details []byte)
```

TransferX is a method for NeoFS balance transfers from one account to another\. Can be invoked by account owner or by Alphabet nodes\.

Produces Transfer and TransferX notifications\.

TransferX method expands Transfer method by having extra details argument\. Also TransferX method allows to transfer assets by Alphabet nodes of the Inner Ring with multi signature\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. Can be invoked only by committee\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


