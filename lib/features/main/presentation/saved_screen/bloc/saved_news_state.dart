part of 'saved_news_bloc.dart';

abstract class SavedNewsState extends Equatable {
  const SavedNewsState();

  @override
  List<Object> get props => [];
}

class SavedNewsInitial extends SavedNewsState {}

class SavedNewsLoading extends SavedNewsState {}

class SavedNewsLoaded extends SavedNewsState {
  final List<NewsModel> news;

  const SavedNewsLoaded(this.news);

  @override
  List<Object> get props => [news];
}

class SavedNewsError extends SavedNewsState {
  final String message;

  const SavedNewsError(this.message);

  @override
  List<Object> get props => [message];
}