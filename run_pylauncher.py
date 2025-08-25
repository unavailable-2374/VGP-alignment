#!/usr/bin/env python
# run_pylauncher.py

import sys
import os
from pylauncher import ClassicLauncher

nnodes = int(os.environ.get('SLURM_NNODES', 1))
ntasks_per_node = int(os.environ.get('SLURM_NTASKS_PER_NODE', 1))

os.environ['PYLAUNCHER_NPROCS'] = str(ntasks_per_node)

cmdfile = sys.argv[1]
launcher = ClassicLauncher(cmdfile, 
                          cores=ntasks_per_node,  # 每个节点的核心数
                          debug='job+host+task')   # 可选：调试信息
