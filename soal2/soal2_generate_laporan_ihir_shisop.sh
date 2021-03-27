#!/bin/bash

export LC_ALL=C

#nomor 2A
awk '
BEGIN {
  OFS='\t'
}
{
  profit=(($NF/($(NF-3)-$NF))*100)
 
  #max default menjadi 0

  if (profit>=max){
 	max=profit
 	id=$1
  }
}
END{
  printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%\n\n",id,max)
}
' Laporan-TokoShiSop.tsv >> hasil.txt

#nomor 2B
awk '
BEGIN{
  FS='\t'
}
{
  if($2~"-2017-" && $10~"Albuquerque")
  a[$7]
}
END {
  printf("Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n")

  for (costumer in a)
  {
 	  printf("%s\n",costumer)
  }
}
' Laporan-TokoShiSop.tsv >> hasil.txt
