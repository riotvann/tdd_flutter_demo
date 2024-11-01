// ask 3 questions when testing a unit
// 1. What does the class depend on
// Answer -- Authentication repository
// 2. How can we create a fake version of the dependency
// Answer -- Use Mocktail
// 3. How do we control what our dependenies do
// Answer -- Using the Mocktail's API

// Mocktail and Mockito

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;
  // Is run before each test
  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  final params = CreateUserParams.empty();
  test('should call the [Respository.createUser]', () async {
    // Arrange
    // STUB
    when(
      () => repository.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
    ).thenAnswer((_) async => const Right(null));
    // Act
    final result = await usecase(params);
    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(
      () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
