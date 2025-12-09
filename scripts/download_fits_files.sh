#!/bin/bash
# TODO: using mArchiveExec to download files returns 400 Bad Request, so wget is used

default="rc.txt"
file=${1:-rc.txt}
echo "$file"

while IFS= read -r p;do
	name=`echo $p | cut -f 1 -d ' '`
	url=`echo $p | cut -f 2 -d ' ' | sed -e 's/^"//' -e 's/"$//'`
	#echo $name
	if [ ! -f $name ] ; then 
		echo "Downloading $name ..."
		wget $url -O $name
	fi
done < "$file"


#docker run -a stdout -a stderr --name montage2-fits-download -v $PWD:/workdir hyperflowwms/montage2-generator sh -c 'cd /workdir/data && mArchiveExec -d 1 1-images.tbl'
#docker run -a stdout -a stderr --name montage2-fits-download -v $PWD:/workdir hyperflowwms/montage2-generator sh -c 'cd /workdir/data && mArchiveExec -d 1 2-images.tbl'
#docker run -a stdout -a stderr --name montage2-fits-download -v $PWD:/workdir hyperflowwms/montage2-generator sh -c 'cd /workdir/data && mArchiveExec -d 1 3-images.tbl'
