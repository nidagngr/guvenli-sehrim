# Guvenli Sehirim

Nida Gungormus

Ad Soyad: Nidasu Gungormus
Ogrenci No: 22080410007

Bu repo, AFAD deprem, MGM hava, IBB AQI, vakit ve TCMB doviz verilerini tek uygulamada toplayan bir monorepo projedir.

## Klasorler

- `backend`: Node.js + Express API gateway, cache ve cron isleri
- `mobile`: Flutter + Provider + Hive tabanli Android uygulamasi

## Calistirma

```bash
docker compose up --build
```

```bash
cd mobile
flutter pub get
flutter build apk --debug
```

## Backend Route'lari

- `/deprem`
- `/hava?city=Ankara`
- `/kalite`
- `/namaz?city=Istanbul`
- `/doviz`
- `/sistem`
