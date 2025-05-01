part of "explore_bloc.dart";

abstract class ExploreEvent {}

class ChangeTopicEvent extends ExploreEvent {
  final String topic;

  ChangeTopicEvent(this.topic);
}

class LoadExploreDataEvent extends ExploreEvent {}

class SelectTagEvent extends ExploreEvent {
  final String tag;

  SelectTagEvent(this.tag);
}

class FetchPopularNewsEvent extends ExploreEvent {
  final String tag;

  FetchPopularNewsEvent(this.tag);
}

class LoadRecomendedNewsEvent extends ExploreEvent {}