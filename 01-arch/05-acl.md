## Access Control Lists

Data security is critical for any object storage. Little is more important for
this purpose than to define whether a user has an access to a particular piece
of information or not. Only a combination of various mechanisms can effectively
provide it, and yet \glspl{acl} remain the key one. Access Control Lists specify
users IDs and the rights they can exercise, namely to read (search through the
conatiner) or to write (other object operations). While receiving a request, any
object server gets a container and compares the sender (the first element in the
chain of signatures) and the container’s ACL. The container’s ACL covers all
objects therein. Thus, an owner of a container obtains full control and sets
certain permissions authorizing defined groups of users only.

To obtain information on authorization rules, NeoFS uses a flexible ACL system
involving basic ACL and extended ACL, if allowed. Together they use multiple
parameters, thus, providing greater control.

### Basic ACL

Basic ACL is written in the structure of a container, and it is always created
simultaneously with the container. Therefore, it is never subject to any
changes. Actually, it is a 32-bit integer storing a bit field in the following
format: 

(table)

Delivered with a container, basic ACL is then cached and taken out of cache
together with the container policy. The containers are private by default. It is
what the default values in the table above witness.

Examples of Basic ACL for containers:

Private container: 0x1C8C8CCC
(table)

Public container with installed sticky bit: 0x3FFFFFFF
(table)

Read only container: 0x1FFFCCFF
(table)

### Extended ACL

Extended ACL is stored in a smart contract of a container. It exists as the only
relevant version stored in the memory of the contract. Only the owner of the
container can change the rules of Extended ACL. An error occurring while you
attempt to get Extended ACL means you are not authorized for that. Such an error
is not cached.

Extended ACL can only specify, limit, and restrict the rules of Basic ACL. If
Basic ACL contains Allow, eALC may specify the rule to a finite list of allowed
keys, while others will be denied. If Basic ACL already contains Deny, eALC can
do nothing. Deny in Basic ACL cannot be changed to Allow in eALC.

When a user generates a container and sets the F-bit of Basic ACL for 0, he or
she does not need to settle the rules immediately. Container contract for a
non-existing Extended ACL request will return a null byte array. It will be
interpreted as a table with no rules.

Contract contains a table with authorization rules. This table is given as a
protobuf message. The rules are organized in groups according to the operation
type. They are employed one by one until the first response. If no matching rule
is found, the allowing rule from Basic ACL is used (denying rule in Basic ACL
stops verification).


The rules are consistently applied as per the table. It means that there is no
separate rule for setting any denying or allowing policy. Everything depends on
the user and the rules generation tool he or she uses.

(table)

Extended ACL cannot contradict the rules of Basic ACL. Therefore, the records
with denied GET, GETRANGE, PUT, SEARCH, HEAD for target.System should be
ignored. One can reduce it to the total ignore of any target.System rules for
Extended ACL.

The list of aliases in Target is likely to grow. For example, to make records in
container from smart contract, one should enter alias in relevant Oracle nodes.
Just like keeping the relevant list of consensus nodes based on the events in
the main Neo chain, one may keep lists of keys for Oracle nodes of different
types and groups.

When protocol gateways convey additional data of an external protocol through
extended header, one can work with requests headers, including extended user
headers. As soon as the whole chain is signed during request transmission, such
headers are hard to falsify. It may be used while putting a user ID to an HTTP
gateway through an X-header and if the Extended ACL only allows to work with
this user's objects marked in user object headers.

Example of Extended ACL:
(table)
