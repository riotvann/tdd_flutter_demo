import 'dart:convert';

import 'package:flutter_tdd_tuto/core/errors/exceptions.dart';
import 'package:flutter_tdd_tuto/core/utils/constants.dart';
import 'package:flutter_tdd_tuto/core/utils/typedef.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/model/user_model.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/entities/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetjUserEndpoint = '/test-api/users';

class AuthRemoteDataSrcImpl extends AuthenticationRemoteDataSource {
  AuthRemoteDataSrcImpl(this._client);
  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // 1. Checks to make sure that it returns the right data when the status
    // code is 200 or the proper response code
    // 2. Checks to make sure that it throws a 'CUSTOM EXPECTION' with the
    // right message when the status code is the bad one

    try {
      final response =
          await _client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
                'avatar': avatar,
              }),
              headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
    // throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetjUserEndpoint),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
