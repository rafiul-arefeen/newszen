// features/search/bloc/explore_popular_bloc.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_zen/config/server_config.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;

  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  // No API search method
  // void _onSearchQueryChanged(SearchQueryChanged event,
  //     Emitter<SearchState> emit) async {
  //   emit(SearchLoading());
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
  //     emit(SearchLoaded(results));
  //   } catch (e) {
  //     emit(SearchError('Failed to load search results'));
  //   }
  // }

  // API search
  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    try {
      final urldata = searchurl + "?q=${event.query}&page=$currentPage&limit=$limit";
      final response = await http.get(Uri.parse(urldata)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        if (results.isEmpty) {
          hasMoreData = false;
        }

        final List<NewsModel> news = results.map((item) => NewsModel.fromJson(item)).toList();

        emit(SearchLoaded(news));
      } else {
        emit(SearchError('Failed to load search results'));
      }
    } catch (e) {
      emit(SearchError('Failed to load search results: $e'));
    }
  }
}
