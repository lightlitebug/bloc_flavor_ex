import 'package:bloc_flavor/blocs/auth_bloc.dart';
import 'package:bloc_flavor/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    tryAutoLogin();
  }

  void tryAutoLogin() {
    BlocProvider.of<AuthBloc>(context).add(AppStarted());
  }

  void _login() {
    BlocProvider.of<AuthBloc>(context).add(LoginRequested());
  }

  void _showAuthError() {
    _sKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Login Failure'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sKey,
      appBar: AppBar(
        title: Text('Flavor and Bloc'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _showAuthError();
          }
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          }
        },
        builder: (context, state) {
          if (state is AppStartedInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is Authenticated) {
            return Center(
              child: Text('Splash Screen'),
            );
          }

          return Center(
            child: RaisedButton(
              child: state is AuthInProgress
                  ? SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 20.0),
                    ),
              onPressed: _login,
            ),
          );
        },
      ),
    );
  }
}
