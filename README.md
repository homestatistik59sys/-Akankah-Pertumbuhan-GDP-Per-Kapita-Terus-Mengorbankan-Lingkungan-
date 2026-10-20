# Dilema Ekonomi ASEAN: Akankah Pertumbuhan GDP Per Kapita Terus Mengorbankan Lingkungan?

Proyek Riset Independen oleh: **Rofinus Ramang**  
Kontak: [LinkedIn](https://linkedin.com) | [Email](mailto:rofinusr.20@gmail.com)

---

## Deskripsi Proyek
Proyek ini merupakan analisis data dan pemodelan ekonometrika untuk menguji hubungan antara pertumbuhan ekonomi, konsumsi energi fosil, dan tingkat degradasi lingkungan di kawasan ASEAN. Landasan teori yang digunakan adalah Environmental Kuznets Curve (EKC) dan Model STIRPAT (Stochastic Regression on Population, Affluence, and Technology) untuk menghindari omitted variable bias (bias akibat penghilangan variabel penting).

## Variabel Penelitian
* **Emisi CO2 (Variabel Dependen - Y):** Indikator atau proksi utama dari tingkat degradasi lingkungan akibat aktivitas manusia di kawasan ASEAN.
* **GDP Per Capita (Variabel Independen - X1):** Mengukur faktor Affluence (tingkat kemakmuran ekonomi). Variabel ini diubah ke bentuk logaritma (log_gdp) untuk melihat nilai elastisitas.
* **Konsumsi Energi Fosil (Variabel Independen - X2):** Mengukur faktor Technology (intensitas energi kotor) dan dimasukkan sebagai variabel kontrol utama.

---

## Metodologi dan Tahapan Pemodelan

### 1. Pemilihan Model (Model Selection)
* **Uji Chow (CEM vs FEM):** Hasil P-Value < 2.2 X 10^-16 (< 0.05), sehingga H0 ditolak. Fixed Effect Model (FEM) terpilih karena tiap negara ASEAN terbukti memiliki karakteristik internal yang unik dan berbeda secara signifikan.
* **Uji Hausman (FEM vs REM):** Hasil P-Value = 0.002193 (< 0.05), sehingga H0 ditolak. Fixed Effect Model (FEM) ditetapkan sebagai model final terbaik dan paling konsisten secara statistik.

### 2. Uji Asumsi Klasik dan Penyelamatan Model (Robustness Check)
* **Diagnosis Gangguan:** Melalui Uji Wooldridge, model FEM terdeteksi mengalami masalah Autokorelasi Serius pada error antarwaktu (p-value = 6.164 X 10^-12). Jika dibiarkan, standar error akan bias (underestimated) dan memicu regresi palsu (spurious regression).
* **Solusi Penyembuhan:** Menyuntikkan metode Driscoll-Kraay Robust Standard Errors (vcovSCC). Langkah ini mengoreksi varians model sehingga seluruh nilai standar error, nilai t-statistik, dan p-value menjadi sehat, tidak bias, serta kebal terhadap heteroskedastisitas dan autokorelasi serentak.

---

## Proyeksi Masa Depan (Short-Term Forecasting 2026–2028)
Peramalan menggunakan Skenario Tren Historis Jangka Pendek (3 tahun ke depan) dengan mengasumsikan GDP tumbuh stabil mengikuti rata-rata masa lalu. Pembatasan jangka pendek ini dipilih untuk menjaga tingkat akurasi dan presisi ramalan tertinggi (lowest error margin). Model mengekstrak nilai intersep unik negara (\alpha_i) dari FEM, menghitung prediksi skala log, lalu dikembalikan (exponential) ke satuan asli fisik (Juta Metrik Ton):
* **Kutub Pertumbuhan Tinggi (Indonesia, Vietnam, Kamboja):** Mengalami kemiringan grafik proyeksi tertajam. Indonesia resmi memimpin sebagai kontributor fisik terbesar yang diproyeksikan menyentuh angka 761 Juta Ton CO2 pada tahun 2028 akibat skala ekonominya yang masif.
* **Kutub Anomali Dekopling (Brunei Darussalam):** Berhasil menunjukkan tren melandai turun secara konsisten. Karakteristik Fixed Effect Brunei membuktikan bahwa sebuah negara bisa tetap tumbuh makmur sambil menekan intensitas karbonnya (decoupling emission).

---

## Kesimpulan Riset
1. **Pembuktian Teori Hubungan Ekonomi-Lingkungan (Efek Dominan GDP):** Riset ini membuktikan secara valid bahwa GDP per Capita merupakan penggerak tunggal paling dominan terhadap peningkatan emisi CO2 di kawasan ASEAN. Dengan nilai elastisitas sebesar 0.9547, artinya setiap pertumbuhan ekonomi sebesar 1% akan memicu lonjakan emisi karbon sebesar 0.95%. Negara-negara ASEAN masih terjebak dalam pola pertumbuhan konvensional yang belum ramah lingkungan (carbon-heavy growth).
2. **Paradoks Energi Fosil di Negara Berkembang:** Tidak signifikannya variabel persentase energi fosil secara parsial menunjukkan ketergantungan negara ASEAN terhadap batu bara dan minyak bumi sudah berada di level "stagnan tinggi" yang merata dari tahun ke tahun. Akibatnya, variasi data energi fosil tidak seprogresif ledakan pertumbuhan aktivitas ekonomi (GDP) dalam memicu dinamika emisi baru.
3. **Rekomendasi Kebijakan:** Model ini membuktikan bahwa tantangan terbesar ASEAN ke depan bukanlah menghentikan pertumbuhan ekonomi, melainkan bagaimana mempercepat transisi energi bersih agar nilai elastisitas 0.95 tersebut bisa ditekan mendekati angka nol di masa depan.
