part of 'user_profile_cubit.dart';


abstract class UserProfileCubitState extends Equatable {
  const UserProfileCubitState();

  @override
  List<Object> get props => [];
}

class UserProfileCubitLoadingState extends UserProfileCubitState {}

class UserProfileCubitLoadedState extends UserProfileCubitState {
  const UserProfileCubitLoadedState({required this.userEntity});
  final UserEntity userEntity;
  @override
  List<Object> get props => [userEntity];
}