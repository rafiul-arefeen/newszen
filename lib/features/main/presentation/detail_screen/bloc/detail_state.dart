part of 'detail_cubit.dart';

class DetailState extends Equatable {
  final bool _isLiked;
  final bool _isSaved;
  @override
  List<Object?> get props => [isLiked, isSaved];

  DetailState({required bool isLiked, required bool isSaved})
      : _isLiked = isLiked,
        _isSaved = isSaved;

  bool get isLiked => _isLiked;  // Getter for isLiked
  bool get isSaved => _isSaved;  // Getter for isSaved
}

class InitialLikeSaveState extends DetailState {
  InitialLikeSaveState() : super(isLiked: false, isSaved: false);
}




