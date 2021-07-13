### netmap contract

Netmap contract description\.

#### Contract methods

##### AddPeer

```go
func AddPeer(nodeInfo []byte)
```

##### Config

```go
func Config(key []byte) interface{}
```

##### Epoch

```go
func Epoch() int
```

##### InitConfig

```go
func InitConfig(args [][]byte)
```

##### InnerRingList

```go
func InnerRingList() []common.IRNode
```

##### Migrate

```go
func Migrate(script []byte, manifest []byte, data interface{}) bool
```

##### NewEpoch

```go
func NewEpoch(epochNum int)
```

##### SetConfig

```go
func SetConfig(id, key, val []byte)
```

##### UpdateInnerRing

```go
func UpdateInnerRing(keys []interop.PublicKey)
```

##### UpdateState

```go
func UpdateState(state int, publicKey interop.PublicKey)
```

##### Version

```go
func Version() int
```


