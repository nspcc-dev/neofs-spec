## Data Audit Game

### Overview

Each epoch, Inner Ring nodes perform a data audit. It is a two-stage game in terms of game theory. At the first stage, nodes in the selected container are asked to collectively reconstruct a list of homomorphic hashes that form a composite hash stored in Storage Group. By doing that, nodes demonstrate that they have all objects and are able to provide a hash of those objects. The provided list of hashes can be validated, but at the current stage, it is unknown, if some nodes are lying.

At the second stage, it is necessary to make sure that nodes are honest and do not fake check results. The Inner Ring nodes calculate a set of nodes’ pairs that store the same object and ask each node to provide thee homomorphic hashes of that object. Ranges are chosen in a way that the hash of a range asked from one node is the composite hash of ranges asked from another node in that pair. Nodes cannot predict objects or ranges that are chosen for audit. They cannot even predict a pair node for the game. This stage discovers malicious nodes fast because each node is serving multiple containers and Storage Groups and participates in many data audit sessions. When a node is caught in a lie it will not get any rewards for this epoch. So the price of faking checks and risks are too high and it is easier and cheaper for the node to be honest and behave correctly.

Combining the fact of nodes being able to reconstruct the Storage Group's composite hash and the fact of nodes honest behavior, the system can consider that the data is safely stored, not corrupted, and available with a high probability.

In the case of a successful data audit result, the Inner Ring nodes initiate microtransactions between the accounts of the data owner and the owner of the storage node invoking the smart contract in the NeoFS Neo sidechain.

![Data Audit](pic/1.png)

### Separation of tasks

InnerRing nodes select containers to audit from a list of all containers in the network, forming a ring of containers, and taking an offset shackle with its number among InnerRing nodes and by audit number.

At each epoch, inner ring node makes data audit. One audit task is a one storage group to check. Storage groups from one container merged into a single audit result structure that will be saved in audit contract.

On each new epoch notification inner ring node must:

 - check amount of unfinished audit tasks from queue, log it and flush it (1),
 - publish all unfinished audit results asynchronously (2),
 - choose new tasks to process (3),
 - run these task in a separate fixed size routine pool (4),
 - merge task results in audit result structures and publish them if there are no tasks left in container (5),
 - optionally dump task results to file (6).

(1) Later we can use this values to initiate inner ring list growth.

(2) Audit results should be published on step 5 when all tasks for a single container are done. If new epoch happens, then we should wait to finish all active tasks and then publish incomplete audit results.

(3) Inner ring lists all available containers from container contract. Additionally it can make extra invoke to find out container complexity, but for now consider all containers are the same. Then based on index and epoch number, inner ring node chooses slice of containers to check. For each container it searches storage groups and put it in a queue of tasks.

(4) Audit checks run in parallel in separate pool of routines. This pool has fixed size, e.g. 3 task at a time. When new epoch happens, inner ring uses new pool of routines. Previous routine pool is alive until running task from previous epoch will be finished (we don't discard already started tasks).

### Audit processor component scheme

![Audit processor](pic/audit_processor)

### Check

For each selected container:

 - generate a list of storage groups (object `SEARCH + GET`);
 - check each group;
 - record the results of all groups

The verification of each group consists of three stages:

 - Prove-of-Retrievability (PoR);
 - Prove-of-Placement (PoP);
 - Prove-of-Data-Possession (PDP).

### Prove-of-Retrievability

In PoR check inner ring node should:

 - get storage group object (1),
 - for each member of storage group, inner ring node makes object.Head request with main_only flag (2),
 - compare cumulative object size and homomorphic hash with the values from step 1 (3),
 - depending on step 3 save storage group ID in list of succeeded or failed storage groups in audit result (4).

###  Prove-of-Placement

At this stage inner ring tries to create pair-coverage for all nodes in container. Later these pairs will play a game based on homomorphic hash properties (PDP check).

To do so inner ring:

 1. picks random member X of storage group,
 2. build placement for X,
 3. make `object.Head` request with `TTL=1 RAW=true main_only=true` to these nodes in placement order until we got enough responses or we went through all container nodes,
 4. increments `HIT` counter in audit result if we got responses from step 3 without single failure,
 5. increment `MISS` counter in audit result if we got enough responses from step 3 but with intermediate failures,
 6. increment `FAIL` counter in audit result if we haven't got enough responses from step 3,
 7. get pair of nodes that returned result in step 3 and mark them covered,
 8. repeat everything from step 1, but ignore objects with placement in step 2 that does not increase coverage in step 7.

(3) enough responses -- is a number of copies according to container policy.

### Prove-of-Data-Possession

For all pairs after PoP, a Prove-of-Data-Possession is performed:

 - if a node from a pair loses the game, it gets into the “lucky” list,
 - if a node from a pair wins the game - it gets into the “unsuccessful” list.

#### Hash check

Knowing the size of the object (object HEAD short), the entire payload range is divided into 4 parts of random length:

 $$ 
 [0 : q1 : half : q2 : size] 
 $$

Next, hashes from ranges are requested (one request per range).

First node:
$$
h_{11}\{Offset: 0,         Length: half\},
$$
$$
h_{12}\{Offset: half,      Length: q_2\},
$$
$$
h_{13}\{Offset: half + q_2, Length: size - (half + q_2)\}
$$

Second node:
$$
h_{21}\{Offset: half,         Length: size - half\},
$$
$$
h_{22}\{Offset: 0,            Length: q_1\},
$$
$$
h_{23}\{Offset: q_1,           Length: half - q_1\},
$$

If the hashes are obtained successfully, then the check is considered passed if:

$$
h_{21} = h_{12} + h_{13}
$$
$$
h_{11} = h_{22} + h_{23}
$$
$$
h_{11} + h_{12} + h_{13} = h_{22} + h_{23} + h_{21} == object hash
$$
