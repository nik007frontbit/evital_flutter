import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class User {
  final String name;
  final String phoneNumber;
  final String city;
  final String imageUrl;
  int rupee;

  User({
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.imageUrl,
    required this.rupee,
  });

  bool get isHighStock => rupee > 50;
}

final List<String> imageUrls = [
  "https://www.wilsoncenter.org/sites/default/files/styles/large/public/media/images/person/james-person-1.webp",
  "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg",
  "https://t3.ftcdn.net/jpg/02/43/12/34/240_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
  "https://t4.ftcdn.net/jpg/03/83/25/83/240_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg",
  "https://t3.ftcdn.net/jpg/03/02/88/46/240_F_302884605_actpipOdPOQHDTnFtp4zg4RtlWzhOASp.jpg",
];

final Random random = Random();

class UserController extends GetxController {
  final users = List<User>.generate(43, (index) {
    return User(
      name: 'User $index',
      phoneNumber: '90330062$index',
      city: 'City $index',
      imageUrl: imageUrls[random.nextInt(imageUrls.length)],
      rupee: random.nextInt(100),
    );
  }).obs;

  final scrollController = ScrollController();

  final displayedUsers = <User>[].obs;
  final searchController = TextEditingController().obs;
  final currentMax = 20.obs;

  @override
  void onInit() {
    super.onInit();
    displayedUsers.addAll(users.take(currentMax.value));
    scrollController.addListener(() {
      if (ScrollController().position.pixels ==
          ScrollController().position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  void loadMore() {
    if (currentMax.value < users.length) {
      currentMax.value += 20;
      displayedUsers.assignAll(users.take(currentMax.value));
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      displayedUsers.assignAll(users.take(currentMax.value));
    } else {
      displayedUsers.assignAll(users
          .where((user) =>
              user.name.contains(query) ||
              user.phoneNumber.contains(query) ||
              user.city.contains(query))
          .take(currentMax.value)
          .toList());
    }
  }

  void updateRupee(User user, int newRupee) {
    user.rupee = newRupee;
    users.refresh();
    displayedUsers.refresh();
  }
}
