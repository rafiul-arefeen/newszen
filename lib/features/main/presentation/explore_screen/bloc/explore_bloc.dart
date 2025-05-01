import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../config/server_config.dart';
import '../../../../../core/utils/pref_utils.dart';

part 'explore_state.dart';
part 'explore_event.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  bool hasMoreData = true;
  int currentPage = 1;
  int limit = 10;
  List<NewsModel> recomendedNews=[];

  ExploreBloc() : super(ExploreLoadingState()) {
    on<ChangeTopicEvent>(_onChangeTopic);
    on<LoadExploreDataEvent>(_onLoadExploreData);
    on<SelectTagEvent>(_onSelectTag);
    on<FetchPopularNewsEvent>(_onFetchPopularNews);

    on<LoadRecomendedNewsEvent>(_onLoadRecomendedNews); // New event handler

    add(LoadRecomendedNewsEvent());
    // New event handler

   // Trigger loading recommended news on initialization// New event handler
  }
  void _onLoadRecomendedNews(LoadRecomendedNewsEvent event, Emitter<ExploreState> emit) async {
    try {

      await _loadRecomendedData();

     // emit(ExploreLoadedState(recomendedNews, 'Recommended'));
    } catch (e) {
      emit(ExploreErrorState('Error loading recommended news: $e'));
    }
  }

  void _onChangeTopic(ChangeTopicEvent event, Emitter<ExploreState> emit) {
    final filteredNews = event.topic == 'All'
        ? mockNewsData
        : mockNewsData.where((news) => news.topic == event.topic).toList();
    emit(ExploreLoadedState(filteredNews, event.topic));
  }

  void _onLoadExploreData(LoadExploreDataEvent event, Emitter<ExploreState> emit) {
    emit(ExploreLoadedState(mockNewsData, 'All'));
  }

  void _onSelectTag(SelectTagEvent event, Emitter<ExploreState> emit) {
    if (state is ExploreLoadedState) {
      final currentState = state as ExploreLoadedState;
      final filteredNews = mockNewsData
          .where((news) =>
      news.title.toLowerCase().contains(event.tag.toLowerCase()) ||
          news.description.toLowerCase().contains(event.tag.toLowerCase()))
          .toList();
      emit(ExploreLoadedState(filteredNews, currentState.selectedTopic));
    }
  }

  // New handler for fetching popular news
  void _onFetchPopularNews(FetchPopularNewsEvent event, Emitter<ExploreState> emit) async {
    emit(ExploreLoadingState()); // Show loading state

    try {
      final urldata = categoryurl + "?category=${event.tag}&page=$currentPage&limit=$limit";
      final response = await http.get(Uri.parse(urldata)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        List<dynamic> results;
        if (decodedResponse is List) {
          // API response is a List
          results = decodedResponse;
        } else if (decodedResponse is Map<String, dynamic>) {
          // API response is a Map with a "results" key
          results = decodedResponse['results'] ?? [];
        } else {
          throw Exception('Invalid API response format');
        }

        if (results.isEmpty) {
          hasMoreData = false;
        }

        final List<NewsModel> news = results.map((item) => NewsModel.fromJson(item)).toList();
        emit(ExploreLoadedState(news, 'Popular')); // Emit loaded state with popular news
      } else {
        emit(ExploreErrorState('Failed to fetch popular news: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ExploreErrorState('An error occurred: $e'));
    }
  }
  Future<void> _loadRecomendedData() async {


    try {

      final getpriorityurl = getsavedurl;

      await PrefUtils.init();

      String? email = await PrefUtils.getEmail();


      var regBody ={"email": await email ?? ""};
      print(email);

      var response = await http.post(
        Uri.parse(getprioritiesuser),
        headers: {"Content-type":"application/json"},
        body: jsonEncode(regBody),
      );
      print(response.statusCode);
      print(response.body);


      if (response.statusCode == 200) {


        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          Map<String, int> categoryPriority = Map<String, int>.from(jsonResponse['categoryPriority']);
          Map<String, int> sourcePriority = Map<String, int>.from(jsonResponse['sourcePriority']);

          // Debugging prints
          print("Category Priority: $categoryPriority");
          print("Source Priority: $sourcePriority");

          Map<String, dynamic> requestBody = {
            "page": 1,
            "limit": 10,
            "categoryPriority": categoryPriority,
            "sourcePriority": sourcePriority
          };

          var responsefinal = await http.post(
            Uri.parse(getrecomendednews),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          );



          List<dynamic> dataNewRecomended = json.decode(responsefinal.body);


          // Now you can use dataNew as a Map to access the properties
          List<NewsModel> news= dataNewRecomended.map((item) => NewsModel.fromJson(item)).toList();

          recomendedNews.addAll(news);
          print(recomendedNews[0]);



          // Prints the savedNews array
        }


      } else {

        emit(ExploreErrorState("hi"));
      }
    } catch (e) {
      emit(ExploreErrorState( e.toString()));
    }
  }
  List<NewsModel> loadRecomendedData(){
    print('hi iam here');
    return recomendedNews;
  }

}