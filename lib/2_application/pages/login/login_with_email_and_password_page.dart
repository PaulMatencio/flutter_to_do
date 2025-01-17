




import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/models/login.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';
import 'package:todo_app/2_application/pages/login/login_with_phone_number_page.dart';
import 'package:todo_app/2_application/pages/login/widgets/email_input.dart';
import 'package:todo_app/2_application/pages/login/widgets/password_input.dart';
import 'package:todo_app/2_application/pages/login/widgets/sign_in_button.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/register/register_page.dart';
import '../home/home_page.dart';


class LoginWithEmailAndPasswordPage extends StatefulWidget {
  const LoginWithEmailAndPasswordPage({super.key});

  ///
  ///  page config
  ///
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'login',
    child: LoginWithEmailAndPasswordPage(),
  );

  @override
  State<LoginWithEmailAndPasswordPage> createState() => _LoginWithEmailAndPasswordPageState();
}

///
///
///
class _LoginWithEmailAndPasswordPageState extends State<LoginWithEmailAndPasswordPage> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginCubit>().emailUnfocused(null);
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginCubit>().passwordUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///   BlocListener is used for showing SnackBar and Dialog
    ///   once state change
    ///
    final theme = Theme.of(context);
    return BlocListener<LoginCubit, LoginCubitState>(
      listener: (BuildContext context, LoginCubitState state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) =>
                FailureDialog(message: state.errorMessage ?? state.loginError),
          );
        }

        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign in.....')),
            );
        }

        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign in successfully')),
            );
          context.goNamed(HomePage.pageConfig.name,
              pathParameters: {'tab': OverviewPage.pageConfig.name});
        }
      },
      child: Align(
        //alignment: const Alignment(0, -3 / 4),
        alignment: Alignment.center,
        child: Container(
          width: 450,
          color: theme.colorScheme.onError,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(context.tr('no_account'),  style: theme.textTheme.titleMedium),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            context.pushNamed(RegisterPage.pageConfig.name),
                        style:
                        ButtonStyle(backgroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary)),
                        child: Text(context.tr('register'),
                            style: theme.textTheme.titleMedium),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      EmailInput(focusNode: _emailFocusNode),
                      const SizedBox(
                        height: 20,
                      ),
                      PasswordInput(focusNode: _passwordFocusNode),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const GoBackButton(),
                          const SignInButton(login: Login.mail,),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                       ElevatedButton(
                          onPressed: () => context.pushNamed(LoginWithPhoneNumberPage.pageConfig.name),
                          style:
                          ButtonStyle(backgroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary)),
                          child: Text(context.tr('login_with_phone_number'),
                              style: theme.textTheme.titleSmall),
                        ),
                  
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}