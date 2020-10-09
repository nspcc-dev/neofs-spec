## neo.fs.v2.accounting



### Service "AccountingService"

The service provides methods for obtaining information
about the account balance in NeoFS system.


### Method Balance

Returns the amount of funds for the requested NeoFS account.

 

__Request Body:__ BalanceRequest.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| owner_id | OwnerID | Carries user identifier in NeoFS system for which the balance is requested. |
         

__Response Body__ BalanceResponse.Body

Request body

| Field | Type | Description |
| ----- | ---- | ----------- |
| balance | Decimal | Carries the amount of funds on the account. |
          
### Message Decimal

Decimal represents the decimal numbers.

| Field | Type | Description |
| ----- | ---- | ----------- |
| value | int64 | value carries number value. |
| precision | uint32 | precision carries value precision. |
     
