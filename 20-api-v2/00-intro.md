\newpage
# NeoFS API v2

NeoFS API v2 is focusing on simplification of previous versions of API used
during early stages of NeoFS development. The new structure makes it easier to
implement NeoFS API in different languages and for different platforms.

All data structures are defined in protobuf format and grouped together with
corresponding services into comparatively independent packages. This allows to
significantly simplify development (automatically generate for most parts) of a
library for working in NeoFS. One can start with a required minimum instead of
implementing the whole package right in the beginning. We tried to make the
packages as independent as possible, and thus minimizing horizontal dependency.

For transport layer, by default we assume that gRPC will be used. These are
popular, simple, and time-tested tools relevant for most languages and
platforms. Although gRPC is used now, we have everything to transfer structures
through other protocols, e.g. JSON-RPC.

## Nodes and their identification

NeoFS API does not differentiate client and server. All members of the network
communicate using the same protocol. The protocol does not distinguish between a
small \Gls{cli} utility and a full-featured storage node. Both are nodes of the
same p2p network.

A \Gls{Node} is identified by a pair of keys for encryption and decryption.

Public key is encoded in compressed form according to [ANSI
x9.62](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.202.2977&rep=rep1&type=pdf)
(section 4.3.6).

----------------  ---------
Elliptic curve    secp256r1
Private key size  32 bytes
Public key size   33 bytes
Example keys:
private key       6af2b8b41ad2e78f19aa0bc4fb5cb746d61ad44ebf9ba2a43b6e5cc3e46715a6
public  key       03065e513fdaccc4556e7de010bf3d5445552357fb17928f3bd8cea33e092a64eb
Neo 3.0 address   Na6DELLB6dtnPmsD7y1HFjVZNZp8S5BdCJ
----------------  ---------

The key format is compatible with the Neo 3.0 Wallets keys. It lets smart
contracts verify the sender by public keys. Thus, each member may have an
internal NEP-5 balance, where NEO Wallet address is formed from a public key, as
it happens in Neo 3.0.

NeoFS is a peer-to-peer network, which means that the clients are equal and each
of them needs a pair of asymmetric keys. To create a container and place an
object, one should have \Gls{GAS} on NeoFS sidechain internal balance. When a
user makes a deposit from his NEO Wallet, operations of container creation and
object placement should be carried out with the same key (if no other keys have
been associated with that OwnerID).

## Requests and Responses

All request and responses in NeoFS API v2 have the same structure. Only their
`.body` fields are different. Any request consists of body, meta headers, and
verification headers. See the corresponding paragraph in the relevant package
description section to learn about the structure of particular parts of a
message in detail.

The `.body` field delivers the structure with the data making up the request or
a response to it.

The `.meta_header` contains metadata to the request.

The `.verify_header` carries cryptographic signatures for `.body` and
`.meta_header`. It allows to check if the message is authentic, see if it has
been correctly transferred between two nodes, and provide an assumed route of
the message where each intermediate node has left its signature.

## Signing RPC messages and data structures

The messages exchanged between the users of the network involves ECDSA
signatures. These signatures is defined in `refs.Signature` type structure. The
`.sign` field keeps byte representation of a signature, while `.key` field
contains public key to verify the signature.

## Stable serialization

To sign messages or structures, one should first turn them into a byte series.
NeoFS protocol is described in protocol buffers v3 format. Protocol Buffers v3
defines the format of serialization for all messages, but
[specification](https://developers.google.com/protocol-buffers/docs/encoding#order)
allows serialization process to be unstable: the same message can be encoded
correctly by various methods. The field order in the encoded message may be
changed randomly.

> When a message is serialized, there is no guaranteed order for how its known or
> unknown fields should be written. Serialization order is an implementation
> detail and the details of any particular implementation may change in the
> future. Therefore, protocol buffer parsers must be able to parse fields in any
> order.

To generate unified signatures for messages, all NeoFS nodes __must stably
serialize structures and messages described in the protocol__.

Serialization is considered stable when it does no change the order of the
fields in an encoded message. All fields are encoded in ascending order
regarding their numbers specified in protocol description.

```go
message Foo {
  bytes one = 1; // C0 FF EE
  bytes two = 2; // BE EF
}

StableSerialize(Foo) =
[0A 03 C0 FF EE][12 02 BE EF]   // OK for GRPC
                                // OK for NeoFS Signature

UnstableSerialize(Foo) =
[12 02 BE EF][0A 03 C0 FF EE]   // OK for GRPC
                                // FAIL for NeoFS Signature
```

Most auto-generated serializers behave occasionally stable, but there is no
guarantee that they will remain the same in future. Clients exploiting
auto-generated serializers should be aware of such risk.

## Signature generation format

The signature of a message or a structure should be stably serialized. The
serialized byte array is hashed with SHA-512. The obtained signature (R,S) is
enciphered uncompressed according to ANSI x9.62 (section 4.3.6)

----------------  ---------
Elliptic curve    secp256r1
Hash function     SHA-512
Signature size    65 bytes
----------------  ---------

message Foo {
  bytes one = 1; // C0 FF EE
  bytes two = 2; // BE EF
}

```
private key = 6af2b8b41ad2e78f19aa0bc4fb5cb746d61ad44ebf9ba2a43b6e5cc3e46715a6
StableSerialize(Foo) = 0a03coffee1202beaf
SHA-512(StableSerialize(Foo)) =
5efec2432616ca322824a7140d5ac332c6a3a388d2746f8cff6e48909d36829f9cb8586718d457c9540112d52ea2da2b448b2f6f689b3f5813c185b426267ed2

R,S = Sign(private key, SHA-512(StableSerialize(Foo)), secp256r1)
R = e13f3e71db728b85acc4cea688d3dae6b01453d2bff1b5ebc2695cedfef7fdd5
S = 2ecbc0cc0ae4f70696682b4e358a4b698d74f9b708c13470e5c808fe04f526e5

Signature =
04e13f3e71db728b85acc4cea688d3dae6b01453d2bff1b5ebc2695cedfef7fdd52ecbc0cc0ae4f70696682b4e358a4b698d74f9b708c13470e5c808fe04
```

Signature function uses random number generator, which grants different
signatures to the same message with each signing cycle.

## Signature chaining in requests and responses

The structure and the order of signatures for `Request` and `Response` messages
are the same. Therefore, everything about `Request` message written below is
true for `Response` on corresponding structures.

All signatures are kept in `RequestVerificationHeader` structure which is filled
before a message is sent. The \glspl{Node} involved in the transmission and resigning
of the messages fill in their own structure copies and put them in origin field
recursively.

If a user sends a request directly to a receiver, the chain consists of one
`RequestVerificationHeader` only.

![Signature chain verification](pic/verification-chain)

The `RequestVerificationHeader` always carries three signatures:

* Message body signature
* Meta header signature
* Verification header signature

### Message body signature

Each RPC message has a field called `Body`. This structure is serialized
stably; it is signed by the sender only. If a message is retransmitted, this
signature is never set in the new copies of `VerificationHeader`.

![Body signature verification](pic/verification-body-chain)

### Meta header signature

Each RPC meassage has a field called meta_header. Meta headers are changed for
every retransmission (e.g. TTL is reduced) and form an equivalent chain.
meta_signature field contains the signature for an already organized structure
of the meta header.

![Meta header signature verification](pic/verification-meta)

### Verification header signature

While putting a new verification header, intermediate nodes should sign the
preceding verification header and put the signature in the origin_signature
field. The requestor does not set this signature.

![Verification header signature verification](pic/verification-origin)

## Container service signatures

In addition to the RPC requests themselves there is a need to sign followong structures:

* Container in `container.PutRequest.Body` message
* Container ID in `container.DeleteRequest.Body` message
* Extended ACL table structure in `container.SetExtendedACLRequest.Body` message

Those structures' signature is verified by smart contracts, hence it must be
compatible with \Gls{NeoVM}. The signature format supported by \Gls{NeoVM} is
different from the format described in previous sections.

A stably serialized message is hashed using SHA-256 algorithm. The resulting
signature (R,S) is encoded uncompressed as a concatenation of the 32-byte sized
coordinates of R and S.

----------------  ---------
Elliptic curve    secp256r1
Hash function     SHA-256
Signature size    64 bytes
----------------  ---------

```
message ContainerID {
  bytes value = 1; // 29fe85bb8c36f5cb676e256113193235a2ba0c0abe6a71f84654afa92801d17a
}

private key = 6af2b8b41ad2e78f19aa0bc4fb5cb746d61ad44ebf9ba2a43b6e5cc3e46715a6
StableSerialize(Foo) = 0a2029fe85bb8c36f5cb676e256113193235a2ba0c0abe6a71f84654afa92801d17a
SHA-256(StableSerialize(Foo)) = a086acbc03862c01bdff3f850b8254f1be9a6d56ec5661c6efba0319654210cc

R,S = Sign(private key, SHA-256(StableSerialize(Foo)), secp256r1)
R = 1233d0e5c87a24c5a56c518596da64b1ceb8d667723b0030c4888b524229ff8a
S = d4e42952d516c2959ba1825e2768cbfe3f4336e7a14c635236ae2ea95fa50435

Signature =
1233d0e5c87a24c5a56c518596da64b1ceb8d667723b0030c4888b524229ff8ad4e42952d516c2959ba1825e2768cbfe3f4336e7a14c635236ae2ea95fa50435
```


## Object service and Session signatures

Object service and the rest of the services and structures in NeoFS API v2 use
the same signature format as in RPC messages signing.

----------------  ---------
Elliptic curve    secp256r1
Hash function     SHA-512
Signature size    65 bytes
----------------  ---------
\newpage
