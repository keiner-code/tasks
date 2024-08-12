import 'package:tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<String> createTask({required Task task});
  Future<List<Task>> getAllTask({required String mail});
  Future<bool> changeStatus({required String status, required String id});
  Future<void> deleteTask({required String id});
  Future<Task> editTask({required Task task});
  Future<Task?> getOneById({required String id});
}
