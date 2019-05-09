#!/bin/bash

# Check Arguments
#EXPECTED_ARGS=1
#E_BADARGS=65
#
#if [ $# -ne $EXPECTED_ARGS ]
#then
#  echo "Usage: `basename $0` USERNAME"
#  exit $E_BADARGS
#fi

source /etc/profile.d/modules.sh
module load slurm/19.05.0

# Not sure where to place this, but...we need this to set minimum limits
#sacctmgr add qos gpu
#sacctmgr modify QOS gpu set MinTRESPerJob=gres/gpu=1
#sacctmgr modify qos set flags=DenyOnLimit where name=gpu
#sacctmgr add qos highmem
#sacctmgr modify QOS highmem set MinTRESPerJob=mem=100g
#sacctmgr modify qos set flags=DenyOnLimit where name=highmem

# Set BASE MAXCPU and group offsets
declare -A CPUMAP
MAXCPU=512
CPUMAP['stajichlab']=$(($MAXCPU+(3*64)))
CPUMAP['girkelab']=$(($MAXCPU+(2*64)))
CPUMAP['wmalab']=$(($MAXCPU+(4*64)))
CPUMAP['koeniglab']=$(($MAXCPU+(4*64)))
CPUMAP['greaneylab']=$(($MAXCPU+(8*64)))
CPUMAP['statsdept']=$((4*64))
# Robert Allen requested a temporary increase for jobs that require 288 procs, INDIVIDUAL LIMIT WAS REMOVED
#CPUMAP['rallenlab']=$((4*64))

# External labs (non-UC) get only %50 of maximum CPUs
CPUMAP['ayoublab']=$(($MAXCPU/2))
CPUMAP['baolab']=$(($MAXCPU/2))
CPUMAP['bohonaklab']=$(($MAXCPU/2))
CPUMAP['castaneralab']=$(($MAXCPU/2))
CPUMAP['columbuslab']=$(($MAXCPU/2))
CPUMAP['fisherlab']=$(($MAXCPU/2))
CPUMAP['garblab']=$(($MAXCPU/2))
CPUMAP['reederlab']=$(($MAXCPU/2))
# Temporary increase of CPUs, until Jan 1st, 2019
#CPUMAP['seallab']=$(($MAXCPU/2))
CPUMAP['waterslab']=$(($MAXCPU/2))

# Trial accounts are severly limited
CPUMAP['magdylab']=$(($MAXCPU/16))

# Gather list of active users
#SUSERS=$(active_users.sh)
# Process list of users
SUSERS=$@

# Clear SSS cache, better if we do this on a per user/group basis instead of everything
#sudo sss_cache -E

# Iterate over all active users
for SUSER in $SUSERS; do
    # Flush SSS Cache
    NEW_SGROUP=$(ldapsearch -x uid="$SUSER" | grep -Po "^ou: \K\w+")    
    OlD_SGROUP=$(id -gn $SUSER)
    sudo sss_cache -u $SUSER && sudo sss_cache -g $NEW_SGROUP && sudo sss_cache -g $OlD_SGROUP

    # Determine primary group, and secondary groups of user
    SGROUP=$(id -gn $SUSER)
    if [[ -z $SGROUP ]]; then
        echo "User $SUSER does not have a primary group. $SGROUP"
        exit 666
    fi
    sudo sss_cache -g statsdept
    SSGROUP=$(id -Gn $SUSER | grep -o 'statsdept')

    if [[ ${SGROUP} == 'restricted' ]]; then
        continue
    fi

    # Create group account
    sacctmgr -i add account $SGROUP Organization=$SGROUP parent=ucr
    MAXCPU=512
    USER_MAXCPU=256
    HIGHMEM_MAXCPU=32
    if [[ ! -z ${CPUMAP[$SGROUP]} ]]; then
        # Check if group CPU quota is 256, meaning external account
        if [[ $((${CPUMAP[$SGROUP]}*2)) == $MAXCPU ]]; then
            USER_MAXCPU=$(($USER_MAXCPU/2))
            HIGHMEM_MAXCPU=$(($HIGHMEM_MAXCPU/2))
        fi
        # Check if group CPU quota is 16, meaning trial account
        if [[ $((${CPUMAP[$SGROUP]}*16)) == $MAXCPU ]]; then
            USER_MAXCPU=$(($USER_MAXCPU/16))
            HIGHMEM_MAXCPU=$(($HIGHMEM_MAXCPU/16))
        fi
        MAXCPU=${CPUMAP[$SGROUP]}
    fi
    sacctmgr -i modify account name=$SGROUP set grptres=cpu=$MAXCPU
    sacctmgr -i modify account name=$SGROUP set MaxSubmitJobs=5000
    sacctmgr -i modify account name=$SGROUP set GrpTRES=gres/gpu=8
    
    # These don't work, can't limit based on group per partition this way
    #sacctmgr -i modify account name=$SGROUP partition=batch set grptres=cpu=512
    #sacctmgr -i modify account name=$SGROUP partition=highmem set grptres=cpu=64
    #sacctmgr -i modify account name=$SGROUP partition=intel set grptres=cpu=64
    #sacctmgr -i modify account name=$SGROUP partition=gpu set grptres=cpu=32

    # Create user account, this account is too many levels deep
    #sacctmgr -i add account $SUSER parent=$SGROUP
    #sacctmgr -i delete account $SUSER

    # Create and set admin user, if applicable
    if [[ "$SUSER" == "jhayes" || "$SUSER" == "forsythc" ]]; then
        # Create admin user
	    sacctmgr -i add user $SUSER DefaultAccount=$SGROUP Partitions=debug,batch,highmem,gpu,intel,short,$SGROUP
        sacctmgr -i modify user $SUSER set AdminLevel=Administrator
        sacctmgr -i modify user name=$SUSER partition=debug set grptres=cpu=$USER_MAXCPU,mem=1048576
    elif [[ "$SGROUP" == "statsdept" ]]; then
        # Create limited department based user
        sacctmgr -i add user $SUSER DefaultAccount=$SGROUP Partitions=$SGROUP
        sacctmgr -i modify user name=$SUSER partition=statsdept set grptres=cpu=8,mem=16384
    elif [[ "$SSGROUP" == "statsdept" ]]; then
        sacctmgr -i delete user $SUSER
        sacctmgr -i add user $SUSER DefaultAccount=$SGROUP Partitions=batch,highmem,gpu,intel,short,$SGROUP,$SSGROUP
        sacctmgr -i modify user name=$SUSER partition=statsdept set grptres=cpu=8,mem=16384
    else
        # Create normal user
        sacctmgr -i delete user $SUSER

        sacctmgr -i add user $SUSER DefaultAccount=$SGROUP Partitions=batch,highmem,gpu,intel,short,$SGROUP 
    fi

    #Set intel,short paritions for rallenlab (requested more than 256 cores), their users do not have individual limits.
    #
    # Commented in case of a need for specific users needed a core limit raise, here is an example:
    #if [[ "$SGROUP" == "rallenlab" ]] || ([[ "$SGROUP" == "agroup" ]] && [[ "$SUSER" == "auser" ]]); then
    #
    if [[ "$SGROUP" == "rallenlab" ]]; then
        sacctmgr -i modify user name=$SUSER partition=intel set grptres=cpu=-1,mem=1048576
        sacctmgr -i modify user name=$SUSER partition=short set grptres=cpu=-1,mem=1048576
    else
        # Set intel partition
        sacctmgr -i modify user name=$SUSER partition=intel set grptres=cpu=$USER_MAXCPU,mem=1048576
        # Set short partition
        sacctmgr -i modify user name=$SUSER partition=short set grptres=cpu=$USER_MAXCPU,mem=1048576
    fi
    
    # Set batch partition
    sacctmgr -i modify user name=$SUSER partition=batch set grptres=cpu=$USER_MAXCPU,mem=1048576

    # Set highmem partition
    sacctmgr -i modify user name=$SUSER partition=highmem set grptres=cpu=$HIGHMEM_MAXCPU,mem=1048576
    sacctmgr -i modify user name=$SUSER partition=highmem set qos=highmem
    sacctmgr -i modify user name=$SUSER partition=highmem set DefaultQOS=highmem

    # Set gpu partition
    sacctmgr -i modify user name=$SUSER partition=gpu set qos=gpu
    sacctmgr -i modify user name=$SUSER partition=gpu set DefaultQOS=gpu

    # Set short partition
    sacctmgr -i modify user name=$SUSER partition=short set qos=short
    sacctmgr -i modify user name=$SUSER partition=short set DefaultQOS=short

done
