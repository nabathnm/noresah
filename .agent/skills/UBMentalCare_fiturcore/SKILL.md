---
name: UB_MentalCare_fiturcore
description: >
  Skill ini digunakan agar menjadi acuan bagaimana nanti aplikasi UBMentalCare dikembangkan sesuai dengan fitur-fitur yang ada
---

## Identifikasi Agent

Anda merupakan mobile developer profesional yang akan membangun aplikasi UBMentalCare. Fokus utama Anda adalah efisiensi, modularitas, dan skalabilitas. Anda tidak hanya menulis kode; Anda merancang arsitektur yang kokoh untuk aplikasi mobile. Anda akan bekerja berdasarkan SOP yang telah ditetapkan untuk memastikan konsistensi, kualitas kode, dan integrasi fitur yang mulus dengan backend yang ada. Anda selalu merujuk kepada file-file acuan yang diberikan untuk memastikan setiap fitur dan alur kerja selaras dengan rancangan sistem yang telah disetujui.

## Warna Utama Aplikasi :

- Primer: #273383
- Sekunder: #FA6400
- Netral: #1B263B, #FFFFFF, #F5F5F5

## Techstack yang digunakan

- Flutter (Frontend)
- Supabase (Backend)

## Role

- User (MAHASISWA UB)
- Psikolog (Pegawai LKM UB)

## Panduan Fitur Utama

1. Autentikasi Pengguna (role : user)

- Tujuan : Agar pengguna bisa masuk menggunakan akun UB (format email: Student.ub.ac.id)
- Fitur Wajib:
  - **Login** : Menggunakan email dan password
- Alur Kerja:
  1. User memasukkan email dan password
  2. Sistem mengautentikasi pengguna berasal dari UB dan memiliki role user

2. Autentikasi Psikolog (role : psikolog)

- Tujuan : Agar psikolog bisa masuk menggunakan akun UB (format email: Psychologist.ub.ac.id)
- Fitur Wajib:
  - **Login** : Menggunakan email dan password
- Alur Kerja:
  1. Psikolog memasukkan email dan password
  2. Sistem mengautentikasi psikolog berasal dari UB dan memiliki role psikolog

3. UBMentalCare AI

- Tujuan : Agar user bisa berkonsultasi sementara dengan model AI untuk mendapat pertolongan pertama ketika sedang merasa resah
- Fitur Wajib:
  - **AI Chatting** : User bisa bertanya kepada AI dan mendapatkan jawaban
  - **Riwayat AI Chatting** : User bisa melihat riwayat percakapannya dengan AI
  - **Otomatis mengetahui tingkat kecemasan user** : Sistem akan secara otomatis mendeteksi tingkat kecemasan user (aman, biasa, cemas ,kritis)

4. Call Darurat

- Tujuan : Ketika status user "dikatakan pada tingkat tinggi / kritis" maka akan muncul tombol untuk melakukan panggilan darurat
- Fitur Wajib:
  - **Tombol Call Darurat** : Muncul ketika status user "dikatakan pada tingkat tinggi / kritis"
  - **Otomatis terhubung ke layanan darurat** : Sistem akan otomatis terhubung ke layanan darurat
  - **Otomatis terkirim lokasi user** : Sistem akan otomatis mengirim lokasi user ke layanan darurat

5. Anonymous Community

- Tujuan : Agar user bisa bertanya kepada psikolog secara anonymous dan mendapatkan jawaban
- Fitur wajib :
  - **User bertanya kepada psikolog** : User bisa bertanya kepada psikolog secara anonymous
  - **Psikolog menjawab pertanyaan user** : Psikolog bisa menjawab pertanyaan user
  - **Constraint** : hanya boleh dijawab oleh psikolog dan user lain tidak boleh menjawab pertanyaan user, forum yang dibuat bisa dilihat oleh user lain

6. Booking Konsultasi

- Tujuan : Agar user bisa melakukan booking konsultasi dengan psikolog (pegawai LKM UB)
- Fitur wajib :
  - **User dapat melihat jadwal psikolog** : User bisa melihat jadwal psikolog yang tersedia
  - **User dapat melakukan booking konsultasi** : User bisa melakukan booking konsultasi dengan psikolog
  - **Psikolog dapat melihat pesanan konsultasi** : Psikolog bisa melihat pesanan konsultasi dari user
  - **Psikolog dapat mengkonfirmasi pesanan konsultasi** : Psikolog bisa mengkonfirmasi pesanan konsultasi dari user
  - **Constraint** : user tidak bisa melakukan booking jika jadwal psikolog sudah penuh

**FITUR PADA HOMEPAGE (7-8)**

7. MoodTracker

- Tujuan : User dapat mencatat moodnya sehari-hari
- Fitur wajib :
  - **User dapat mencatat moodnya** : Berisi pilihan emoji mulai dari Sedih, Biasa, Senang, Gembira, Bahagia

8. Journaling

- Tujuan : user dapat mencatat apa yang dirasakannya setiap hari
- Fitur wajib :
  - **User dapat mencatat apa yang dirasakannya** : User bisa mencatat apa yang dirasakannya
  - **User dapat melakukan CRUD journaling** : User bisa melakukan create, update, delete pada journalingnya
  - **User dapat list journaling** : User dapat melihat daftar journalnya (berdasarkan tanggal)

Tambahan :

- Aplikasi dapat memperlihatkan status mental user (aman, biasa, cemas ,kritis) pada homepage

New Feature :

- Saya ingin membuat fitur dimana user bisa memberi reaksi mood dia setiap hari dengan kategori sebagai berikut : - Sedih (-3) - Biasa (0) - Senang (+1) - Gembira (+2) - Bahagia (+3)
  Alur kerja : User akan diperbolehkan untuk mengisi mood dia hari ini (hanya sekali sehari) -> memencet emojis dan bisa memberi sedikit catatan (opsional) -> sistem akan memberikan point pada table profile user berupa mood poin yang bisa mempengaruhi status kecemasan
- Status kecemasan user bisa dipengaruhi dari nilai mood user. kategori status kecemasan user yaitu :
  - Aman (nilai mood user >= 0)
  - Waspada (nilai mood user <= -10)
  - Khawatir (nilai mood user <= -30)
  - Kritis (nilai mood user <= -50)

New Feature 2 :

- Psikolog dapat melihat daftar mahasiswa yang melakukan konsultasi dengan dirinya
- Psikoog dapat melihat daftar mahasiswa yang dalam status khawatir dan kritis untuk di tindak langsung berdasarkan mood score
