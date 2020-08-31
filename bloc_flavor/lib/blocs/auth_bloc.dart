// events
import 'dart:async';

import 'package:bloc_flavor/blocs/app_config_bloc.dart';
import 'package:bloc_flavor/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

// states
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {}

class AppStartedInProgress extends AuthState {}

class AuthInProgress extends AuthState {}

class Authenticated extends AuthState {
  final String token;

  Authenticated({@required this.token}) : assert(token != null);
}

class UnAuthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errMessage;

  AuthFailure({@required this.errMessage}) : assert(errMessage != null);
}

// bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AppConfigBloc appConfigBloc;
  StreamSubscription appConfigSubscription;
  String baseUrl, dataUrl, buildFlavor;

  AuthBloc({
    @required this.authRepository,
    @required this.appConfigBloc,
  })  : assert(authRepository != null),
        assert(appConfigBloc != null),
        super(AuthUninitialized()) {
    appConfigSubscription = appConfigBloc.listen((appConfigState) {
      if (appConfigState is AppConfigState) {
        baseUrl = appConfigState.appConfig.baseUrl;
        dataUrl = appConfigState.appConfig.dataUrl;
        buildFlavor = appConfigState.appConfig.buildFlavor;
        print('in AuthBloc baseUrl: $baseUrl');
        print('in AuthBloc dataUrl: $dataUrl');
        print('in AuthBloc buildFlavor: $buildFlavor');
      }
    });
  }

  @override
  Future<void> close() {
    appConfigSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginRequested) {
      yield AuthInProgress();
      await Future.delayed(Duration(seconds: 1));

      try {
        final String token = await authRepository.login(baseUrl);

        if (buildFlavor == 'dev') {
          print('token in AuthBloc: $token');
        }
        await authRepository.persistToken(token);
        yield Authenticated(token: token);
      } catch (e) {
        yield AuthFailure(errMessage: e.toString());
      }
    }

    if (event is AppStarted) {
      yield AppStartedInProgress();
      await Future.delayed(Duration(seconds: 1));

      if (await authRepository.hasToken()) {
        final String token = await authRepository.getToken();
        yield Authenticated(token: token);
      } else {
        yield UnAuthenticated();
      }
    }

    if (event is LogoutRequested) {
      await authRepository.deleteToken();
    }
  }
}
