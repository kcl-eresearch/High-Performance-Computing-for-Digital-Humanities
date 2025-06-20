#!/bin/bash
#SBATCH --job-name=squares_numba
#SBATCH --partition=cpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH -t 0-0:02 # time (D-HH:MM)

# Load any required modules
module load python/3.11.6-gcc-13.2.0

# Activate virtual environment
source numba_venv/bin/activate

python squares_numba.py