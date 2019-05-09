#!/bin/bash -l

#SBATCH -p short
#SBATCH --nodes=3
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:20:00
#SBATCH --job-name=spark-test

##########################################################
# PBS version was pulled from here:                      #
#   https://www.dursi.ca/post/spark-in-hpc-clusters.html #
##########################################################

# Get names of allocated nodes
nodes=($( scontrol show hostnames $SLURM_NODELIST ))
nnodes=${#nodes[@]}
last=$(( $nnodes - 1 ))

# Move to directory where job was submitted from
cd $SLURM_WORKING_DIR

# Assign location to Spark home var
export SPARK_HOME=/rhome/jhayes/shared/pkgs/spark/2.4.0-bin-hadoop2.7
# Log into first node and start master Spark process
ssh ${nodes[0]}.ib.int.bioinfo.ucr.edu "module load java/8u45; cd ${SPARK_HOME}; ./sbin/start-master.sh"
sparkmaster="spark://${nodes[0]}:7077"

# Assign location to scratch var
SCRATCH=~/bigdata/Projects/spark/
# Create work directory
mkdir -p ${SCRATCH}/work
# Remove old logs, if they exist
rm -f ${SCRATCH}/work/nohup*.out

# On each node, start Spark worker
for i in $( seq 0 $last ); do
        ssh ${nodes[$i]}.ib.int.bioinfo.ucr.edu "cd ${SPARK_HOME}; module load java/8u45; nohup ./bin/spark-class org.apache.spark.deploy.worker.Worker ${sparkmaster} &> ${SCRATCH}/work/nohup-${nodes[$i]}.out" &
done

# Remove old results, if it exists
rm -rf ${SCRATCH}/wordcounts

# Create Spark Python code to be worked
cat > sparkscript.py <<EOF
from pyspark import SparkContext

sc = SparkContext(appName="wordCount")
file = sc.textFile("${SCRATCH}/moby-dick.txt")
counts = file.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a+b)
counts.saveAsTextFile("${SCRATCH}/wordcounts")
EOF

# Load proper version of Java
module load java/8u45

# Submit spark job
${SPARK_HOME}/bin/spark-submit --master ${sparkmaster} sparkscript.py
# For more infor regarding running Spark in parallel, refer to the following:
# https://spoddutur.github.io/spark-notes/distribution_of_executors_cores_and_memory_for_spark_application.html

# Stop Spark master process
ssh ${nodes[0]}.ib.int.bioinfo.ucr.edu "module load java/8u45; cd ${SPARK_HOME}; ./sbin/stop-master.sh"
# Stop worker process
for i in $( seq 0 $last ); do
    # This kills all java processes, maybe better if we killed specific process IDs?
    ssh ${nodes[$i]}.ib.int.bioinfo.ucr.edu "killall java"
    done
wait

