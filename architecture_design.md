# Dokumentasi Arsitektur Perangkat Lunak & Aliran Data: UBMentalCare

Dokumen ini menjelaskan arsitektur perangkat lunak, rancangan basis data, fungsionalitas sistem, dan mekanisme aliran data pada aplikasi **UBMentalCare** dari input mahasiswa (pengguna akhir) hingga menjadi analitik yang divisualisasikan pada dashboard pimpinan Lembaga Konseling Mahasiswa (LKM) Universitas Brawijaya.

---

## 1. Skema Arsitektur High-Level (High-Level Architecture)

Aplikasi **UBMentalCare** dibangun menggunakan pendekatan modern berbasis **BaaS (Backend-as-a-Service)** dengan integrasi kecerdasan buatan (AI) untuk klasifikasi emosional secara real-time.

### Diagram Arsitektur High-Level

```mermaid
flowchart TD
    subgraph ClientLayer["1. Lapisan Klien (Frontend - Flutter)"]
        A[Mahasiswa App] -- Input Mood/Chat/Jurnal --> ClientEngine[Flutter App Engine]
        B[Psikolog App & Dashboard] -- Kelola Booking & Jawab Forum --> ClientEngine
        C[Dashboard Pimpinan LKM] -- Visualisasi & Analitik Kampus --> ClientEngine
    end

    subgraph APILayer["2. Lapisan Integrasi & Gateway (HTTPS / WSS)"]
        Gateway{Supabase Client SDK & HTTP API}
        ClientEngine --> Gateway
    end

    subgraph BackendLayer["3. Lapisan Backend (BaaS Supabase & PostgreSQL)"]
        Auth[Supabase Auth - Login Akun UB]
        DB[(Supabase DB - PostgreSQL)]
        Realtime[Supabase Realtime Server]
        
        Gateway --> Auth
        Gateway --> DB
        Gateway --> Realtime
    end

    subgraph AIEngine["4. Lapisan AI (Natural Language Processing & Klasifikasi)"]
        Groq[Groq API - Llama 3.3\nDetektor Sentimen Utama]
        Gemini[Google Gemini API - Gemini 2.5\nFallback LLM Engine]
    end

    subgraph ExternalServices["5. Layanan Eksternal & Integrasi"]
        Emergency[Layanan Darurat / WhatsApp / LKM Call Center]
    end

    %% Koneksi Aliran Data
    Gateway -- Request Analisis Sentimen Chat --> AIEngine
    AIEngine -- Kirim Hasil Klasifikasi & Respon Chat --> Gateway
    DB -- Perubahan Data --> Realtime
    Realtime -- Push Data Real-Time --> B
    ClientEngine -- Trigger Panggilan & Lokasi GPS --> Emergency
```

### Penjelasan Komponen Arsitektur:
1. **Lapisan Klien (Flutter Mobile App):**
   * **Mahasiswa App:** Antarmuka pengguna untuk mahasiswa UB mengekspresikan mood harian, menulis jurnal, melakukan chat mitigasi dengan AI, melakukan *booking* psikolog, dan memicu panggilan darurat jika kritis.
   * **Psikolog App:** Panel bagi psikolog LKM UB untuk memantau mahasiswa bimbingan, menjawab forum *community*, dan mengonfirmasi jadwal konsultasi.
   * **Dashboard Pimpinan:** Antarmuka visual (chart, metrik) yang menampilkan agregat statistik kesehatan mental mahasiswa UB secara *real-time*.
2. **Lapisan Integrasi & Gateway (Supabase SDK & HTTP Client):** Mengamankan komunikasi antara klien dan server menggunakan token JWT.
3. **Lapisan Backend (Supabase BaaS & PostgreSQL Database):**
   * **Supabase Auth:** Autentikasi ketat menggunakan format email Universitas Brawijaya (`@student.ub.ac.id` untuk mahasiswa dan `@psychologist.ub.ac.id` untuk psikolog).
   * **Supabase Database (PostgreSQL):** Penyimpanan data terstruktur dengan relasi dinamis.
   * **Supabase Realtime:** Mengirim pembaruan instan ke perangkat psikolog apabila ada mahasiswa yang masuk ke tingkat distress berbahaya (**Khawatir** atau **Kritis**).
4. **Lapisan AI (Groq & Gemini API):**
   * **Groq API (Llama 3.3):** Digunakan sebagai pendeteksi utama karena kecepatan tinggi dalam memproses teks curhat mahasiswa dan melakukan klasifikasi distress level.
   * **Google Gemini API (Gemini 2.5):** Berperan sebagai sistem *fallback* otomatis apabila Groq API mengalami limitasi atau kegagalan jaringan.
5. **Layanan Eksternal (WhatsApp & Emergency Services):** Menghubungkan langsung mahasiswa kritis dengan LKM UB via WhatsApp link atau panggilan telepon darurat beserta koordinat lokasi GPS mahasiswa.

---

## 2. Diagram Use Case (Use Case Diagram)

Diagram di bawah ini menggambarkan interaksi antara berbagai Aktor (Mahasiswa, Psikolog, Pimpinan LKM, dan ResahAI/UBMentalCareAI) dengan fitur-fitur utama di dalam sistem.

```mermaid
graph TD
    %% Actors
    Mahasiswa((Mahasiswa UB))
    Psikolog((Psikolog LKM UB))
    Pimpinan((Pimpinan LKM UB))
    ResahAI((UBMentalCareAI))

    %% Use Cases
    subgraph UseCases["Use Case Diagram - UBMentalCare"]
        UC_Login[UC1: Autentikasi dengan Akun UB]
        UC_Chat[UC2: Konsultasi Interaktif AI]
        UC_Klasifikasi[UC3: Deteksi Tingkat Distress Otomatis]
        UC_Mood[UC4: Pencatatan Mood Harian]
        UC_Journal[UC5: Pengisian Jurnal Harian]
        UC_Emergency[UC6: Panggilan Darurat & Kirim Lokasi]
        UC_Booking[UC7: Booking Konsultasi Ahli]
        UC_Forum[UC8: Anonymous Community QA]
        UC_Dashboard_Psikolog[UC9: Tindak Lanjut Pasien & Konfirmasi Booking]
        UC_Dashboard_Pimpinan[UC10: Monitoring Visualisasi & Analitik Kesehatan Mental]
    end

    %% Relationships
    Mahasiswa --> UC_Login
    Mahasiswa --> UC_Chat
    Mahasiswa --> UC_Mood
    Mahasiswa --> UC_Journal
    Mahasiswa --> UC_Booking
    Mahasiswa --> UC_Forum

    UC_Chat --> ResahAI
    ResahAI --> UC_Klasifikasi
    UC_Klasifikasi --> UC_Emergency

    Psikolog --> UC_Login
    Psikolog --> UC_Dashboard_Psikolog
    Psikolog --> UC_Forum

    Pimpinan --> UC_Login
    Pimpinan --> UC_Dashboard_Pimpinan

    UC_Dashboard_Psikolog -.-> |includes| UC_Booking
    UC_Dashboard_Psikolog -.-> |includes| UC_Klasifikasi
```

---

## 3. Entity Relationship Diagram (ERD)

Desain basis data relasional yang mendasari sistem UBMentalCare, memastikan integritas data mahasiswa, klasifikasi AI, mood tracker harian, hingga log booking konsultasi psikolog.

```mermaid
erDiagram
    PROFILES {
        uuid id PK "Relasi ke auth.users Supabase"
        string nickname "Nama panggilan/samaran mahasiswa"
        string gender "Jenis kelamin"
        date birth_date "Tanggal lahir"
        string phone_number "Nomor WhatsApp aktif"
        string role "Role: student | psychologist | pimpinan"
        boolean is_onboarding_completed "Status penyelesaian onboarding"
        integer mood_score "Mood akumulatif yang mempengaruhi status kesehatan mental"
        timestamp created_at "Waktu registrasi"
    }

    DISTRESS_CLASSIFICATIONS {
        uuid id PK "ID unik klasifikasi"
        uuid user_id FK "Menunjuk ke PROFILES.id"
        integer level "Skala distress: 1=Aman, 2=Waspada, 3=Khawatir, 4=Kritis"
        string level_label "Label teks: Aman, Waspada, Khawatir, Kritis"
        string summary "Rangkuman curhat singkat hasil ekstraksi AI"
        string[] keywords "Kata kunci pemicu kecemasan"
        timestamp created_at "Waktu deteksi"
    }

    MOOD_LOGS {
        uuid id PK "ID pencatatan harian"
        uuid user_id FK "Menunjuk ke PROFILES.id"
        integer mood_value "Nilai: Sedih(-3), Biasa(0), Senang(+1), Gembira(+2), Bahagia(+3)"
        string notes "Catatan singkat opsional"
        date logged_date "Tanggal pencatatan (Constraint: 1 entry per hari)"
    }

    JOURNALS {
        uuid id PK "ID jurnal"
        uuid user_id FK "Menunjuk ke PROFILES.id"
        string title "Judul tulisan jurnal"
        text content "Konten refleksi emosi"
        integer mood_rating "Rating mood 1-5"
        timestamp created_at "Tanggal penulisan"
    }

    BOOKINGS {
        uuid id PK "ID pemesanan jadwal"
        uuid student_id FK "Menunjuk ke PROFILES.id (Student)"
        uuid psychologist_id FK "Menunjuk ke PROFILES.id (Psychologist)"
        timestamp scheduled_at "Tanggal dan jam konsultasi"
        string status "Status: pending | confirmed | cancelled"
        text notes "Keluhan atau catatan awal pasien"
    }

    COMMUNITY_POSTS {
        uuid id PK "ID post forum"
        uuid student_id FK "Menunjuk ke PROFILES.id (Student)"
        boolean is_anonymous "Flag anonimitas"
        text question "Pertanyaan dari mahasiswa"
        uuid answered_by FK "Menunjuk ke PROFILES.id (Psychologist)"
        text answer "Jawaban profesional dari psikolog"
        timestamp created_at "Waktu pembuatan"
    }

    PROFILES ||--o{ DISTRESS_CLASSIFICATIONS : "memiliki"
    PROFILES ||--o{ MOOD_LOGS : "mencatat"
    PROFILES ||--o{ JOURNALS : "menulis"
    PROFILES ||--o{ BOOKINGS : "memesan (sebagai mahasiswa)"
    PROFILES ||--o{ BOOKINGS : "mengelola (sebagai psikolog)"
    PROFILES ||--o{ COMMUNITY_POSTS : "membuat (sebagai mahasiswa)"
    PROFILES ||--o{ COMMUNITY_POSTS : "menjawab (sebagai psikolog)"
```

---

## 4. Aliran Data End-to-End (Data Flow Diagram)

Diagram berikut menjelaskan secara sekuensial bagaimana data bergerak dari input mahasiswa (mood harian & AI chat) hingga diproses dan disajikan pada dashboard pimpinan/psikolog secara real-time.

```mermaid
sequenceDiagram
    autonumber
    actor Mahasiswa as Mahasiswa (End User)
    participant Flutter as Flutter App (Klien)
    participant AI as AI Engine (Groq / Gemini)
    participant Supabase as Supabase (BaaS Backend)
    actor Psikolog as Psikolog LKM UB
    actor Pimpinan as Pimpinan LKM UB

    %% ALIRAN 1: INPUT MOOD TRACKER
    Note over Mahasiswa, Flutter: Aliran 1: Penginputan Mood Harian
    Mahasiswa->>Flutter: Memilih emoji mood (Contoh: Sedih dengan nilai -3)
    Flutter->>Flutter: Menjumlahkan nilai ke mood_score saat ini di profil
    Flutter->>Supabase: Mengirim query update mood_score di tabel 'profiles'
    Note over Supabase: Sistem secara otomatis memperbarui klasifikasi berdasarkan:<br/>Aman (>=0), Waspada (<=-10), Khawatir (<=-30), Kritis (<=-50)

    %% ALIRAN 2: CHATTING DENGAN UBMentalCareAI
    Note over Mahasiswa, Flutter: Aliran 2: Konsultasi Interaktif AI
    Mahasiswa->>Flutter: Mengetik pesan curhat ("Saya sangat stres dan ingin menyerah...")
    Flutter->>Flutter: Melakukan scanning kata kunci kritis/darurat secara lokal
    Flutter->>AI: Mengirim pesan terenkripsi dengan System Prompt Mitigasi
    Note over AI: Llama 3.3 memproses sentimen emosional & membubuhkan tag tersembunyi:<br/>[CLASSIFICATION:KRITIS]
    AI-->>Flutter: Mengirimkan teks respon empati + tag klasifikasi tersembunyi
    Flutter->>Flutter: Ekstrak tag [CLASSIFICATION:KRITIS] dan hapus tag dari UI visual mahasiswa
    Flutter->>Supabase: Simpan data hasil analisis ke tabel 'distress_classifications'

    %% ALIRAN 3: DETEKSI & CALL DARURAT (IF KRITIS)
    Note over Flutter, Supabase: Aliran 3: Penanganan Kondisi Darurat (Kritis)
    Flutter->>Flutter: Membuka pop-up Alert Darurat dan tombol Hubungi LKM
    Flutter->>Supabase: Memicu pembaruan real-time status mahasiswa ke "Kritis"

    %% ALIRAN 4: REAL-TIME NOTIFIKASI & DASHBOARD ANALITIK
    Note over Supabase, Pimpinan: Aliran 4: Visualisasi & Analitik Dashboard Pimpinan
    Supabase-->>Psikolog: Push Data Real-Time: Daftar Mahasiswa status Kritis & Khawatir
    Supabase-->>Pimpinan: Agregasikan data (distribusi distress, rata-rata mood, status darurat)
    Pimpinan->>Flutter: Membuka dashboard pimpinan LKM UB
    Supabase-->>Flutter: Mengembalikan data olahan statistik & grafik (Chart)
    Note over Pimpinan: Pimpinan melihat metrik tren kesehatan mental makro mahasiswa UB
    Psikolog->>Mahasiswa: Melakukan penjangkauan aktif (reach out) via WhatsApp / Panggilan Langsung
```

---

## 5. Mekanisme Pemrosesan Menjadi Analitik & Informasi

Bagaimana data mentah bertransformasi menjadi visualisasi bernilai tinggi untuk dashboard pimpinan? Berikut alurnya:

### A. Transformasi Data Mentah ke Informasi
1. **Poin Mood harian (`MOOD_LOGS`)** diakumulasikan secara *rolling summation* pada tabel `profiles.mood_score`. Nilai negatif yang terus menurun menunjukkan tren depresi.
2. **Interaksi Chat (`distress_classifications`)** diubah menjadi data kategorikal berbobot (skala 1-4).
3. **Log Booking (`bookings`)** digunakan untuk memantau tingkat kegawatan kasus yang sukses ditangani versus kasus aktif.

### B. Visualisasi pada Dashboard Pimpinan
Data yang telah dikelompokkan oleh Supabase diproyeksikan dalam bentuk:
* **Pie Chart Distribusi Distress:** Menunjukkan proporsi jumlah mahasiswa Universitas Brawijaya yang berada dalam status *Aman, Waspada, Khawatir,* dan *Kritis*. Berguna bagi pimpinan untuk menentukan urgensi kampanye kesehatan mental.
* **Line Chart Tren Mood Bulanan:** Mengukur rata-rata kebahagiaan mahasiswa dari waktu ke waktu (misal: penurunan tajam saat minggu ujian/UTS/UAS).
* **Bar Chart Beban Kerja Psikolog:** Memperlihatkan statistik booking konsultasi aktif per psikolog LKM untuk optimasi alokasi SDM.
* **Tabel Perhatian Khusus (Real-Time):** Menampilkan daftar mahasiswa kritis secara real-time berdasarkan akumulasi point mood terendah (`<= -50`) dan analisis sentimen AI, lengkap dengan tombol penjangkauan klinis instan.

Dengan demikian, dari sekadar input emoji mood dan ketikan curhat sederhana oleh mahasiswa, sistem berhasil merumuskan indikator kesehatan mental kampus secara komprehensif bagi pimpinan Universitas Brawijaya untuk pengambilan kebijakan strategis.
