import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import '../../../../../1_domain/use_cases/authentication.dart';

part 'user_profile_cubit_state.dart';

class  UserProfileCubit extends Cubit<UserProfileCubitState> {
  UserProfileCubit({required this.loginWithEmailAndPassword}) : super(UserProfileCubitLoadingState());
  LoginWithEmailAndPassword   loginWithEmailAndPassword;

}