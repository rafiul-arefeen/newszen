import 'package:equatable/equatable.dart';
import 'package:news_zen/core/model/news_model.dart';

import '../../../../../core/model/social_model.dart';

abstract class SocialNewsState extends Equatable {
  const SocialNewsState();

  @override
  List<Object?> get props => [];
}

class SocialNewsInitial extends SocialNewsState {}

class SocialNewsLoading extends SocialNewsState {}

// class TrendingNewsLoading extends NewsState {}

// class TrendingNewsLoaded extends SocialNewsState {
//   final List<NewsModel> trendingNews;
//
//   const TrendingNewsLoaded({
//     required this.trendingNews
//   });
//
//   @override
//   List<Object?> get props => [trendingNews];
// }


class SocialNewsLoaded extends SocialNewsState {
  final List<SocialModel> pageViewNews;
  // final List<SocialModel> horizontalNews;
  // final List<SocialModel> trendingNews;
  // final List<SocialModel> popularNews;
  // final List<SocialModel> latestNews;
  final List<SocialModel> mostViewedNews;

  const SocialNewsLoaded({
    required this.pageViewNews,
    // required this.horizontalNews,
    // required this.trendingNews,
    // required this.popularNews,
    // required this.latestNews,
    required this.mostViewedNews,
  });

  @override
  List<Object?> get props => [pageViewNews];
}

class SocialNewsError extends SocialNewsState {
  final String error;

  const SocialNewsError({required this.error});

  @override
  List<Object?> get props => [error];
}