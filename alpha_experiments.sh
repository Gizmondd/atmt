for alpha in $(seq 0.0 0.1 1.0);
do
    python translate_beam.py --checkpoint-path checkpoints_asg4/checkpoint_best.pt --data data_asg4/prepared_data --beam-size 4 --alpha $alpha --output alpha_results/output_alpha_$alpha

    sh postprocess_asg4.sh alpha_results/output_alpha_$alpha alpha_results/output_alpha_$alpha en

    echo test with alpha value $alpha >> alpha_results/bleu_scores.txt
    cat alpha_results/output_alpha_$alpha.postprocessed | python -m sacrebleu data_asg4/raw_data/test.en >> alpha_results/bleu_scores.txt
done