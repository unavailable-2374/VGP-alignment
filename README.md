# VGP Genome Alignment Pipeline

A large-scale genomic alignment pipeline for processing Vertebrate Genomes Project (VGP) assemblies using wfmash on high-performance computing clusters.

## Overview

This pipeline performs all-vs-all pairwise genome alignments across 582 vertebrate genome assemblies from the VGP project. It uses [wfmash](https://github.com/waveygang/wfmash) for efficient sequence alignment and is designed to run on SLURM-managed HPC systems.

## Features

- **Large-scale processing**: Handles 582 genome assemblies (>338,000 pairwise comparisons)
- **HPC optimized**: Designed for distributed execution on SLURM clusters
- **Fault tolerance**: Job status tracking and automatic resume capability
- **Resource monitoring**: Memory and timing statistics collection
- **Organized output**: Structured directory layout for alignment results

## Repository Structure

```
.
├── makecommands.sh         # Command generation script
├── launchy.sh             # SLURM job submission script
├── run_pylauncher.py      # Python execution manager
├── vgp.fa.list           # List of genome assembly files
├── genome_sizes.tsv      # Genome metadata with sizes
└── command/              # Generated command files
    ├── vgp_part1.txt
    ├── vgp_part2.txt
    └── ...
```

## Prerequisites

- **wfmash**: Sequence alignment tool
- **SLURM**: Workload manager
- **Python**: With pylauncher module
- **HPC cluster**: With sufficient compute resources

## Usage

### 1. Generate Alignment Commands

Create all pairwise alignment commands from your genome list:

```bash
./makecommands.sh vgp.fa.list > all_commands.sh
```

### 2. Submit to SLURM

Submit the job to your HPC cluster:

```bash
sbatch --nodes=32 launchy.sh command_file.txt
```

### 3. Monitor Progress

Check job status files in the `status/` directory:
- `.ok` - Job completed successfully
- `.no` - Job failed
- `.map.ok` - Mapping phase completed
- `.aln.ok` - Alignment phase completed

## Configuration

### HPC Settings (SLURM)

- **Nodes**: 32
- **CPUs per task**: 112
- **Memory**: Exclusive node access
- **Time limit**: 48 hours
- **Partition**: spr (configurable)

### wfmash Parameters

- **Threads**: 112 per job
- **Profile**: ani50-2 (50% ANI threshold)
- **Output format**: PAF (Pairwise Alignment Format)

## Output Structure

The pipeline creates organized output directories:

```
pafs/     # PAF alignment files
logs/     # Standard error logs
times/    # Performance statistics
status/   # Job status tracking
```

## Data Requirements

- **Input genomes**: 582 compressed FASTA files (.fna.gz)
- **Total comparisons**: ~338,000 pairwise alignments
- **Storage**: Substantial space required for alignment outputs

## Performance

- **Execution time**: Up to 48 hours on 32 nodes
- **Scalability**: Designed for hundreds of genomes
- **Fault tolerance**: Automatic job resumption
- **Resource monitoring**: Memory and CPU usage tracking

## Troubleshooting

### Common Issues

1. **Job failures**: Check `.no` status files and corresponding logs
2. **Resource limits**: Adjust SLURM parameters in `launchy.sh`
3. **Missing dependencies**: Ensure wfmash and pylauncher are available
4. **Storage space**: Monitor disk usage in output directories

### Resume Failed Jobs

The pipeline automatically skips completed jobs based on status files. To restart:

```bash
# Remove failed status files
rm status/*.no

# Resubmit the job
sbatch --nodes=32 launchy.sh command_file.txt
```

## Citation

If you use this pipeline in your research, please cite:

- **wfmash**: The underlying alignment tool
- **Vertebrate Genomes Project**: Source of genome assemblies
- Any relevant publications from your analysis

## License

This project is available under standard academic use terms. Please respect the licenses of underlying tools (wfmash, pylauncher) and data sources (VGP).

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with clear description

## Support

For issues related to:
- **Pipeline scripts**: Open an issue in this repository
- **wfmash**: See the [wfmash documentation](https://github.com/waveygang/wfmash)
- **HPC systems**: Contact your local system administrators