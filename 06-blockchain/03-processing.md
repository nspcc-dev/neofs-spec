### processing contract

Processing contract is a contract deployed in NeoFS main chain\.

Processing contract pays for all multi signature transaction executions when notary service enabled in main chain\. Notary service prepares multi signed transaction\, however they should contain side chain GAS to be executed\. It is inconvenient to ask Alphabet nodes to pay for these transactions: nodes can change over time\, some nodes will spend side chain GAS faster\, it creates economic instability\.

Processing contract exists to solve this issue\. At the Withdraw invocation of NeoFS contract\, user pays fee directly to this contract\. This fee is used to pay for Cheque invocation of NeoFS contract that returns main chain GAS back to the user\. Address of the Processing contract is uses as the first signer in the multi signature transaction\. Therefore NeoVM executes Verify method of the contract and if invocation is verified\, then Processing contract pays for the execution\.

#### Contract notifications

Processing contract does not produce notifications to process\.

#### Contract methods

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data interface{})
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS contract\.

##### Update

```go
func Update(script []byte, manifest []byte, data interface{})
```

Update method updates contract source code and manifest\. Can be invoked only by side chain committee\.

##### Verify

```go
func Verify() bool
```

Verify method returns true if transaction contains valid multi signature of Alphabet nodes of the Inner Ring\.

##### Version

```go
func Version() int
```

Version returns version of the contract\.


