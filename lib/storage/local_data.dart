import 'package:flutter_app/custom_widgets/chats.dart';
import 'package:flutter_app/custom_widgets/contacts.dart';
import 'package:flutter_app/custom_widgets/profile.dart';

class LocalData {
  static const List<Map<String, String>> pagerList = [
    {'image': 'assets/images/Chat.png', 'title': 'Send & Recieve Messages'},
    {'image': 'assets/images/world.png', 'title': 'Be Connected'},
    {'image': 'assets/images/Safe.png', 'title': 'Safe and Secure'},
    {
      'image': 'assets/images/Text.png',
      'title': 'Have longer and encrypted conversation'
    },
    {'image': 'assets/images/notify.png', 'title': 'Get Notifications'},
    {'image': 'assets/images/enjoy.png', 'title': 'Enjoy!!!'},
  ];
  static List<Map<String, dynamic>> bottomNavList = [
    {
      'Screen': Chats(),
      'title': 'Chats',
    },
    {
      'Screen': Contacts(),
      'title': 'Contacts',
    },
    {
      'Screen': Profile(),
      'title': 'Profile',
    },
  ];
}
