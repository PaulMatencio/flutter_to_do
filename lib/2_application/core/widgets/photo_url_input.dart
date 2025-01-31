import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PhotoUrlInput extends StatelessWidget {
  const PhotoUrlInput({required this.focusNode, required this.cubit,super.key});
  final FocusNode focusNode;
  final Function cubit;

  String? get photoUrl=> FirebaseAuth.instance.currentUser?.photoURL;
  @override
  Widget build(BuildContext context) {
    /// BlocBuilder is using  a dependency injection widget so a
    ///  single instance of bloc can be provide to multiple widgets
    ///   within a subtree
    final theme = Theme.of(context);

//final cubit = context.select((LoginCubit cubit) => cubit);
    return TextFormField(
      initialValue: photoUrl??'',
      focusNode: focusNode,
      decoration: InputDecoration(
        icon: const Icon(Icons.photo),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: theme.colorScheme.primary),
        ),
        labelText: 'Photo Url',
        helperText: 'Valid Url ',
        errorText: cubit().state.photoUrl.displayError != null
            ? 'Please ensure the Url  entered is valid'
            : null,
      ),
      onChanged: (value) {
        cubit().photoUrlChanged(cubit().state.photoUrl, value);
      },
      textInputAction: TextInputAction.next,
    );
  }
}