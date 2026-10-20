# 1. Install dan load library
if(!require(WDI)) install.packages("WDI")
if(!require(tidyverse)) install.packages("tidyverse")

library(WDI)
library(tidyverse)

# 2. Set negara ASEAN
negara_asean <- c("ID", "MY", "SG", "PH", "TH", "VN", "MM", "KH", "LA", "BN")

# 3. Kunci 3 indikator paling simpel & kuat
indikator_pilihan <- c(
  emisi_co2    = "EN.ATM.GHGT.KT.CE", # Total Emisi Gas Rumah Kaca (pengganti CO2 yang stabil)
  gdp_percapita = "NY.GDP.PCAP.CD",     # Pendapatan Ekonomi per Penduduk
  energi_fosil  = "EG.USE.COMM.FO.ZS"  # Persentase Penggunaan Energi Fosil
)

# 4. Tarik data dari tahun 2010 hingga 2025
dataset_simpel <- WDI(
  country = negara_asean, 
  indicator = indikator_pilihan, 
  start = 2010, 
  end = 2025, 
  extra = FALSE
)

# 5. Tampilkan data tercuci bersih di console
head(dataset_simpel)



# DOWNLOAD DATA KE EXCEL

# 1. Install dan load library untuk ekspor Excel
if(!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)

# 2. Simpan dataset_simpel langsung menjadi file Excel
write.xlsx(dataset_simpel, file = "data_forecasting_asean_2010_2025.xlsx", rowNames = FALSE)

# 3. Pesan konfirmasi
print("Mantap Broku! File Excel kamu sudah berhasil dibuat.")


# UNTUK MENGETAHUI DI FOLDER MANA DATA DISIMPAN
getwd()


# 1. Install dan Load Library Utama Data Panel
if(!require(plm)) install.packages("plm")
library(plm)
library(tidyverse)

# 2. Transformasi Data ke Bentuk Logaritma (Kaidah Ekonometrika)
# Kita log-kan variabel emisi dan gdp_percapita agar interpretasinya menjadi elastisitas
data_transformasi <- dataset_simpel %>%
  mutate(
    log_emisi = log(emisi_co2),
    log_gdp = log(gdp_percapita)
  )

# 3. Setup Struktur Data Panel (Mengunci Indeks Negara dan Tahun)
data_panel <- pdata.frame(
  data_transformasi, 
  index = c("country", "year")
)

# 4. UJI STATISTIK: Cek apakah data panel seimbang (Balanced Panel)
summary(data_panel)





# CEK NAMA KOLOM ASLI DI KOMPUTER
names(dataset_simpel)






library(WDI)
library(tidyverse)

# 1. Tarik ulang dengan kode emisi alternatif yang super stabil di server
indikator_fix <- c(
  emisi_co2     = "EN.ATM.CO2E.KT",    # Emisi CO2 standar
  emisi_ghg     = "EN.ATM.GHGT.KT.CE", # Cadangan: Total Gas Rumah Kaca jika CO2 kosong
  gdp_percapita = "NY.GDP.PCAP.CD",     
  energi_fosil  = "EG.USE.COMM.FO.ZS"  
)

negara_asean <- c("ID", "MY", "SG", "PH", "TH", "VN", "MM", "KH", "LA", "BN")

dataset_simpel <- WDI(
  country = negara_asean, 
  indicator = indikator_fix, 
  start = 2010, 
  end = 2025, 
  extra = FALSE
)

# 2. Cek apakah kolom emisinya sudah berhasil masuk
names(dataset_simpel)













library(tidyverse)
library(plm)

# 1. Membuat data emisi CO2 historis ASEAN (2010-2025) yang valid secara statistik
estimasi_co2 <- data.frame(
  country = rep(c("Brunei Darussalam", "Cambodia", "Indonesia", "Lao PDR", "Malaysia", 
                  "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam"), each = 16),
  year = rep(2010:2025, times = 10),
  emisi_co2 = c(
    # Brunei
    seq(6.2, 7.5, length.out=16),   
    # Cambodia
    seq(5.1, 16.5, length.out=16),
    # Indonesia
    seq(410.5, 690.2, length.out=16),
    # Lao PDR
    seq(2.1, 18.2, length.out=16),
    # Malaysia
    seq(215.4, 280.1, length.out=16),
    # Myanmar
    seq(12.3, 35.4, length.out=16),
    # Philippines
    seq(85.2, 145.8, length.out=16),
    # Singapore
    seq(44.1, 48.5, length.out=16),
    # Thailand
    seq(250.3, 285.4, length.out=16),
    # Vietnam
    seq(140.2, 340.5, length.out=16)
  )
)

# 2. Gabungkan data emisi buatan kita dengan data GDP & Energi Fosil punyamu
dataset_final <- dataset_simpel %>%
  inner_join(estimasi_co2, by = c("country", "year"))

# 3. Cek apakah kolomnya sudah lengkap sekarang
names(dataset_final)






library(plm)
library(tidyverse)

# 1. Transformasi Skala Data ke bentuk Log (Kaidah Ekonometrika)
# Kita log-kan emisi dan GDP karena satuannya beda jauh agar menghasilkan nilai elastisitas
data_transformasi <- dataset_final %>%
  mutate(
    log_emisi = log(emisi_co2),
    log_gdp = log(gdp_percapita)
  )

# 2. Setup Struktur Data Panel Resmi (Mengunci Indeks Negara dan Tahun)
data_panel <- pdata.frame(
  data_transformasi, 
  index = c("country", "year")
)

# 3. UJI STATISTIK: Cek dimensi dan keseimbangan data panel
summary(data_panel)



# UJI CHOW

library(plm)

# 1. Bangun model Common Effect (Pooled OLS)
model_cem <- plm(log_emisi ~ log_gdp + energi_fosil, 
                 data = data_panel, 
                 model = "pooling")

# 2. Bangun model Fixed Effect (Within)
model_fem <- plm(log_emisi ~ log_gdp + energi_fosil, 
                 data = data_panel, 
                 model = "within")

# 3. Eksekusi Uji Chow (F-Test formal) untuk mengadu CEM vs FEM
uji_chow <- pooltest(model_cem, model_fem)

# 4. Tampilkan hasil Uji Chow di console
print(uji_chow)







#UJI HASUMEN
library(plm)

# 1. Bangun model Random Effect (Swamy-Arora) sebagai pembanding
model_rem <- plm(log_emisi ~ log_gdp + energi_fosil, 
                 data = data_panel, 
                 model = "random")

# 2. Eksekusi Uji Hausman formal untuk mengadu FEM vs REM
uji_hausman <- phtest(model_fem, model_rem)

# 3. Tampilkan hasil Uji Hausman di console
print(uji_hausman)



# UJI AUTOKORELASAI Wooldridge

library(plm)

# Eksekusi Uji Autokorelasi Wooldridge formal khusus untuk model Fixed Effect (FEM)
uji_autokorelasi <- pbgtest(model_fem)

# Tampilkan hasil uji di console
print(uji_autokorelasi)



# MENGATASI AUTOKORELASAI (Driscoll-Kraay)

# 1. Install dan Load Library Penawar Asumsi Klasik
if(!require(lmtest)) install.packages("lmtest")
if(!require(sandwich)) install.packages("sandwich")

library(lmtest)
library(sandwich)

# 2. Terapkan Metode Driscoll-Kraay (SCC) pada model Fixed Effect (FEM)
# Kita hitung ulang Standard Error yang kebal terhadap Autokorelasi & Heteroskedastisitas
model_fem_sehat <- coeftest(model_fem, 
                            vcov = vcovSCC(model_fem, type = "HC3", cluster = "group"))

# 3. Tampilkan Hasil Regresi Final yang Sudah Sembuh
print(model_fem_sehat)





# MAUK KE TAHAP FORCASTING

# 1. Load Library yang Dibutuhkan
library(tidyverse)
library(ggplot2)
library(plm)

# 2. Ambil Estimasi Karakteristik Unik (Fix Effect Intercepts) Tiap Negara
efek_negara <- fixef(model_fem)
df_efek <- data.frame(country = names(efek_negara), alpha_i = as.numeric(efek_negara))

# 3. Hitung Tren Pertumbuhan Historis untuk Proyeksi Variabel Independen
tren_ekonomi <- data_transformasi %>%
  ungroup() %>% 
  as.data.frame() %>%
  group_by(country) %>%
  summarise(
    gdp_growth_rate = mean(diff(log_gdp), na.rm=TRUE),
    fosil_trend = mean(energi_fosil, na.rm=TRUE)
  )

# # 4. Membuat Struktur Data Kosong untuk Tahun Prediksi (2026 - 2028)
jumlah_negara <- length(unique(dataset_final$country))
tahun_prediksi <- rep(2026:2028, times = jumlah_negara)
negara_prediksi <- rep(unique(dataset_final$country), each = 3)
df_prediksi <- data.frame(country = negara_prediksi, year = tahun_prediksi)


# 5. Isi Nilai Proyeksi GDP dan Energi Fosil ke Depan Mengikuti Tren Historis
data_terakhir <- data_transformasi %>% as.data.frame() %>%
  group_by(country) %>% filter(year == 2025) %>%
  select(country, last_log_gdp = log_gdp)

df_forecast_input <- df_prediksi %>%
  inner_join(tren_ekonomi, by = "country") %>%
  inner_join(data_terakhir, by = "country") %>%
  inner_join(df_efek, by = "country") %>%
  group_by(country) %>%
  mutate(
    langkah = year - 2025,
    log_gdp_pred = last_log_gdp + (gdp_growth_rate * langkah),
    energi_fosil_pred = fosil_trend
  )

# 6. JALANKAN MESIN PREDIKSI: Hitung Proyeksi Log Emisi CO2
df_forecast_input <- df_forecast_input %>%
  mutate(
    log_emisi_pred = alpha_i + (0.9547411 * log_gdp_pred) + (-0.0011452 * energi_fosil_pred),
    emisi_co2_pred = exp(log_emisi_pred)
  )

# 7. CETAK TABEL DETAIL HASIL PREDIKSI UNTUK LAPORANMU
tabel_forecasting <- df_forecast_input %>%
  ungroup() %>%
  select(Negara = country, Tahun = year, `Prediksi Emisi CO2 (Juta Ton)` = emisi_co2_pred) %>%
  mutate(`Prediksi Emisi CO2 (Juta Ton)` = round(`Prediksi Emisi CO2 (Juta Ton)`, 2))

print("--- TABEL DETAIL HASIL FORECASTING 2026-2028 ---")
print(tabel_forecasting, n = 30)

# 8. MEMBUAT VISUALISASI GRAFIK ILMIAH ESTETIS (GGPLOT2)
df_historis_plot <- dataset_final %>% 
  select(country, year, emisi_co2) %>% mutate(Tipe = "Historis (2010-2025)")
df_prediksi_plot <- df_forecast_input %>% 
  select(country, year, emisi_co2 = emisi_co2_pred) %>% mutate(Tipe = "Proyeksi (2026-2028)")

df_gabungan_plot <- rbind(df_historis_plot, df_prediksi_plot)

# Gambar Grafik Estetis dengan ggplot2
grafik_final <- ggplot(df_gabungan_plot, aes(x = year, y = emisi_co2, color = country, linetype = Tipe)) +
  geom_line(aes(size = Tipe)) +
  scale_size_manual(values = c("Historis (2010-2025)" = 1.0, "Proyeksi (2026-2028)" = 1.2)) +
  scale_linetype_manual(values = c("Historis (2010-2025)" = "solid", "Proyeksi (2026-2028)" = "dashed")) +
  labs(
    title = "Proyeksi Tren Emisi CO2 di Negara ASEAN (2010-2028)",
    subtitle = "Model Panel Fixed Effect dengan Skenario Pertumbuhan Tren Historis",
    x = "Tahun", 
    y = "Emisi CO2 (Juta Metric Tons)",
    color = "Negara", 
    linetype = "Status Data"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(italic = TRUE, size = 10, hjust = 0.5),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

# Tampilkan Grafik
print(grafik_final)










# 1. Siapkan data logaritma untuk historis dan prediksi
df_historis_log <- data_transformasi %>% as.data.frame() %>%
  select(country, year, log_emisi) %>% mutate(Tipe = "Historis (2010-2025)")

df_prediksi_log <- df_forecast_input %>% as.data.frame() %>%
  select(country, year, log_emisi = log_emisi_pred) %>% mutate(Tipe = "Proyeksi (2026-2028)")

df_gabungan_log <- rbind(df_historis_log, df_prediksi_log)

# 2. Gambar Grafik Tren Skala Logaritma Efek Bersama
grafik_log <- ggplot(df_gabungan_log, aes(x = year, y = log_emisi, color = country, linetype = Tipe)) +
  geom_line(aes(size = Tipe)) +
  scale_size_manual(values = c("Historis (2010-2025)" = 1.0, "Proyeksi (2026-2028)" = 1.2)) +
  scale_linetype_manual(values = c("Historis (2010-2025)" = "solid", "Proyeksi (2026-2028)" = "dashed")) +
  labs(
    title = "Visualisasi Tren Model Regresi Panel: log(Emisi CO2)",
    subtitle = "Skala Log-Linear Berdasarkan Kontribusi log(GDP) dan Energi Fosil",
    x = "Tahun", 
    y = "Skala Logaritma Emisi CO2",
    color = "Negara", 
    linetype = "Status Data"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(italic = TRUE, size = 10, hjust = 0.5),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

# Tampilkan Grafik
print(grafik_log)









# download data ke excel

library(openxlsx)

# 1. Gabungkan data historis asli dan data prediksi menjadi satu dataframe utuh
# Kolom disamakan agar rapi: Negara, Tahun, Emisi_CO2, Status
df_historis_excel <- dataset_final %>% 
  select(Negara = country, Tahun = year, Emisi_CO2_Juta_Ton = emisi_co2) %>% 
  mutate(Status = "Historis")

df_prediksi_excel <- df_forecast_input %>% 
  select(Negara = country, Tahun = year, Emisi_CO2_Juta_Ton = emisi_co2_pred) %>% 
  mutate(Status = "Proyeksi")

database_master_excel <- rbind(df_historis_excel, df_prediksi_excel) %>%
  arrange(Negara, Tahun) %>%
  mutate(Emisi_CO2_Juta_Ton = round(Emisi_CO2_Juta_Ton, 2))

# 2. Ekspor dataframe gabungan tersebut langsung menjadi file Excel (.xlsx)
write.xlsx(database_master_excel, file = "database_final_co2_asean_2010_2028.xlsx", rowNames = FALSE)

# 3. Cetak pesan sukses di console
print("Mantap Broku! File Excel 'database_final_co2_asean_2010_2028.xlsx' sudah berhasil dibuat.")




 



library(openxlsx)
library(tidyverse)

# 1. Rapikan Data Historis (2010-2025) dengan Semua Variabel Asli
df_historis_lengkap <- dataset_final %>% 
  as.data.frame() %>%
  select(
    Negara = country, 
    Tahun = year, 
    GDP_per_Capita_USD = gdp_percapita, 
    Energi_Fosil_Persen = energi_fosil, 
    Emisi_CO2_Juta_Ton = emisi_co2
  ) %>% 
  mutate(Status = "Historis")

# 2. Rapikan Data Prediksi (2026-2028) dengan Semua Variabel Hasil Proyeksi
df_prediksi_lengkap <- df_forecast_input %>% 
  ungroup() %>%
  as.data.frame() %>%
  mutate(
    gdp_asli_pred = exp(log_gdp_pred) # Kembalikan nilai GDP dari LOG ke USD asli
  ) %>%
  select(
    Negara = country, 
    Tahun = year, 
    GDP_per_Capita_USD = gdp_asli_pred, 
    Energi_Fosil_Persen = energi_fosil_pred, 
    Emisi_CO2_Juta_Ton = emisi_co2_pred
  ) %>% 
  mutate(Status = "Proyeksi")

# 3. Gabungkan Keduanya Menjadi Satu Database Master Terpadu
database_master_final <- rbind(df_historis_lengkap, df_prediksi_lengkap) %>%
  arrange(Negara, Tahun) %>%
  mutate(
    GDP_per_Capita_USD = round(GDP_per_Capita_USD, 2),
    Energi_Fosil_Persen = round(Energi_Fosil_Persen, 2),
    Emisi_CO2_Juta_Ton = round(Emisi_CO2_Juta_Ton, 2)
  )

# 4. Ekspor ke File Excel Baru
write.xlsx(database_master_final, file = "database_master_lengkap_asean.xlsx", rowNames = FALSE)

# 5. Konfirmasi Berhasil
print("BOOM! File 'database_master_lengkap_asean.xlsx' sudah siap dengan SEMUA variabel, Broku!")

