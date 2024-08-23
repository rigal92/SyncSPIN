#!/bin/sh
PORTO=/run/user/1001/gvfs/smb-share:server=porto.univ-lyon1.fr,share=home$/riccardo.galafassi


#dry runs to see if we are deleting some stuff in teh target
#NEEDED????

# echo "Checking for files to be delited in the destination folder..."
# echo "Reading Teaching folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Teaching/ $PORTO/Documents/Teaching | grep "^deleting"
# echo "Reading Bibliography folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Bibliography/ $PORTO/Documents/Bibliography| grep "^deleting"
# echo "Reading Phd folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Phd/ $PORTO/Documents/Phd| grep "^deleting"
# echo "Reading Routines folder:"
# rsync -avn --delete /home/rgalafassi/Routines/ $PORTO/Routines| grep "^deleting"
# echo "Reading Templates folder:"
# rsync -avn --delete /home/rgalafassi/Templates/ $PORTO/Templates| grep "^deleting"

#Ask for confirmation before applying the changes
echo "Do you want to confirm the backup process? (y)"
read CICCIO
if [ $CICCIO = "y" ] 
then 
    #actual runs
    rsync -av --delete /home/rgalafassi/Documents/Bibliography/ $PORTO/Documents/Bibliography
    rsync -av --delete /home/rgalafassi/Documents/Phd/ $PORTO/Documents/Phd
    rsync -av --delete /home/rgalafassi/Documents/Teaching/ $PORTO/Documents/Teaching
	rsync -av --exclude='myPy/exps' --delete /home/rgalafassi/Routines/ $PORTO/Routines
	rsync -av --delete /home/rgalafassi/Templates/ $PORTO/Templates| grep "^deleting"


else
    echo "No changements have been made. Exiting."
fi
