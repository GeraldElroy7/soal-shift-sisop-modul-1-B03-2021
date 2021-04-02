# soal-shift-sisop-modul-1-B03-2021

## Soal 1

Pada soal 1, kita diminta untuk membantu Ryujin untuk membuat laporan harian untuk aplikasi perusahaannya, *ticky*. Ada 2 laporan yang perlu dibuat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan **laporan penggunaan user** pada *ticky*. Soal ini tidak boleh dikerjakan menggunakan `AWK`

## Penyelesaian 1A





*User* diminta untuk mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: `jenis log (ERROR/INFO)`, `pesan log`, dan `username` pada setiap baris lognya. Untuk mempermudah pekerjaannya maka diperluka **regex** dalam memeriksa satu per satu baris.

