


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/register/widgets/confirmed_password_input.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/pages/register/widgets/email_input.dart' as register;
import 'package:todo_app/2_application/pages/register/widgets/password_input.dart'  as register;
import 'package:todo_app/2_application/pages/register/widgets/sign_up_button.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/register/bloc/cubit/register_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  ///
  ///  page config
  ///
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'register',
    child: RegisterPage(),
  );
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
///
///
///
class _RegisterPageState extends State<RegisterPage> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmedPasswordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<RegisterCubit>().emailUnfocused(null);
      //  FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegisterCubit>().passwordUnfocused();
       // FocusScope.of(context).requestFocus(_confirmedPasswordFocusNode);
      }
    });
    _confirmedPasswordFocusNode.addListener(() {
      if (!_confirmedPasswordFocusNode.hasFocus) {
       context.read<RegisterCubit>().confirmedPasswordUnfocused();
      }
    });

  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmedPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///   BlocListener is used for showing SnackBar and Dialog
    ///   once state change
    ///
    final theme =Theme.of(context);
    return BlocListener<RegisterCubit, RegisterCubitState>(
      listener: (BuildContext context, RegisterCubitState state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) =>  FailureDialog(message: state.errorMessage?? state.signUpError),
          );
        }

        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign up.....')),
            );
        }

        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.tr('successful_signup'))),
            );
          context.goNamed(HomePage.pageConfig.name,
              pathParameters: {'tab': DashboardPage.pageConfig.name});
        }
      },
      child: Align(
        //alignment: const Alignment(0, -3 / 4),
        alignment: Alignment.center ,
        child: Container(
          width: 450,
          color: theme.colorScheme.onError,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                register.EmailInput(focusNode: _emailFocusNode),
                const SizedBox(height:20,),
                register.PasswordInput(focusNode: _passwordFocusNode),
                const SizedBox(height:20,),
                ConfirmedPasswordInput(focusNode: _confirmedPasswordFocusNode),
                const SizedBox(height:20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const GoBackButton(),
                    const SignUpButton(),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}