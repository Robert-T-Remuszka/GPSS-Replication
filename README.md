# GPSS-Replication
My replication of "Bartik Instruments: What, When, Why, and How" by Paul Goldsmith-Pinkham, Isaac Sorkin and Henry Swift.

# Setup Instructions
1. Download the official replication package at [Open ICPSR](https://www.openicpsr.org/openicpsr/project/117405/version/V1/view).
2. Rename the downloaded directory to `"GPSS-Replication-ICPSR"`.

# File Descriptions
1. [PrepareRotembergData.do](PrepareRotembergData.do) prepares the data provided in the GPSS replication package for replicating summary table 1 in the paper. This code is largely identical to `"make_rotemberg_summary_BAR.do"` in the ICPSR replication package. I add some annotations regarding what is happening in the code.
2. [script.jl](script.jl) calculates the Rotemberg weights. This is very similar to the Mata commands in the `"bartik_weight.ado"` file provided in the ICPSR replication package. I also replicate summary table 1 in the paper.
