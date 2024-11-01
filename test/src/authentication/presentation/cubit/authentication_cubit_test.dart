import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_tuto/core/errors/failure.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/usecases/create_user.dart';
import 'package:flutter_tdd_tuto/src/authentication/domain/usecases/get_users.dart';
import 'package:flutter_tdd_tuto/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group(
    'createUser',
    () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when successfull',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => const [
          CreatingUser(),
          UserCreated(),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, Authentication error] when unsuccessfull',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
        expect: () => [
          const CreatingUser(),
          AuthenticationError(tAPIFailure.errorMessage)
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );
    },
  );

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded] when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersFailure] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () =>
          [const GettingUsers(), AuthenticationError(tAPIFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
