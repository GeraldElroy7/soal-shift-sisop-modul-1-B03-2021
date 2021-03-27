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
name_num=1
for((counter=1; counter<=23; counter++))
do
  if [ $name_num -le 9 ]
  then
	wget -O Koleksi_0$name_num.jpg -a Foto.log https://loremflickr.com/320/240/kitten
	find_same 0$name_num
  else
	wget -O Koleksi_$name_num.jpg -a Foto.log https://loremflickr.com/320/240/kitten
	find_same $name_num
  fi
  let name_num=$name_num+1
done