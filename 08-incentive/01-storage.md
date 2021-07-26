## Data storage payments

Data storage payments are made once in an epoch. Epochs are measured in side chain blocks and can change their duration against real time. Thus, estimated profit and expense for an hour, week or month may vary depending on epoch duration. Payment operations are not specified in the protocol. Storage node owners should check payment details by themselves and delete unpaid data if they want to free some storage space.

Data storage payments are also done in two steps: 

- basic income payments,
- data audit payments.

### Basic income

Basic income provides asset flow from data owners to storage node owners when data owners do not create storage groups to trigger audit and audit payments. Basic income settlements are calculated per container. Exact payment price calculated from average estimated data size on a single node of a container, basic income rate in NeoFS network configuration, number of nodes in container.

Basic income rate is a NeoFS network configuration value managed by Alphabet nodes of the Inner Ring. It is stored as GAS per GiB value. Once in an epoch Storage Nodes calculate average data size of each container node store. This data then aggregated inside the container nodes and then aggregated value stored in container contract. 

When epoch `N` starts, Inner Ring nodes estimate the data size for every registered container from `N-1` epoch. To do that they use the formula below 

$$
\frac{Size \cdot Rate}{2^{30}}
$$

GAS, where $Size$ is the estimated container size, $Rate$ is the basic income rate. The owner of the container will be charged 

$$
\frac{Size \cdot Rate}{2^{30}} \cdot N
$$

GAS, where $N$ is the number of nodes in the container.

![Basic income collection](pic/basic-income)

### Data audit

Data audit is triggered if container contains Storage Group objects. Data audit settlements are also calculated per container. Exact payment price calculated from Storage Node cost attributes, total size of successfully audited storage groups, number of nodes in the container.

Storage groups define the subset of objects inside a container and provides extra meta information for data audit. Objects that are not covered by a storage group are not tested for integrity or safety by Inner Ring nodes. Inner Ring nodes perform data audit permanently. At the start of epoch `N`, Alphabet nodes of the Inner Ring create settlements or all successfully checked Storage Groups from epoch `N-1`. To do that they use formula below

$$
\frac{\sum_{i=1}^{k} SGSize_i}{2^{30}} \cdot Price
$$

GAS, where $SGSize$ s the total size of objects, covered by the storage group (in bytes), $Price$ is a storage node attribute (n GAS per GiB), $k$ is the number of successfully checked Storage Groups in the container. The owner of the container will be charged

$$
\sum_{j=1}^{n} \frac{\sum_{i=1}^{k} SGSize_i}{2^{30}} \cdot Price_j
$$

GAS, where $n$ is the number of nodes in the container.
