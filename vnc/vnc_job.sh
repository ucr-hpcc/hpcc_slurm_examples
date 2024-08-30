#!/bin/bash

sbatch -o 'vnc_job-%j.out' -p epyc -c 4 --time 2:00:00 --wrap='vncserver -fg'

