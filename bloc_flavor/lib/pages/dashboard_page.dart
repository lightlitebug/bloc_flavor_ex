import 'package:bloc_flavor/blocs/app_config_bloc.dart';
import 'package:bloc_flavor/blocs/auth_bloc.dart';
import 'package:bloc_flavor/blocs/get_data_bloc.dart';
import 'package:bloc_flavor/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard-page';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _message = '';
  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    BlocProvider.of<GetDataBloc>(context).add(GetDataRequested());
  }

  void _showGetDataError(String errMessage) {
    _sKey.currentState.showSnackBar(
      SnackBar(
        content: Text(errMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = BlocProvider.of<AppConfigBloc>(context);

    return Scaffold(
      key: _sKey,
      appBar: AppBar(
        title: Text(
          mode.appConfig.buildFlavor == 'dev'
              ? 'Dev Dashboard'
              : 'Prod Dsashboar',
        ),
        actions: [
          FlatButton(
            child: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginPage.routeName, (route) => false);
            },
          ),
        ],
      ),
      body: BlocConsumer<GetDataBloc, GetDataState>(
        listener: (context, state) {
          if (state is GetDataRequestFailure) {
            _showGetDataError(state.errMessage);
          }
        },
        builder: (context, state) {
          if (state is GetDataInProgress) {
            if (mode.appConfig.buildFlavor == 'dev') {
              print('Getting Data in Progress');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetDataRequestSuccess) {
            if (mode.appConfig.buildFlavor == 'dev') {
              print('Successfully Getting Data');
            }
            _message = state.message;
          }
          return Center(
            child: Text(
              _message,
              style: TextStyle(fontSize: 20.0),
            ),
          );
        },
      ),
    );
  }
}
