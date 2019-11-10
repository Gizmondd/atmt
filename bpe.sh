sh preprocess_experiment_data.sh

python train.py --data experiment/prepared_data --cuda True

python translate.py --data experiment/prepared_data --cuda True

sh postprocess.sh model_translations.txt model_translations.postprocessed.txt en

echo "BPE model" >> output.txt
cat model_translations.postprocessed.txt | sacrebleu experiment/raw_data/test.en >> output.txt