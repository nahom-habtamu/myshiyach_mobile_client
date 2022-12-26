import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/services/injection_container.dart' as di;
import 'core/services/injection_container.dart';
import 'presentation/bloc/change_language/change_language_cubit.dart';
import 'presentation/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import 'presentation/constants/app_level_state.dart';
import 'presentation/constants/app_pages.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp ();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ChangeLanguageCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetProductByIdCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale("en");
  PendingDynamicLinkData? linkData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(((timeStamp) {
      handleDynamicLink();
    }));
  }

  void handleDynamicLink() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        setState(() {
          linkData = dynamicLinkData;
        });
      }
    });

    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    if (data?.link != null) {
      setState(() {
        linkData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...AppLevelState.get()],
      child: BlocBuilder<ChangeLanguageCubit, String>(
        builder: (context, state) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (_locale?.languageCode != Locale(state).languageCode) {
              setState(() {
                _locale = Locale(state);
              });
            }
          });
          return MaterialApp(
            title: "My Shiyach",
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _locale,
            theme: ThemeData(
              primaryColor: const Color(0xff11435E),
              fontFamily: 'DMSans',
            ),
            home: SplashPage(linkData: linkData),
            routes: AppPages.get(),
          );
        },
      ),
    );
  }
}
