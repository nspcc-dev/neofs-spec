## Storage metrics
\label{sec:Reports}

Every storage node should track taken storage by every container is serves. Statistics are sent to Container contract which, in turn, calculates total sum for every container, billing information (see \nameref{sec:Incentive}), and summary for every user. Storage nodes are free not to send any updates if no storage changes have happened since the last report.

Container contract has API for fetching actual values e.g. `GetNodeReportSummary`, `GetReportByNode`, `GetBillingStatByNode`, etc. This values can be treated as a general NeoFS state metrics. 

The number of reports per epoch is limited, and metrics should not be considered as up-to-date state; there is always some delay.
