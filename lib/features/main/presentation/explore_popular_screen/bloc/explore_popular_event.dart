part of 'explore_popular_bloc.dart';

abstract class exploreEvent {}

class exploreQueryChanged extends exploreEvent {
  final String query;

  exploreQueryChanged(this.query);
}