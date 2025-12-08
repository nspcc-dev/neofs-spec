## Data storage payments

Data storage payments are made once an epoch. Epochs are measured in seconds based on FS chain blocks' timestamps, and can change their duration depending on network settings. Thus, estimated profit and expense for an hour, week or month may vary depending on epoch duration. Payments are done based on load reports that storage nodes do every epoch (see \nameref{sec:Reports}). Storage node must be part of container to report its storage in it and receive incoming payments. Storing data without reporting about it leads to no balance increase.

Data storage payments flow: 

- accumulating storage reports in the Balance contract and calculate normalized averages for epochs based on the number of reports and their announcement time in an epoch,
- initiating transfers to storage nodes by the Alphabet node consensus for every actual container for an epoch,
- atomic payment distribution on the Balance contract side without any external interference, fully based on the actual FS chain state.

### Basic income

Basic income provides basic asset flow from data owners to storage node owners. Basic income settlements are calculated per container. Exact payment price is calculated based on the normalized container size retrieved from the storage node's reports and the basic income rate in NeoFS network configuration. Note that all the data is paid, not only the uploaded one: objects may be duplicated based on container policies (and, in fact, are expected to have additional replicas in most of the cases), container size in such cases is calculated as the sum of every stored object on storage nodes, including duplicated data.

Basic income rate is a NeoFS network configuration value managed by Alphabet nodes of the Inner Ring. It is stored as GAS per GiB value. Once an epoch, Storage Nodes send reports to the Container contract about containers they serve, single report per every container. This data is normalized inside Container contract taking into account time of the previous report. Storage nodes receive payments independently based on the reports they have sent previously.

Normalized billing size for $j$ node in $i$ container:

$$
R_{i,j}=\sum_{k=0}^{N}r_{k}\frac{(n_{k+1}-n_{k})}{n_{N}-n_{0}}
$$

where $N$ is number of reports in this epoch - 1, $r_{i}$ is reported size, and $n_{i}$ is timestamp of the report ($n_{N}$ is epoch end timestamp). Time is defined based on the block's timestamp at which report was announced, this is based on FS chain's execution state. If there are no changes in node's storage related to a container, it may not update its report in the contract. In such cases, the latest reported value is considered as storage size for all the following epochs and no normalization is required.

![Report size normalization](pic/report-normalization)

When epoch `N` starts, Inner Ring nodes initiate payments for `N-1` epoch, sending consensus payment transaction to FS chain. Balance contract distribute payments based on billing information stored in Container contract which in turn is based on storage node reports.

Payment that every data owner must pay every epoch:

$$
\sum_{i}^{}\sum_{j}^{}\frac{R_{i,j}\cdot Rate}{2^{30}}
$$

GAS, where $R_{i,j}$ is normalized container size report from the $j$-th node in $i$-th container the owner owns, $Rate$ is the basic income rate. Every storage node receives GAS equals the sum above with corresponded fixed $j$ and only $i$s that correspond containers storage node belongs to.

![Basic income collection](pic/basic-income)
