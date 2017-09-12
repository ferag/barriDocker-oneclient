#!/bin/bash
env
mkdir -p /onedata/input
mkdir -p /onedata/output

ONECLIENT_AUTHORIZATION_TOKEN="$INPUT_ONEDATA_TOKEN" PROVIDER_HOSTNAME="$INPUT_ONEDATA_PROVIDERS" oneclient --no_check_certificate --authentication token -o ro /onedata/input || exit 1
ONECLIENT_AUTHORIZATION_TOKEN="$OUTPUT_ONEDATA_TOKEN" PROVIDER_HOSTNAME="$OUTPUT_ONEDATA_PROVIDERS" oneclient --no_check_certificate --authentication token -o rw /onedata/output || exit 1

echo Start at $(date)

INPUTDIR="/onedata/input/$INPUT_ONEDATA_SPACE/$INPUT_PATH"
OUTPUTDIR="/onedata/output/$OUTPUT_ONEDATA_SPACE/$OUTPUT_PATH"

mkdir -p "$OUTPUTDIR" # create if it does not exists
TEMPW=$(mktemp -d --tmpdir=/ workspace.XXXXXXXXXX)

WORKDIR="$TEMPW"

echo "Hello ${HOSTNAME} ${date}" > test.txt

cp ./*.txt "$OUTPUTDIR"
cp ./*.inp "$OUTPUTDIR"
cp ./*.lga "$OUTPUTDIR"
cp ./*.lsp "$OUTPUTDIR"
cp ./*.lst "$OUTPUTDIR"

echo Output file: "$OUTPUTDIR"/"$OUTPUT_FILENAMES"

cd -

echo Cleaning temp workspace
rm -rf "$WORKDIR"/* && rm -rf "$WORKDIR"


echo End at $(date)

sleep 5

umount /onedata/input || exit 1
umount /onedata/output || exit 1
