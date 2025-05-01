import 'package:flutter/material.dart';
import 'package:news_zen/features/main/presentation/saved_screen/bloc/saved_cubit.dart';
import 'package:news_zen/features/main/presentation/explore_screen/bloc/explore_bloc.dart';
//import 'package:sizer/sizer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/login_form/bloc/login_cubit.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';

import 'features/main/presentation/detail_screen/bloc/detail_cubit.dart';
import 'features/main/presentation/explore_popular_screen/bloc/explore_popular_bloc.dart';
import 'features/main/presentation/home_screen/bloc/news_cubit.dart';
import 'features/main/presentation/home_screen/bloc/news_cubit.dart';
import 'features/main/presentation/news_sites_screen/bloc/news_by_source_bloc.dart';
import 'features/main/presentation/signupform/bloc/signup_cubit.dart';
import 'features/main/presentation/socials_screen/bloc/social_news_cubit.dart';

class Newszen extends StatefulWidget {
  const Newszen({super.key});

  @override
  State<Newszen> createState() => _NewszenState();
}

class _NewszenState extends State<Newszen> {

  bool isLoggedIn = false;
  bool isDataFetch = false;

  @override
  void initState() {
    islogin();
    super.initState();


  }

  Future<void> islogin() async {
    final String? phoneNumber = await PrefUtils.getEmail();
    final String? password = await PrefUtils.getPassword();
    isLoggedIn = phoneNumber != null && password != null;
    print(MediaQuery.of(context).size.height);
    print(isLoggedIn);
    print(phoneNumber);
    print(password);
    isDataFetch = true;
    FlutterNativeSplash.remove();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainBottomBar(),
    );*/
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<NewsCubit>(create: (_) => NewsCubit()),
        BlocProvider<SignupCubit>(create: (_) => SignupCubit()),
        BlocProvider<DetailCubit>(create: (_) => DetailCubit()),
        BlocProvider<NewsBySourceBloc>(create: (_) => NewsBySourceBloc()),
        BlocProvider<SavedCubit>(create: (_) => SavedCubit()),

        BlocProvider<SocialNewsCubit>(create: (_) => SocialNewsCubit()),
        BlocProvider<ExploreBloc>(create: (_) => ExploreBloc()),
        BlocProvider<ExplorePopularBloc>(create: (_) => ExplorePopularBloc()),
      ],
      child: ResponsiveSizer(
          builder: (context,orientation,devicetype) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: isDataFetch
                  ? isLoggedIn ? MainBottomBar() : LoginFormScreen()
                  : CircularProgressIndicator(),

            );
          }
      ),


    );
  }
}
