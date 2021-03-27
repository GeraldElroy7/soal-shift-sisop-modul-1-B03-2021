#!/bin/bash

find_same(){
	for((cek=1; cek<name_num; cek++))
	do
		if [ $cek -le 9 ]
		then
			cmp Koleksi_$1.jpg Koleksi_0$cek.jpg
			res_cmp=$?
			if [ $res_cmp -eq 0 ]
			then
		  	   rm Koleksi_$1.jpg
		  	   let name_num=$name_num-1
		 	   break
			fi
		else
			cmp Koleksi_$1.jpg Koleksi_$cek.jpg
			res_cmp=$?
			if [ $res_cmp -eq 0 ]
			then
		  	   rm Koleksi_$1.jpg
		  	   let name_num=$name_num-1
		 	   break
			fi
		fi
	done
}
make_func(){
	now=$(date +"%d-%m-%Y")
	mkdir $1_$now
	name_num=1
	
	for((counter=1; counter<=23; counter++))
	do
	    if [ $name_num -le 9 ]
	    then
		wget -O Koleksi_0$name_num.jpg -a Foto.log $2
		find_same 0$name_num
  	    else
		wget -O Koleksi_$name_num.jpg -a Foto.log $2
		find_same $name_num
 	    fi
  	    let name_num=$name_num+1
	done
	mv Koleksi_* $1_$now && mv Foto.log $1_$now
}

yday=$(date -d yesterday +"%d-%m-%Y")
ls Kucing_$yday

find_res=$?
if [ $find_res -ne 0 ]
then
	make_func Kucing https://loremflickr.com/320/240/kitten
else
	make_func Kelinci https://loremflickr.com/320/240/bunny
fi
