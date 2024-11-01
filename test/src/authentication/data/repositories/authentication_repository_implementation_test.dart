import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/core/errors/exceptions.dart';
import 'package:flutter_tdd_tuto/core/errors/failure.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_tdd_tuto/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/entities/user.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  const tException = APIException(
    message: 'Unkown Error Occured',
    statusCode: 500,
  );

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group('createUser2', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';
    test(
        'should call the [RemoteDataSource.createUser] and complete successfully when the call to the remote source is successfull',
        () async {
      // check that the remote source is called and
      // with the right data

      //Arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repoImpl.createUser(
          avatar: avatar, name: name, createdAt: createdAt);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [ServerFailure] when the call to the remote source is unsuccessfull',
        () async {
      // Arrange
      when(() => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(
              named: 'avatar',
            ),
          )).thenThrow(
        const APIException(
          message: 'Unkown Error Occured',
          statusCode: 500,
        ),
      );
      // Act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(
        result,
        equals(
          const Left(
            APIFailure(message: 'Unkown Error Occured', statusCode: 500),
          ),
        ),
      );

      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>] when'
        'the remote source is successfull', () async {
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

      final result = await repoImpl.getUsers();

      // expect(result, const Right([]));
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote source is unsuccessfull',
        () async {
      // Arrange
      when(() => remoteDataSource.getUsers()).thenThrow(tException);

      final result = await repoImpl.getUsers();

      expect(result, equals(Left(APIFailure.fromException(tException))));

      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
