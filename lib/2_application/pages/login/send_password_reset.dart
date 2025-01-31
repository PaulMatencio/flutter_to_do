import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/models/login.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/email_input.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/pages/login/bloc/cubit/login_cubit.dart';
import 'package:todo_app/2_application/pages/login/widgets/sign_in_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  ///
  ///  page config
  ///
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'reset_password',
    child: ResetPasswordPage(),
  );

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

///
///
///
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginCubit>().emailUnfocused(null);
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
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
              const SnackBar(
                  content: Text('Sending email to reset password.....')),
            );
        }

        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Email is successfully sent')),
            );
          context.goNamed('login');
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
            child: BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                final cubit = context.read<LoginCubit>;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    EmailInput(focusNode: _emailFocusNode, cubit: cubit),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const GoBackButton(),
                        Tooltip(
                            message: 'reset password',
                            child:
                                SignInButton(login: Login.reset, cubit: cubit)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
