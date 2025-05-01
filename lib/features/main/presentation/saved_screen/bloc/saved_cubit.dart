import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:news_zen/core/model/news_model.dart';

import 'package:http/http.dart' as http;
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:news_zen/features/main/presentation/saved_screen/bloc/saved_state.dart';

class SavedCubit extends Cubit<SavedState> {

  List<NewsModel> savedNews=[];

  List<dynamic> data = [];

  List<NewsModel> recomendedNews=[];


  SavedCubit() : super(SavedNewsInitial())  {
    _loadSaveData();
    _loadRecomendedData();
  }

  Future<void> _loadSaveData() async {


    try {
      emit(SavedNewsLoading());


      final getsavednewsurl = getsavedurl;

      await PrefUtils.init();

      String? email = await PrefUtils.getEmail();


      var regBody ={"email": await email ?? ""};

      var response = await http.post(
        Uri.parse(getsavednewsurl),
        headers: {"Content-type":"application/json"},
        body: jsonEncode(regBody),
      );


      if (response.statusCode == 200) {


        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          data = jsonResponse['savedNews'];
            // Prints the savedNews array
        }


        NewsResponse responseModel = NewsResponse.fromJson(json.decode(response.body));
        List<String> savedNewsFetch = responseModel.savedNews;


        if (data.isEmpty) {

          //hasMoreData = false;
        }
        else
        {
          var newsidurl = getnewsbyid ;
          for(String newsId in savedNewsFetch )
            {
              var regBodyNew = {"id":newsId};

              var responseNew = await http.post(
                Uri.parse(newsidurl),
                headers: {"Content-type":"application/json"},
                body: jsonEncode(regBodyNew),
              );


              Map<String, dynamic> dataNew = json.decode(responseNew.body);

              // Now you can use dataNew as a Map to access the properties
              NewsModel news = NewsModel.fromJson(dataNew);
              savedNews.add(news);


            }

        }

        emit(SavedNewsLoaded(
            savedNews: savedNews,
        ));

      } else {

        emit(SavedNewsError(error: 'Failed to load news'));
      }
    } catch (e) {
      emit(SavedNewsError(error: e.toString()));
    }
  }
  List<NewsModel> loadSaveData(){
    return savedNews;
  }
  Future<void> _loadRecomendedData() async {


    try {

      final getpriorityurl = getsavedurl;

      await PrefUtils.init();

      String? email = await PrefUtils.getEmail();


      var regBody ={"email": await email ?? ""};

      var response = await http.post(
        Uri.parse(getprioritiesuser),
        headers: {"Content-type":"application/json"},
        body: jsonEncode(regBody),
      );


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

          Map<String, dynamic> dataNewRecomended = json.decode(responsefinal.body);

          // Now you can use dataNew as a Map to access the properties
          NewsModel news = NewsModel.fromJson(dataNewRecomended);
          recomendedNews.add(news);



          // Prints the savedNews array
        }


      } else {

        emit(SavedNewsError(error: 'Failed to load news'));
      }
    } catch (e) {
      emit(SavedNewsError(error: e.toString()));
    }
  }
  List<NewsModel> loadRecomendedData(){
    return recomendedNews;
  }

}

class NewsResponse {
  bool status;
  List<String> savedNews;

  NewsResponse({required this.status, required this.savedNews});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'],
      savedNews: List<String>.from(json['savedNews']),
    );
  }
}