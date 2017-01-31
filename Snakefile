RAWDATA_DIR = '/staging/as/skchoudh/dna/ENCODE_idr_20Jan_2017'
OUT_DIR = '/staging/as/skchoudh/rna/ENCODE_idr_20Jan_2017'
MOCA_CFG = '/home/cmb-panasas2/skchoudh/software_frozen/moca.cfg'

workdir: OUT_DIR

from itertools import chain
from os.path import join
import glob

SAMPLES = glob.glob('{}/*.bed'.format(RAWDATA_DIR), recursive=True)
SAMPLES = [sample.replace('.bed','') for sample in SAMPLES]

rule all:
    input:
        expand('{sample}/moca_output/moca_plots/moca_Phylop_1.pdf')

rule run_moca:
    input: RAWDATA_DIR+ '/{sample}.bed'
    output: '{sample}/moca_output/moca_plots/moca_Phylop_1.pdf'
    params:
        out_dir = '{sample}/moca_output'
    shell:
        r'''
        source activate moca_encode && moca -g hg19 -c {MOCA_CFG} --oc {params.out_dir} --cores 24
        '''
