import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/1_domain/entities/auth_user.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/2_application/core/models/display_name.dart';
import 'package:todo_app/2_application/core/models/phone_number.dart';
import '../1_domain/entities/unique_id.dart';
import '../2_application/core/models/models.dart';


// <Type>    ->   List<TodoCollection>
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class Params extends Equatable {}

class NoParams extends Params {
  @override
  List<Object?> get props => [];
}

class ToDoEntryIdsParam extends Params {
  ToDoEntryIdsParam({
    required this.collectionId,
    required this.entryId,
  }) : super();

  final EntryId entryId;
  final CollectionId collectionId;

  @override
  List<Object> get props => [collectionId, entryId];
}

class CollectionIdParam extends Params {
  CollectionIdParam({
    required this.collectionId,
  }) : super();

  final CollectionId collectionId;

  @override
  List<Object> get props => [collectionId];
}

class ToDoEntryParams extends Params {
  ToDoEntryParams({
    required this.entry,
    required this.collectionId,
  }) : super();

  final ToDoEntry entry;
  final CollectionId collectionId;

  @override
  List<Object> get props => [entry, collectionId];
}

class ToDoCollectionParams extends Params {
  ToDoCollectionParams({required this.collection}) : super();

  final ToDoCollection collection;

  @override
  List<Object> get props => [collection];
}

class EmailAndPassWordParams extends Params {
  EmailAndPassWordParams({
    required this.email,
    required this.password,
    //this.displayName,
  }) : super();

  final Email email;
  final Password password;
  //final DisplayName  ? displayName;

  @override
  List<Object> get props => [email, password];
}

class EmailParam extends Params {
  EmailParam({
    required this.email,
  }) : super();

  final Email email;

  @override
  List<Object> get props => [email];
}


class UserParam extends Params {
  UserParam({
    required this.user,
  }) : super();
  final UserEntity user;
  @override
  List<Object> get props => [user];
}

class UpdateUserParam extends Params {
  UpdateUserParam({
    required this.displayName,
    required this.phoneNumber,
  }) : super();
  final String displayName;
  final  String phoneNumber;
  @override
  List<Object> get props => [displayName];
}


class PhoneNumberParam extends Params {
  PhoneNumberParam({
    required this.phoneNumber,
  }) : super();
  final PhoneNumber  phoneNumber ;

  @override
  List<Object> get props => [phoneNumber];
}

class VerificationCodeParam extends Params {
    VerificationCodeParam({
      required  this.verificationCode,
      required this.confirmationResult,

});
    final String verificationCode;
    final ConfirmationResult  confirmationResult;
    @override
    List<Object> get props => [];
}




