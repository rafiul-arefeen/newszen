
class AppAssets{
  AppAssets._();

  static _ImageConstant get image => _ImageConstant();
}

class _ImageConstant {

  static String imagePath = 'assets/images';
  static String newsIconPath = 'assets/news_icons';
  static String socialIconPath = 'assets/social_icons';

  String img_short_logo ='$imagePath/img_short_logo.png';
  String img_med_logo = '$imagePath/img_med_logo.png';

  String img_prothom_alo_logo = '$newsIconPath/prothomalo.png';
  String img_bdnews24_logo = '$newsIconPath/bdnews24.png';
  String img_mzamin_logo = '$newsIconPath/mzamin.png';
  String img_daily_star_logo = '$newsIconPath/dailystar.png';
  String img_ittefaq_logo = '$newsIconPath/ittefaq.png';
  String img_cnn_logo = '$newsIconPath/cnn.png';
  String img_aljazeera_logo = '$newsIconPath/aljazeera.png';
  String img_bbc_logo = '$newsIconPath/bbc.png';

  String img_logoname = '$imagePath/img_logoname.png';

  String img_dilip_kumar = '$imagePath/img_dilip_kumar.png';
  String img_news = '$imagePath/img_news.png';
  String img_user_profile = "$imagePath/img_user_profile.jpg";

  String img_home_icon = '$imagePath/img_home_icon.png';
  String img_explore_icon = '$imagePath/img_explore_icon.png';
  String img_saved_icon = '$imagePath/img_saved_icon.png';
  String img_profile_icon = '$imagePath/img_profile_icon.png';

  String img_home_icon_active = '$imagePath/img_home_icon_active.png';
  String img_explore_icon_active = '$imagePath/img_explore_icon_active.png';
  String img_saved_icon_active = '$imagePath/img_saved_icon_active.png';
  String img_profile_icon_active = '$imagePath/img_profile_icon_active.png';

  String img_globe_icon = '$socialIconPath/globe.png';
  String img_twitter_icon = '$socialIconPath/twitter.png';
  String img_youtube_icon = '$socialIconPath/youtube.png';
}