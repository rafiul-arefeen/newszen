// features/explore/bloc/explore_popular_bloc.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_zen/config/server_config.dart';

part 'explore_popular_event.dart';
part 'explore_popular_state.dart';

class ExplorePopularBloc extends Bloc<exploreEvent, exploreState> {
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;

  ExplorePopularBloc() : super(exploreInitial()) {
    on<exploreQueryChanged>(_onexploreQueryChanged);
  }

  // No API explore method
  // void _onexploreQueryChanged(exploreQueryChanged event,
  //     Emitter<exploreState> emit) async {
  //   emit(exploreLoading());
  //
  //   try {
  //     final results = mockNewsData
  //         .where((news) =>
  //     news.title.toLowerCase().contains(event.query.toLowerCase()) ||
  //         news.description
  //             .toLowerCase()
  //             .contains(event.query.toLowerCase()))
  //         .toList();
  //
  //     emit(exploreLoaded(results));
  //   } catch (e) {
  //     emit(exploreError('Failed to load explore results'));
  //   }
  // }

  // API explore
  void _onexploreQueryChanged(exploreQueryChanged event, Emitter<exploreState> emit) async {
    emit(exploreLoading());

    try {
      final urldata = categoryurl + "?category=${event.query}&page=$currentPage&limit=$limit";
      final response = await http.get(Uri.parse(urldata)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the response as a List<dynamic>
        final List<dynamic> results = json.decode(response.body);

        if (results.isEmpty) {
          hasMoreData = false;
        }

        // Convert the list of JSON objects into a list of NewsModel
        final List<NewsModel> news = results.map((item) => NewsModel.fromJson(item)).toList();

        emit(exploreLoaded(news));
      } else {
        emit(exploreError('Failed to load explore results'));
      }
    } catch (e) {
      emit(exploreError('Failed to load explore results: $e'));
    }
  }
}
