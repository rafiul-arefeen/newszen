part of 'news_by_source_bloc.dart';

abstract class NewsBySourceEvent extends Equatable {
  const NewsBySourceEvent();

  @override
  List<Object> get props => [];
}

class FetchNewsBySource extends NewsBySourceEvent {
  final String source;
  final int page;
  final int limit;

  const FetchNewsBySource({required this.source, this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [source, page, limit];
}