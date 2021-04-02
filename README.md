# soal-shift-sisop-modul-1-B03-2021

## Soal 1

Pada soal 1, kita diminta untuk membantu Ryujin untuk membuat laporan harian untuk aplikasi perusahaannya, *ticky*. Ada 2 laporan yang perlu dibuat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan **laporan penggunaan user** pada *ticky*. Soal ini tidak boleh dikerjakan menggunakan `AWK`

## Cara Pengerjaan 1A

![Source Code 1A](/images/1a.png)

*User* diminta untuk mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: `jenis log (ERROR/INFO)`, `pesan log`, dan `username` pada setiap baris lognya. Untuk mempermudah pekerjaannya maka diperluka **regex** dalam memeriksa satu per satu baris.

Kami memamaki `grep` agar bisa mengambil kata/kalimat yang dicari per **line-nya**. Tambahkan juga `grep -o`, `-o` agar dia **hanya** mencari kata/kalimat yang sudah di-filter. Karena `(ERROR/INFO)` dimulai dengan huruf kapital E dan I, maka cukup cari kalimat yang mengandung `E|I`. 

`|` memiliki arti **atau**, jadi mencari tiap line yang mengandung huruf E atau I. Setelah itu, akhiri dengan file yang dituju, yaitu `syslog.log`
