sh preprocess_experiment_data.sh

python train.py --data experiment/prepared_data --cuda True --save-dir bpe

python translate.py --data experiment/prepared_data --cuda True --checkpoint-path bpe/checkpoint_best.pt --output bpe/test.txt

sh postprocess.sh bpe/test.txt bpe/test.txt en

echo "BPE model" >> output.txt
cat bpe/test.txt | sacrebleu experiment/raw_data/test.en >> output.txt