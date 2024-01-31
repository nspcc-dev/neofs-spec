### proxy contract



Package proxy contains implementation of Proxy contract deployed in NeoFS sidechain.

Proxy contract pays for all multisignature transaction executions when notary service is enabled in the sidechain. Notary service prepares multisigned transactions, however they should contain sidechain GAS to be executed. It is inconvenient to ask Alphabet nodes to pay for these transactions: nodes can change over time, some nodes will spend sidechain GAS faster. It leads to economic instability.

Proxy contract exists to solve this issue. While Alphabet contracts hold all sidechain NEO, proxy contract holds most of the sidechain GAS. Alphabet contracts emit half of the available GAS to the proxy contract. The address of the Proxy contract is used as the first signer in a multisignature transaction. Therefore, NeoVM executes Verify method of the contract; and if invocation is verified, Proxy contract pays for the execution.

#### Contract notifications

Proxy contract does not produce notifications to process.

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

Update method updates contract source code and manifest. It can be invoked only by committee.

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

