for beam_size in {1..15}
do
    # python translate_beam.py --checkpoint-path checkpoints_asg4/checkpoint_best.pt --data data_asg4/prepared_data --beam-size $beam_size --output bsize_results/output_bsize_$beam_size

    # sh postprocess_asg4.sh bsize_results/output_bsize_$beam_size bsize_results/output_bsize_$beam_size en

    echo test with beam size $beam_size >> bsize_results/bleu_scores.txt
    cat bsize_results/output_bsize_$beam_size.postprocessed | python -m sacrebleu data_asg4/raw_data/test.en >> bsize_results/bleu_scores.txt
done