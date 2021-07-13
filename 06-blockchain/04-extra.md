## Balance transfer details encoding

Alphabet nodes of the Inner Ring use `balance.TransferX` method to manage
balances of the NeoFS users at deposit (mint), withdraw (burn), audit
settlements, etc. `TransferX` method has `details` argument and `transferX`
notification contains `details` field. This field contains bytes that encode
reason of data transfer. First byte of the `details` field defines transfer
type and all other bytes provide extra details.

| First Byte | Description | Extra data |
| --- | ------- | ----------- |
|0x01|**Mint**: deposit processed by NeoFS contract.|32-byte hash of main chain transaction which invoked `neofs.Deposit` method.|
|0x02|**Burn**: cheque processed by NeoFS contract.|32-byte hash of main chain transaction which invoked `neofs.Cheque` method.|
|0x03|**Lock**: withdraw processed by NeoFS contract.|32-byte hash of main chain transaction which invoked `neofs.Withdraw` method.|
|0x04|**Unlock**: withdraw processed by NeoFS contract but cheque didn't process before timeout, so balance returned to the account.|Up to 8 bytes of epoch number when asset lock was removed.|
|0x10|**ContainerFee**: put processed by Container contract.|32-byte Container ID|
|0x40|**AuditSettlement**: payment to Inner Ring node for processed audit.|8 bytes of epoch (LittleEndian) number when settlement happened.|
|0x41|**BasicIncomeCollection**: transfer assets from data owner accounts to the banking account.|8 bytes of epoch (LittleEndian) number when settlement happened.|
|0x42|**BasicIncomeDistribution**: transfer assets from banking account to storage node owner accounts.|8 bytes of epoch (LittleEndian) number when settlement happened.|
