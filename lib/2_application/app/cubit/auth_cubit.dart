import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/0_data/models/user_model.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/repositories/authentication_repository.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit({required this.authenticationRepository})
      : super(AuthCubitInitial(isLoggedIn: false));
  final AuthenticationRepository authenticationRepository;

  void authStateChanged0({User? user}) {
    final bool isLoggedIn = user != null;
    emit(AuthCubitInitial0(
      user: user,
      isLoggedIn: isLoggedIn,
    ));
  }

  /// Subscribes to the provided [stream] and invokes the [onData] callback
  /// when the [stream] emits new data.
  void authStateChanged({UserEntity? user}) {
    final bool isLoggedIn = user?.uid != null;
    emit(AuthCubitInitial(
      user: user,
      isLoggedIn: isLoggedIn,
    ));
  }


}
