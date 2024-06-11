part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeUserShow extends HomeState {
  List<User> users;

  HomeUserShow({required this.users});
}
