# learning rate
python train.py --data baseline/prepared_data --cuda True --save-dir learning_rate --learning_rate 0.001
python translate.py --data baseline/prepared_data --checkpoint-path learning_rate/checkpoint_best.pt --output learning_rate/test.txt --cuda True
sh postprocess.sh learning_rate/test.txt learning_rate/test.txt en
cat learning_rate/test.txt | sacrebleu baseline/raw_data/test.en

# embed dim
python train.py --data baseline/prepared_data --cuda True --save-dir embed_dim --encoder-embed-dim 128 --decoder-embed-dim 128
python translate.py --data baseline/prepared_data --checkpoint-path embed_dim/checkpoint_best.pt --output embed_dim/test.txt --cuda True
sh postprocess.sh embed_dim/test.txt embed_dim/test.txt en
cat embed_dim/test.txt | sacrebleu baseline/raw_data/test.en

# hidden size
python train.py --data baseline/prepared_data --cuda True --save-dir hidden_size --encoder-hidden-size 128 --decoder-hidden-size 256
python translate.py --data baseline/prepared_data --checkpoint-path hidden_size/checkpoint_best.pt --output hidden_size/test.txt --cuda True
sh postprocess.sh hidden_size/test.txt hidden_size/test.txt en
cat hidden_size/test.txt | sacrebleu baseline/raw_data/test.en

# dropout
python train.py --data baseline/prepared_data --cuda True --save-dir dropout --encoder-dropout-in 0.2 --encoder-dropout-out 0.2 --decoder-dropout-in 0.2 --decoder-dropout-out 0.2
python translate.py --data baseline/prepared_data --checkpoint-path dropout/checkpoint_best.pt --output dropout/test.txt --cuda True
sh postprocess.sh dropout/test.txt dropout/test.txt en
cat dropout/test.txt | sacrebleu baseline/raw_data/test.en

# Combined training of hidden_size and dropout
python train.py --data baseline/prepared_data --cuda True --save-dir hyperparameter_combined --encoder-hidden-size 128 --decoder-hidden-size 256 --encoder-dropout-in 0.2 --encoder-dropout-out 0.2 --decoder-dropout-in 0.2 --decoder-dropout-out 0.2
python translate.py --data baseline/prepared_data --checkpoint-path hyperparameter_combined/checkpoint_best.pt --output hyperparameter_combined/test.txt --cuda True
sh postprocess.sh hyperparameter_combined/test.txt hyperparameter_combined/test.txt en
cat hyperparameter_combined/test.txt | sacrebleu baseline/raw_data/test.en