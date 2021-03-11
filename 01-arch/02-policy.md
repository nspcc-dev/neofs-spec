## Storage Policy

In NeoFS, storage policy is a flexible way to specify rules for storing objects.
Depending on the context, the term "placement policy" can be used
to denote the same thing.
It consists of 4 parts described in detail below:
1. Filters
2. Selectors
3. Replicas
4. Container Backup Factor.

The result of applying a storage policy to the netmap is a set of nodes structured
by `Replicas`. It is called (`Container`)[./05-containers.md] and
is used to select candidates to put objects on.

### Filters
Filter is a mechanism to specify which nodes are allowed to store an object.
This is done by querying node's attributes and checking if they satisfy
certain condition. For example, it allows us to precisely specify
"nodes from Europe (but not from Italy) which have SSD and are not very expensive".
In the following sections by "filter" we mean both the filter itself and
the set of nodes which it specifies.
The exact meaning should be obvious from the context.

#### Simple filters
Simple filter can compare a single node attribute with some value.
It has 3 fields:
1. `Key` -- name of node attirbute. 
2. `Value` -- value to compare attibute with.
3. `Op` -- operation to be used for comparison.

To make it easier to understand, simple filters will be specified as `Key Op Value`.

For example:
1. `Country = USA` means "use nodes for which `Country` attribute
   is equal to `USA`", i.e. nodes located in USA.
2. `Price < 100` means "use nodes demanding less than 100 price units per unit of storage". 
   Price units are agreed upon by each NeoFS network
   and are beyond the scope of this document.

#### Operations
Currently only 8 operations are allowed, 2 of which are used for creating
compound filters from other ones.
1. `EQ`/`NE` check if attribute is equal/not equal to the filter's value.
2. `GT`/`GE`/`LT`/`LE` check if numerical attribute
   is greater-than/greater-or-equal/less-than/less-or-equal than
   the filter's value.
3. `OR` checks if node satisfies at least one of the filters provided as arguments.
4. `AND` checks if node satisfies all filters provided as arguments.

#### Compound filters
Compound filter can combine simple filters to specify arbitrarily complex
conditions. Consider example from the previous section: we may write
`Country = USA AND Price < 100` to filter nodes which are located in USA
and have price less than 100.

#### Filters with name
If filters are used in selectors (or other filters) they should have name.
Consider filter `GoodCountry`: `Country = Spain OR Country = Canada`.
If we need nodes from these countries but want to vary maximum price
depending on the storage type they have, we may write this filter:
```
GoodCountry AND StorageType = SSD AND Price < 100
OR
GoodCountry AND StorageType = HDD AND Price < 10
```
### Selectors
Selector is a mechanism to specify which of the previously
filtered nodes will be included in the container. It has 5 fields:
1. `Name` -- name that can be referred to.
2. `Attribute` -- name of the attribute for grouping nodes.
When it is set, nodes are grouped in buckets based on `Attribute` value.
It can be omitted to create buckets "randomly".
3. `Count` -- number of nodes to include in bucket or number of buckets,
   depending on `Clause`.
4. `Clause` specifies how `Count` is interpreted:
   - `SAME` -- choose nodes from the same bucket
   - `DISTINCT` -- choose nodes from distinct buckets.
5. `Filter` name of the filter to choose nodes from.
   If it is omitted or is `*`, all nodes from the netmap are used. 

Selector can return different set of nodes for every epoch,
however, they are always the same on each storage node having the same netmap.
The degree to which this set of nodes is changed also depends on how strict
the filter is. For example, if we select a few nodes based on very specific
attributes, this set will always be the same.
However, if all these nodes go down, data can be lost.

#### HRW
HRW stands for (Rendezvous hashing)[https://en.wikipedia.org/wiki/Rendezvous_hashing].
It helps to achieve 3 goals:
1. Select nodes uniformly from the whole netmap.
This means that every node has a chance to be included in container.
2. Select nodes deterministically. Identical (netmap, placement policy) pair
result in the same container on every storage node.
3. Prioritize nodes providing better conditions.
Nodes having more space, better price or better rating
are to be selected with higher probability. Specific weighting algorithm is defined
for NeoFS network as a whole and is beyond scope of this document.
See (our HRW implementation)[https://github.com/nspcc-dev/hrw] for details.

### Replicas
Replica is an independent set of nodes where single object copy is stored. It can refer
to selector (by default all nodes are considered) and can specify a number
of copies to store.
### Container Backup Factor
Container backup factor (`CBF`)controls maximum amount of nodes to be included in a container.
It doesn't set strict boundaries, though. Consider placement policy which selects `X` nodes
in 2 different countries with `CBF 2`. In this case we can expect container to have
from `X` to `X * 2` nodes in every selected country. Having less than `X * 2` nodes
is not considered as fail.
