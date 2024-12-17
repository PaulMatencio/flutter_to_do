part of 'auth_cubit.dart';

@immutable
abstract class AuthCubitState extends Equatable {}

class AuthCubitInitial0 extends AuthCubitState {
  final bool isLoggedIn;
  final User? user;
  AuthCubitInitial0({
    required this.isLoggedIn,
    this.user,
  });

  @override
  List<Object?> get props => [user,isLoggedIn];
}

class AuthCubitInitial extends AuthCubitState {
  final bool isLoggedIn;
  final UserEntity? user ;
  AuthCubitInitial({
    required this.isLoggedIn,
    this.user,
  });

  @override
  List<Object?> get props => [user,isLoggedIn];
}

