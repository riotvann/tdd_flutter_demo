// ask 3 questions when testing a unit
// 1. What does the class depend on
// Answer -- Authentication repository
// 2. How can we create a fake version of the dependency
// Answer -- Use Mocktail
// 3. How do we control what our dependenies do
// Answer -- Using the Mocktail's API

// Mocktail and Mockito

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/entities/user.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  final tResponse = [User.empty()];

  test(
    'should call [AuthRepo.getUsers] and return [List<User>]',
    () async {
      // Arange
      when(
        () => repository.getUsers(),
      ).thenAnswer((_) async => Right(tResponse));

      // Act
      final result = await usecase();

      expect(result, equals(Right<dynamic, List<User>>(tResponse)));

      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
