#!/bin/sh
#PBS -N test_job
#PBS -l nodes=1,walltime=01:00:00
#PBS -q batch

date
sleep 60
hostname
