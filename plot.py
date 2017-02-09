OUT_DIR = '/media/dna/encode_plots/ENCODE_idr_20Jan_2017'
MOCA_CFG = '/home/saket/github/moca-scripts/moca.cfg.local'
from itertools import chain
import glob
import os

SAMPLES = glob.glob('{}/**/logo_rc*.png'.format(OUT_DIR), recursive=True)
DIRECTORIES = []
FIMO_SAMPLES = []
FIMO_RANDOM = []
CENTRIMO_SAMPLES = []
MOTIF_NUMBERS = []
TITLES = []
GENOMES = []

for sample in SAMPLES:
    sample = sample.replace('.png', '')
    motif_number = sample[-1]
    directory = os.path.dirname(sample)
    genome = open(directory.replace('/moca_output/meme_out', '').replace('encode_plots/', '')+'.assembly').read().strip()
    GENOMES.append(genome)
    DIRECTORIES.append(directory)
    FIMO_SAMPLES.append(os.path.join(directory, 'fimo_out_{}'.format(motif_number)))
    FIMO_RANDOM.append(os.path.join(directory, 'fimo_random_{}'.format(motif_number)))
    CENTRIMO_SAMPLES.append(directory.replace('meme_out', 'centrimo_out'))
    MOTIF_NUMBERS.append(int(motif_number))
    title = directory.split('/moca_output')[0].split('/')[-1]
    TITLES.append(title)


    for meme_dir, centrimo_dir, fimo_sample, fimo_random, motif_number, genome, title in zip(DIRECTORIES, CENTRIMO_SAMPLES, FIMO_SAMPLES, FIMO_RANDOM, MOTIF_NUMBERS, GENOMES, TITLES):
        out_dir = os.path.join(meme_dir.replace('meme_out', ''), 'moca_plots')
        print('source activate mocadev && moca plot --meme_dir {} --centrimo-dir {} --fimo-dir-sample {} --fimo-dir-control {} --flank-motif 5 --motif {} --oc {} -c {} -g {} --name {}'.format(meme_dir,
        centrimo_dir,
        fimo_sample,
        fimo_random,
        motif_number,
        out_dir,
        MOCA_CFG,
        genome,
        title))
