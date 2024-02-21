## Access Control Lists

Access control in a decentralized untrusted environment is a complicated problem. It must be verifiable by every network participant and still be open for changes to revoke unwanted access permissions or adjust to infrastructure changes.

NeoFS solves this by using \Gls{acl} rules from the combination of sources:

- Basic ACL in the container structure,
- BearerToken ACL rules in the request,
- Extended ACL rules in the SideChain smart contract.

\Glspl{acl} specifies a set of actions that a particular user or a group of users can do with objects in the container. Each request coming through a storage node gets verified against those rules and rejected if the requests's action is not allowed.

### Basic ACL

Basic ACL is a part of the container structure, and it is always created simultaneously with the container. Therefore, it is never subject to any changes. It is a 32-bit integer with a bit field in the following format:

![BasicACL bit field](pic/acl-basic)

| Symbol | Meaning | Description                                                                                                             |
|--------|:--------|-------------------------------------------------------------------------------------------------------------------------|
| **B**  | Bearer  | Allows using Bear Token ACL rules to replace eACL rules                                                                 |
| **U**  | User    | The owner of the container identified by the public key linked to the container                                         |
| **S**  | System  | Inner Ring and/or container nodes in the current version of network map                                                 |
|        |         | IR nodes can only perform `Get`, `GetRangeHash`, `Head`, and `Search` necessary for data audit.                         |
|        |         | Container nodes can only do verbs required for the replication. i.e., `Get`, `Put`, `Head`, `Search` and `GetRangeHash`.|
| **O**  | Others  | Clients that do not match any of the categories above                                                                   |
| **F**  | Final   | Flag denying Extended ACL. If set, Basic ACL check is final, Extended ACL is ignored                                    |
| **X**  | Sticky  | Flag denying different owners of the request and the object                                                             |
|        |         | If set, object in `Put` request must have one `Owner` and be signed with the same signature                             |
|        |         | If not set, the object must be correct but can be of any owner.                                                         |
|        |         | The nodes falling for `SYSTEM` role are exception from this rule. For them the bit is ignored.                          |
| **0**  | Deny    | Denies operation of the identified category                                                                             |
| **1**  | Allow   | Allows operation of the identified category                                                                             |

Basic ACL was designed to be processed and verified really fast. It's simple enough, but covers the majority of access restriction use cases, especially when combined with a carefully tailored Storage Policy.

There are well-known Basic ACLs:

Final -- with a flag denying Extended ACL:

`private`: 0x1C8C8CCC

![Basic ACL `private`](pic/acl-basic-private)

`public-read`: 0x1FBF8CFF

![Basic ACL `public-read`](pic/acl-basic-public-read)

`public-read-write`: 0x1FBFBFFF

![Basic ACL `public-read-write`](pic/acl-basic-public-read-write)

`public-append`: 0x1FBF9FFF

![Basic ACL `public-append`](pic/acl-basic-public-append)

Non-final -- Extended ACL can be set:

`eacl-private`: 0x0C8C8CCC

![Basic ACL `eacl-private`](pic/eacl-acl-basic-private)

`eacl-public-read`: 0x0FBF8CFF

![Basic ACL `eacl-public-read`](pic/eacl-acl-basic-public-read)

`eacl-public-read-write`: 0x0FBFBFFF

![Basic ACL `eacl-public-read-write`](pic/eacl-acl-basic-public-read-write)

`eacl-public-append`: 0x0FBF9FFF

![Basic ACL `eacl-public-append`](pic/eacl-acl-basic-public-append)

### Extended ACL

Extended ACL is stored in the container smart contract in NeoFS Sidechain. This means it can be changed during container lifetime and there will be only one latest version of it in use. Only the container owner, or the bearer of a SessionToken with a Container context signed by the container owner, can change the Extended ACL rules. Since it is stored in a form of a stable serialized protobuf structure, eACL table can be only replaced with a new version, not altered or changed in-place in any way.

Extended ACL can only specify Basic ACL rules and make them more restitutive, but it can never ease them. Extended ACL rules can never conflict with Basic ACL rules or cancel them. If something is denied at Basic ACL level, it can never be allowed again by eACL. If Basic ACL contains Allow, eACL may specify the rule to a finite list of allowed keys and Deny all others. If Basic ACL already contains Deny, eACL can do nothing. Deny in Basic ACL cannot be changed to Allow in eACL. Therefore, the records with denied `GET`, `GETRANGE`, `PUT`, `SEARCH`, `HEAD` for `System` target must be ignored. This reduces to ignoring any `System` target rules.

When a user creates a container with the F-bit of Basic ACL set to 0, they do not need to settle the rules immediately. For a non-existing Extended ACL request, Container contract will return a null byte array. It will be interpreted as a table with no rules.

To get the latest eACL version, a Storage Node needs to request it via RPC from the SideChain node. If an eACL can't be retrieved, the access permissions check fails.

Extended ACL rules get processed on-by-one, from the beginning of the table, based on the request operation, until matching the rule found. It means that there is no separate rule for setting denying or allowing policy. Final fallback rules must be provided by the user, if needed.

![Extended ACL rules check](pic/acl-ext-apply)

Extended ACL rules and table format may change depending on the version of NeoFS API used. Please see the corresponding API specification section for details.'

Each eACL rule record has four fields:

| Field     | Description                                                                        |
|-----------|------------------------------------------------------------------------------------|
| Operation | NeoFS request action verb                                                          |
| Action    | Rule execution result action. Allows or denies access if the rule's filters match. |
| Filter    | Filter to check particular properties of the request or the object                 |
| Target    | Subject's role class or a list of public keys to match                             |

and can be presented in different intermediate formats, like JSON, for the users' convenience.

```json
{
  "records": [
    {
      "operation": "GET",
      "action": "DENY",
      "filters": [
        {
          "headerType": "OBJECT",
          "matchType": "STRING_NOT_EQUAL",
          "key": "Classification",
          "value": "Public"
        }
      ],
      "targets": [
        {
          "role": "OTHERS"
        }
      ]
    }
  ]
}
```

Note that some filters with `$Object` prefix are not suitable for making denying rules on certain operations. There may be an undefined behavior on some combinations of NeoFS verbs and object attributes when eACL is set. In the table below, `+` means allowed to be used and `-` means undefined behavior, hence not allowed.

| $Object:        | GET | HEAD | PUT | DELETE | SEARCH | RANGE | RANGEHASH |
|-----------------|:---:|:----:|:---:|:------:|:------:|:-----:|:---------:|
| version         | +   | +    | +   | -      | -      | -     | -         |
| objectID        | +   | +    | +   | +      | -      | +     | +         |
| containerID     | +   | +    | +   | +      | +      | +     | +         |
| ownerID         | +   | +    | +   | -      | -      | -     | -         |
| creationEpoch   | +   | +    | +   | -      | -      | -     | -         |
| payloadLength   | +   | +    | +   | -      | -      | -     | -         |
| payloadHash     | +   | +    | +   | -      | -      | -     | -         |
| objectType      | +   | +    | +   | -      | -      | -     | -         |
| homomorphicHash | +   | +    | +   | -      | -      | -     | -         |
| User headers    | +   | +    | +   | -      | -      | -     | -         |

Let us make an example. `Delete` and `Range` operations are likely to show undefined behavior if `Head` has been denied for objects with particular `payloadLength`. They fail because they need to produce `HEAD` requests upon execution. If a user cannot `Head`, those operations cannot work properly. The full table of spawning object requests is given below.

| Base/Gen | PUT | DELETE | HEAD | RANGE | GET | HASH | SEARCH |
|----------|:---:|:------:|:----:|:-----:|:---:|:----:|:------:|
| PUT      | +   | -      | -    | -     | -   | -    | -      |
| DELETE   | -   | -      | +    | -     | -   | -    | +      |
| HEAD     | -   | -      | +    | -     | -   | -    | -      |
| RANGE    | -   | -      | +    | +     | -   | -    | -      |
| GET      | -   | -      | +    | -     | +   | -    | -      |
| HASH     | -   | -      | +    | +     | -   | -    | -      |
| SEARCH   | -   | -      | -    | -     | -   | -    | +      |

Also, note that user attributes cannot be used as filters in an eACL rule as it provokes an undefined behaviour. By design, when user attributes are set for a Complex Object, they are not inherited in the Part Objects and are only stored in the Link Object header. We cannot control the access for an Object of size more than `maxObjectSize`. To keep the system consistent we do not support eACL filters by user attributes for small Objects as well.


### Bearer Token

`BearerToken` allows to use the Extended ACL rules table from the token attached to the request, instead of the Extended ACL table from the `Container` smart contract.

Just like [JWT](https://jwt.io), it has a limited lifetime and scope, hence can be used in the similar use cases, like providing authorization to externally authenticated party.

BearerToken can be issued only by the container owner and must be signed using the key associated with the container's `OwnerID`.

In the gRPC request, `BearerToken` is encoded in a protobuf format, but can be also presented in different intermediate formats, like JSON, for the users' convenience.

```json
{
  "body": {
    "eaclTable": {
      "version": {
        "major": 2,
        "minor": 6
      },
      "containerID": {
        "value": "DIFWB4CFTayb9IAqeGwLGJdJfW6i5wWllPsF50EmazQ="
      },
      "records": [
        {
          "operation": "GET",
          "action": "ALLOW",
          "filters": [
            {
              "headerType": "OBJECT",
              "matchType": "STRING_EQUAL",
              "key": "Classification",
              "value": "Public"
            }
          ],
          "targets": [
            {
              "role": "OTHERS",
              "keys": []
            }
          ]
        },
      ]
    },
    "ownerID": null,
    "lifetime": {
      "exp": "100500",
      "nbf": "1",
      "iat": "0"
    }
  },
  "signature": {
    "key": "AiGljnj41qh9o9uVqP9b9CArihHvXfGmljhAZNo4DceG",
    "signature": "BAwfdE1ZVL0LfREGkuXRKT2....GA="
  }
}
```

BearerToken format may change depending on the version of NeoFS API used. Please see the corresponding API specification section for details.

### ACL check algorithm

NeoFS tries to start with local Basic ACL checks that are fast and cheap in terms of resource consumption. This should cover the vast majority of cases. Then, if present in the request, the ACL records from `BearerToken`, again locally. For the rest of complex cases, the Storage Node retrieves the Extended ACL table from the Container smart contract. Thereafter, the NeoFS ACL system may slow down the request processing only in complex cases when it's inevitable.

The resulting ACL check algorithm is the following:

![ACL check order](pic/acl-order)

