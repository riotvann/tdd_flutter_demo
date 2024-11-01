import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/core/errors/exceptions.dart';
import 'package:flutter_tdd_tuto/core/errors/failure.dart';
import 'package:flutter_tdd_tuto/core/utils/typedef.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/entities/user.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // final response = http.get()
    //   return jsonDecode(source)
    // final datasource = AuthenticationRemoteDataSource();
    // datasource.createUser(createdAt: createdAt, name: name, avatar: avatar);
    //Principles of solid and TDD, test driven development
    // First write tests
    // call the remote data source
    // check if the method returns the proper data
    // make sure that it returns the proper data if there is no exception
    // check if when the remoteDatasource throws an exception, return a failure
    // if it doesn't, we return the actual expected data

    // TODO:
    // _remoteDataSource
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
    // throw UnimplementedError();
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
    // TODO: implement getUsers
    // throw UnimplementedError();
  }
}
