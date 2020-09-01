---
title: "NeoFS Technical Specification"
subtitle: "Architecture and Implementation details"
author: "Neo Saint Petersburg Competence Center"
lang: "en"
titlepage: true
logo: 00-intro/pic/logo.pdf
logo-width: 300
toc-own-page: true
colorlinks: true
links-as-notes: true
...

# Introduction

## Overview

\Gls{NeoFS} is a decentralized distributed object storage system integrated with [Neo Blockchain](https://neo.org).

We store and distribute users' data across a peer-to-peer network of \Glspl{Node}. Whether a business or an individual, any Neo user may join the network and get paid for providing storage resources to others or pay a competitive price and employ NeoFS storage solution.

The decentralized architecture and flexible storage
policies allow users to reliably store object data in the NeoFS network. Each \Gls{Node} is responsible for executing the storage policies selected by the users
regarding the geographical location, redundancy level, number of nodes, type of
disks, capacity, etc. Thus, NeoFS enables a transparent
data placement process and gives full control over data to the users.

Deep [Neo Blockchain](https://neo.org) integration allows NeoFS to be used by
\glspl{dApp} directly from
[NeoVM](https://docs.neo.org/docs/en-us/basic/technology/neovm.html) on the
[Smart
Contract](https://docs.neo.org/docs/en-us/basic/technology/neocontract.html)
code level. As a result, dApps are not limited to on-chain storage and one can
manipulate large amounts of data without paying a prohibitive price.

NeoFS provides native [gRPC](https://grpc.io) \Gls{api} and supports popular protocol gateways
such as [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html),
[HTTP](https://wikipedia.org/wiki/Hypertext_Transfer_Protocol),
[FUSE](https://wikipedia.org/wiki/Filesystem_in_Userspace), and
[sFTP](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol), which allows
developers to easily integrate their applications without rewriting their codes.

This whole set of features makes it possible to utilize dApp's Smart
Contract to manage monetary assets and obtain data access permissions on NeoFS through a regular Web Browser or a mobile application.

## Background

## Technical Requirements

## Out of Scope

## Future Goals
