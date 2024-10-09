part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}


final class CreateGroup extends GroupEvent{
  final String groupName;
  final String groupDescription;

  CreateGroup(this.groupName, this.groupDescription);
}

final class LoadGroups extends GroupEvent{}

final class DeleteGroup extends GroupEvent{
  final String groupId;

  DeleteGroup(this.groupId);
}