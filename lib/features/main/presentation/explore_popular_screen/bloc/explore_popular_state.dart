part of 'explore_popular_bloc.dart';

abstract class exploreState {}

class exploreInitial extends exploreState {}

class exploreLoading extends exploreState {}

class exploreLoaded extends exploreState {
  final List<NewsModel> results;

  exploreLoaded(this.results);
}

class exploreError extends exploreState {
  final String message;

  exploreError(this.message);
}