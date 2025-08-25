# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains scripts and tools for large-scale genomic alignment using wfmash for the Vertebrate Genomes Project (VGP). The project processes hundreds of genome assemblies in pairwise comparisons to generate alignment data.

## Key Files and Architecture

### Core Scripts
- `makecommands.sh` - Generates wfmash alignment commands for all pairwise genome comparisons
- `launchy.sh` - SLURM job script for distributed execution on HPC clusters  
- `run_pylauncher.py` - Python wrapper for pylauncher to manage parallel job execution

### Data Files
- `vgp.fa.list` - List of genome assembly filenames (582 genomes with .fna.gz extension)
- `genome_sizes.tsv` - Genome assembly metadata with sequence IDs and lengths
- `command/vgp_part*.txt` - Generated command files containing wfmash execution commands

### Workflow Architecture
1. **Command Generation**: `makecommands.sh` reads the genome list and generates all-vs-all pairwise alignment commands
2. **Job Submission**: `launchy.sh` submits SLURM jobs to HPC cluster with appropriate resource allocation
3. **Parallel Execution**: `run_pylauncher.py` manages distributed execution across multiple compute nodes
4. **Output Organization**: Results are organized into `pafs/`, `logs/`, `times/`, and `status/` directories

## Common Commands

### Generate alignment commands
```bash
./makecommands.sh vgp.fa.list > all_commands.sh
```

### Submit SLURM job for parallel execution
```bash
sbatch --nodes=32 launchy.sh command_file.txt
```

### Run with pylauncher directly
```bash
python run_pylauncher.py command_file.txt
```

## HPC Configuration

- **Target System**: TACC Stampede3 supercomputer
- **wfmash Path**: `/work/10779/shuocao2374/stampede3/wfmash/build/bin/wfmash`
- **Resource Requirements**: 32 nodes, 112 cores per node, exclusive access
- **Job Time Limit**: 48 hours
- **Alignment Profile**: ani50-2 (50% ANI threshold)

## Output Structure

The workflow creates several directories for organized output:
- `pafs/` - PAF alignment files from wfmash
- `logs/` - Standard error logs for each alignment job
- `times/` - Timing and memory usage statistics
- `status/` - Job status tracking files (.ok, .no, .map.ok, .aln.ok)

## Development Notes

- All genome filenames use double .fna.gz extension in commands (artifact from generation script)
- Commands include comprehensive error handling with trap statements
- Status files enable job resumption and duplicate work avoidance
- Memory and timing data collected for performance analysis