

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/models/login.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/confirmation_code_input.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';
import 'package:todo_app/2_application/pages/login/widgets/sign_in_button.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';


class ConfirmationResultPage extends StatefulWidget {
  const ConfirmationResultPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'confirmation_result',
    child: ConfirmationResultPage(),
  );

  @override
  State<ConfirmationResultPage> createState() =>
      _ConfirmationResultPageState();
}

class _ConfirmationResultPageState extends State<ConfirmationResultPage> {
  final _confirmationResultFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confirmationResultFocusNode.addListener(() {
      if (!_confirmationResultFocusNode.hasFocus) {
        context.read<LoginCubit>().confirmationCodeUnfocused(null);
        FocusScope.of(context).requestFocus(_confirmationResultFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _confirmationResultFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                const SnackBar(content: Text('confirmation code in progress.....')),
              );
          }


          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Confirmation code is successfully  sent')),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                 ConfirmationCodeInput(focusNode: _confirmationResultFocusNode,cubit:context.read<LoginCubit>),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const GoBackButton(),
                      SignInButton(login: Login.confirmation,cubit:context.read<LoginCubit>),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}