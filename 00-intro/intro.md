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
...

# Introduction

## Overview

\Gls{NeoFS} is a decentralized distributed object storage system integrated with
the [Neo Blockchain](https://neo.org).

\Glspl{Node} are organized in peer-to-peer network that takes care of storing
and distributing user's data. Any Neo user may participate in the network and
get paid for providing storage resources to other users or store his data in
\Gls{NeoFS} and pay a competitive price for it.

Users can reliably store object data in the \Gls{NeoFS} network and have a
transparent data placement process due to decentralized architecture and
flexible storage policies. Under the users we mean both individuals and
enterprises. Each \Gls{Node} is responsible for executing the storage policies
that the users select for geographical location, reliability level, number of
nodes, type of disks, capacity, etc. Thus, \Gls{NeoFS} gives full control over
data to users.

Deep [Neo Blockchain](https://neo.org) integration allows \Gls{NeoFS} to be used
by \glspl{dApp} directly from
[NeoVM](https://docs.neo.org/docs/en-us/basic/technology/neovm.html) on the
[Smart
Contract](https://docs.neo.org/developerguide/en/articles/smart_contract.html)
code level. This way \glspl{dApp} are not limited to on-chain storage and can
manipulate large amounts of data without paying a prohibitive price.

\Gls{NeoFS} has native [gRPC](https://grpc.io) \Gls{api} and popular protocol
gates such as [AWS
S3](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html),
[HTTP](https://wikipedia.org/wiki/Hypertext_Transfer_Protocol),
[FUSE](https://wikipedia.org/wiki/Filesystem_in_Userspace) and
[sFTP](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) allowing
developers to easily integrate their applications without rewriting their code.

Using this set of features, it's possible, for example, to have \gls{dApp}'s
Smart Contract to manage monetary assets and data access permissions on
\Gls{NeoFS} and let users access that data using a regular Web Browser or mobile
application.


## Background

## Technical Requirements

## Out of Scope

## Future Goals

\newpage
