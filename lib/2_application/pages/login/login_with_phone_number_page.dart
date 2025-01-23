

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/models/login.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/core/widgets/phone_number_input.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';
import 'package:todo_app/2_application/pages/login/confirmation_result_page.dart';
import 'package:todo_app/2_application/pages/login/widgets/sign_in_button.dart';



class LoginWithPhoneNumberPage extends StatefulWidget {
  const LoginWithPhoneNumberPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'login_phone',
    child: LoginWithPhoneNumberPage(),
  );

  @override
  State<LoginWithPhoneNumberPage> createState() =>
      _LoginWithPhoneNumberPageState();
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  final _phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneNumberFocusNode.addListener(() {
      if (!_phoneNumberFocusNode.hasFocus) {
        context.read<LoginCubit>().phoneNumberUnfocused(null);
        FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<LoginCubit>;
    return BlocListener<LoginCubit, LoginCubitState>(
        listener: (BuildContext context, LoginCubitState state) {

          if (state.status.isFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            showDialog<void>(
              context: context,
              builder: (_) => FailureDialog(
                  message: state.errorMessage ?? state.loginError),
            );
          }

          if (state.status.isInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Sign in.....')),
              );
          }

          if (state.confirmationResult != null)  {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Enter confirmation Code')),
              );
              context.pushNamed(ConfirmationResultPage.pageConfig.name);
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                 PhoneNumberInput(focusNode: _phoneNumberFocusNode,cubit: cubit),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const GoBackButton(),
                      SignInButton(login: Login.phone,cubit:cubit,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}