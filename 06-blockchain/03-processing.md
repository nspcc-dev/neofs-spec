### processing contract



Package processing contains Processing contract which is deployed to main chain.

Processing contract pays for all multisignature transaction executions when notary service is enabled in the main chain. Notary service prepares multisigned transactions, however their senders should have GAS to succeed. It is inconvenient to ask Alphabet nodes to pay for these transactions: nodes can change over time, some nodes will spend GAS faster. It leads to economic instability.

Processing contract exists to solve this issue. At the Withdraw invocation of NeoFS contract, a user pays fee directly to this contract. This fee is used to pay for Cheque invocation of NeoFS contract that returns main chain GAS back to the user. The address of the Processing contract is used as the first signer in the multisignature transaction. Therefore, NeoVM executes Verify method of the contract and if invocation is verified, Processing contract pays for the execution.

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
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by the FS chain committee.

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

