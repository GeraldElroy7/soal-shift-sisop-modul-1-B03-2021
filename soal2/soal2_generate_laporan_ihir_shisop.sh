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
  printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%\n",id,max)
}
' Laporan-TokoShiSop.tsv >> hasil.txt

#nomor 2B
awk '
BEGIN{
  OFS='\t'
}
{
  if($2 -eq "-2017-" && $10 -eq "Albuquerque")
  a[$7]++
}
END{
  echo -e "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"

  for (costumer in a)
  {
 	print customer
  }
}
' Laporan-TokoShiSop.tsv >> hasil.txt
