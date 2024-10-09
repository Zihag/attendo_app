part of 'groupdetail_bloc.dart';

@immutable
sealed class GroupDetailEvent {}

class LoadGroupDetail extends GroupDetailEvent{
  final String groupid;

  LoadGroupDetail(this.groupid);
}