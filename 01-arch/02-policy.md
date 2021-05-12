## Storage Policy

In NeoFS, storage policy is a flexible way to specify rules for storing objects. The result of storage policy rules application to the network maps is a set of storage nodes, able to store data according to the requested policy. This result maybe called "placement", hence sometimes you may find the term "placement policy" used to denote the same thing as the "storage policy".

Because Storage Policy is attached to the container structure there is a compact definition for system's internal use and some higher level language definitions for humans to use, that are translated to internal representation. For example, there is an SQL-like language to be used by humans, JSON notation to be used in software and there may be many others, like a graphical language using [Blockly](https://developers.google.com/blockly). In our examples we will use SQL-like notation.

Storage Policy internal definition consists of four parts:

1. Filters
2. Selectors
3. Replicas
4. Container Backup Factor

The result of applying a storage policy to the netmap is a set of nodes structured by `Replicas` and used to select candidates to put objects on. The selection algorithm is deterministic, hence on different nodes or clients the same Storage Policy applied to the same version of netmap will give the identical result.

### Filters

Filter is a mechanism to specify which nodes are allowed to store an object. This is done by querying node's attributes and checking if they satisfy certain condition. For example, it allows to precisely specify "Store objects in nodes from Europe, but not from Italy, which have SSD and have a good reputation".

Simple filter can compare a single node attribute with some value.

It has 3 fields:

1. `Key` — name of node attribute
2. `Value` — value to compare attribute with
3. `Op` — operation to be used for comparison

For better understanding, simple filters will be specified as `Key Op Value`.

For example:

1. `Country = Argentina` means use nodes for which `Country` attribute is equal to `Argentina`, i.e. nodes located in USA.
2. `Rating > 4.5` means use nodes with rating better then 4.5

Currently only eight operations are supported, two of which are used for creating compound filters from the other ones.

1. `EQ`/`NE` check if attribute is equal/not equal to the filter's value.
2. `GT`/`GE`/`LT`/`LE` check if numerical attribute is greater-than/greater-or-equal/less-than/less-or-equal than the filter's value.
3. `OR` checks if node satisfies at least one of the filters provided as arguments.
4. `AND` checks if node satisfies all filters provided as arguments.

Compound filter can combine simple filters to specify arbitrarily complex conditions. Consider example from the previous section: we may write `Country = Argentina AND Rating > 4.5` to filter nodes which are located in Argentina and have a good rating at the same time.

If filters are used in selectors or other filters, they should have name. Consider filter `Country = Finland OR Country = Iceland AS ColdCountry`. If we need nodes from these countries but want to vary maximum price depending on the storage type they have, we may write this filter:

```
ColdCountry AND StorageType = SSD AND Price < 100
OR
ColdCountry AND StorageType = HDD AND Price < 10
```

### Selectors

Selector is a mechanism to specify which of the previously filtered nodes will be included in the container. It has 5 fields:

1. `Name` — name that can be referred to
2. `Attribute` — name of the attribute for grouping nodes. When it is set, nodes are grouped in buckets based on `Attribute` value. It can be omitted to create buckets "randomly".
3. `Count` — number of nodes to be included in a bucket or number of buckets, depending on `Clause`.
4. `Clause` specifies how `Count` is interpreted:
   - `SAME` — choose nodes from the same bucket
   - `DISTINCT` — choose nodes from distinct buckets
5. `Filter` — name of the filter to choose nodes from. If it is omitted or is `*`, all nodes from the netmap are used.

Selector can return different set of nodes for every epoch; however, they are always the same on each storage node having the same netmap. The degree to which this set of nodes is changed also depends on how strict the filter is. For example, if we select a few nodes based on a very specific attribute, this set will always be the same. However, if all these nodes go down, data can be lost.

### Replicas

Replica is an independent set of nodes where single object copy is stored. It can refer to selector (by default all nodes are considered) and can specify a number of copies to store.

### Container Backup Factor

Container backup factor (`CBF`) controls maximum number of nodes to be included in a container's node set. It doesn't set strict boundaries, though. Consider placement policy which selects `X` nodes in 2 different countries with `CBF 2`. In this case, we can expect container's node set to have from `X` to `X * 2` nodes in every selected country. Having less than `X * 2` nodes is not considered as fail.
