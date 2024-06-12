import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

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
  "https://t3.ftcdn.net/jpg/02/43/12/34/240_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
  "https://t3.ftcdn.net/jpg/02/43/12/34/240_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
  "https://t3.ftcdn.net/jpg/02/43/12/34/240_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
  "https://t4.ftcdn.net/jpg/03/83/25/83/240_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg",
  "https://t3.ftcdn.net/jpg/03/02/88/46/240_F_302884605_actpipOdPOQHDTnFtp4zg4RtlWzhOASp.jpg",
];

final Random random = Random();

class HomeCubit extends Cubit<HomeState> {
  List<User> users = [];

  final scrollController = ScrollController();

  final displayedUsers = <User>[];
  int currentMax = 20;

  HomeCubit() : super(HomeInitial()) {
    users = List<User>.generate(43, (index) {
      return User(
        name: 'User $index',
        phoneNumber: '90330062$index',
        city: 'City $index',
        imageUrl: imageUrls[random.nextInt(imageUrls.length)],
        rupee: random.nextInt(100),
      );
    });
    displayedUsers.addAll(users.take(currentMax));
    emit(HomeUserShow());
    /*scrollController.addListener(() {
      if (ScrollController().position.pixels ==
          ScrollController().position.maxScrollExtent) {
        loadMore();
      }
    });*/
  }

  void loadMore() {
    if (currentMax < users.length) {
      currentMax += 20;
      displayedUsers.assignAll(users.take(currentMax));
      emit(HomeUserShow());
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      displayedUsers.assignAll(users.take(currentMax));
      emit(HomeUserShow());
    } else {
      displayedUsers.assignAll(users
          .where((user) =>
              user.name.contains(query) ||
              user.phoneNumber.contains(query) ||
              user.city.contains(query))
          .take(currentMax)
          .toList());
      emit(HomeUserShow());
    }
  }

  void updateRupee(User user, int newRupee) {
    users.map(
      (e) {
        if (e.name == user.name) {
          e.rupee = newRupee;
        }
      },
    ).toList();
    displayedUsers.map(
      (e) {
        if (e.name == user.name) {
          e.rupee = newRupee;
        }
      },
    ).toList();
    emit(HomeUserShow());
  }
}
