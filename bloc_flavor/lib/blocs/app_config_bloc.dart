// events
import 'package:bloc_flavor/models/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppConfigEvent {}

// states
class AppConfigState {
  final AppConfig appConfig;

  AppConfigState({@required this.appConfig}) : assert(appConfig != null);
}

// bloc
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfig appConfig;

  AppConfigBloc({this.appConfig})
      : assert(appConfig != null),
        super(AppConfigState(appConfig: appConfig));

  @override
  Stream<AppConfigState> mapEventToState(AppConfigEvent event) async* {
    yield AppConfigState(appConfig: appConfig);
  }
}
