# 🏕️ Outdoor Store App

Aplikasi mobile berbasis **Flutter** yang terintegrasi dengan **Backend Golang** untuk sistem e-commerce sederhana seperti autentikasi, cart, dan order.

---

## 👤 Identitas Mahasiswa

* **Nama** : *UMAR BAKRI*
* **NIM**  : *1123150046*
* **Link Demo YouTube** : *(MENYUSUL..)*

---

## 📱 Deskripsi Aplikasi

Outdoor Store App adalah aplikasi mobile yang memungkinkan pengguna untuk:

* Login menggunakan Firebase Authentication
* Melihat daftar produk outdoor
* Menambahkan produk ke keranjang (cart)
* Melakukan checkout dan membuat pesanan
* Mengelola data order

---

## 🧱 Struktur Project

```
outdoorstore/
├── lib/                  # Source code Flutter
├── android/
├── ios/
├── pubspec.yaml
├── backend/              # Backend Golang
│   ├── main.go
│   ├── go.mod
│   ├── handlers/
│   ├── services/
│   ├── repositories/
│   └── .env
```

---

## ⚙️ Cara Menjalankan Aplikasi

### 🔹 1. Clone Repository

```bash
git clone https://github.com/leovern123/uts_1123150046_outdoorstore
cd uts_1123150046_outdoorstore
```

---

### 🔹 2. Setup Backend (Golang)

Masuk ke folder backend:

```bash
cd backend
```

Install dependency:

```bash
go mod tidy
```

Buat file `.env`:

```env
PORT=8081

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=
DB_NAME=outdoorstore

JWT_SECRET=secret123
```

Jalankan backend:

```bash
go run main.go
```

Backend akan berjalan di:

```
http://localhost:8081
```

---

### 🔹 3. Setup Database

Pastikan MySQL sudah aktif, lalu buat database:

```sql
CREATE DATABASE outdoorstore;
```

Import atau jalankan migration sesuai kebutuhan project.

---

### 🔹 4. Jalankan Flutter

Kembali ke root project:

```bash
flutter pub get
flutter run
```

---

### 🔹 5. Konfigurasi API di Flutter

Edit base URL di Flutter:

```dart
const baseUrl = "http://10.198.178.21:8081";
```

> ⚠️ Gunakan IP lokal (bukan localhost) jika dijalankan di HP

---

## 🔐 Fitur Utama

* ✅ Firebase Authentication (Login/Register)
* ✅ Verifikasi token ke backend Golang
* ✅ CRUD Produk
* ✅ Cart (Keranjang Belanja)
* ✅ Checkout & Order
* ✅ Manajemen Order

---

## 🛠️ Teknologi yang Digunakan

| Teknologi     | Keterangan      |
| ------------- | --------------- |
| Flutter       | Frontend Mobile |
| Golang        | Backend API     |
| MySQL         | Database        |
| Firebase Auth | Autentikasi     |

---
## 🚀 Penutup

Project ini dibuat sebagai bagian dari ujian UTS mata kuliah mobile lanjutan untuk memahami integrasi antara:

* Mobile App (Flutter)
* Backend API (Golang)
* Authentication (Firebase)

---
