# instructions for making myth json annotations
# prerequisite: 
#   1. download the board publications 
#   2. csv file named grouplist containing mapping of sosol user name
#      to group members one row per member format: sosolusername,membername
git clone https://github.com/perseids-project/hypothesis-client
cd hypothesis-client
# make sure to clear out any old directories
rm -fr annotations.output
rm -fr annotations.fixed
rm -fr myth
mkdir myth
# replace downloadfilename with the name of the downloaded zip file
unzip downloadfilename myth
find myth/approved -name "*.xml" > list
find myth/finalizing -name "*.xml" >> list
scripts/makelist.pl < list > annotations
bundle exec rake transform["annotations","annotations.output"]
find annotations.output -name "*.json" > list2
bundle exec rake transformformyth["list2","grouplist","annotations.fixed"]
# this zip file should be unzipped in the joth data directory
# (joth bare data directory is cloned from https://github.com/perseids-client-apps-joth)
# and then run python sort.py
zip -j annotations_for_gapvis.zip `find annotations.fixed -name "*.json"`
# this zip file should be unzipped in the git repo  in the pdljann collection directory 
zip annotations_for_git.zip `find annotations.fixed -name "*.json"`

