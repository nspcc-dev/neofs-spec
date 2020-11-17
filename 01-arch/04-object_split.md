## Large objects split

NeoFS has a limit on the maximal physically stored single object size. If there
is a large object exceeding that `MaxObjectSize`, it will be split into a series
of smaller objects logically linked together.

For each part of the original object's payload a separate object with own
`ObjectID` will be created. The large object will not be physically present in
the system, but it will be reconstructed from the object parts when requested.

All objects participating int the split have the `Split` headers set. Depending
on the place in the split hierarchy it has different field combinations. There
are four possible cases:

* First part \
  First part object only has `split_id` set, as there is no more information
  known at this point

* Middle parts \
  Middle parts have information about the previous part in `previous` field
  additionally to `split_id`

* Last part \
  At this point all the information about object under split is known. Hence
  last part contains not only `split_id` and `previous` fields, but also
  `ObjectID` of the original large object in `parent` field, signed `ObjectID`
  in `parent_signature` and original object's `Header` in `parent_header`.

* Link object \
  There are special "Link objects" that have the same common `split_id`, do not
  have any payload, but contain original object's `ObjectID` in `parent` field,
  it's signature in `parent_signature`, original object's `Header` in
  `parent_header` and the list of all object parts with payload in repeated
  `children` field. Link objects help to speed up the large object
  reconstruction and `HEAD` requests processing. If Link object is lost, the
  original large object still will be reconstructed from part-objects, but it
  will require more actions from NeoFS nodes.

All of the split hierarchy objects may be physically stored on different nodes.
During reconstruction at first the link object or the last part object will be
found. If it's a HEAD request, the link object or the last part object will have
all the information required to return original large object's HEAD response.
For GET request, the payload will be taken from part objects listed in
`split.children` header. As they are ordered, it will be possible to start
streaming the payload as soon as the first part object becomes available. If Link
object is lost, some additional time will be spent on reconstructing the list
from `split.previous` header fields.

If the whole payload is available, large object may be split at client side
using local tools like `neofs-cli`. In this case the resulting object set will
be signed with user's key. Such split type can be called "Static split".

When large object's payload is not fully available right away or it is too big
to be split locally, the object upload can be started in a Session with other
NeoFS node and be streamed in PUT operation part by part. Object parts will be
automatically created as soon as payload hits the MaxObjectSize limit. In this
case the resulting object set will be signed with session key signed by user's
key. Such split type can be called "Dynamic split".
