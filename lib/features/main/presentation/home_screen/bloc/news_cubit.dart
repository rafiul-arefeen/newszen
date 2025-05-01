import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'news_state.dart';
import 'package:http/http.dart' as http;

class NewsCubit extends Cubit<NewsState> {

  final int limit = 10;
  bool hasMoreData = true;
  int currentPage = 1;
  int currentTrendingPage = 1;
  int currentPopularPage = 1;
  int currentLatestPage = 1;
  int currentMostviewedPage = 1;
  bool start = true;

  List<NewsModel> pageViewNews=[];
  List<NewsModel> horizontalNews=[];
  List<NewsModel> trendingNews=[];
  List<NewsModel> popularNews=[];
  List<NewsModel> latestNews=[];
  List<NewsModel> mostViewedNews=[];
  NewsCubit() : super(NewsInitial())  {
    _loadDataThenTrending();
  }
  void _loadDataThenTrending() {
    loadData(currentDataPage: currentPage).then((_) {
      loadTrendingNews(currentTrendingPage: currentTrendingPage);
      loadLatestNews(currentLatestPage: currentLatestPage);
      loadPopularNews(currentPopularPage: currentPopularPage);
      loadMostViewNews(currentMostViewedPage: currentMostviewedPage);
    });
  }

  Future<void> loadData({required int currentDataPage}) async {


    try {
      emit(NewsLoading());

      final urldata= datafetchurl + "?page=$currentDataPage";

      final response = await http.get(Uri.parse(urldata));
      print('inside data');

      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {
          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();
          if(currentDataPage==1) pageViewNews.addAll(news);
          horizontalNews.addAll(news);
          //currentPage++;

        }

        emit(NewsLoaded(
          pageViewNews: pageViewNews,
          horizontalNews: horizontalNews,
          trendingNews: trendingNews,
          popularNews: popularNews,
          latestNews: latestNews,
          mostViewedNews: mostViewedNews
        ));

      } else {

        emit(NewsError(error: 'Failed to load news'));
      }
    } catch (e) {
      emit(NewsError(error: e.toString()));
    }
  }
  Future<void> loadTrendingNews({required int currentTrendingPage})  async {


    try {
      emit(NewsLoading());

      final urldatatrending= trendingurl + "?page=$currentTrendingPage";
      print('inside trending');
      final responsetrending = await http.get(Uri.parse(urldatatrending));
      print('inside trending');
      if (responsetrending.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(responsetrending.body);

        print(DateTime.now());

        List<dynamic> data = json.decode(responsetrending.body);


        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {
          print('here');
          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();
          print('here');
          trendingNews.addAll(news);
          //currentPage++;

        }


        /*emit(TrendingNewsLoaded(
          trendingNews: trendingNews
        ));*/

        emit(NewsLoaded(
            pageViewNews: pageViewNews,
            horizontalNews: horizontalNews,
            trendingNews: trendingNews,
            popularNews: popularNews,
            latestNews: latestNews,
            mostViewedNews: mostViewedNews
        ));

      } else {

        emit(NewsError(error: 'Failed to load news'));

      }
    } catch (e) {
      emit(NewsError(error: e.toString()));

    }
  }
  Future<void> loadPopularNews({required int currentPopularPage})  async {


    try {
      emit(NewsLoading());

      final urldatapopular= popularurl + "?page=$currentPopularPage";

      final responsetrending = await http.get(Uri.parse(urldatapopular));
      print('popular done');
      if (responsetrending.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(responsetrending.body);

        List<dynamic> data = json.decode(responsetrending.body);
        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {

          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();

          popularNews.addAll(news);
          //currentPage++;

        }


        emit(NewsLoaded(
            pageViewNews: pageViewNews,
            horizontalNews: horizontalNews,
            trendingNews: trendingNews,
            popularNews: popularNews,
            latestNews: latestNews,
            mostViewedNews: mostViewedNews
        ));

      } else {

        emit(NewsError(error: 'Failed to load news'));

      }
    } catch (e) {
      emit(NewsError(error: e.toString()));

    }
  }
  Future<void> loadLatestNews({required int currentLatestPage})  async {


    try {
      emit(NewsLoading());

      final urldatalatest= latesturl + "?page=$currentLatestPage";

      final responsetrending = await http.get(Uri.parse(urldatalatest));
      print('latest done');
      if (responsetrending.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(responsetrending.body);

        List<dynamic> data = json.decode(responsetrending.body);
        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {

          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();

          latestNews.addAll(news);
          //currentPage++;

        }


        emit(NewsLoaded(
            pageViewNews: pageViewNews,
            horizontalNews: horizontalNews,
            trendingNews: trendingNews,
            popularNews: popularNews,
            latestNews: latestNews,
            mostViewedNews: mostViewedNews
        ));

      } else {

        emit(NewsError(error: 'Failed to load news'));

      }
    } catch (e) {
      emit(NewsError(error: e.toString()));

    }
  }
  Future<void> loadMostViewNews({required int currentMostViewedPage})  async {


    try {
      emit(NewsLoading());

      final urldatamostview= mostviewedurl + "?page=$currentMostViewedPage";

      final responsetrending = await http.get(Uri.parse(urldatamostview));
      print('mostviewed done');
      if (responsetrending.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(responsetrending.body);

        List<dynamic> data = json.decode(responsetrending.body);
        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {

          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();

          mostViewedNews.addAll(news);
          //currentPage++;

        }


        emit(NewsLoaded(
            pageViewNews: pageViewNews,
            horizontalNews: horizontalNews,
            trendingNews: trendingNews,
            popularNews: popularNews,
            latestNews: latestNews,
            mostViewedNews: mostViewedNews
        ));

      } else {

        emit(NewsError(error: 'Failed to load news'));

      }
    } catch (e) {
      emit(NewsError(error: e.toString()));

    }
  }


  List<NewsModel> filterPageViewNews(String topic) {
    final filteredNews = topic == 'all'
        ? pageViewNews
        : pageViewNews.where((news) => news.topic == topic).toList();
    if(topic=='all')
    {
      emit(NewsLoaded(
          pageViewNews: pageViewNews,
          horizontalNews: horizontalNews,
          trendingNews: trendingNews,
          popularNews: popularNews,
          latestNews: latestNews,
          mostViewedNews: mostViewedNews
      ));
      return pageViewNews;
    }
    emit(NewsLoaded(
        pageViewNews: pageViewNews,
        horizontalNews: horizontalNews,
        trendingNews: trendingNews,
        popularNews: popularNews,
        latestNews: latestNews,
        mostViewedNews: mostViewedNews
    ));
    return pageViewNews.where((news) => news.topic == topic).toList();;


  }

  List<NewsModel> filterHorizontalNews(String topic) {
    if (topic == 'all') {
      print("inside all topic ");
      // If "All" is selected, return combined results from all categories
      List<NewsModel> allNews = [];
      allNews.addAll(mostViewedNews);
      allNews.addAll(trendingNews);
      allNews.addAll(popularNews);
      allNews.addAll(latestNews);

      if(start)
        {
          start=false;
          allNews.shuffle();
        }



      return allNews;
    } else if (topic == 'Trending') {
      print("inside trending topic ");
      return trendingNews;
    } else if (topic == 'Popular') {
      print("inside popular topic ");
      return popularNews;
    } else if (topic == 'Latest') {
      print("inside latest topic ");
      return latestNews;
    } else if (topic == 'MostViewed') {
      print("inside mostviewed topic ");
      return mostViewedNews;
    }
    return [];
  }

  List<NewsModel> fetchMoreNews(String topic) {
    List<NewsModel> result=[];
    if(topic=='Trending')
    currentTrendingPage++;
    loadTrendingNews(currentTrendingPage: currentTrendingPage);
    result=trendingNews.toList();
    return result;
  }
}


