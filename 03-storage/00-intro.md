\newpage
# Storage Nodes

## Address format

NeoFS uses \Gls{MultiAddr} format in a human-readable string version as a Node address in `netmap`. Any new node must provide correct \Gls{MultiAddr} on bootstrap stage. After bootstrap, addresses are verified by `IR` before new Node is a part of `netmap`.

Correct address *composition* and *order*:

1. Network layer(`dns4`, `ip4` or `ip6`);
2. Transport layer(`tcp`);
3. Presentation layer(`tls`) - optional, may be absent.

### Examples:

#### Correct
- `/dns4/somehost/tcp/80/tls`;
- `/ip4/1.2.3.4/tcp/80`.
  
#### Incorrect
- `/tcp/80/ip4/1.2.3.4`;
- `/tls/ip4/1.2.3.4/tcp/80`;
- `/ip4/1.2.3.4/dns4/somehost/tcp/80`.
