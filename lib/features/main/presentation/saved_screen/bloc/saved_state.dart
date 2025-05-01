import 'package:equatable/equatable.dart';
import 'package:news_zen/core/model/news_model.dart';

abstract class SavedState extends Equatable {
  const SavedState();

  @override
  List<Object?> get props => [];
}

class SavedNewsInitial extends SavedState {}

class SavedNewsLoading extends SavedState {}


class SavedNewsLoaded extends SavedState {
  final List<NewsModel> savedNews;


  const SavedNewsLoaded({
    required this.savedNews,

  });

  @override
  List<Object?> get props => [savedNews];
}

class SavedNewsError extends SavedState {
  final String error;

  const SavedNewsError({required this.error});

  @override
  List<Object?> get props => [error];
}
