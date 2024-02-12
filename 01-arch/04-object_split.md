## Large objects split

NeoFS has a limit on the maximal physically stored single object size. If there is a large object exceeding that `MaxObjectSize`, it will be split into a series of smaller objects that are logically linked together.

For each part of the original object's payload, a separate object with own `ObjectID` will be created. The large object will not be physically present in the system, but it will be reconstructed from the object parts when requested.

There are two active versions of the split objects, both are supported, but the second one is more flexible and support attributes-based ACL rules. The first one is kept for backward compatibility only. All objects participating in the split have the `Split` headers set. Depending on the place in the split hierarchy, it has different field combinations.

### Object Split V1

![Large object split V1](pic/object_split_all_v1)

* First part \
  First part object only has the `split_id` field set, as there is no more information known at this point

* Middle parts \
  Middle parts have information about the previous part in `previous` field in addition to the `split_id`

* Last part \
  At this point, all the information about the object under split is known. Hence, the last part contains not only the `split_id` and `previous` fields, but also the `ObjectID` of the original large object in its `parent` field, signed `ObjectID` in `parent_signature` and original object's `Header` in `parent_header`.

* Link object \
  There are special "Link objects" that have the same common `split_id`, do not have any payload, but contain original object's `ObjectID` in `parent` field, it's signature in `parent_signature`, original object's `Header` in `parent_header` and the list of all object parts with payload in repeated `children` field. Link objects help to speed up the large object reconstruction and `HEAD` requests processing. If Link object is lost, the original large object still will be reconstructed from its parts, but it will require more actions from NeoFS nodes.

### Object Split V2
\pagebreak

![Large object split V2](pic/object_split_all_v2)

* First part \
  First part object only has `parent_header` fields set. The parent header is not finished: since there is no information about payload, it cannot be measured, hashed and signed (also, no object ID can be assigned). However, it has all user information attached to the object (e.g. attributes), and plays the role of representative of the original object until all the parts are uploaded to the NeoFS.

* Middle parts \
  Middle parts have information about the previous part in `previous` field and the first one in the `first` field

* Last part \
  At this point, all the information about the object under split is known. Hence, the last part contains not only the `first` and `previous` fields, but also the `ObjectID` of the original large object in its `parent` field, signed `ObjectID` in `parent_signature` and original object's `Header` in `parent_header`.

* Link object \
  There are special "Link objects" that have the same common `first` field, but also contain original object's `ObjectID` in `parent` field, its signature in `parent_signature`, original object's `Header` in `parent_header` and a list of all the object parts' IDs paired with their sizes encoded in the payload. Link objects help to speed up the large object reconstruction and `HEAD` requests processing. If a Link object is lost, the original large object still will be reconstructed from its parts, but it will require more actions from NeoFS nodes.

All the split hierarchy objects may be physically stored on different nodes. During reconstruction, at first the link object or the last part object will be found. If it's a HEAD request, the link object or the last part object will have all the information required to return the original large object's HEAD response. For a GET request, the payload will be taken from part objects listed in the Link object's payload. As they are ordered, it will be possible to begin streaming the payload as soon as the first part object becomes available. If a Link object is lost, some additional time will be spent on reconstructing the list from `split.previous` header fields.

If the whole payload is available, a large object may be split on the client side using local tools like `neofs-cli`. In this case, the resulting object set will be signed with user's key. Such a split type can be called a "Static split".

There are attribute-based ACL rules in the NeoFS. Before the last part and the link object are created, the original object's parts should be validated according to the initial object's information about the original object.

When the large object's payload is not fully available right away, or it is too big to be split locally, the object upload can be started in a Session with another NeoFS node and be streamed in a PUT operation, part by part. Object parts will be automatically created as soon as the payload hits the MaxObjectSize limit. In this case, the resulting object set will be signed with a session key signed by user's key. This split type can be called a "Dynamic split".
