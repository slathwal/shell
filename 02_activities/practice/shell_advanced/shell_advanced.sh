#!/bin/bash

# Setup environment
# Unzip the dataset into the current directory
unzip dataset.zip

# Change directory into the folder containing the data package contents
cd dataset

# Count the number of files in the original folder
raw_file_count=$(find ./ -type f | wc -w)

# Print the current path to your working directory
pwd

# Make a new folder called "tidied_data"
mkdir tidied_data

# Take inventory
# 1. List the contents of the data folder
ls

#  2. List all the EEG files and write this list to a text file in the tidied_data folder named `eeg_inventory.txt`
ls eeg* > ./tidied_data/eeg_inventory.txt
ls eeg* | tee ./tidied_data/eeg_inventory.txt

#  3. Preview the first 8 lines of this file using the head command
head -n 8 ./tidied_data/eeg_inventory.txt

# 4. Double check visually - does the naming convention of the EEG files match `eeg_[subjectid]_[session].edf`
cat ./tidied_data/eeg_inventory.txt

# 5. Based on the eeg_inventory.txt file and the naming convention, generate a list of subject numbers and write it to a file named `subject_ids_from_eeg.txt`
cat tidied_data/eeg_inventory.txt | cut -c 5-8 | tee ./tidied_data/subject_ids_from_eeg.txt

# 6. Preview the first 8 lines of the subject numbers file
head -n 8 ./tidied_data/subject_ids_from_eeg.txt

# 7. Sort the `subject_ids_from_eeg.txt` file and write the output to `subject_ids_from_eeg_sorted.txt`
sort ./tidied_data/subject_ids_from_eeg.txt > ./tidied_data/subject_ids_from_eeg_sorted.txt

# 8. Preview the fist 8 lines of this file
head -n 8 ./tidied_data/subject_ids_from_eeg_sorted.txt

# 9. Let's double check: does each subject have multiple EEG files? Are their subject IDs duplicated?
# Yes

# 10. Create a unique list of subject IDs and write the output to `subject_ids.txt`. 
uniq ./tidied_data/subject_ids_from_eeg_sorted.txt ./tidied_data/subject_ids.txt

# 11. Preview the first 8 lines of this file
head -n 8 ./tidied_data/subject_ids.txt 

#12. For each subject, create a folder named after the subjectID in the tidied_data directory
for subject in $(cat ./tidied_data/subject_ids.txt)
do 
  mkdir ./tidied_data/$subject
done

# 13. Move all files relating to that subject into their respective directories
for subject in $(cat ./tidied_data/subject_ids.txt)
do
    mv *$subject* tidied_data/$subject/
done

# 14. Notice that all the notes files have not been named consistently. Rename all the note files to `[subjectid]_notes.txt` within each subject folder
for subject in $(cat ./tidied_data/subject_ids.txt)
do
    mv tidied_data/$subject/*notes*.txt "tidied_data/$subject/${subject}_notes.txt"
done

# Checking our work
# Generate a list of all files within all directories in tidied_data

for subject in $(cat ./tidied_data/subject_ids.txt)
do 
    find ./tidied_data/$subject -type f | wc -w
done
# Count the number of lines in the file list
sum=0
for subject in $(cat ./tidied_data/subject_ids.txt)
do 
    files=$(find ./tidied_data/$subject -type f | wc -w)
    sum=$((sum + $files))
done
echo "$sum"

# Do the file counts match?
if [ "$raw_file_count" -eq "$sum" ]; then
  echo "file counts in datasets and tidied_data are equal"
else
  echo "file counts in datasets and tidied_data are NOT equal"
fi
    



