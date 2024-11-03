part of 'group_bloc.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

final class GroupLoading extends GroupState {}

final class GroupLoaded extends GroupState {
  final List<Map<String, dynamic>> groups;

  GroupLoaded(this.groups);
}

final class GroupError extends GroupState {
  final String message;
  GroupError(this.message);
}

