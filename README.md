# soal-shift-sisop-modul-1-B03-2021
1. Nur Putra Khanafi     05111940000020
2. Gerald Elroy Van Ryan 05111940000187
3. Husnan                05111940007002

## Soal 1

Pada soal 1, *user* diminta untuk membantu Ryujin untuk membuat laporan harian untuk aplikasi perusahaannya, *ticky*. Ada 2 laporan yang perlu dibuat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan **laporan penggunaan user** pada *ticky*. Soal ini tidak boleh dikerjakan menggunakan `AWK`.

### Cara Pengerjaan 1A

![Source Code 1A](/images/1a.png)

*User* diminta untuk mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: `jenis log (ERROR/INFO)`, `pesan log`, dan `username` pada setiap baris lognya. Untuk mempermudah pekerjaannya, maka diperlukan **regex** dalam memeriksa satu per satu baris.

Kami memakai `grep` agar bisa mengambil kata/kalimat yang dicari per **line-nya**. Tambahkan juga `grep -o` agar dia **hanya** mencari kata/kalimat yang sudah di-filter (`-o`). 

Karena `(ERROR/INFO)` dimulai dengan huruf kapital E dan I, maka cukup cari kalimat yang mengandung `E|I`. `|` memiliki arti **atau**, jadi mencari tiap line yang mengandung huruf E atau I. 

Kami juga menambahkan `.*` pada *syntax*, agar karakter setelah huruf yang difilter juga ikut di-*print* hingga karakter terakhir pada line tersebut. Setelah itu, akhiri dengan file yang dituju, yaitu `syslog.log`

#### Output
![Output 1A](/images/hasil1a.png)

### Cara Pengerjaan 1B

![Source Code 1B](/images/1b.png)

Pada soal ini, *user* diminta untuk menampilkan semua pesan **error** yang muncul beserta jumlah kemunculannya. Kami memakai `grep -o` lagi agar hanya mengambil karakter sesuai yang di-filter. Karena yang diminta hanya pesan yang **error**, maka yang di-*filter* cukup `"ERROR.*`. 

Karena yang diminta hanya pesan error-nya, maka **username** tidak diperlukan. Kami tambahkan:

```bash
cut -d "(" -f1
```

Arti dari *command* ini ialah mengambil semua karakter sebelum tanda "(", karena adanya *delimiter* (`-d`). Ketika *command* `cut` dilakukan, maka *field* sebelum *delimiter* akan dianggap `field 1`, maka dari itu ditambahkan `-f1` pada syntaxnya, agar hanya mengambil semua karakter sebelum "(".

Setelah itu, lakukan `sort` agar bisa melakukan `uniq`. `uniq` akan mengelompokkan karakter sesuai jenis **Error**-nya, sistemnya seperti `GROUP BY` pada SQL. Terakhir, tambahkan `-c` setelah `uniq` agar bisa dihitung/di-*count* berdasarkan jumlah kemunculannya pada file tersebut.

#### Output
![Output 1B](/images/hasil1b.png)

### Cara Pengerjaan 1C

![Source Code 1C](/images/1c.png)

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
![Output 1C](/images/hasil1c.png)

### Cara Pengerjaan 1D

![Source Code 1D](/images/1d.png)

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
![Output 1D](/images/hasil1d.png)

### Cara Pengerjaan 1E

![Source Code 1E](/images/1e.png)

Soal 1E dapat dikatakan sebagai lanjutan dari soal **1C**. Setelah semua informasi dari 1C didapat, maka buat outputnya ke dalam file `user_statistis.csv` dengan header **Username,INFO,ERROR** dan diurutkan berdasarkan *username* secara **ascending**.

Pertama kali, buat *header* yang diminta dengan *syntax* berikut : 

```bash
echo "Username,Info,Error" > user_statistic.csv
```

Artinya, karakter yang ada di dalam `echo` tersebut di-*print* di awal file `user_statistic.csv`.

Cara mencari karakter yang dicari juga sama persis dengan **1C**, cukup tambahkan `>> user_statistic.csv` pada akhir *syntax* agar output dapat muncul di file `user_statistic.csv`.

#### Output
![Output 1E](/images/hasil1e.png)

### Kendala Selama Pengerjaan

1. Awalnya, perlu mencari referensi yang banyak terlebih dahulu karena baru pertama kali menggunakan bahasa *Bash*.
2. Pada awalnya, cukup bingung untuk mengambil karakter pada tiap line karena tidak boleh menggunakan `awk`. Namun, akhirnya dari berbagai referensi, bisa menggunakan *command* `grep`.
3. Pada soal 1D, awalnya tidak tahu caranya untuk bisa *sorting* dalam bentuk kalimat karena belum ada pembatasnya. Akhirnya, baru tau adanya *delimiter* agar bisa memisahkan kalimat dengan pembatas yang diinginkan.

## Soal 2

### Cara Pengerjaan 2A

![2a_sisop](https://user-images.githubusercontent.com/57633103/113398288-8cce3a80-93c8-11eb-8cea-474a19d683c7.png)

Untuk mengetahui Row ID dan profit percentage terbesar maka menggunakan definisi dari Profit Percentage yaitu : `profit=(($NF/($(NF-3)-$NF))*100)`. 
`NF` yaitu kolom paling belakang, berdasarkan definisi tersebut kolomnya dihitung paling terakhir setelah itu mundur tiga setelah itu dikali seratus maka akan diketahui  profit percentage nya, Setelah itu masuk ke percabangan, jika  `profit>=max` maka yang paling besar akan ditampilkan ID nya beserta  profit percentage nya dan otputnya pada `hasil.txt`.

#### Output
![2a_sisop_output](https://user-images.githubusercontent.com/57633103/113399663-c2742300-93ca-11eb-864f-c77fe015e420.png)


### Cara Pengerjaan 2B

![2b_sisop](https://user-images.githubusercontent.com/57633103/113398735-40cfc580-93c9-11eb-8d08-8d0c4a903841.png)

Membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque. `if($2~"-2017-" && $10~"Albuquerque")` Setelah melalui percabangan maka akan diteruskan ke `a[$7]` yaitu terdapat nama-nama yang ada pada rentang tersebut, Setelah itu diiterasikan array tersebut `for (costumer in a)`, dan akan ditampilkan satu persatu isi dari array nya dan otputnya pada `hasil.txt`.

#### Output
![2b_sisop_output](https://user-images.githubusercontent.com/57633103/113399719-df105b00-93ca-11eb-97f5-6ee6c895e821.png)


### Cara Pengerjaan 2C

![2c_sisop](https://user-images.githubusercontent.com/57633103/113432227-32a09a00-9407-11eb-8f8d-fb5cdfd84b1b.png)

Membutuhkan segment customer dan jumlah transaksinya yang paling sedikit. Karena mencari yang paling sedikit, `min` diinisialisasikan menjadi `9999` yaitu angka paling maksimal, Setelah itu dilakukan iterasi `for(seg in c)` dan terdapat percabangan didalamnya `if(min > c[seg])`, maka akan terus dicari yang paling sedikit terus akan ditampilkan di `bukan1.txt`.

#### Output
![2c_sisop_output](https://user-images.githubusercontent.com/57633103/113432235-346a5d80-9407-11eb-9149-9fdbb467a21c.png)

### Cara Pengerjaan 2D

![2d_sisop](https://user-images.githubusercontent.com/57633103/113432238-346a5d80-9407-11eb-8f03-0c48898e7c0b.png)

mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut. Hampir sama dengan `2c` perbedaannya terdapat pada kolom, untuk `2c` menggunakan kolom `$8` sedangakan `2d` kolom `$13` Mengunakan `NF` yaitu kolom paling belakang diinisialisasikan sebagai profit
Setelah itu jika `NR > 1` maka index nya bertambah sesuai profitnya. Beranjak ke `END` nya setelah diinisialisasi `min` ke angka paling besar, masuk ke iterasi `for(reg in c)`, jika `min > c[reg]` maka `min` nya akan berubah menjadi kecil agar ketemu angka paling kecilnya terus akan ditampilkan di `bukan1.txt`.

#### Output
![2d_sisop_output](https://user-images.githubusercontent.com/57633103/113432241-3502f400-9407-11eb-9e51-ee0f3755d94a.png)

### Kendala Selama Pengerjaan

## Soal 3

Pada soal 3, *user* diminta untuk membantu Kuuhaku dalam *mendownload* 23 foto kucing atau kelinci dari link yang akan disimpan dalam folder dengan **penamaan tertentu** lalu di *zip* dan *unzip* sesuai **waktu yang ditentukan**.

### Cara Pengerjaan 3A

![Source Code 3A](/images/1a.png)

*User* diminta untuk *mendownload* 23 foto kucing dari link *https://loremflickr.com/320/240/kitten* dengan penamaan file *Koleksi_01, Koleksi_02, dst* serta **menyimpan** log fotonya ke file *Foto.log*. Kemudian jika terdapat foto yang sama, maka foto tersebut akan di **hapus** dengan tidak perlu *mendownload* ulang foto lain.

Untuk melakukan aksi sebanyak 23 kali, maka digunakan looping 
```bash
for((counter=1; counter<=23; counter++))
do
  [ARGUMENT]
done
```

Untuk mendownload foto tersebut, kami menggunakan `wget -O [PENAMAAN_FILE] -a [FILE_LOG] [LINK]` agar dapat **menyimpan** foto dengan penamaan lain serta membuat file lognya. Pada penamaan file, dilakukan kondisi `if else` yaitu

```bash
if [ $name_num -le 9 ]
```

yang mana jika foto tersimpan kurang dari 10, maka penamaan filenya adalah *Koleksi_0X* dan jika sudah 10 atau lebih, maka penamaan filenya adalah *Koleksi_X*. 

Kemudian, untuk mencari foto yang sama, kami menggunakan `cmp [FILE_1] [FILE_2]` yang mana akan membandingkan *byte* kedua file. Output dari fungsi tersebut disimpan dengan menggunakan `$?`. Jika hasilnya adalah 0, maka kedua file tersebut sama. Untuk menghapus file yang sama, kami menggunakan `rm [FILE]`

#### Output
![Output 1A](/images/hasil1a.png)

### Cara Pengerjaan 3B

![Source Code 1B](/images/1b.png)

Kali ini, *user* diminta untuk **menjalankan** *script* pada soal sebelumnya yang mana hasilnya akan disimpan dalam folder. 

Untuk menjalankan *script soal3a*, kami perlu mengakses folder letak *script* tersebut. Oleh karena itu, digunakan `cd [Directory_Destination]`. Kemudian, *script* dijalankan dengan `bash soal3a.sh`

Untuk membuat foldernya, kami menggunakan
```bash
now=$(date +"%d-%m-%Y")
mkdir $now
```
Variabel `now` akan menyimpan nilai `date` tanggal pada waktu itu sehingga folder yang dibuat memiliki nama tanggal saat itu.

Terakhir, untuk menyimpan hasil *script soal3a*, semua file *Koleksi_* dan *Foto.log* dipindahkan dengan menggunakan `mv Koleksi_* $now && mv Foto.log $now`.

![Source Code Cron3B]()

Untuk menjalankan *script soal3b* secara otomatis, kami menggunakan *crontab*.

Pada argumen pertama `0`, memiliki arti pada menit ke 0
Pada argumen kedua `20`, memiliki arti pada jam 20 atau 8 malam
Pada argumen ketiga `1-31/7,2-31/4`, memiliki arti pada tiap tujuh hari dimulai pada tanggal 1 atau tiap 4 hari dimulai pada tanggal 2
Pada argumen keempat dan kelima `* *`, memiliki arti bahwa tidak ada pengaturan waktu tertentu pada bulan dan nama hari

Dengan menuliskan *code* tersebut didalam `crontab -e`, maka *script soal3b* akan dijalankan secara otomatis jika semua argumen tersebut terpenuhi.


#### Output
![Output 1B](/images/hasil1b.png)

### Cara Pengerjaan 3C

![Source Code 1C](/images/1c.png)

Pada soal 3C, *user* diminta untuk *mendownload* foto kucing dan kelinci sesuai dengan *link* masing-masing secara bergantian pada hari yang berbeda yang mana hasilnya akan disimpan pada folder Kucing atau Kelinci.



#### Output
![Output 1C](/images/hasil1c.png)

### Cara Pengerjaan 1D

![Source Code 1D](/images/1d.png)

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
![Output 1D](/images/hasil1d.png)

### Cara Pengerjaan 1E

![Source Code 1E](/images/1e.png)

Soal 1E dapat dikatakan sebagai lanjutan dari soal **1C**. Setelah semua informasi dari 1C didapat, maka buat outputnya ke dalam file `user_statistis.csv` dengan header **Username,INFO,ERROR** dan diurutkan berdasarkan *username* secara **ascending**.

Pertama kali, buat *header* yang diminta dengan *syntax* berikut : 

```bash
echo "Username,Info,Error" > user_statistic.csv
```

Artinya, karakter yang ada di dalam `echo` tersebut di-*print* di awal file `user_statistic.csv`.

Cara mencari karakter yang dicari juga sama persis dengan **1C**, cukup tambahkan `>> user_statistic.csv` pada akhir *syntax* agar output dapat muncul di file `user_statistic.csv`.

#### Output
![Output 1E](/images/hasil1e.png)

### Kendala Selama Pengerjaan

1. Awalnya, perlu mencari referensi yang banyak terlebih dahulu karena baru pertama kali menggunakan bahasa *Bash*.
2. Pada awalnya, cukup bingung untuk mengambil karakter pada tiap line karena tidak boleh menggunakan `awk`. Namun, akhirnya dari berbagai referensi, bisa menggunakan *command* `grep`.
3. Pada soal 1D, awalnya tidak tahu caranya untuk bisa *sorting* dalam bentuk kalimat karena belum ada pembatasnya. Akhirnya, baru tau adanya *delimiter* agar bisa memisahkan kalimat dengan pembatas yang diinginkan.
