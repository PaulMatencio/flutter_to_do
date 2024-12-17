

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import '../../../../../1_domain/use_cases/authentication.dart';

part 'profile_cubit_state.dart';

class  ProfileCubit extends Cubit<ProfileCubitState> {
  ProfileCubit({required this.loginWithEmailAndPassword}) : super(ProfileCubitLoadingState());
  LoginWithEmailAndPassword   loginWithEmailAndPassword;

}