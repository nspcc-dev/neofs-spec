## neo.fs.v2.audit




### Message DataAuditResult

DataAuditResult keeps record of conducted Data Audits. The detailed report is
generated separately.

| Field | Type | Description |
| ----- | ---- | ----------- |
| version | Version | Data Audit Result format version. Effectively the version of API library used to report DataAuditResult structure. |
| audit_epoch | fixed64 | Epoch number when the Data Audit was conducted |
| container_id | ContainerID | Container under audit |
| public_key | bytes | Public key of the auditing InnerRing node in a binary format |
| complete | bool | Shows if Data Audit process was complete in time or if it was cancelled |
| requests | uint32 | Number of request done at PoR stage |
| retries | uint32 | Number of retries done at PoR stage |
| pass_sg | ObjectID | List of Storage Groups that passed audit PoR stage |
| fail_sg | ObjectID | List of Storage Groups that failed audit PoR stage |
| hit | uint32 | Number of sampled objects under audit placed in an optimal way according to the containers placement policy when checking PoP |
| miss | uint32 | Number of sampled objects under audit placed in suboptimal way according to the containers placement policy, but still at a satisfactory level when checking PoP |
| fail | uint32 | Number of sampled objects under audit stored in a way not confirming placement policy or not found at all when checking PoP |
| pass_nodes | bytes | List of storage node public keys that passed at least one PDP |
| fail_nodes | bytes | List of storage node public keys that failed at least one PDP |
     
