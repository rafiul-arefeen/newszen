part of 'news_by_source_bloc.dart';

abstract class NewsBySourceState extends Equatable {
  const NewsBySourceState();

  @override
  List<Object> get props => [];
}

class NewsBySourceInitial extends NewsBySourceState {}

class NewsBySourceLoading extends NewsBySourceState {}

class NewsBySourceLoaded extends NewsBySourceState {
  final List<NewsModel> news;

  const NewsBySourceLoaded(this.news);

  @override
  List<Object> get props => [news];
}

class NewsBySourceError extends NewsBySourceState {
  final String message;

  const NewsBySourceError(this.message);

  @override
  List<Object> get props => [message];
}