import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, completed, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String errorMessage;

  const ProfileState({
    required this.status,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];

  factory ProfileState.initial() => ProfileState(
        status: ProfileStatus.initial,
        errorMessage: '',
      );

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
