# Normalize and tokenize training data
cat experiment/raw_data/train.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q > experiment/preprocessed_data/train.de.p

cat experiment/raw_data/train.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q > experiment/preprocessed_data/train.en.p

# Truecase
perl moses_scripts/train-truecaser.perl --model experiment/preprocessed_data/tm.de --corpus experiment/preprocessed_data/train.de.p

perl moses_scripts/train-truecaser.perl --model experiment/preprocessed_data/tm.en --corpus experiment/preprocessed_data/train.en.p

cat experiment/preprocessed_data/train.de.p | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.de > experiment/preprocessed_data/train.de 

cat experiment/preprocessed_data/train.en.p | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.en > experiment/preprocessed_data/train.en

# Normalize punctuation
cat experiment/raw_data/valid.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.de > experiment/preprocessed_data/valid.de

cat experiment/raw_data/valid.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.en > experiment/preprocessed_data/valid.en

cat experiment/raw_data/test.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.de > experiment/preprocessed_data/test.de

cat experiment/raw_data/test.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.en > experiment/preprocessed_data/test.en

cat experiment/raw_data/tiny_train.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.de > experiment/preprocessed_data/tiny_train.de

cat experiment/raw_data/tiny_train.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model experiment/preprocessed_data/tm.en > experiment/preprocessed_data/tiny_train.en

# BPE
subword-nmt learn-joint-bpe-and-vocab -i experiment/preprocessed_data/train.de experiment/preprocessed_data/train.en --write-vocabulary experiment/preprocessed_data/vocab.de experiment/preprocessed_data/vocab.en -s 20000 -o experiment/preprocessed_data/deen.bpe

for file in train tiny_train valid test
do
    for lang in de en
    do
        subword-nmt apply-bpe -i experiment/preprocessed_data/$file.$lang -o experiment/preprocessed_data/$file.$lang.bpe -c experiment/preprocessed_data/deen.bpe --vocabulary experiment/preprocessed_data/vocab.$lang --vocabulary-threshold 2

        rm experiment/preprocessed_data/$file.$lang

        mv experiment/preprocessed_data/$file.$lang.bpe experiment/preprocessed_data/$file.$lang
    done
done

rm experiment/preprocessed_data/train.de.p
rm experiment/preprocessed_data/train.en.p

python preprocess.py --target-lang en --source-lang de --dest-dir experiment/prepared_data/ --train-prefix experiment/preprocessed_data/train --valid-prefix experiment/preprocessed_data/valid --test-prefix experiment/preprocessed_data/test --tiny-train-prefix experiment/preprocessed_data/tiny_train --threshold-src 2 --threshold-tgt 2 --num-words-src 4000 --num-words-tgt 4000
