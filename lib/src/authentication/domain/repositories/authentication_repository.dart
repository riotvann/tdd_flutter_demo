// Made to be a contract or interface
// Define what functionality this feature should carry
// It doesn't implements them

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/core/errors/failure.dart';
import 'package:flutter_tdd_tuto/core/utils/typedef.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
