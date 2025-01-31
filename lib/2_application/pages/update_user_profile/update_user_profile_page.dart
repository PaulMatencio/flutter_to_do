import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/delete_user_button.dart';
import 'package:todo_app/2_application/core/widgets/email_input.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/core/widgets/logout_button.dart';
import 'package:todo_app/2_application/core/widgets/photo_url_input.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/core/widgets/failure_dialog.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/update_user_profile/bloc/cubit/update_user_profile_cubit.dart';
import 'package:todo_app/2_application/pages/update_user_profile/widgets/display_name.dart';
import 'package:todo_app/2_application/pages/update_user_profile/widgets/email_verification_button.dart';

class UpdateUserProfilePage extends StatefulWidget {
  const UpdateUserProfilePage({super.key});

  ///
  ///  page config
  ///
  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'update_profile',
    child: UpdateUserProfilePage(),
  );
  @override
  State<UpdateUserProfilePage> createState() => _UpdateUserProfilePageState();
}

///
///
///
class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  final _emailFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _photoUrlFocusNode = FocusNode();

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool ? get isVerified => FirebaseAuth.instance.currentUser?.emailVerified;
  //String? get email => FirebaseAuth.instance.currentUser?.email;
  //String? get displayName => FirebaseAuth.instance.currentUser?.displayName;


  @override
  void initState() {
    super.initState();
    _displayNameFocusNode.addListener(() {
      if (!_displayNameFocusNode.hasFocus) {
        context.read<UpdateUserProfileCubit>().displayNameUnfocused();
      }
    });

    _photoUrlFocusNode.addListener(() {
      if (!_photoUrlFocusNode.hasFocus) {
        context.read<UpdateUserProfileCubit>().photoUrlUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _displayNameFocusNode.dispose();
    _photoUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///   BlocListener is used for showing SnackBar and Dialog
    ///   once state change
    ///
    final theme = Theme.of(context);

    return BlocListener<UpdateUserProfileCubit, UpdateUserProfileCubitState>(
      listener: (BuildContext context, UpdateUserProfileCubitState state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) => FailureDialog(
                message: state.errorMessage ?? state.updateUserprofileError),
          );
        }

        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Updating  user profile .....')),
            );
        }

        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.tr('update_user_ok'))),
            );
          context.goNamed(HomePage.pageConfig.name,
              pathParameters: {'tab': DashboardPage.pageConfig.name});
        }
      },
      child: Align(
          //alignment: const Alignment(0, -3 / 4),
          alignment: Alignment.center,
          child: Container(
            width: 500,
            color: theme.colorScheme.onError,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<UpdateUserProfileCubit,
                  UpdateUserProfileCubitState>(
                builder: (context, state) {
                  final cubit = context.read<UpdateUserProfileCubit>;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Update profile',style: theme.textTheme.titleMedium),
                      const SizedBox(
                        height: 20,
                      ),
                      SendEmailVerification(isVerified: isVerified?? false),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const LogOutButton(),
                          const DeleteUserButton(),
                            //Expanded(child: SendEmailVerification(isVerified: isVerified?? false))
                        ],
                      ),

                      const SizedBox(
                        height: 60,
                      ),
                      EmailInput(
                          focusNode: _emailFocusNode,
                          cubit: cubit,
                          readOnly: true),
                      const SizedBox(
                        height: 20,
                      ),
                      DisplayNameInput(focusNode: _displayNameFocusNode),
                      const SizedBox(
                        height: 20,
                      ),
                      PhotoUrlInput(
                          focusNode: _photoUrlFocusNode, cubit: cubit),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const GoBackButton(),
                          ElevatedButton(
                            onPressed: cubit().state.isValid
                                ? () async {
                                    await cubit()
                                        .updateProfile();
                                  }
                                : null,
                            child: Text('submit',
                                style: Theme.of(context).textTheme.titleMedium),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,

                      ),
                    ],
                  );
                },
              ),
            ),
          )),
    );
  }
}


class SendEmailVerification extends StatelessWidget {
  const SendEmailVerification({super.key,required this.isVerified});
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return !isVerified?  EmailVerificationButton():SizedBox();
  }
}
