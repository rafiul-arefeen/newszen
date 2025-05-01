part of 'home_bloc.dart';

abstract class HomeEvent {}

class ChangeTopicEvent extends HomeEvent {
  final String topic;

  ChangeTopicEvent(this.topic);
}

class LoadHomeDataEvent extends HomeEvent {}