## neo.fs.v2.link




### Message Link

Link is a payload of helper objects that contain the full list of the split
chain objects' IDs. It is created only after the whole split chain is known
and signed. This object is the only object that refers to every "child object"
ID. It is NOT required for the original object assembling. It MUST have ALL
the "child objects" IDs. Child objects MUST be ordered according to the
original payload split, meaning the first payload part holder MUST be placed
at the first place in the corresponding link object. Sizes MUST NOT be omitted
and MUST be a real object payload size in bytes.

| Field | Type | Description |
| ----- | ---- | ----------- |
| children | MeasuredObject | Full list of the "child" object descriptors. |
   
### Message Link.MeasuredObject

Object ID with its object's payload size.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | ObjectID | Object ID. |
| size | uint32 | Object size in bytes. |
     
