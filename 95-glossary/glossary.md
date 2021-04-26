\newpage
# Terms and definitions

Object
 : The immutable piece of data with a metadata in form of a set of key-value
 headers. Object has a globally unique identifier.

HRW
 : HRW stands for (Rendezvous
hashing)[https://en.wikipedia.org/wiki/Rendezvous_hashing]. It helps to achieve
3 goals:

1. Select nodes uniformly from the whole netmap.
This means that every node has a chance to be included in container nodes set.
2. Select nodes deterministically. Identical (netmap, storage policy) pair
results in the same placement set on every storage node.
3. Prioritize nodes providing better conditions.

Nodes having more space, better price or better rating are to be selected with
higher probability. Specific weighting algorithm is defined for NeoFS network as
a whole and is beyond scope of this document. See [NeoFS HRW
implementation](https://github.com/nspcc-dev/hrw) for details.


<!-- Here comes generated glossary. See glossaries LaTeX package. -->
<!-- https://www.overleaf.com/learn/latex/glossaries -->
<!-- http://tug.ctan.org/macros/latex/contrib/glossaries/glossariesbegin.pdf -->
<!-- See definitions in glossary.tex file -->

\printglossaries
