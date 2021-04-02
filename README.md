# soal-shift-sisop-modul-1-B03-2021

## Soal 1

Pada soal 1, *user* diminta untuk membantu Ryujin untuk membuat laporan harian untuk aplikasi perusahaannya, *ticky*. Ada 2 laporan yang perlu dibuat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan **laporan penggunaan user** pada *ticky*. Soal ini tidak boleh dikerjakan menggunakan `AWK`.

## Cara Pengerjaan 1A

![Source Code 1A](/images/1a.png)

*User* diminta untuk mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: `jenis log (ERROR/INFO)`, `pesan log`, dan `username` pada setiap baris lognya. Untuk mempermudah pekerjaannya, maka diperlukan **regex** dalam memeriksa satu per satu baris.

Kami memakai `grep` agar bisa mengambil kata/kalimat yang dicari per **line-nya**. Tambahkan juga `grep -o` agar dia **hanya** mencari kata/kalimat yang sudah di-filter (`-o`). 

Karena `(ERROR/INFO)` dimulai dengan huruf kapital E dan I, maka cukup cari kalimat yang mengandung `E|I`. `|` memiliki arti **atau**, jadi mencari tiap line yang mengandung huruf E atau I. 

Kami juga menambahkan `.*` pada *syntax*, agar karakter setelah huruf yang difilter juga ikut di-*print* hingga karakter terakhir pada line tersebut. Setelah itu, akhiri dengan file yang dituju, yaitu `syslog.log`

## Cara Pengerjaan 1B

![Source Code 1B](/images/1b.png)

Pada soal ini, *user* diminta untuk menampilkan semua pesan **error** yang muncul beserta jumlah kemunculannya. Kami memakai `grep -o` lagi agar hanya mengambil karakter sesuai yang di-filter. Karena yang diminta hanya pesan yang **error**, maka yang di-*filter* cukup `"ERROR.*`. 

Karena yang diminta hanya pesan error-nya, maka **username** tidak diperlukan. Kami tambahkan:

```bash
cut -d "(" -f1
```

Arti dari *command* ini ialah mengambil semua karakter sebelum tanda "(", karena adanya *delimiter* (`-d`). Ketika *command* `cut` dilakukan, maka *field* sebelum *delimiter* akan dianggap `field 1`, maka dari itu ditambahkan `-f1` pada syntaxnya, agar hanya mengambil semua karakter sebelum "(".

Setelah itu, lakukan `sort` agar bisa melakukan `uniq`. `uniq` akan mengelompokkan karakter sesuai jenis **Error**-nya, sistemnya seperti `GROUP BY` pada SQL. Terakhir, tambahkan `-c` setelah `uniq` agar bisa dihitung/di-*count* berdasarkan jumlah kemunculannya pada file tersebut.

## Cara Pengerjaan 1C

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

## Cara Pengerjaan 1D

![Source Code 1D](/images/1d.png)


