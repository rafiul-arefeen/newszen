part of 'home_bloc.dart';

abstract class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<NewsModel> news;
  final String selectedTopic;

  HomeLoadedState(this.news, this.selectedTopic);
}