#!/bin/bash
#SBATCH --job-name=pylauncher_example
#SBATCH --partition=spr
#SBATCH --output=%x.o%j
#SBATCH --error=%x.e%j
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=112
#SBATCH --nodes=32
#SBATCH --exclusive
#SBATCH --time=48:00:00

# note: must specify --nodes=N on command line
# and --cpus-per-task=N on command line

export LAUNCHER_SCHED=dynamic

cmdfile=$1

module load python
module load pylauncher

mkdir pafs logs times status
python run_pylauncher.py "$cmdfile"
#python -c "from pylauncher import ClassicLauncher; ClassicLauncher('"$cmdfile"')"
