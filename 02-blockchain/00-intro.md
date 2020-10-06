\newpage

# Blockchain components

## NeoFS Governance

NeoFS uses the sidechain as a database to store meta-information about the 
network: network map, audit results, containers. The sidechain works on the 
same principle as the main net: there are no free transactions, and the 
committee chooses the consensus nodes, etc. To operate with the sidechain we 
need to solve the following issues:

  - how the main net committee can control inner ring nodes and the 
consensus nodes of the sidechain,
  - how storage nodes and inner ring nodes get sidechain utility token to send 
transactions?

NeoFS Governance intended to answer these questions with seven alphabetical 
sidechain contracts.

### Alphabetical contracts

#### Description

Alphabetic contracts are seven contracts deployed in the side-chain, named 
after the names of [Glagolitic](https://en.wikipedia.org/wiki/Glagolitic_script) 
script: Az, Buky, Vedi, Glagoli, Dobro, Jest, Zhivete. These 
contracts contain 10,000,000 NEO in their accounts (approximately 14,285,000 
for each). By storing NEO on the contract accounts, we protect it from unauthorized 
use by malicious sidechain nodes. Contracts do not transfer NEO and use it to vote 
for sidechain validators and to emit utility token.

#### Invocation

Contracts cannot distribute utility token or vote by themselves. To do these 
operations, inner ring nodes invoke alphabetical contract methods. First seven 
inner ring nodes from the inner ring list can invoke corresponding alphabetical 
contracts. One node invokes one contract. 

``` InnerRing1 --> Az
InnerRing2 --> Buky
InnerRing3 --> Vedi
InnerRing4 --> Glagoli
InnerRing5 --> Dobro
InnerRing6 --> Jest
InnerRing7 --> Zhivete
InnerRing8
InnerRing9
...
```

Alphabetic contracts have hardcoded indexes. Contracts authenticate method 
invoker by using the list of inner ring node keys from netmap contract.

``` @startuml

participant "InnerRing1" as ir1
participant "InnerRing2" as ir2
participant "Az\ncontract" as az
participant "Netmap\ncontract" as nm


alt successful case
  ir1 -> az: Emit()
  az -> nm: InnerRingList()
  nm -> az: [ ]PublicKeys
  note left
    valid invoker
  end note
  az -> az: emit gas
else panic case
  ir2 -> az: Emit()
  az -> nm: InnerRingList()
  nm -> az: [ ]PublicKeys
  note left
    invalid invoker
  end note
  az -x az: panic
end
@enduml
```

### Utility token distribution

Inner ring nodes invoke Emit() method in corresponding alphabetical contracts. 
This method transfers all it's neo to its account, thereby producing utility 
token emission. Within the same invocation context, the contract transfers a 
share of the available gas to all inner ring wallets. 

```
InnerRingNodeEmission = G * 7/8 * 1/N 
G - contract's utility token amount 
N - lentgh of inner ring list
```

After receiving utility token, the nodes of the inner ring can periodically 
transfer a share to all storage nodes and use the received utility token for 
sidechain operations: change epochs, register new containers, save audit 
results, etc.


### Changing sidechain validators

Beforehand inner ring nodes register new validator keys in the list of candidates 
for the sidechain committee. Then inner ring nodes invoke Vote([]keys) method on 
corresponding alphabetical contracts. Contract votes for the keys proposed in 
passed arguments by sending `VotesPerKey` votes for each key.

```
VotesPerKey = A / N
A - contract's NEO amount
N - length of proposed keys list
```

### Inner ring list control from main net committee

By using Emit() and Vote() methods, inner ring nodes take full control of the 
sidechain. They control validator keys and utility token distribution. Thus, if 
the main net committee will control list of inner ring nodes, then it will 
control sidechain as well. 

The standard scheme for updating inner inner ring is to add keys to the 
candidate list with some deposit, and then inner ring nodes confirm list update.

```
@startuml

participant "NeoFS\ncontract" as nfscon
participant "InnerRing1" as ir0
participant "InnerRing2" as ir1
participant "InnerRing3" as ir2
participant "InnerRing4\n(out)" as ir3
participant "InnerRing5\n(new)" as ir4

ir4 -> nfscon: InnerRingAddCandidate

ir0 -> nfscon: UpdateInnerRing( {1, 2, 3, 5} )
ir1 -> nfscon: UpdateInnerRing( {1, 2, 3, 5} )
ir2 -> nfscon: UpdateInnerRing( {1, 2, 3, 5} )
ir3 -> nfscon: UpdateInnerRing( {1, 2, 3, 5} )


nfscon --> ir0: Notify
nfscon --> ir1: Notify
nfscon --> ir2: Notify
nfscon --> ir3: Notify
nfscon --> ir4: Notify
@enduml
```

The committee should be able to change the list without accumulating signatures 
of inner ring nodes. However, the new list must still hold  "at least 2 \ 3 + 1 
former nodes" property.

```
@startuml

participant "NeoFS\ncontract" as nfscon
participant "InnerRing1" as ir0
participant "InnerRing2" as ir1
participant "InnerRing3" as ir2
participant "InnerRing4\n(out)" as ir3
participant "InnerRing5\n(new)" as ir4
participant "Committee" as cmt

alt failed update

cmt -> nfscon: UpdateInnerRing( {1, 5, 6, 7} )
nfscon -x nfscon: panic
note right
at least 2\3+1
nodes must be the same
end note

else success update

cmt -> nfscon: UpdateInnerRing( {1, 2, 3, 5} )
nfscon --> ir0: Notify
nfscon --> ir1: Notify
nfscon --> ir2: Notify
nfscon --> ir3: Notify
nfscon --> ir4: Notify
end

@enduml
```

`UpdateInnerRing()` method checks if the sender is a committee and does not 
accumulate the signatures of the inner ring nodes.