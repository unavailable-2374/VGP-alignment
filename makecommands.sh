#!/usr/bin/env bash
# gen_wfmash_cmds.sh
# 用法：
#   ./gen_wfmash_cmds.sh samples.list > run_all.sh
#   bash run_all.sh
#   # 或者并行运行（注意：run_all.sh 开头包含 mkdir -p 行，不影响）：
#   # parallel -j 10 < run_all.sh

set -euo pipefail

LIST_FILE="${1:-samples.list}"   # 单列列表文件，每行是样本基名（无后缀）
WFMASH="/work/10779/shuocao2374/stampede3/wfmash/build/bin/wfmash"
THREADS=112
PROFILE="ani50-2"
#BLOCK="50m"

if [[ ! -s "$LIST_FILE" ]]; then
  echo "找不到列表文件或为空：$LIST_FILE" >&2
  exit 1
fi

mapfile -t NAMES < <(grep -v '^[[:space:]]*$' "$LIST_FILE" | grep -v '^[[:space:]]*#')

for ((i=0; i<${#NAMES[@]}; i++)); do
  for ((j=0; j<${#NAMES[@]}; j++)); do
    [[ $i -eq $j ]] && continue
    target="${NAMES[i]}"
    query="${NAMES[j]}"
pair="${target}_${query}"
printf "%s\n" "srun -N1  -c 112 --mem=0 --exclusive bash -lc 'set -eEuo pipefail ; [[ -f status/${pair}.ok ]] && echo \"[SKIP] ${pair} already done\" && exit 0; rm -f status/${pair}.{no,ok,map.ok,aln.ok}; trap \"touch status/${pair}.no\" ERR; trap \"touch status/${pair}.no; exit 130\" SIGINT SIGTERM; /usr/bin/time -f \"%C\n%Us user %Ss system %P cpu %es total %MKb max memory\" -o \"times/${pair}.${PROFILE}.map.txt\" \"$WFMASH\" -t ${THREADS} -Y \"#\" -n 1 -p ${PROFILE} \"${target}.fna.gz\" \"${query}.fna.gz\" -m > \"pafs/${pair}.${PROFILE}.map.paf\" 2> \"logs/${pair}.${PROFILE}.map.log\"; touch \"status/${pair}.map.ok\"; /usr/bin/time -f \"%C\n%Us user %Ss system %P cpu %es total %MKb max memory\" -o \"times/${pair}.${PROFILE}.aln.txt\" \"$WFMASH\" -t ${THREADS} -Y \"#\" -n 1 -p ${PROFILE} \"${target}.fna.gz\" \"${query}.fna.gz\" -i \"pafs/${pair}.${PROFILE}.map.paf\" > \"pafs/${pair}.${PROFILE}.aln.paf\" 2> \"logs/${pair}.${PROFILE}.aln.log\"; touch \"status/${pair}.aln.ok\"; touch \"status/${pair}.ok\"'"
  done
done
