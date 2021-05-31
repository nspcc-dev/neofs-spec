\newpage
# Reputation model

NeoFS reputation system is a subsystem for calculating trust in a node. It is based on a reputation model for assessing trust, which is, in turn, based on the EigenTrust algorithm designed for peer-to-peer reputation management.

The [EigenTrust](http://ilpubs.stanford.edu:8090/562/1/2002-56.pdf) algorithm is built on the concept of transitive trust: if peer `i` trusts any peer `j`, it will also trust the peers that `j` trusts.

The Subject of trust assessment
: is the one who calculates trust.

The Object of trust assessment
: is the one whose trust is being calculated.
