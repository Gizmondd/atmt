infile=$1
outfile=$2
lang=$3

# Reverse BPE, detruecase and detokenize
sed 's/@@ //g' $infile | perl moses_scripts/detruecase.perl | perl moses_scripts/detokenizer.perl -q -l $lang > $outfile