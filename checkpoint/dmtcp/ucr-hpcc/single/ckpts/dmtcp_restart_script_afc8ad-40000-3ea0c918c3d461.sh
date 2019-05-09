#!/bin/bash

set -m # turn on job control

#This script launches all the restarts in the background.
#Suggestions for editing:
#  1. For those processes executing on the localhost, remove
#     'ssh <hostname> from the start of the line.
#  2. If using ssh, verify that ssh does not require passwords or other
#     prompts.
#  3. Verify that the dmtcp_restart command is in your path on all hosts,
#     otherwise set the dmt_rstr_cmd appropriately.
#  4. Verify DMTCP_COORD_HOST and DMTCP_COORD_PORT match the location of
#     the dmtcp_coordinator. If necessary, add
#     'DMTCP_COORD_PORT=<dmtcp_coordinator port>' after
#     'DMTCP_COORD_HOST=<...>'.
#  5. Remove the '&' from a line if that process reads STDIN.
#     If multiple processes read STDIN then prefix the line with
#     'xterm -hold -e' and put '&' at the end of the line.
#  6. Processes on same host can be restarted with single dmtcp_restart
#     command.


check_local()
{
  worker_host=$1
  unset is_local_node
  worker_ip=$(gethostip -d $worker_host 2> /dev/null)
  if [ -z "$worker_ip" ]; then
    worker_ip=$(nslookup $worker_host | grep -A1 'Name:' | grep 'Address:' | sed -e 's/Address://' -e 's/ //' -e 's/	//')
  fi
  if [ -z "$worker_ip" ]; then
    worker_ip=$(getent ahosts $worker_host |grep "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+ *STREAM" | cut -d' ' -f1)
  fi
  if [ -z "$worker_ip" ]; then
    echo Could not find ip-address for $worker_host. Exiting...
    exit 1
  fi
  ifconfig_path=$(which ifconfig)
  if [ -z "$ifconfig_path" ]; then
    ifconfig_path="/sbin/ifconfig"
  fi
  output=$($ifconfig_path -a | grep "inet addr:.*${worker_ip} .*Bcast")
  if [ -n "$output" ]; then
    is_local_node=1
  else
    is_local_node=0
  fi
}


pass_slurm_helper_contact()
{
  LOCAL_FILES="$1"
  # Create temp directory if needed
  if [ -n "$DMTCP_TMPDIR" ]; then
    CURRENT_TMPDIR=$DMTCP_TMPDIR/dmtcp-`whoami`@`hostname`
  elif [ -n "$TMPDIR" ]; then
    CURRENT_TMPDIR=$TMPDIR/dmtcp-`whoami`@`hostname`
  else
    CURRENT_TMPDIR=/tmp/dmtcp-`whoami`@`hostname`
  fi
  if [ ! -d "$CURRENT_TMPDIR" ]; then
    mkdir -p $CURRENT_TMPDIR
  fi
  # Create files with SLURM environment
  for CKPT_FILE in $LOCAL_FILES; do
    SUFFIX=${CKPT_FILE%%.dmtcp}
    SLURM_ENV_FILE=$CURRENT_TMPDIR/slurm_env_${SUFFIX##*_}
    echo "DMTCP_SRUN_HELPER_ADDR=$DMTCP_SRUN_HELPER_ADDR" >> $SLURM_ENV_FILE
  done
}


usage_str='USAGE:
  dmtcp_restart_script.sh [OPTIONS]

OPTIONS:
  --coord-host, -h, (environment variable DMTCP_COORD_HOST):
      Hostname where dmtcp_coordinator is running
  --coord-port, -p, (environment variable DMTCP_COORD_PORT):
      Port where dmtcp_coordinator is running
  --hostfile <arg0> :
      Provide a hostfile (One host per line, "#" indicates comments)
  --ckptdir, -d, (environment variable DMTCP_CHECKPOINT_DIR):
      Directory to store checkpoint images
      (default: use the same directory used in previous checkpoint)
  --restartdir, -d, (environment variable DMTCP_RESTART_DIR):
      Directory to read checkpoint images from
  --tmpdir, -t, (environment variable DMTCP_TMPDIR):
      Directory to store temporary files (default: $TMDPIR or /tmp)
  --no-strict-checking:
      Disable uid checking for checkpoint image. This allows the
      checkpoint image to be restarted by a different user than the one
      that created it.  And suppress warning about running as root.
      (environment variable DMTCP_DISABLE_STRICT_CHECKING)
  --interval, -i, (environment variable DMTCP_CHECKPOINT_INTERVAL):
      Time in seconds between automatic checkpoints
      (Default: Use pre-checkpoint value)
  --coord-logfile PATH (environment variable DMTCP_COORD_LOG_FILENAME
              Coordinator will dump its logs to the given file
  --help:
      Print this message and exit.'


ckpt_timestamp="Thu Aug 23 17:00:13 2018"

remote_shell_cmd="ssh"

coord_host=$DMTCP_COORD_HOST
if test -z "$DMTCP_COORD_HOST"; then
  coord_host=i11
fi

coord_port=$DMTCP_COORD_PORT
if test -z "$DMTCP_COORD_PORT"; then
  coord_port=46172
fi

checkpoint_interval=$DMTCP_CHECKPOINT_INTERVAL
if test -z "$DMTCP_CHECKPOINT_INTERVAL"; then
  checkpoint_interval=60
fi
export DMTCP_CHECKPOINT_INTERVAL=${checkpoint_interval}

if [ $# -gt 0 ]; then
  while [ $# -gt 0 ]
  do
    if [ $1 = "--help" ]; then
      echo "$usage_str"
      exit
    elif [ $# -ge 1 ]; then
      case "$1" in
        --coord-host|--host|-h)
          coord_host="$2"
          shift; shift;;
        --coord-port|--port|-p)
          coord_port="$2"
          shift; shift;;
        --coord-logfile)
          DMTCP_COORD_LOGFILE="$2"
          shift; shift;;
        --hostfile)
          hostfile="$2"
          if [ ! -f "$hostfile" ]; then
            echo "ERROR: hostfile $hostfile not found"
            exit
          fi
          shift; shift;;
        --restartdir|-d)
          DMTCP_RESTART_DIR=$2
          shift; shift;;
        --ckptdir|-d)
          DMTCP_CKPT_DIR=$2
          shift; shift;;
        --tmpdir|-t)
          DMTCP_TMPDIR=$2
          shift; shift;;
        --no-strict-checking)
          noStrictChecking="--no-strict-checking"
          shift;;
        --interval|-i)
          checkpoint_interval=$2
          shift; shift;;
        *)
          echo "$0: unrecognized option '$1'. See correct usage below"
          echo "$usage_str"
          exit;;
      esac
    elif [ $1 = "--help" ]; then
      echo "$usage_str"
      exit
    else
      echo "$0: Incorrect usage.  See correct usage below"
      echo
      echo "$usage_str"
      exit
    fi
  done
fi

dmt_rstr_cmd=/bigdata/operations/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/dmtcp/2.5.2/bin/dmtcp_restart
which $dmt_rstr_cmd > /dev/null 2>&1 || dmt_rstr_cmd=dmtcp_restart
which $dmt_rstr_cmd > /dev/null 2>&1 || echo "$0: $dmt_rstr_cmd not found"
which $dmt_rstr_cmd > /dev/null 2>&1 || exit 1

# Number of hosts in the computation = 1
# Number of processes in the computation = 2

# SYNTAX:
#  :: <HOST> :<MODE>: <CHECKPOINT_IMAGE> ... :<REMOTE SHELL CMD>
# Host names and filenames must not include ':'
# At most one fg (foreground) mode allowed; it must be last.
# 'maybexterm' and 'maybebg' are set from <MODE>.
worker_ckpts='
 :: i11 :bg: ckpts/ckpt_sleep_afc8ad-135000-5b7f4a85.dmtcp ckpts/ckpt_bash_afc8ad-40000-3ea0c9317bade2.dmtcp : ssh
'

# Check for resource manager
ibrun_path=$(which ibrun 2> /dev/null)
if [ ! -n "$ibrun_path" ]; then
  discover_rm_path=$(which dmtcp_discover_rm)
  if [ -n "$discover_rm_path" ]; then
    eval $(dmtcp_discover_rm -t)
    srun_path=$(which srun 2> /dev/null)
    llaunch=`which dmtcp_rm_loclaunch`
    if [ $RES_MANAGER = "SLURM" ] && [ -n "$srun_path" ]; then
      eval $(dmtcp_discover_rm -n "$worker_ckpts")
      if [ -n "$DMTCP_DISCOVER_RM_ERROR" ]; then
          echo "Restart error: $DMTCP_DISCOVER_RM_ERROR"
          echo "Allocated resources: $manager_resources"
          exit 0
      fi
      export DMTCP_REMLAUNCH_NODES=$DMTCP_REMLAUNCH_NODES
      bound=$(($DMTCP_REMLAUNCH_NODES - 1))
      srun_nnodes=0
      srun_ntasks=0
      for i in $(seq 0 $bound); do
        eval "val=\${DMTCP_REMLAUNCH_${i}_SLOTS}"
        #skip allocated-but-not-used nodes (dmtcp_discover_rm returns 0)
        test "$val" = "0" && continue
        srun_nnodes=$(( $srun_nnodes + 1 ))
        export DMTCP_REMLAUNCH_${i}_SLOTS="$val"
        bound2=$(($val - 1))
        for j in $(seq 0 $bound2); do
          srun_ntasks=$(( $srun_ntasks + 1 ))
          eval "ckpts=\${DMTCP_REMLAUNCH_${i}_${j}}"
          export DMTCP_REMLAUNCH_${i}_${j}="$ckpts"
        done
      done
      if [ "$DMTCP_DISCOVER_PM_TYPE" = "HYDRA" ]; then
        export DMTCP_SRUN_HELPER_SYNCFILE=`mktemp ./tmp.XXXXXXXXXX`
        rm $DMTCP_SRUN_HELPER_SYNCFILE
        dmtcp_srun_helper -r $srun_path "$llaunch"
        if [ ! -f $DMTCP_SRUN_HELPER_SYNCFILE ]; then
          echo "Error launching application"
          exit 1
        fi
        # export helper contact info
        . $DMTCP_SRUN_HELPER_SYNCFILE
        pass_slurm_helper_contact "$DMTCP_LAUNCH_CKPTS"
        rm $DMTCP_SRUN_HELPER_SYNCFILE
        dmtcp_restart --join-coordinator --coord-host $DMTCP_COORD_HOST --coord-port $DMTCP_COORD_PORT $DMTCP_LAUNCH_CKPTS
      else
        DMTCP_REMLAUNCH_0_0="$DMTCP_REMLAUNCH_0_0 $DMTCP_LAUNCH_CKPTS"
        $srun_path --nodes=$srun_nnodes --ntasks=$srun_ntasks "$llaunch"
      fi
      exit 0
    elif [ $RES_MANAGER = "TORQUE" ]; then
      #eval $(dmtcp_discover_rm "$worker_ckpts")
      #if [ -n "$new_worker_ckpts" ]; then
      #  worker_ckpts="$new_worker_ckpts"
      #fi
      eval $(dmtcp_discover_rm -n "$worker_ckpts")
      if [ -n "$DMTCP_DISCOVER_RM_ERROR" ]; then
          echo "Restart error: $DMTCP_DISCOVER_RM_ERROR"
          echo "Allocated resources: $manager_resources"
          exit 0
      fi
      arguments="PATH=$PATH DMTCP_COORD_HOST=$DMTCP_COORD_HOST DMTCP_COORD_PORT=$DMTCP_COORD_PORT"
      arguments=$arguments" DMTCP_CHECKPOINT_INTERVAL=$DMTCP_CHECKPOINT_INTERVAL"
      arguments=$arguments" DMTCP_TMPDIR=$DMTCP_TMPDIR"
      arguments=$arguments" DMTCP_REMLAUNCH_NODES=$DMTCP_REMLAUNCH_NODES"
      bound=$(($DMTCP_REMLAUNCH_NODES - 1))
      for i in $(seq 0 $bound); do
        eval "val=\${DMTCP_REMLAUNCH_${i}_SLOTS}"
        arguments=$arguments" DMTCP_REMLAUNCH_${i}_SLOTS=\"$val\""
        bound2=$(($val - 1))
        for j in $(seq 0 $bound2); do
          eval "ckpts=\${DMTCP_REMLAUNCH_${i}_${j}}"
          arguments=$arguments" DMTCP_REMLAUNCH_${i}_${j}=\"$ckpts\""
        done
      done
      pbsdsh -u "$llaunch" "$arguments"
      exit 0
    fi
  fi
fi


worker_ckpts_regexp=\
'[^:]*::[ \t\n]*\([^ \t\n]\+\)[ \t\n]*:\([a-z]\+\):[ \t\n]*\([^:]\+\)[ \t\n]*:\([^:]\+\)'

worker_hosts=$(\
  echo $worker_ckpts | sed -e 's/'"$worker_ckpts_regexp"'/\1 /g')
restart_modes=$(\
  echo $worker_ckpts | sed -e 's/'"$worker_ckpts_regexp"'/: \2/g')
ckpt_files_groups=$(\
  echo $worker_ckpts | sed -e 's/'"$worker_ckpts_regexp"'/: \3/g')
remote_cmd=$(\
  echo $worker_ckpts | sed -e 's/'"$worker_ckpts_regexp"'/: \4/g')

if [ ! -z "$hostfile" ]; then
  worker_hosts=$(\
    cat "$hostfile" | sed -e 's/#.*//' -e 's/[ \t\r]*//' -e '/^$/ d')
fi

localhost_ckpt_files_group=

num_worker_hosts=$(echo $worker_hosts | wc -w)

maybejoin=
if [ "$num_worker_hosts" != "1" ]; then
  maybejoin='--join-coordinator'
fi

for worker_host in $worker_hosts
do

  ckpt_files_group=$(\
    echo $ckpt_files_groups | sed -e 's/[^:]*:[ \t\n]*\([^:]*\).*/\1/')
  ckpt_files_groups=$(echo $ckpt_files_groups | sed -e 's/[^:]*:[^:]*//')

  mode=$(echo $restart_modes | sed -e 's/[^:]*:[ \t\n]*\([^:]*\).*/\1/')
  restart_modes=$(echo $restart_modes | sed -e 's/[^:]*:[^:]*//')

  remote_shell_cmd=$(echo $remote_cmd | sed -e 's/[^:]*:[ \t\n]*\([^:]*\).*/\1/')
  remote_cmd=$(echo $remote_cmd | sed -e 's/[^:]*:[^:]*//')

  maybexterm=
  maybebg=
  case $mode in
    bg) maybebg='bg';;
    xterm) maybexterm=xterm;;
    fg) ;;
    *) echo "WARNING: Unknown Mode";;
  esac

  if [ -z "$ckpt_files_group" ]; then
    break;
  fi

  new_ckpt_files_group=""
  for tmp in $ckpt_files_group
  do
      if  [ ! -z "$DMTCP_RESTART_DIR" ]; then
        tmp=$DMTCP_RESTART_DIR/$(basename $tmp)
      fi
      new_ckpt_files_group="$new_ckpt_files_group $tmp"
  done

tmpdir=
if [ ! -z "$DMTCP_TMPDIR" ]; then
  tmpdir="--tmpdir $DMTCP_TMPDIR"
fi

coord_logfile=
if [ ! -z "$DMTCP_COORD_LOGFILE" ]; then
  coord_logfile="--coord-logfile $DMTCP_COORD_LOGFILE"
fi

  check_local $worker_host
  if [ "$is_local_node" -eq 1 -o "$num_worker_hosts" == "1" ]; then
    localhost_ckpt_files_group="$new_ckpt_files_group $localhost_ckpt_files_group"
    continue
  fi
  if [ -z $maybebg ]; then
    $maybexterm /usr/bin/$remote_shell_cmd -t "$worker_host" \
      $dmt_rstr_cmd --coord-host "$coord_host" --cord-port "$coord_port"\
      $ckpt_dir --join-coordinator --interval "$checkpoint_interval" $tmpdir \
      $new_ckpt_files_group
  else
    $maybexterm /usr/bin/$remote_shell_cmd "$worker_host" \
      "/bin/sh -c '$dmt_rstr_cmd --coord-host $coord_host --coord-port $coord_port $coord_logfile\
      $ckpt_dir --join-coordinator --interval "$checkpoint_interval" $tmpdir \
      $new_ckpt_files_group'" &
  fi

done

if [ -n "$localhost_ckpt_files_group" ]; then
exec $dmt_rstr_cmd --coord-host "$coord_host" --coord-port "$coord_port" $coord_logfile \
  $ckpt_dir $maybejoin --interval "$checkpoint_interval" $tmpdir $noStrictChecking $localhost_ckpt_files_group
fi

#wait for them all to finish
wait
