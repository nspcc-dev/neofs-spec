## neo.fs.v2.accounting



### Service "AccountingService"

Accounting service provides methods for interaction with NeoFS sidechain via
other NeoFS nodes to get information about the account balance. Deposit and
Withdraw operations can't be implemented here, as they require Mainnet NeoFS
smart contract invocation. Transfer operations between internal NeoFS
accounts are possible, if both use the same token type.


### Method Balance

Returns the amount of funds in GAS token for the requested NeoFS account.

Statuses:
- **OK** (0, SECTION_SUCCESS):
balance has been successfully read;
- Common failures (SECTION_FAILURE_COMMON).

 

__Request Body:__ BalanceRequest.Body

To indicate the account for which the balance is requested, it's identifier
is used. It can be any existing account in NeoFS sidechain `Balance` smart
contract. If omitted, client implementation MUST set it to the request's
signer `OwnerID`.

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Valid user identifier in `OwnerID` format for which the balance is requested. Required field. |
         

__Response Body__ BalanceResponse.Body

The amount of funds in GAS token for the `OwnerID`'s account requested.
Balance is `Decimal` format to avoid precision issues with rounding.

| Field | Type | Description |
| ----- | ---- | ----------- |
| balance | Decimal | Amount of funds in GAS token for the requested account. |
          
### Message Decimal

Standard floating point data type can't be used in NeoFS due to inexactness
of the result when doing lots of small number operations. To solve the lost
precision issue, special `Decimal` format is used for monetary computations.

Please see [The General Decimal Arithmetic
Specification](http://speleotrove.com/decimal/) for detailed problem
description.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | int64 | Number in smallest Token fractions. |
| precision | uint32 | Precision value indicating how many smallest fractions can be in one integer. |
     
