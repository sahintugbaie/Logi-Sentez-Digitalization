CREATE VIEW vw_Debord_Sentezi_Analizi AS
WITH Temel_Hesaplamalar AS (
    SELECT 
        Referans,
        [7 Günlük Ortalama Tüketim] AS Ortalama, -- Ortalama tüketim verisi
        [Küçük amabalaj içi adet] AS UC,               -- Ambalaj içi adet [cite: 18, 46, 49]
        [Adres Sayısı] AS LBC, -- Adres sayısı [cite: 46, 49]
        MevcutDotasyon,
        AkisTipi,
        
        /* 1. Algoritma: (Günlük Ambalaj Tüketimi) */
        CAST([7 Günlük Ortalama Tüketim] AS FLOAT) / 
        NULLIF((CAST([Küçük amabalaj içi adet] AS FLOAT) / NULLIF([Adres Sayısı], 0)), 0) AS Emb_J,

        /* 2. Algoritma: Olması Gereken Dotasyon */
        CEILING(CAST([Photostock 7 Days Average] AS FLOAT) / NULLIF([Küçük amabalaj içi adet], 0)) * [Küçük amabalaj içi adet] AS OlmasiGerekenDotasyon

    FROM HamVeriler -- FazlaStok, VeriTabanı ve Adres Çalışması tablolarının join hali
)
SELECT 
    *,
    /* 3. Algoritma: İlave Dotasyon */ 
    (OlmasiGerekenDotasyon - MevcutDotasyon) AS IlaveDotasyon,

    /* 4. Algoritma: Aksiyon Kararı */
    CASE 
        WHEN (OlmasiGerekenDotasyon - MevcutDotasyon) > 0 THEN 
            'Dotasyon ' + CAST(OlmasiGerekenDotasyon AS VARCHAR) + ' olacak şekilde yer gözü verilmeli.'
        WHEN AkisTipi = 'AP' THEN 'Ap stok güncelleme'
        ELSE 'İç lojistik aksiyonunu yazınız.'
    END AS Aksiyon,

    /* 5. Algoritma: Sorumlu Bölüm */
    CASE 
        WHEN (OlmasiGerekenDotasyon - MevcutDotasyon) > 0 THEN 'Yerleşim'
        ELSE 'İç Akışlar'
    END AS SorumluBolum,

    /* 6. Algoritma: Stok Çeşidi Alert */
    CASE 
        WHEN (OlmasiGerekenDotasyon % UC) <> 0 THEN 'Hata: UC Katı Değil'
        ELSE 'Normal'
    END AS Stok Çeşidi Alert,

    /* 7. Algoritma: Kulvar Durumu */
    CASE 
        WHEN MevcutDotasyon >= OlmasiGerekenDotasyon THEN 'Yeterli'
        ELSE 'Kapasite Artırımı Gerekli'
    END AS KulvarDurumu
FROM Temel_Hesaplamalar;