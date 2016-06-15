
set -e

export image_name=bvberkum/munin-server
#export dckr_name=${hostname}-munin-server

export scriptdir=$(dirname $(which dckr))
. $(which dckr)

dckr_build


echo build $image_name

