import 'package:equatable/equatable.dart';
import 'package:news_zen/core/model/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class TrendingNewsLoading extends NewsState {}

class TrendingNewsLoaded extends NewsState {
  final List<NewsModel> trendingNews;

  const TrendingNewsLoaded({
    required this.trendingNews
  });

  @override
  List<Object?> get props => [trendingNews];
}
class NewsLoaded extends NewsState {
  final List<NewsModel> pageViewNews;
  final List<NewsModel> horizontalNews;
  final List<NewsModel> trendingNews;
  final List<NewsModel> popularNews;
  final List<NewsModel> latestNews;
  final List<NewsModel> mostViewedNews;

  const NewsLoaded({
    required this.pageViewNews,
    required this.horizontalNews,
    required this.trendingNews,
    required this.popularNews,
    required this.latestNews,
    required this.mostViewedNews,
  });

  @override
  List<Object?> get props => [pageViewNews, horizontalNews];
}

class NewsError extends NewsState {
  final String error;

  const NewsError({required this.error});

  @override
  List<Object?> get props => [error];
}
