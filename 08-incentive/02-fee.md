## Service fees

### Container creation fee

To create a container, data owner should pay fee. It is calculated as $7 \cdot fee$, where $fee$ is a value from NeoFS network configuration (`ContainerFee`). Each Alphabet node gets $fee$ GAS during this operation.

### Audit result fee

Each generated audit result must be paid for by the container owner. Data owner pays $fee$ set in NeoFS network configuration (`AuditFee`) per one audited container. 

### Inner Ring candidate fee

To become a part of the Inner Ring list, an Inner Ring candidate must register its key in NeoFS contract. This operation transfers to NeoFS contract $fee$ value that is set in NeoFS network configuration (`InnerRingCandidateFee`).

### Withdraw fee

To withdraw assets, Alphabet nodes need main chain GAS to invoke Cheque method of NeoFS contract that transfers assets back to the user. This GAS is paid by the user at Withdraw invocation. In notary enabled environment, the user pays $fee$ value set in NeoFS network configuration (`WithdrawFee`). In notary disabled environment, the user pays $7 \cdot fee$.
