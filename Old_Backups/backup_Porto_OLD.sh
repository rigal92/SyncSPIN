#!/bin/sh
#dry runs to see if we are deleting some stuff in teh target

#NEEDED????

# echo "Checking for files to be delited in the destination folder..."
# echo "Reading Teaching folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Teaching/ /mnt/Porto/Documents/Teaching | grep "^deleting"
# echo "Reading Bibliography folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Bibliography/ /mnt/Porto/Documents/Bibliography| grep "^deleting"
# echo "Reading Phd folder:"
# rsync -avn --delete /home/rgalafassi/Documents/Phd/ /mnt/Porto/Documents/Phd| grep "^deleting"
# echo "Reading Routines folder:"
# rsync -avn --delete /home/rgalafassi/Routines/ /mnt/Porto/Routines| grep "^deleting"
# echo "Reading Templates folder:"
# rsync -avn --delete /home/rgalafassi/Templates/ /mnt/Porto/Templates| grep "^deleting"

#Ask for confirmation before applying the changes
echo "Do you want to confirm the backup process? (y)"
read CICCIO
if [ $CICCIO = "y" ] 
then 
    #actual runs
    rsync -av --delete /home/rgalafassi/Documents/Bibliography/ /mnt/Porto/Documents/Bibliography
    rsync -av --delete /home/rgalafassi/Documents/Phd/ /mnt/Porto/Documents/Phd
    rsync -av --delete /home/rgalafassi/Documents/Teaching/ /mnt/Porto/Documents/Teaching
	rsync -av --delete --exclude='myPy/exps' /home/rgalafassi/Routines/ /mnt/Porto/Routines
	rsync -av --delete /home/rgalafassi/Templates/ /mnt/Porto/Templates| grep "^deleting"


else
    echo "No changements have been made. Exiting."
fi
