import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/core/widgets/phone_number_input.dart';
import 'package:todo_app/2_application/pages/create_user_profile/bloc/cubit/create_user_profile_cubit.dart';
import 'package:todo_app/2_application/pages/create_user_profile/widgets/display_name.dart';
import 'package:todo_app/2_application/pages/create_user_profile/widgets/email_input.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';

class CreateUserProfilePage extends StatefulWidget {
  const CreateUserProfilePage({super.key});

  ///
  ///  page config
  ///
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'register',
    child: CreateUserProfilePage(),
  );
  @override
  State<CreateUserProfilePage> createState() => _CreateUserProfilePageState();
}

///
///
///
class _CreateUserProfilePageState extends State<CreateUserProfilePage> {
  final _emailFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  String? get email => FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
    /*
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<CreateUserProfileCubit>().emailUnfocused(null);
        //  FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
     */

    _displayNameFocusNode.addListener(() {
      if (!_displayNameFocusNode.hasFocus) {
        context.read<CreateUserProfileCubit>().displayNameUnfocused();
      }
    });

    _phoneNumberFocusNode.addListener(() {
      if (!_phoneNumberFocusNode.hasFocus) {
        context.read<CreateUserProfileCubit>().phoneNumberUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _displayNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///   BlocListener is used for showing SnackBar and Dialog
    ///   once state change
    ///
    final theme = Theme.of(context);
    return BlocListener<CreateUserProfileCubit, CreateUserProfileCubitState>(
      listener: (BuildContext context, CreateUserProfileCubitState state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) => FailureDialog(
                message: state.errorMessage ?? state.createUserprofileError),
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
        alignment: Alignment.center,
        child: BlocBuilder<CreateUserProfileCubit, CreateUserProfileCubitState>(
          builder: (context, state) {
            return Container(
              width: 450,
              color: theme.colorScheme.onError,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    EmailInput(focusNode: _emailFocusNode),
                    const SizedBox(
                      height: 20,
                    ),
                    DisplayNameInput(focusNode: _displayNameFocusNode),
                    const SizedBox(
                      height: 20,
                    ),
                    PhoneNumberInput(focusNode: _phoneNumberFocusNode,cubit:context.read<CreateUserProfileCubit>),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const GoBackButton(),
                        ElevatedButton(
                          onPressed: state.isValid
                              ? () async {
                                  await context
                                      .read<CreateUserProfileCubit>()
                                      .createUserProfile();
                                }
                              : null,
                          child: Text('Sign Up',
                              style: Theme.of(context).textTheme.titleMedium),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
