#!/bin/bash

if [ $# -ne 1 ]
then 
	echo "specify master/worker"
	exit 1
fi
case $1 in
	master)
		BB_DIR=bbot_master
		BB_TYPE=MASTER
		echo "$BB_TYPE";;
	worker)
		BB_DIR=bbot_worker
		BB_TYPE=WORKER
		echo "$BB_TYPE";;
	*)
	echo "only master/ worker supported for first argument"
	exit 2
	;;
esac
echo $BB_DIR
ROOT_DIR=`pwd`

if [ ! -d $BB_DIR ] ; then 
    
   mkdir $BB_DIR
   cd $BB_DIR

   virtualenv sandbox
   source sandbox/bin/activate

   echo "setting up bb $BB_TYPE on python "
   which python

   # installation
   if [ "$BB_TYPE" = "MASTER" ]
   then
      pip install buildbot
      pip install buildbot-www
      pip install buildbot-console-view
      pip install buildbot-waterfall-view
      pip install buildbot-grid-view

      #create the master
      buildbot create-master master
      #copy cfg file
      cp -dpvf $ROOT_DIR/master.cfg master/master.cfg
   else 
      pip install buildbot-worker
   fi
  
   cd ..
   CUR_DIR=`pwd`
   echo "current directory: $CUR_DIR"
else
  echo "directory already exists"
fi

