import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/services/network_info.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import 'intro_page.dart';
import 'master_page.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/splashPage";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Connectivity _connectivity = Connectivity();
  dynamic networkStream;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    networkStream =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult source) {
      checkConnection(source);
    });
  }

  @override
  void dispose() {
    super.dispose();
    networkStream.cancel();
  }

  Future<void> checkConnection(source) async {
    switch (source) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        var result = await NetworkInfo().isConnected();
        setState(() {
          isConnected = result;
        });
        context.read<AuthCubit>().loginUser(null);
        break;
      case ConnectivityResult.none:
      default:
        setState(() {
          isConnected = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderBody(),
    );
  }

  BlocBuilder<AuthCubit, AuthState> renderBody() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccessfull) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              MasterPage.routeName,
            );
          });
        }
        if (state is AuthError) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              IntroPage.routeName,
            );
          });
        }
        return isConnected ? renderAppTitle() : renderNoNetwork();
      },
    );
  }

  Center renderAppTitle() {
    return Center(
      child: Text(
        AppLocalizations.of(context).appTitle,
        style: const TextStyle(
          color: Color(0xFF11435E),
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  renderNoNetwork() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            child: Image.asset(
              'assets/no_network.png',
            ),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: const Text(
            'Please Connect to the internet to continue using the application',
            style: TextStyle(
              color: Color(0xFF11435E),
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
