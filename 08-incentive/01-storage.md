## Data storage payments

Data storage payments are made once an epoch. Epochs are measured in FS chain blocks and can change their duration against real time. Thus, estimated profit and expense for an hour, week or month may vary depending on epoch duration. Payment operations are not specified in the protocol. Storage node owners should check payment details themselves and delete unpaid data if they want to free some storage space.

Data storage payments are also made in two steps: 

- basic income payments,

### Basic income

Basic income provides basic asset flow from data owners to storage node owners. Basic income settlements are calculated per container. Exact payment price is calculated from an average data size estimated for a single node of a container, basic income rate in NeoFS network configuration, and the number of nodes in the container.

Basic income rate is a NeoFS network configuration value managed by Alphabet nodes of the Inner Ring. It is stored as GAS per GiB value. Once an epoch, Storage Nodes calculate the average data size of each container node store. This data is then accumulated inside the container nodes; once done, the aggregated value is stored in the container contract. 

When epoch `N` starts, Inner Ring nodes estimate the data size for every registered container from epoch `N-1`. To do so, they use the formula given below 

$$
\frac{Size \cdot Rate}{2^{30}}
$$

GAS, where $Size$ is the estimated container size, $Rate$ is the basic income rate. The owner of the container will be charged 

$$
\frac{Size \cdot Rate}{2^{30}} \cdot N
$$

GAS, where $N$ is the number of nodes in the container.

![Basic income collection](pic/basic-income)
