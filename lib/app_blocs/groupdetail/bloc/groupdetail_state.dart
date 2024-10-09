part of 'groupdetail_bloc.dart';

@immutable
sealed class GroupDetailState {}

final class GroupDetailInitial extends GroupDetailState {}

class GroupDetailLoading extends GroupDetailState{}

class GroupDetailLoaded extends GroupDetailState{
  final Map<String, dynamic> groupData;

  GroupDetailLoaded(this.groupData);
}

class GroupDetailError extends GroupDetailState{
  final String message;

  GroupDetailError(this.message);
}