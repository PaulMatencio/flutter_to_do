
part of 'profile_cubit.dart';

abstract class ProfileCubitState extends Equatable {
  const ProfileCubitState();

  @override
  List<Object> get props => [];
}

class ProfileCubitLoadingState extends ProfileCubitState {}

class ProfileCubitLoadedState extends ProfileCubitState {
  const ProfileCubitLoadedState({required this.userEntity});
  final UserEntity userEntity;
  @override
  List<Object> get props => [userEntity];
}