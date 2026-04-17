import 'package:flutter/material.dart';

class AppKeys {
  static const dashboardDepremCard = Key('dashboard_deprem_card');
  static const dashboardHavaCard = Key('dashboard_hava_card');
  static const dashboardAqiCard = Key('dashboard_aqi_card');
  static const dashboardNamazCard = Key('dashboard_namaz_card');
  static const dashboardDovizCard = Key('dashboard_doviz_card');
  static const dashboardKonumText = Key('dashboard_konum_text');
  static const dashboardRefresh = Key('dashboard_refresh');
  static const dashboardOfflineBanner = Key('dashboard_offline_banner');

  static const navDashboard = Key('nav_dashboard');
  static const navDeprem = Key('nav_deprem');
  static const navHava = Key('nav_hava');
  static const navAqi = Key('nav_aqi');
  static const navNamaz = Key('nav_namaz');
  static const navDoviz = Key('nav_doviz');
  static const navAyarlar = Key('nav_ayarlar');

  static const depremMap = Key('deprem_map');
  static const depremList = Key('deprem_list');
  static const depremStats = Key('deprem_stats');
  static const depremFilterMagnitude = Key('deprem_filter_magnitude');
  static const depremFilterTime = Key('deprem_filter_time');
  static const depremFilterRegion = Key('deprem_filter_region');

  static const havaCurrentTemp = Key('hava_current_temp');
  static const havaCurrentHumidity = Key('hava_current_humidity');
  static const havaCurrentWind = Key('hava_current_wind');
  static const havaFeelsLike = Key('hava_feels_like');
  static const hava5GunList = Key('hava_5gun_list');
  static const havaSaatlikList = Key('hava_saatlik_list');
  static const havaCityDropdown = Key('hava_city_dropdown');
  static const havaGpsButton = Key('hava_gps_button');
  static const havaFavoriteButton = Key('hava_favorite_button');

  static const aqiValueText = Key('aqi_value_text');
  static const aqiCategoryText = Key('aqi_category_text');
  static const aqiColorIndicator = Key('aqi_color_indicator');
  static const aqiAdviceCard = Key('aqi_advice_card');
  static const aqiTrendChart = Key('aqi_trend_chart');
  static const aqiStationMap = Key('aqi_station_map');

  static const namazKalanSure = Key('namaz_kalan_sure');
  static const namazYaklasanVakit = Key('namaz_yaklasan_vakit');
  static const namazImsakText = Key('namaz_imsak_text');
  static const namazGunesText = Key('namaz_gunes_text');
  static const namazOgleText = Key('namaz_ogle_text');
  static const namazIkindiText = Key('namaz_ikindi_text');
  static const namazAksamText = Key('namaz_aksam_text');
  static const namazYatsiText = Key('namaz_yatsi_text');
  static const namazHaftalikList = Key('namaz_haftalik_list');
  static const namazCityDropdown = Key('namaz_city_dropdown');

  static const dovizUsdCard = Key('doviz_usd_card');
  static const dovizEurCard = Key('doviz_eur_card');
  static const dovizAltinCard = Key('doviz_altin_card');
  static const dovizRatesList = Key('doviz_rates_list');
  static const dovizFavoriteButton = Key('doviz_favorite_button');

  static const ayarlarThemeDropdown = Key('ayarlar_theme_dropdown');
  static const ayarlarDepremSwitch = Key('ayarlar_deprem_switch');
  static const ayarlarAqiSwitch = Key('ayarlar_aqi_switch');
  static const ayarlarDepremSlider = Key('ayarlar_deprem_slider');
  static const ayarlarAqiSlider = Key('ayarlar_aqi_slider');
  static const ayarlarRefreshDropdown = Key('ayarlar_refresh_dropdown');
  static const ayarlarCacheClear = Key('ayarlar_cache_clear');
}
