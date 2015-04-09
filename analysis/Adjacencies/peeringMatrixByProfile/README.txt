Steps to generate peering matrix by profile:

1) peeringMatrixByProfile.sh: generates the peering matrix, ordering ASes by profile (order file based on profile spreadsheet). Hashes (#) are used as profile separators, so that a horizontal line can be plotted to separate members by profile
2) profile_separator.sh: insert marks to identify different profiles
3) removeZeros.sh: remove zero-only lines
4) connectivityScale.sh: creates connectivity scale as the last column
5) generatePlt.sh: generates the gnuplot file

The script runPeeringMatrix.sh can be used to run all of the above programs in a sequence
