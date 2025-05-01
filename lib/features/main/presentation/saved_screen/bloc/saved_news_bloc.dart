import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'saved_news_event.dart';
part 'saved_news_state.dart';

class SavedNewsBloc extends Bloc<SavedNewsEvent, SavedNewsState> {
  bool hasMoreData = true;

  SavedNewsBloc() : super(SavedNewsInitial()) {
    on<FetchSavedNews>(_onFetchSavedNews);
  }

  Future<void> _onFetchSavedNews(
      FetchSavedNews event, Emitter<SavedNewsState> emit) async {
    emit(SavedNewsLoading());
    print('Fetching saved news for email: ${event.email}'); // Debug print

    try {
      final url = 'https://newszen-apibackend.vercel.app/getsavednews';
      print('API URL: $url'); // Debug print

      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'email': event.email}), // Send email in the request body
        headers: {'Content-Type': 'application/json'}, // Set headers
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API Response: $data'); // Debug print

        // Extract the 'savedNews' list from the response
        final List<dynamic> savedNews = data['savedNews'];

        if (savedNews.isEmpty) {
          hasMoreData = false; // No more data available
        }

        // Parse the list of news articles
        final List<NewsModel> news = savedNews.map((item) => NewsModel.fromJson(item)).toList();
        emit(SavedNewsLoaded(news));
        print('Emitted SavedNewsLoaded state'); // Debug print
      } else {
        emit(SavedNewsError('Failed to load saved news'));
        print('Emitted SavedNewsError state'); // Debug print
      }
    } catch (e) {
      emit(SavedNewsError('Failed to load saved news: $e'));
      print('Emitted SavedNewsError state: $e'); // Debug print
    }
  }
}