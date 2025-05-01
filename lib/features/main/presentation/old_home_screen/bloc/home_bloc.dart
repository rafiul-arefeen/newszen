import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<ChangeTopicEvent>(_onChangeTopic);
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  void _onChangeTopic(ChangeTopicEvent event, Emitter<HomeState> emit) {
    final filteredNews = event.topic == 'All'
        ? mockNewsData
        : mockNewsData.where((news) => news.topic == event.topic).toList();
    emit(HomeLoadedState(filteredNews, event.topic));
  }

  void _onLoadHomeData(LoadHomeDataEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(mockNewsData, 'All'));
  }
}