import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../config/server_config.dart';

part 'news_by_source_event.dart';
part 'news_by_source_state.dart';

class NewsBySourceBloc extends Bloc<NewsBySourceEvent, NewsBySourceState> {
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;
  String selectedSource = "CNN";

  NewsBySourceBloc() : super(NewsBySourceInitial()) {
    on<FetchNewsBySource>(_onFetchNewsBySource);
  }

  Future<void> _onFetchNewsBySource(
      FetchNewsBySource event, Emitter<NewsBySourceState> emit) async {
    emit(NewsBySourceLoading());
    print('Fetching news for source: ${event.source}'); // Debug print

    try {
      final url = sourceurl + "?source=${event.source}&page=$currentPage&limit=$limit";
      print('API URL: $url'); // Debug print
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          hasMoreData = false;
        }

        final List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();
        emit(NewsBySourceLoaded(news));
        print('Emitted NewsBySourceLoaded state'); // Debug print
      } else {
        emit(NewsBySourceError('Failed to load news by source'));
        print('Emitted NewsBySourceError state'); // Debug print
      }
    } catch (e) {
      emit(NewsBySourceError('Failed to load news: $e'));
      print('Emitted NewsBySourceError state: $e'); // Debug print
    }
  }
}