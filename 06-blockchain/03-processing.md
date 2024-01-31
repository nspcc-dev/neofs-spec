### processing contract



Package processing contains implementation of Processing contract deployed in NeoFS mainchain.

Processing contract pays for all multisignature transaction executions when notary service is enabled in the mainchain. Notary service prepares multisigned transactions, however they should contain sidechain GAS to be executed. It is inconvenient to ask Alphabet nodes to pay for these transactions: nodes can change over time, some nodes will spend sidechain GAS faster. It leads to economic instability.

Processing contract exists to solve this issue. At the Withdraw invocation of NeoFS contract, a user pays fee directly to this contract. This fee is used to pay for Cheque invocation of NeoFS contract that returns mainchain GAS back to the user. The address of the Processing contract is used as the first signer in the multisignature transaction. Therefore, NeoVM executes Verify method of the contract and if invocation is verified, Processing contract pays for the execution.

#### Contract notifications

Processing contract does not produce notifications to process.

#### Contract methods

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data any)
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS contract.

##### Update

```go
func Update(script []byte, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by the sidechain committee.

##### Verify

```go
func Verify() bool
```

Verify method returns true if transaction contains valid multisignature of Alphabet nodes of the Inner Ring.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

