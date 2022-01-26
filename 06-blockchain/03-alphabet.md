### alphabet contract

Alphabet contract is a contract deployed in NeoFS side chain\.

Alphabet contract is designed to support GAS producing and voting for new validators in the side chain\. NEO token is required to produce GAS and vote for a new committee\. If can be distributed among alphabet nodes of Inner Ring\. However\, some of them may be malicious and some NEO can be lost\. It will lead to side chain economic destabilization\. To avoid it\, all 100 000 000 NEO are distributed among all alphabet contracts\.

To identify alphabet contracts\, they are named with letters of the Glagolitic\. Names are set at contract deploy\. Alphabet nodes of Inner Ring communicate with one of the alphabetical contracts to emit GAS\. To vote for a new list of side chain committee\, alphabet nodes of Inner Ring create multisignature transactions for each alphabet contract\.

#### Contract notifications

Alphabet contract does not produce notifications to process\.

#### Contract methods

##### Emit

```go
func Emit()
```

Emit method produces side chain GAS and distributes it among Inner Ring nodes and proxy contract\. Can be invoked only by Alphabet node of the Inner Ring\.

To produce GAS\, alphabet contract transfers all available NEO from contract account to itself\. If notary enabled\, then 50% of the GAS in the contract account transferred to proxy contract\. 43\.75% of the GAS are equally distributed among all Inner Ring nodes\. Remaining 6\.25% of the GAS stays in the contract\.

If notary disabled\, then 87\.5% of the GAS are equally distributed among all Inner Ring nodes\. Remaining 12\.5% of the GAS stays in the contract\.

##### Gas

```go
func Gas() int
```

GAS returns amount of side chain GAS stored in contract account\.

##### Name

```go
func Name() string
```

Name returns Glagolitic name of the contract\.

##### Neo

```go
func Neo() int
```

NEO returns amount of side chain NEO stored in contract account\.

##### OnNEP17Payment

```go
func OnNEP17Payment(from interop.Hash160, amount int, data interface{})
```

OnNEP17Payment is a callback for NEP\-17 compatible native GAS and NEO contracts\.

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

##### Vote

```go
func Vote(epoch int, candidates []interop.PublicKey)
```

Vote method votes for side chain committee\. Requires multisignature from Alphabet nodes of the Inner Ring\.

This method is used when governance changes list of Alphabet nodes of the Inner Ring\. Alphabet nodes share keys with side chain validators\, therefore it is required to change them as well\. To do that NEO holders\, which are alphabet contracts\, should vote for new committee\.


