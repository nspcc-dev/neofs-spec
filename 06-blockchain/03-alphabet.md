### alphabet contract



Package alphabet contains implementation of Alphabet contract deployed in NeoFS sidechain.

Alphabet contract is designed to support GAS production and vote for new validators in the sidechain. NEO token is required to produce GAS and vote for a new committee. It can be distributed among alphabet nodes of the Inner Ring. However, some of them may be malicious, and some NEO can be lost. It will destabilize the economic of the sidechain. To avoid it, all 100,000,000 NEO are distributed among all alphabet contracts.

To identify alphabet contracts, they are named with letters of the Glagolitic alphabet. Names are set at contract deploy. Alphabet nodes of the Inner Ring communicate with one of the alphabetical contracts to emit GAS. To vote for a new list of side chain committee, alphabet nodes of the Inner Ring create multisignature transactions for each alphabet contract.

#### Contract notifications

Alphabet contract does not produce notifications to process.

#### Contract methods

##### Emit

```go
func Emit()
```

Emit method produces sidechain GAS and distributes it among Inner Ring nodes and proxy contract. It can be invoked only by an Alphabet node of the Inner Ring.

To produce GAS, an alphabet contract transfers all available NEO from the contract account to itself. 50% of the GAS in the contract account are transferred to proxy contract. 43.75% of the GAS are equally distributed among all Inner Ring nodes. Remaining 6.25% of the GAS stay in the contract.

##### Gas

```go
func Gas() int
```

Gas returns the amount of the sidechain GAS stored in the contract account.

##### Name

```go
func Name() string
```

Name returns the Glagolitic name of the contract.

##### Neo

```go
func Neo() int
```

Neo returns the amount of sidechain NEO stored in the contract account.

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data any)
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS and NEO contracts.

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

##### Vote

```go
func Vote(epoch int, candidates []interop.PublicKey)
```

Vote method votes for the sidechain committee. It requires multisignature from Alphabet nodes of the Inner Ring.

This method is used when governance changes the list of Alphabet nodes of the Inner Ring. Alphabet nodes share keys with sidechain validators, therefore it is required to change them as well. To do that, NEO holders \(which are alphabet contracts\) should vote for a new committee.

