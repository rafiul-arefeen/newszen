part of 'saved_news_bloc.dart';

abstract class SavedNewsEvent extends Equatable {
  const SavedNewsEvent();

  @override
  List<Object> get props => [];
}

class FetchSavedNews extends SavedNewsEvent {
  final String email;

  const FetchSavedNews({required this.email});

  @override
  List<Object> get props => [email];
}