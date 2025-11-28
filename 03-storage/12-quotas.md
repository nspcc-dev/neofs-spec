## Storage quotas

NeoFS storage support limiting storage space used by a container and/or by a user (meaning storage sum of every container he has created or, in other words, every container that has this user as owner). Container and user quotas are independent and may overlap depending on containers state. Quotas limit the whole storage used by every storage node that serve container(s), the summary is accumulated in Container contract and is based on node's storage reports (see \nameref{sec:Reports}).

### Quotas administration

There is network setting (`AlphabetManagesQuotas`) that defines who is allowed to manage quotas:

- setting is missing or set to anything that cannot be converted to `true` in terms of Neo VM: only container's owner and user is allowed to set, change, cancel quotas,
- setting is set to anything that can be converted to `true` in terms of Neo VM (e.g. non-empty array with non-zero bytes): only Alphabet consensus is allowed to set, change, cancel quotas.

### Hard/Soft quota differences

Quotas have two independent modes: soft and hard. Both can be set at a time, both can have any values, there is no requirement on how these values should correspond to each other.

Soft quota instructs storage nodes to warn their administrator that the limit is exceeded in logs. It does not intend to alter storage, and any storage changes are still allowed.

Hard quota instructs storage nodes to deny any object that lead to exceeding the limits. Current used storage is taken from the summary reports in the Container contract, _not_ from the local statistics.

## Setting

Quotas are stored and maintained inside Container contract. The contract provides API for fetching and setting values:

- `SetSoftContainerQuota`/`SetHardContainerQuota` and `ContainerQuota`,
- `SetSoftUserQuota`/`SetHardUserQuota` and `UserQuota`.

These methods can be called in raw FS chain transaction using `neo-go` CLI, or using `neofs-adm` CLI. Example:
```
# setting container|user quota; --soft flag instructs to set soft quota, missing flag sets hard quota 
$ neofs-adm fschain quota container|user -r <FS chain RPC> -w <owner_wallet> --cid <container_id> [--soft] -- <value>

# fetching container|user quotas
$ neofs-adm fschain quota container|user -r <FS chain RPC> --cid <container_id>                                       
<container_id>|<user_id> container|user quotas:
Soft limit: 0
Hard limit: 0

```

To cancel previously set quota, non-positive value should be set instead.
