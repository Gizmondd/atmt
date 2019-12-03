for gamma in $(seq 0 1 10);
do
    python translate_beam.py --checkpoint-path checkpoints_asg4/checkpoint_best.pt --data data_asg4/prepared_data --beam-size 4 --alpha 0.6 --nbest 3 --gamma $gamma --output gamma_results/output_gamma_$gamma

     sh postprocess_asg4.sh gamma_results/output_gamma_$gamma gamma_results/output_gamma_$gamma en
done