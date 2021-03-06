#!/bin/bash

export_dir="export"

mkdir -p "${export_dir}/data"
cp -fR AnalizePictures $export_dir
cp -fR image-processing $export_dir
cp run.sh $export_dir
cp download.sh $export_dir

for data in $( ls data/ ); do
	if [ -d "data/${data}" ]; then 
		mkdir "${export_dir}/data/${data}"
		cp data/${data}/*.json "${export_dir}/data/${data}"
	else
		cp data/${data} "${export_dir}/data/"
	fi
done;
zip -r p2-tuma-stopinsek-jsons.zip ${export_dir}/*
rm -R $export_dir
