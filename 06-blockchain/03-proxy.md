### proxy contract



Package proxy implements Proxy contract which is deployed to FS chain.

Proxy contract pays for all multisignature transaction executions when notary service is enabled in FS chain. Notary service prepares multisigned transactions, however their senders should have FS chain GAS to succeed. It is inconvenient to ask Alphabet nodes to pay for these transactions: nodes can change over time, some nodes will spend FS chain GAS faster. It leads to economic instability.

Proxy contract exists to solve this issue. While Alphabet contracts hold all FS chain NEO, proxy contract holds most of FS chain GAS. Alphabet contracts emit half of the available GAS to the proxy contract. The address of the Proxy contract is used as the first signer in a multisignature transaction. Therefore, NeoVM executes Verify method of the contract; and if invocation is verified, Proxy contract pays for the execution.

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
func Update(nefFile, manifest []byte, data any)
```

Update method updates contract source code and manifest. It can be invoked only by committee.

##### Verify

```go
func Verify() bool
```

Verify checks whether carrier transaction contains either \(2/3N \+ 1\) or \(N/2 \+ 1\) valid multi\-signature of the NeoFS Alphabet. Container contract's \`SubmitObjectPut\` is an exception, Alphabet signature is not required, contract's \`VerifyPlacementSignatures\` is called instead.

##### Version

```go
func Version() int
```

Version returns the version of the contract.

