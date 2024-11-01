import 'dart:convert';

import 'package:flutter_tdd_tuto/core/errors/exceptions.dart';
import 'package:flutter_tdd_tuto/core/utils/constants.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDatasource;

  setUp(() {
    client = MockClient();
    remoteDatasource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User Created Successfully', 201));

      final methodCall = remoteDatasource.createUser;

      expect(
          methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          completes);

      verify(
        () => client.post(
          Uri.https(
            kBaseUrl,
            kGetjUserEndpoint,
          ),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw [APIException] when the status code is not 200 or 201',
        () async {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('Invalid email address', 400),
      );

      final methodCall = remoteDatasource.createUser;

      expect(
        () async => methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
          const APIException(
            message: 'Invalid email address',
            statusCode: 400,
          ),
        ),
      );

      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test('should return a [List<User>] when the status code is 200', () async {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );

      final result = await remoteDatasource.getUsers();
      expect(result, equals(tUsers));

      verify(
        () => client.get(
          Uri.https(
            kBaseUrl,
            kGetjUserEndpoint,
          ),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw [APIException] when the status code is not 200',
        () async {
      const tMessage = 'Server Down, server down';
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(tMessage, 500),
      );

      final methodCall = remoteDatasource.getUsers;

      expect(
        () => methodCall(),
        throwsA(
          const APIException(
            message: tMessage,
            statusCode: 500,
          ),
        ),
      );

      verify(
        () => client.get(
          Uri.https(
            kBaseUrl,
            kCreateUserEndpoint,
          ),
        ),
      ).called(1);
    });
  });
}
