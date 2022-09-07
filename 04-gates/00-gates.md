\newpage
# Protocol gateways
## HTTP
## S3

[NeoFS S3 gateway](https://github.com/nspcc-dev/neofs-s3-gw) provides API compatible with Amazon S3 cloud storage service.

### Access Box scheme

S3 gateway has to authenticate user requests regarding [AWS spec](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html).
So we have the following scheme:

![Access box scheme](pic/accessbox-scheme)

1. A user uses the [neofs-s3-authmate](https://github.com/nspcc-dev/neofs-s3-gw/blob/master/docs/authmate.md)
(Authmate) tool to get credentials (`access_key_id` and `secret_access_key`).
2. Authmate forms "AccessBox" object (see the next section) and puts it into NeoFS.
3. Authmate output contains credentials (`access_key_id` and `secret_access_key`) that can be used with AWS CLI, for example.
4. The user sends request to NeoFS S3 Gateway using standard AWS tool.
5. S3 Gateway gets "AccessBox" from NeoFS by `access_key_id` and fetches Bearer Token from it.
6. S3 Gateway uses fetched Bearer token to send a request to NeoFS on behalf of the user.

#### Form Access Box object

Actually, `AccessBox` is a regular object in NeoFS but properly formed. 
It contains an encrypted  Bearer token (`BT`), Session tokens (`STs`) and a `secret_access_key`.

The credentials are formed by the following steps:

1. User provides Authmate with `BT`, `STs` and `s3gw_public_key_k`(the public keys of the gates that will be able 
to handle credentials) that will be used when the user sends requests via S3 Gateway.
2. Authmate:
   1. Generates a `secret_access_key` (it's 32 random bytes) and P256 (secp256r1) key pair 
      (`authmate_private_key`, `authmate_public_key`).
   2. Forms a `tokens` protobuf struct that contains `BT`, `STs`, `secret_access_key`
   3. For each `s3gw_public_key_k` derives a symmetric key `symmetric_key_k`
      using [ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) and 
      encrypts `tokens` (`encrypted_tokens_k = encrypt(tokens.to_bytes(), secret_key_k, nonce_k)`).
   4. For each `encypted_tokens_k` forms a struct called `gate_k` that contains `encrypted_tokens_k` and `s3gw_public_key_k`.
   5. Forms the final binary object `AccessBox` that contains `authmate_public_key`, `gate_1`, ..., `gate_k`.
   6. Puts the `AccessBox` object to NeoFS and saves its address `CID/OID` as `access_key_id`.
   7. Returns the pair (`access_key_id`, `secret_access_key`) to the user.

#### Handle S3 request

On getting a request, S3 Gateway:

1. Fetches the `access_key_id` from the `Authorization` header.
2. Gets `AccessBox` from NeoFS by address (recall `access_key_id` is `CID/OID`)
3. Using `s3gw_private_key_k` and `authmate_public_key` derives `symmetric_key_k` and decrypts `encrypted_token_k` that 
has been found by matching `s3gw_public_key_k` in `gate_k` struct.
4. Checks the signature of the initial request using `secret_access_key` from `tokens` struct.
5. Uses `BT` and `STs` to perform requests to NeoFS.

## sFTP
