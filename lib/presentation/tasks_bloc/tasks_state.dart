part of 'tasks_bloc.dart';

enum TasksStatus { initial, loading, success, failure }

enum DialogStatus { none, create, edit }

class TasksState extends Equatable {
  final TasksStatus status;
  final List<Task> tasks;
  final Task? task;
  final String errorMessage;
  final DialogStatus openDialog;
  const TasksState(
      {this.status = TasksStatus.initial,
      this.tasks = const [],
      this.errorMessage = '',
      this.openDialog = DialogStatus.none,
      this.task});

  TasksState copyWith(
          {Task? task,
          TasksStatus? status,
          List<Task>? tasks,
          String? errorMessage,
          DialogStatus? openDialog}) =>
      TasksState(
          status: status ?? this.status,
          tasks: tasks ?? this.tasks,
          task: task ?? this.task,
          openDialog: openDialog ?? this.openDialog,
          errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object?> get props => [status, tasks, task, openDialog];
}
