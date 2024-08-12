import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/domain/repositories/task_repository.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository repository;
  TasksBloc({required this.repository}) : super(const TasksState()) {
    on<TasksAddRequest>(_addTask);
    on<TasksGetAllRequest>(_getAllTask);
    on<TaskDeleteRequest>((event, emit) => _deleteTask(event, emit));
    on<TaskGetOneRequest>(_getOneById);
    on<TaskUpdateRequest>(_updateTask);
    on<ChangeStatusTask>(_changeStatusTask);
    on<NewTasksState>(_newTaskState);
    on<ChangeShowDialog>((event, emit) {
      emit(state.copyWith(openDialog: event.dialogStatus));
    });
  }

  void _newTaskState(NewTasksState event, Emitter<TasksState> emit) {
    emit(const TasksState());
  }

  void _changeStatusTask(
      ChangeStatusTask event, Emitter<TasksState> emit) async {
    await repository.changeStatus(status: event.status, id: event.id);
    final updatedTaskStatus = state.tasks.map((task) {
      return task.id == event.id
          ? Task(
              date: task.date,
              estatus: event.status,
              id: task.id,
              title: task.title)
          : task;
    }).toList();
    emit(state.copyWith(tasks: updatedTaskStatus));
  }

  void _updateTask(TaskUpdateRequest event, Emitter<TasksState> emit) async {
    final updatedTask = await repository.editTask(task: event.task);

    final updatedTasks = state.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void _getOneById(TaskGetOneRequest event, Emitter<TasksState> emit) async {
    final updateTask = await repository.getOneById(id: event.id);
    emit(state.copyWith(task: updateTask, openDialog: DialogStatus.edit));
  }

  void _deleteTask(TaskDeleteRequest event, Emitter<TasksState> emit) async {
    await repository.deleteTask(id: event.id);
    final updatedTasks = List<Task>.from(state.tasks)
      ..removeWhere((task) => task.id == event.id);
    emit(state.copyWith(tasks: updatedTasks));
  }

  void _getAllTask(TasksGetAllRequest event, Emitter<TasksState> emit) async {
    try {
      final response = await repository.getAllTask(mail: event.mail);
      emit(state.copyWith(tasks: response));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error: $e'));
    }
  }

  void _addTask(TasksAddRequest event, Emitter<TasksState> emit) async {
    try {
      emit(state.copyWith(task: event.task, status: TasksStatus.loading));
      final idRef = await repository.createTask(task: event.task);
      final Task updateIdTask = Task(
          id: idRef,
          email: event.task.email,
          date: event.task.date,
          estatus: event.task.estatus,
          title: event.task.title);
      final newTask = List<Task>.from(state.tasks)..add(updateIdTask);
      emit(state.copyWith(
        task: event.task,
        status: TasksStatus.success,
        tasks: newTask,
      ));
    } catch (e) {
      emit(state.copyWith(task: event.task, status: TasksStatus.failure));
    }
  }
}
