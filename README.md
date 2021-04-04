# soal-shift-sisop-modul-1-B03-2021

### Anggota Kelompok
1. Nur Putra Khanafi     05111940000020
2. Gerald Elroy Van Ryan 05111940000187
3. Husnan                05111940007002

## Soal 1

Pada soal 1, *user* diminta untuk membantu Ryujin untuk membuat laporan harian untuk aplikasi perusahaannya, *ticky*. Ada 2 laporan yang perlu dibuat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan **laporan penggunaan user** pada *ticky*. Soal ini tidak boleh dikerjakan menggunakan `AWK`.

### Cara Pengerjaan 1A

![1a](https://user-images.githubusercontent.com/65794806/113507651-6b16b400-957e-11eb-9717-8cba20e3ac3d.png)

*User* diminta untuk mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: `jenis log (ERROR/INFO)`, `pesan log`, dan `username` pada setiap baris lognya. Untuk mempermudah pekerjaannya, maka diperlukan **regex** dalam memeriksa satu per satu baris.

Kami memakai `grep` agar bisa mengambil kata/kalimat yang dicari per **line-nya**. Tambahkan juga `grep -o` agar dia **hanya** mencari kata/kalimat yang sudah di-filter (`-o`). 

Karena `(ERROR/INFO)` dimulai dengan huruf kapital E dan I, maka cukup cari kalimat yang mengandung `E|I`. `|` memiliki arti **atau**, jadi mencari tiap line yang mengandung huruf E atau I. 

Kami juga menambahkan `.*` pada *syntax*, agar karakter setelah huruf yang difilter juga ikut di-*print* hingga karakter terakhir pada line tersebut. Setelah itu, akhiri dengan file yang dituju, yaitu `syslog.log`

#### Output
![hasil1a](https://user-images.githubusercontent.com/65794806/113507655-75d14900-957e-11eb-8991-8edfa7d9df7c.png)

### Cara Pengerjaan 1B

![1b](https://user-images.githubusercontent.com/65794806/113507657-7cf85700-957e-11eb-8f54-031338d49123.png)

Pada soal ini, *user* diminta untuk menampilkan semua pesan **error** yang muncul beserta jumlah kemunculannya. Kami memakai `grep -o` lagi agar hanya mengambil karakter sesuai yang di-filter. Karena yang diminta hanya pesan yang **error**, maka yang di-*filter* cukup `"ERROR.*`. 

Karena yang diminta hanya pesan error-nya, maka **username** tidak diperlukan. Kami tambahkan:

```bash
cut -d "(" -f1
```

Arti dari *command* ini ialah mengambil semua karakter sebelum tanda "(", karena adanya *delimiter* (`-d`). Ketika *command* `cut` dilakukan, maka *field* sebelum *delimiter* akan dianggap `field 1`, maka dari itu ditambahkan `-f1` pada syntaxnya, agar hanya mengambil semua karakter sebelum "(".

Setelah itu, lakukan `sort` agar bisa melakukan `uniq`. `uniq` akan mengelompokkan karakter sesuai jenis **Error**-nya, sistemnya seperti `GROUP BY` pada SQL. Terakhir, tambahkan `-c` setelah `uniq` agar bisa dihitung/di-*count* berdasarkan jumlah kemunculannya pada file tersebut.

#### Output
![hasil1b](https://user-images.githubusercontent.com/65794806/113507666-85e92880-957e-11eb-9ef7-c024f373f40c.png)

### Cara Pengerjaan 1C

![1c](https://user-images.githubusercontent.com/65794806/113507670-8b467300-957e-11eb-8d5a-b56e15ce6bb0.png)

Pada 1C, *user* diminta untuk menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap *user*-nya.

*Command* `cut` digunakan kembali agar bisa mengambil karakter yang diinginkan pada setiap line.<br/>

```bash
cut -d "(" -f2 syslog.log | cut -d ")" -f1
```

Arti dari syntax ini ialah mengambil karakter **setelah** karakter "(". Agar bisa mengambil karakter setelah *delimiter*, maka menggunakan `-f2` atau *field two*. Lalu, difilter lagi untuk mengambil semua karakter sebelum ")" agar sisa yang terambil hanyalah *username*-nya.

`sort | uniq` juga ditambahkan pada *command* agar *username* dapat di-*grouping* sesuai karakternya.

```bash
while read line
```

Lalu, masuk ke dalam perulangan. Kami menggunakan *while* agar data dapat diiterasi untuk tiap linenya. `line` menjadi perwakilan untuk tiap username agar nanti dapat di-*print*.

Untuk setiap line-nya (dalam `while`), lakukan:

```bash
do
  e=$(grep -o "ERROR.*($line)" syslog.log | wc -l)
  i=$(grep -o "INFO.*($line)" syslog.log | wc -l)
  echo -e "$line,$i,$e"
done
```

Setiap kali berhasil ditemukan karakter `ERROR`, maka dihitung jumlah kemunculannya dengan `wc -l` dan dimasukkan ke variabel `e`. Jadi, nilai dari `e` adalah total kemunculan untuk tiap jenis `ERROR`. Begitu juga dengan `INFO` yang diinisiasikan pada variabel `i`.<br/>

Setelah `while` selesai dilakukan, maka *print* setiap username (`uniq`) beserta jumlah kemunculan INFO & ERROR-nya.

#### Output
![hasil1c](https://user-images.githubusercontent.com/65794806/113507673-939eae00-957e-11eb-8ce5-637d0564651b.png)

### Cara Pengerjaan 1D

![1d](https://user-images.githubusercontent.com/65794806/113507681-9ac5bc00-957e-11eb-91cb-120327c4e541.png)

Pada soal **1D**, *user* diminta untuk membuat daftar pesan error dan jumlah kemunculannya **diurutkan** berdasarkan jumlah kemunculan pesan error dari yang terbanyak.

Pesan **error** dapat dikelompokkan berdasarkan jenisnya. Ini adalah contoh kata yang mewakilkan setiap pesan **error** yang ada, seperti:

 - modified
 - permission
 - tried
 - timeout
 - exist
 - connection

Agar mudah untuk diiterasi, maka tiap *keyword* ini diinisiasikan sebagai sebuah variabel. Variabelnya ini nanti berisikan berapa kali jumlah kemunculan untuk tiap jenis pesan **error**. Contohnya sebagai berikut:

```bash
modified=$(grep "modified" syslog.log | wc -l)
```

Artinya, isi dari variabel `modified` adalah jumlah kemunculan kata *modified* pada `syslog.log` untuk tiap barisnya. Gunakan `grep` agar bisa mengambil karakter yang diinginkan, lalu tambahkan `wc -l` agar dihitung juga jumlah kemunculannya. Ini juga berlaku untuk pesan *error* lainnya.

Tambahkan juga *header* sebagai awalan dari file `error_message.csv` dengan syntax:

```bash
echo "Error,Count" > error_message.csv
```

Setelah semua variabel sudah mempunyai nilai, langkah terakhir adalah *print* semua jenis **error** beserta jumlah kemunculannya. Variabel tadi dipanggil dengan prefix `$`, contohnya adalah `$modified`.

Soal meminta untuk mengurutkan dari jumlah kemunculan pesan error yang terbanyak. Maka, lakukan syntax ini: 

```bash
sort -t"," -k2 -nr  >> error_message.csv
```

Agar dapat diurutkan, pisahkan kalimat `printf` tadi dengan *delimiter* ",". Jadi, karakter sebelum koma (pesan **error**) akan dianggap kolom pertama, dan setelah koma (jumlah kemunculan) akan dianggap sebagai kolom kedua. Lakukan *sorting* pada kolom kedua secara *descending* dengan *command* `-nr`, yang berarti *number reverse*.

Setelah semua *syntax* dilakukan, keluarkan outputnya ke file `error_message.csv`.

#### Output
![hasil1d](https://user-images.githubusercontent.com/65794806/113507686-a1ecca00-957e-11eb-9efc-730f05efbfde.png)

### Cara Pengerjaan 1E

![1e](https://user-images.githubusercontent.com/65794806/113507692-a74a1480-957e-11eb-8cbc-a7716db65afa.png)

Soal 1E dapat dikatakan sebagai lanjutan dari soal **1C**. Setelah semua informasi dari 1C didapat, maka buat outputnya ke dalam file `user_statistis.csv` dengan header **Username,INFO,ERROR** dan diurutkan berdasarkan *username* secara **ascending**.

Pertama kali, buat *header* yang diminta dengan *syntax* berikut : 

```bash
echo "Username,Info,Error" > user_statistic.csv
```

Artinya, karakter yang ada di dalam `echo` tersebut di-*print* di awal file `user_statistic.csv`.

Cara mencari karakter yang dicari juga sama persis dengan **1C**, cukup tambahkan `>> user_statistic.csv` pada akhir *syntax* agar output dapat muncul di file `user_statistic.csv`.

#### Output
![hasil1e](https://user-images.githubusercontent.com/65794806/113507699-afa24f80-957e-11eb-90f5-6924f4522614.png)

### Kendala Selama Pengerjaan
1. Awalnya, perlu mencari referensi yang banyak terlebih dahulu karena baru pertama kali menggunakan bahasa *Bash*.
2. Pada awalnya, cukup bingung untuk mengambil karakter pada tiap line karena tidak boleh menggunakan `awk`. Namun, akhirnya dari berbagai referensi, bisa menggunakan *command* `grep`.
3. Pada soal 1D, awalnya tidak tahu caranya untuk bisa *sorting* dalam bentuk kalimat karena belum ada pembatasnya. Akhirnya, baru tau adanya *delimiter* agar bisa memisahkan kalimat dengan pembatas yang diinginkan.

## Soal 2

### Cara Pengerjaan 2A

![2a_sisop](https://user-images.githubusercontent.com/57633103/113398288-8cce3a80-93c8-11eb-8cea-474a19d683c7.png)

Untuk mengetahui Row ID dan profit percentage terbesar maka menggunakan definisi dari Profit Percentage yaitu : `profit=(($NF/($(NF-3)-$NF))*100)`. 
`NF` yaitu kolom paling belakang, berdasarkan definisi tersebut kolomnya dihitung paling terakhir setelah itu mundur tiga setelah itu dikali seratus maka akan diketahui  profit percentage nya, Setelah itu masuk ke percabangan, jika  `profit>=max` maka yang paling besar akan ditampilkan ID nya beserta  profit percentage nya dan outputnya pada `hasil.txt`.

#### Output
![2a_sisop_output](https://user-images.githubusercontent.com/57633103/113399663-c2742300-93ca-11eb-864f-c77fe015e420.png)

### Cara Pengerjaan 2B

![2b](https://user-images.githubusercontent.com/64303057/113510159-99e35900-9583-11eb-968e-2f7c9be8e9ab.png)

Membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque. `if($2~"-2017-" && $10~"Albuquerque")` Setelah melalui percabangan maka akan diteruskan ke `a[$7]` yaitu terdapat nama-nama yang ada pada rentang tersebut, Setelah itu diiterasikan array tersebut `for (costumer in a)`, dan akan ditampilkan satu persatu isi dari array nya dan outputnya pada `hasil.txt`.

#### Output
![2b_sisop_output](https://user-images.githubusercontent.com/57633103/113399719-df105b00-93ca-11eb-97f5-6ee6c895e821.png)

### Cara Pengerjaan 2C

![2c](https://user-images.githubusercontent.com/64303057/113510176-b97a8180-9583-11eb-91fc-b48f5331dd90.png)

Membutuhkan segment customer dan jumlah transaksinya yang paling sedikit. Karena mencari yang paling sedikit, `min` diinisialisasikan menjadi `9999` yaitu angka paling maksimal, Setelah itu dilakukan iterasi `for(seg in c)` dan terdapat percabangan didalamnya `if(min > c[seg])`, maka akan terus dicari yang paling sedikit terus akan ditampilkan di `hasil.txt`.

#### Output
![hasil2c](https://user-images.githubusercontent.com/64303057/113510183-c1d2bc80-9583-11eb-8443-e81d569a1173.png)

### Cara Pengerjaan 2D

![2d](https://user-images.githubusercontent.com/64303057/113510243-1ece7280-9584-11eb-89a1-4516c510c627.png)

*User* diminta untuk mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut. Hampir sama dengan `2c` tetapi perbedaannya terdapat pada kolom, untuk `2c` menggunakan kolom `$8` sedangakan `2d` kolom `$13`.

Lalu, gunakanlah `NF` yaitu kolom paling belakang diinisialisasikan sebagai profit. Setelah itu jika `NR > 1` maka index nya bertambah sesuai profitnya. Beranjak ke `END` nya setelah diinisialisasi `min` ke angka paling besar, masuk ke iterasi `for(reg in c)`, jika `min > c[reg]` maka `min` nya akan berubah menjadi kecil agar ketemu angka paling kecilnya terus akan ditampilkan di `hasil.txt`.

#### Output
![hasil2d](https://user-images.githubusercontent.com/64303057/113510194-d3b45f80-9583-11eb-9e50-6efa0fec3d50.png)

### Cara Pengerjaan 2E

Output dari semua *code* soal 2 disimpan dalam file ***Hasil.txt***. Oleh karena itu pada akhir tiap *code* disertakan
```bash
Laporan-TokoShiSop.tsv >> hasil.txt
```


### Kendala Selama Pengerjaan
1. Sebelumnya pada soal 2C dan 2D batas yang digunakan kurang tepat sehingga tidak dapat menampilkan hasil

## Soal 3

Pada soal 3, *user* diminta untuk membantu Kuuhaku dalam *mendownload* 23 foto kucing atau kelinci dari link yang akan disimpan dalam folder dengan **penamaan tertentu** lalu di *zip* dan *unzip* sesuai **waktu yang ditentukan**.

### Cara Pengerjaan 3A

![CodeSoal3a](https://user-images.githubusercontent.com/65794806/113506097-4cf88600-9575-11eb-9499-f98bd922e61b.png)

*User* diminta untuk *mendownload* 23 foto kucing dari link *https://loremflickr.com/320/240/kitten* dengan penamaan file *Koleksi_01, Koleksi_02, dst* serta **menyimpan** log fotonya ke file *Foto.log*. Kemudian jika terdapat foto yang sama, maka foto tersebut akan di **hapus** dengan tidak perlu *mendownload* ulang foto lain.

Untuk melakukan aksi sebanyak 23 kali, maka digunakan *looping* 
```bash
for((counter=1; counter<=23; counter++))
do
  [ARGUMENT]
done
```

Untuk *mendownload* foto tersebut, kami menggunakan `wget -O [PENAMAAN_FILE] -a [FILE_LOG] [LINK]` agar dapat **menyimpan** foto dengan penamaan lain serta membuat file lognya. Pada penamaan file, dilakukan kondisi `if else` yaitu

```bash
if [ $name_num -le 9 ]
	[ARGUMENT]
else
	[ARGUMENT]
fi
```

yang mana jika foto tersimpan kurang dari 10, maka penamaan filenya adalah *Koleksi_0X* dan jika sudah 10 atau lebih, maka penamaan filenya adalah *Koleksi_X*. 

Kemudian, untuk mencari foto yang sama, kami menggunakan `cmp [FILE_1] [FILE_2]` yang mana akan membandingkan *byte* kedua file. Output dari fungsi tersebut disimpan dengan menggunakan `$?`. Jika hasilnya adalah 0, maka kedua file tersebut sama. Untuk menghapus file yang sama, kami menggunakan `rm [FILE]`

#### Output
![Output3a](https://user-images.githubusercontent.com/65794806/113506104-5e419280-9575-11eb-8e30-432f0dfba715.png)

### Cara Pengerjaan 3B

![Code3b](https://user-images.githubusercontent.com/65794806/113506313-a90fda00-9576-11eb-9713-892cdebb8fa0.png)

Kali ini, *user* diminta untuk **menjalankan** *script* pada soal sebelumnya yang mana hasilnya akan disimpan dalam folder. 

Untuk menjalankan *script soal3a*, kami perlu mengakses folder letak *script* tersebut. Oleh karena itu, digunakan `cd [Directory_Destination]`. Kemudian, *script* dijalankan dengan `bash soal3a.sh`

Untuk membuat foldernya, kami menggunakan
```bash
now=$(date +"%d-%m-%Y")
mkdir $now
```
Variabel `now` akan menyimpan nilai `date` tanggal pada waktu itu sehingga folder yang dibuat memiliki nama tanggal saat itu.

Terakhir, untuk menyimpan hasil *script soal3a*, semua file *Koleksi_* dan *Foto.log* dipindahkan dengan menggunakan
```bash
mv Koleksi_* $now && mv Foto.log $now
```

#### Output Bash 3b
![Output3b](https://user-images.githubusercontent.com/65794806/113506326-ca70c600-9576-11eb-9d64-6d83f988c44c.png)

### Crontab 3b
![CodeCron3b](https://user-images.githubusercontent.com/65794806/113506350-f68c4700-9576-11eb-836d-f5669ce949f9.png)

Untuk menjalankan *script soal3b* secara otomatis, kami menggunakan *crontab*.

- Pada argumen pertama `0`, memiliki arti pada menit ke 0
- Pada argumen kedua `20`, memiliki arti pada jam 20 atau 8 malam
- Pada argumen ketiga `1-31/7,2-31/4`, memiliki arti pada tiap tujuh hari dimulai pada tanggal 1 atau tiap 4 hari dimulai pada tanggal 2
- Pada argumen keempat dan kelima `* *`, memiliki arti bahwa tidak ada pengaturan waktu tertentu pada bulan dan nama hari

Dengan menuliskan *code* tersebut didalam `crontab -e`, maka *script soal3b* akan dijalankan secara otomatis jika semua argumen tersebut terpenuhi.


#### Output Crontab
***Setting waktu pada tanggal 22 jam 19.59 ke jam 20.00***
![OutputCron3b](https://user-images.githubusercontent.com/65794806/113506382-263b4f00-9577-11eb-9c3e-7869f51cf5b5.png)

### Cara Pengerjaan 3C
[*SOURCE CODE SOAL 3C*](https://github.com/GeraldElroy7/soal-shift-sisop-modul-1-B03-2021/blob/main/soal3/soal3c.sh)

Pada soal 3C, *user* diminta untuk *mendownload* foto kucing dan kelinci sesuai dengan *link* masing-masing secara bergantian pada hari yang berbeda yang mana hasilnya akan disimpan pada folder Kucing atau Kelinci.

Algoritma pengerjaan pada soal ini mirip dengan soal3a dengan tambahan beberapa variabel dan *action*.

Untuk menentukan foto mana yang akan *didownload*, perlu dilihat terlebih dahulu apakah ada folder dengan nama tanggal sebelumnya(kemarin) pada *directory*.

```bash
yday=$(date -d yesterday +"%d-%m-%Y")
ls Kucing_$yday

find_res=$?
if [ $find_res -ne 0 ]
then
	make_func Kucing https://loremflickr.com/320/240/kitten
else
	make_func Kelinci https://loremflickr.com/320/240/bunny
fi
```

Jika ada folder dengan nama Kucing, maka pada hari ini akan mendownload foto kelinci. Begitu juga sebaliknya. Kemudian, jika tidak ada folder dengan nama tanggal sebelumnya, maka foto yang duluan akan didownload adalah foto kucing.

Selanjutnya, algoritma akan sama dengan soal3a dengan penambahan *action* 

```bash
now=$(date +"%d-%m-%Y")
	mkdir $1_$now
```
pada awal algoritma untuk membuat folder dengan nama tanggal sekarang, dan 

```bash
mv Koleksi_* $1_$now && mv Foto.log $1_$now
```
pada akhir algoritma untuk memindahkan semua file foto dengan awalan nama *Koleksi_* dan file lognya.


#### Output
#### Contoh 1
![Output3c1](https://user-images.githubusercontent.com/65794806/113506415-5da9fb80-9577-11eb-81d4-01d17330f014.png)

#### Contoh 2
![Output3c2](https://user-images.githubusercontent.com/65794806/113506435-7a463380-9577-11eb-8f7f-0921d319991b.png)

![Output3c3](https://user-images.githubusercontent.com/65794806/113506445-83cf9b80-9577-11eb-92a8-c5da08335aeb.png)

### Cara Pengerjaan 3D

![Code3d](https://user-images.githubusercontent.com/65794806/113506450-8b8f4000-9577-11eb-916d-79d52a714a2e.png)

Pada *problem* 3D, *user* diminta untuk melakukan *zip* folder-folder Kucing_ dan Kelinci_ menjadi Koleksi.zip yang mempunyai *password* tanggal pada saat di *zip*.

Untuk melakukan *zip*, kami perlu mengakses letak folder yang akan di *zip* dengan *command* `cd [FOLDER_TUJUAN]`.
Setelah itu, membuat variabel yang akan menyimpan nilai `date` pada tanggal saat itu sebagai *password* file *zip* yang akan dibuat

```bash
unknow=$(date +"%d%m%Y")
zip -r -m -q --password $unknow Koleksi.zip Kucing_* Kelinci_*
```
- `zip -r` berfungsi untuk melakukan *zip* pada sebuah folder
- `zip -m` berfungsi untuk menghapus file/folder yang telah di *zip*
- `zip -q` berfungsi untuk tidak memunculkan info pada terminal ketika di *zip*
- `zip --password` berfungsi untuk membuat sebuah kata sandi pada file *zip* yang dibuat

Pada argumen `Kucing_* Kelinci_*`, memiliki arti bahwa folder yang dipilih adalah folder dengan nama depan *Kucing_* maupun *Kelinci_*.

#### Output
![Output3d1](https://user-images.githubusercontent.com/65794806/113507038-c21a8a00-957a-11eb-901b-327b8c0c5c72.png)

![Output3d2](https://user-images.githubusercontent.com/65794806/113506459-9d70e300-9577-11eb-99bd-803a0b1cb39d.png)

### Cara Pengerjaan 3E
[*SOURCE CODE CRON 3E*](https://github.com/GeraldElroy7/soal-shift-sisop-modul-1-B03-2021/blob/main/soal3/cron3e.tab)

Pada soal 3E, *user* diminta untuk membuat *crontab* agar dapat menjalankan perinta *zip* dan *unzip* secara otomatis sesuai dengan waktu yang ditentukan.
Pada baris pertama, 
```bash
0 7 * * 1-5 bash ~/soal-shift-sisop-modul-1-B03-2021/soal3/soal3d.sh
```
- Pada argumen pertama `0`, memiliki arti pada menit ke 0
- Pada argumen kedua `7`, memiliki arti pada jam 7 pagi
- Pada argumen ketiga dan keempat `* *`, memiliki arti bahwa tidak ada pengaturan waktu tertentu pada tanggal dan bulan
- Pada argumen kelima `1-5`, memiliki arti pada rentang hari senin sampai jumat setiap minggunya

*script soal3d* akan dijalankan jika semua argumen tersebut terpenuhi. 

Kemudian pada baris kedua,
```bash
1 18 * * 1-5 /usr/bin/unzip -P `date +"%d%m%Y"` ~/soal-shift-sisop-modul-1-B03-2021/soal3/Koleksi.zip -d ~/soal-shift-sisop-modul-1-B03-2021/soal3 && rm ~/soal-shift-sisop-modul-1-B03-2021/soal3/Koleksi.zip
```
- Pada argumen pertama `1`, memiliki arti pada menit ke 1
- Pada argumen kedua `18`, memiliki arti pada jam 18 atau 6 sore
- Pada argumen ketiga dan keempat `* *`, memiliki arti bahwa tidak ada pengaturan waktu tertentu pada tanggal dan bulan
- Pada argumen kelima `1-5`, memiliki arti pada rentang hari senin sampai jumat setiap minggunya

Perintah unzip akan dijalankan jika semua argumen tersebut terpenuhi. `/usr/bin/unzip` merupakan `command` yang serupa dengan `unzip`, `-P` digunakan untuk memasukkan kata sandi yaitu `date +"%d%m%Y"` atau *tanggal saat itu* pada file yang akan di *unzip*, `-d` digunakan untuk meletakkan tempat hasil *unzip*, dan `rm` untuk menghapus *zip* file yang telah di *unzip*

#### Output
***Setting waktu pada tanggal 2 April 2021(hari jumat) jam 6.59 ke 7.00***
![OutputCron3e1](https://user-images.githubusercontent.com/65794806/113506467-ab266880-9577-11eb-896c-c8c119939d4a.png)

***Setting waktu pada tanggal 2 April 2021(hari jumat) jam 18.00 ke 18.01***
![OutputCron3e2](https://user-images.githubusercontent.com/65794806/113506518-e6c13280-9577-11eb-8355-fa20e3734062.png)

### Kendala Selama Pengerjaan

1. Code unzip dalam cron tidak mau tereksekusi, tetapi cron dapat mengeksekusi sebuah script yang isinya code unzip tersebut.
