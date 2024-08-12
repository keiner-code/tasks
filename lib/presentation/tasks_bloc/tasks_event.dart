part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class ChangeShowDialog extends TasksEvent {
  final DialogStatus dialogStatus;
  const ChangeShowDialog(this.dialogStatus);
}

class NewTasksState extends TasksEvent {}

class TasksAddRequest extends TasksEvent {
  final Task task;
  const TasksAddRequest(this.task);

  @override
  List<Object> get props => [task];
}

class TaskUpdateRequest extends TasksEvent {
  final Task task;
  const TaskUpdateRequest(this.task);
}

class TasksGetAllRequest extends TasksEvent {
  final String mail;
  const TasksGetAllRequest(this.mail);
}

class TaskDeleteRequest extends TasksEvent {
  final String id;
  const TaskDeleteRequest(this.id);

  @override
  List<Object> get props => [id];
}

class TaskGetOneRequest extends TasksEvent {
  final String id;
  const TaskGetOneRequest(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeStatusTask extends TasksEvent {
  final String id;
  final String status;
  const ChangeStatusTask(this.id, this.status);
}
