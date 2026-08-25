---
title: "NeoFS Technical Specification"
subtitle: "Architecture and Implementation details"
author: "Neo Saint Petersburg Competence Center"
lang: "en"
titlepage: true
titlepage-rule-color: "00E599"
logo: 00-intro/pic/logo.pdf
logo-width: 300
toc-own-page: true
colorlinks: true
links-as-notes: true
table-use-row-colors: true
...

# Introduction

## Overview

\Gls{NeoFS} is a decentralized distributed object storage system integrated with the [Neo Blockchain](https://neo.org).

We store and distribute users' data across a peer-to-peer network of \Glspl{Node}. Whether a business or an individual, any Neo user can join the network and get paid for providing storage resources to others, or pay a competitive price to use NeoFS as a storage solution.

Decentralized architecture and flexible storage policies allow users to reliably store object data in the NeoFS network. Each \Gls{Node} is responsible for executing specific storage policies selected by the user, including geographical location, redundancy level, number of nodes, type of disk, capacity, etc. Thus, NeoFS enables transparent data placement process which gives full control over data to users.

Deep [Neo Blockchain](https://neo.org) integration allows NeoFS to be used by \glspl{dApp} directly from [NeoVM](https://docs.neo.org/docs/en-us/basic/technology/neovm.html) at the [Smart Contract](https://docs.neo.org/docs/en-us/basic/technology/neocontract.html) code level. As a result, dApps are not limited to on-chain storage and one can manipulate large amounts of data without paying a prohibitive price.

NeoFS provides native [gRPC](https://grpc.io) \Gls{api} and supports popular protocol gateways such as [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html) and [REST](https://en.wikipedia.org/wiki/REST), which allows developers to easily integrate their existing applications without rewriting code.

Together, this set of features makes it possible to utilize a dApp's Smart Contract to manage monetary assets and obtain data access permissions on NeoFS through a regular Web Browser or a mobile application.


## Background

While blockchain technology solves synchronization problem and gives some
shared state to applications it was never designed to store any decent amounts
of data. But real applications have storage requirements for different
purposes, so an extension of some kind for blockchain was needed and that's
the initial problem NeoFS tried to solve.

It at the same time wanted to keep the advantages of a distributed system
since many applications built around blockchain technology still had a lot
of centralization points on their backends. A typical one is using cloud
storage providers for users data and hosting. This is also one of the key
requirements for NeoFS, to be able to build an application without external
centralized dependencies.

Then we always wanted to keep the spirit of decentralization in that no single
entity should be responsible for the whole network/dictate policies and prices.
That's why the network allows anyone to spin up a node to store some data and
other network-level functions are performed by a set of keys designated by
a Neo network committee.

The same requirement always brought another implication with it: in NeoFS
nodes can't trust each other in the same way blockchain nodes can not trust
each other by default. This affects both request verifications and storage
proofing, the network needs to be safe both from malicious users and from
malicious nodes.

As project evolved these initial requirements were augmented with various
additional ones like ability to run efficient private networks, so current
NeoFS tries to be more generic and cover more scenarios.


## Technical Requirements

NeoFS can work on a broad range of modern hardware. Client-side its
requirements are not much different from any other cloud storage providers
and working via gateways brings the cost even lower, anything that can
perform HTTP requests can access NeoFS data.

Storage nodes require some disk space to provide it to users and need to
have good internet connectivity to answer various requests in timely manner
(otherwise they can get bad reputation and/or be kicked out of the network
map). CPU-wise any mid-range modern desktop processor is sufficient and
real nodes can function with as low as 8 GB of RAM, but this can depend
on implementation and we recommend more in general.

Inner ring nodes have lower resource requirements than storage nodes, but
their connectivity and availability matters even more since they're
responsible for action approval and network synchronization.

Specific NeoFS implementations can have more precise requirements, but in
general there is nothing in the protocol that makes it impossible to work
with low-spec hardware in private networks.


## Out of Scope

## Future Goals
