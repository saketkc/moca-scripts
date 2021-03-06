RAWDATA_DIR = '/staging/as/skchoudh/dna/ENCODE_idr_20Jan_2017'
OUT_DIR = '/staging/as/skchoudh/rna/ENCODE_idr_20Jan_2017'
MOCA_CFG = '/home/cmb-panasas2/skchoudh/software_frozen/moca.cfg'

workdir: OUT_DIR

from itertools import chain
from os.path import join
import glob

SAMPLES = glob.glob('{}/**/*.bed'.format(RAWDATA_DIR), recursive=True)
SAMPLES = [sample.replace('.bed','').replace(RAWDATA_DIR+'/','') for sample in SAMPLES]

rule all:
    input:
        expand('{sample}/moca_output/moca_plots/moca_PhyloP_1.png', sample=SAMPLES)

rule run_pipe:
    input:
        bed= RAWDATA_DIR+ '/{sample}.bed',
        assembly= RAWDATA_DIR+ '/{sample}.assembly',

    output: '{sample}/moca_output/meme_out/logo1.png'
    threads: 24
    params:
        out_dir = '{sample}/moca_output',
        flank_motif = 5,
        slop_length = 50
    run:
        genome = open(input.assembly).read().strip()
        shell('source activate moca_encode && moca find_motifs -i {input.bed} -g {genome}'
              ' -c {MOCA_CFG} -o {params.out_dir}'
              ' --slop-length {params.slop_length}'
              ' --flank-motif {params.flank_motif}'
              ' --cores {threads}'
              ' --show-progress')
