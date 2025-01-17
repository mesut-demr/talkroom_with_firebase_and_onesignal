import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, completed, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String errorMessage;
  final bool isLoginPage;

  const AuthState({
    required this.status,
    required this.errorMessage,
    required this.isLoginPage,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isLoginPage,
      ];

  factory AuthState.initial() => AuthState(
        status: AuthStatus.initial,
        errorMessage: '',
        isLoginPage: true,
      );

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? isLoginPage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoginPage: isLoginPage ?? this.isLoginPage,
    );
  }
}
