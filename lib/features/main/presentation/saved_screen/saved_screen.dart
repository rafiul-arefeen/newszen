import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/news_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:news_zen/features/main/presentation/saved_screen/bloc/saved_state.dart';


import 'bloc/saved_cubit.dart';

class SavedScreen extends StatefulWidget {
  SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late final SavedCubit _savedCubit;

  @override
  void initState() {
    super.initState();
    _savedCubit = context.read<SavedCubit>();


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo, // Your logo asset
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    icon: Icon(Icons.close, color: primary_red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: main_background_colour,
      body: BlocBuilder<SavedCubit,SavedState>(
        builder: (context, state) {
          if (state is SavedNewsError)
            {
              return Center(child: Text("Failed to  news"));
            }
          else
            {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Saved Articles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _savedCubit.loadSaveData().length,
                      itemBuilder: (context, index) {
                        final newsItem =  _savedCubit.loadSaveData()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: NewsCard(newsItem: newsItem),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
        },

      ),
    );
  }
}