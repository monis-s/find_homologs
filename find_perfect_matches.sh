#!/bin/bash

# Check the number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: ./find_perfect_matches.sh <query file> <subject file> <output file>"
    exit 1
fi

# Assign arguments to variables
query_file="$1"
subject_file="$2"
output_file="$3"

# Run BLAST with custom output format
# Using 'std qlen slen' to get standard fields plus query length and subject length
blastn -query "$query_file" -subject "$subject_file" -task blastn-short -outfmt "6 std qlen slen" -out temp_blast_output.txt

# Check for errors in BLAST command
if [ $? -ne 0 ]; then
    echo "An error occurred while running BLAST."
    exit 1
fi

# Filter for perfect matches and write them to the output file
# $3 is the identity percentage, $4 is alignment length, $13 is query length, $14 is subject length
awk '$3 == 100 && $4 == $13 { print }' temp_blast_output.txt > "$output_file"


# Count the number of perfect matches
num_perfect_matches=$(wc -l < "$output_file")
echo "Number of perfect matches: $num_perfect_matches"

# Remove the temporary BLAST output file
rm temp_blast_output.txt
