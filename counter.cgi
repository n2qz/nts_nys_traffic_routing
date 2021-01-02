#!/bin/ksh
# smj's no nonsense house.
loop=0                             # set the while counter.
while [ -f .lck ]                  # while the lock file exists,
do
 sleep 1                           # sleep 1.
 loop=`expr $loop + 1`             # then increment the counter.
 if [ "$loop" -gt "10" ]           # if it increments beyond 10,
  then rm -f .lck                  # clear the lock file.
 fi
done
touch -f .lck                      # create a new lock file.
count=`cat .cnt`                   # get the current count.
if [ "$count" = "" ]               # if its empty,
 then count=1                      # start the counter over.
 else count=`expr $count + 1`      # otherwise just increment
fi
echo $count > .cnt                 # write out the new count.
rm .lck                            # clear the lock
echo "Content-type: text/html\n\n" # make some html noise.
echo "[<font size=-2 color=ffcc00>$count</font>]"
