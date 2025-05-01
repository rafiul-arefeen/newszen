import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/pref_utils.dart';



part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState>
{
  DetailCubit() : super (InitialLikeSaveState());

  Future<void> validateLikeIcon(BuildContext context , String id , String category, String source)
  async {
    if (state.isLiked) {
      // Call function when item is liked
      await _removeliked(context, id,category,source);
    } else {
      // Call function when item is not liked
      _addliked(context, id,category,source);
    }
    emit(DetailState(
      isLiked: !state.isLiked,
      isSaved: state.isSaved,
    ));


  }
  Future<void> validateSaveIcon(BuildContext context , String id , String category, String source)
  async {
    if (state.isSaved) {
      // Call function when item is liked
      await _removesaved(context, id,category,source);
    } else {
      // Call function when item is not liked
      _addsaved(context, id,category,source);
    }
    emit(DetailState(
      isLiked: state.isLiked,
      isSaved: !state.isSaved,
    ));


  }

  Future<void> _addliked(BuildContext context,String id, String category, String source) async{
    await PrefUtils.init();
    String? futureString =await PrefUtils.getEmail();
    var regBody = {
      "email":await futureString ?? '',
      "newsId":id,
      "category":category,
      "source":source

    };

    var response = await http.post(
      Uri.parse(addlikedurl),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );
    print('addlikeapiworked');

    var jsonResponse = jsonDecode(response.body);
    print(id);
    print(category);
    print(source);
    print(futureString);






  }
  Future<void> _removeliked(BuildContext context,String id, String category, String source) async{
    await PrefUtils.init();
    Future<String?> futureString =PrefUtils.getEmail();
    var regBody = {
      "email":await futureString ?? '',
      "newsId":id,
      "category":category,
      "source":source

    };

    var response = await http.post(
      Uri.parse(removelikedurl),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );
    print('removelikeapiworked');

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {

    }



  }

  Future<void> _addsaved(BuildContext context,String id, String category, String source) async{
    await PrefUtils.init();
    Future<String?> futureString =PrefUtils.getEmail();
    var regBody = {
      "email":await futureString ?? '',
      "newsId":id,
      "category":category,
      "source":source

    };

    var response = await http.post(
      Uri.parse(addsavedurl),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );
    print('addsaveapiworked');

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {

    }



  }
  Future<void> _removesaved(BuildContext context,String id, String category, String source) async{
    await PrefUtils.init();
    Future<String?> futureString =PrefUtils.getEmail();
    var regBody = {
      "email":await futureString ?? '',
      "newsId":id,
      "category":category,
      "source":source

    };

    var response = await http.post(
      Uri.parse(removesavedurl),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );
    print('removesaveapiworked');

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {

    }



  }



}