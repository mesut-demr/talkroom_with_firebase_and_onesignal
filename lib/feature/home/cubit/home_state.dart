import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, completed, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String errorMessage;
  final List<Map<String, dynamic>> rooms;
  final String selectedRoomId;

  const HomeState({
    required this.status,
    required this.errorMessage,
    required this.rooms,
    required this.selectedRoomId,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        rooms,
        selectedRoomId,
      ];

  factory HomeState.initial() => HomeState(
        status: HomeStatus.initial,
        errorMessage: '',
        rooms: [],
        selectedRoomId: '',
      );

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<Map<String, dynamic>>? rooms,
    String? selectedRoomId,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rooms: rooms ?? this.rooms,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
    );
  }
}
