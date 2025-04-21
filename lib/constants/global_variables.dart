import 'package:flutter/material.dart';

String uri = 'http://192.168.206.203:3000';

// API Keys
// ignore: constant_identifier_names
const String GEMINI_API_KEY = 'AIzaSyCdi2fInyjOrq8BU4zvt0yGu-1HnuLrN4o';

class GlobalVariables {
  // COLORS

  static const secondaryColor = Color.fromRGBO(50, 50, 50, 25);
  static const textColor = Color.fromRGBO(205, 205, 204, 255);
  static const backgroundColor = Color.fromRGBO(36, 37, 37, 255);

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {'title': 'Mobiles', 'image': 'assets/images/mobiles.jpeg'},
    {'title': 'Essentials', 'image': 'assets/images/essentials.jpeg'},
    {'title': 'Appliances', 'image': 'assets/images/appliances.jpeg'},
    {'title': 'Books', 'image': 'assets/images/books.jpeg'},
    {'title': 'Fashion', 'image': 'assets/images/fashion.jpeg'},
  ];
}
