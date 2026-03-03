# Logi-Sentez-Digitalization
Bu proje, montaj hattında "tanımsız" konumda bulunan parçaların sentez ve analiz sürecini otomatize etmek amacıyla geliştirilmiştir. Manuel olarak Excel üzerinden yürütülen ve yaklaşık 90 dakika süren veri işleme süreci, geliştirilen SQL tabanlı algoritmalar ve dijital iş akışları sayesinde 5 dakikaya indirilmiştir.

## Temel Kazanımlar
* **Zaman Tasarrufu:** Süreç %94 oranında hızlandırıldı (1.5 saat -> 5 dk).

* **Verimlilik:** Yıllık tahmini 2,88 k€ kazanç sağlandı.

* **Hata Minimizasyonu:** Manuel veri girişi ve hesaplama hataları otomatik "Stoklama Çeşidi Alert" sistemiyle engellendi.

## Teknik Mimari ve Veri Kaynakları
Proje, 3 farklı ana veri kaynağını entegre ederek çalışır:

* **Fazla Stok Sayımı Verileri:** Güncel stok ve debord adetleri.

* Ambalaj ve lojistik akış parametreleri.

* **Adres Çalışması Verileri:** Hat kenarı (LBC) yerleşim bilgileri.

## Hesaplama Algoritmaları (7 Kritik Sütun)
Sistem, ham verileri işleyerek aşağıdaki 7 metriği otomatik olarak hesaplar:

* **emb/j (Günlük Ambalaj Tüketimi):** [Ortalama Tüketim] / ([Ambalaj İçi Adet] / [Adres Sayısı]) formülü ile hat kenarı akış hızı belirlenir.

* **Olması Gereken Dotasyon:** SQL kontrol parametreleri ve ambalaj katlarına yuvarlama mantığı ile hesaplanır.

* **İlave Dotasyon:** [Olması Gereken Dotasyon] - [Mevcut Dotasyon] farkı ile ihtiyaç belirlenir.

* **Aksiyon Kararı:** İlave dotasyon miktarı ve akış tipi (AP/İç Akışlar) kombinasyonuna göre dinamik aksiyon metinleri oluşturulur.

* **Sorumlu Bölüm:** Hesaplanan aksiyon tipine göre görevin hangi departmana (Yerleşim veya İç Akışlar) atanacağı belirlenir.

* **Stoklama Çeşidi Alert:** Dotasyonun ambalaj içi adet (UC) katlarıyla uyumlu olup olmadığını denetleyen kontrol mekanizmasıdır.

* **Kulvar Durumu:** Mevcut fiziksel kapasitenin hesaplanan ihtiyacı karşılayıp karşılamadığını analiz eder.

## Kullanılan Teknolojiler
* **SQL (MSSQL):** Veri işleme ve temel algoritmaların kurgulanması.
