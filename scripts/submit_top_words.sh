#! /bin/bash -l

#SBATCH --job-name=top_words
#SBATCH --partition=cpu
#SBATCH --reservation=cpu_introduction
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH -t 0-0:10 # time (D-HH:MM)

module load python/3.11.6-gcc-13.2.0
source top_words_env/bin/activate

python /datasets/hpc_training/DH-RSE/scripts/top_words.py /datasets/hpc_training/DH-RSE/data/paradise-lost.txt 20