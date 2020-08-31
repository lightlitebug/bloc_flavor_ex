import 'package:bloc_flavor/blocs/app_config_bloc.dart';
import 'package:bloc_flavor/blocs/auth_bloc.dart';
import 'package:bloc_flavor/blocs/get_data_bloc.dart';
import 'package:bloc_flavor/repositories/auth_repository.dart';
import 'package:bloc_flavor/repositories/get_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:bloc_flavor/models/app_config.dart';
import 'package:bloc_flavor/pages/dashboard_page.dart';
import 'package:bloc_flavor/pages/login_page.dart';

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  final AuthRepository authRepository = AuthRepository(
    httpClient: http.Client(),
  );
  final GetDataRepository getDataRepository = GetDataRepository(
    httpClient: http.Client(),
  );

  MyApp({
    Key key,
    @required this.appConfig,
  })  : assert(appConfig != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigBloc>(
          create: (context) => AppConfigBloc(appConfig: appConfig),
        ),
        BlocProvider<AuthBloc>(create: (context) {
          BlocProvider.of<AppConfigBloc>(context).add(AppConfigEvent());
          return AuthBloc(
            authRepository: authRepository,
            appConfigBloc: BlocProvider.of<AppConfigBloc>(context),
          );
        }),
        BlocProvider<GetDataBloc>(create: (context) {
          BlocProvider.of<AppConfigBloc>(context).add(AppConfigEvent());
          return GetDataBloc(
            getDataRepository: getDataRepository,
            authRepository: authRepository,
            appConfigBloc: BlocProvider.of<AppConfigBloc>(context),
          );
        }),
      ],
      child: MaterialApp(
        title: 'Bloc & Flavors',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          DashboardPage.routeName: (context) => DashboardPage(),
        },
      ),
    );
  }
}
