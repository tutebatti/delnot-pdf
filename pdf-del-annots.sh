#!/bin/bash

###########################
#						     
#	Cleans pdfs of annotations		
#			                          
#  1) pdf is uncompressed,			  
#  2) stripped of annotations,                    
#  3) and compressed again			 
#			                         
###########################

# Check if file is a pdf file

mtype=$(file --mime-type -b "$1")

if ! echo $mtype | grep -q pdf ; then
	echo "The provided file in not a pdf. Script is aborted."
	exit 0
fi

# 1) pdf is uncompressed

echo "Pdf-file $1 is being uncompressed." 

pdftk "$1" output ${1%.*}_uc.pdf uncompress

# 2) uncompressed pdf is stripped of annotations

echo "All annotations in the file are being deleted." 

LANG=C sed -n '/^\/Annots/!p' ${1%.*}_uc.pdf > ${1%.*}_uc_stripped.pdf

# 3) stripped pdf is compressed again

echo "Result is saved as ${1#.pdf}_stripped.pdf ."

pdftk ${1%.*}_uc_stripped.pdf output ${1%.*}_stripped.pdf compress

echo "Temporary files are deleted."

rm ${1%.*}_uc.pdf

rm ${1%.*}_uc_stripped.pdf

read -p "Do you want to delete the original pdf-file? - Input YES ist required! - " delconform

if [ "$delconform" == "YES" ]

# delete original file if input = "YES"

	then
		rm "$1"

	else
		echo "Original pdf $1 is not deleted."

fi

echo "Done!"

exit 0
