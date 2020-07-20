#!/bin/bash

sbatch -o 'vnc_job-%j.out' -p short,batch -c 4 --time 2:00:00 --wrap='vncserver -fg'

