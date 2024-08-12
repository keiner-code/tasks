import 'package:tasks/domain/datasources/task_datasource.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final TaskDatasource datasource;
  TaskRepositoryImpl(this.datasource);
  @override
  Future<bool> changeStatus({required String status, required String id}) {
    return datasource.changeStatus(status: status, id: id);
  }

  @override
  Future<String> createTask({required Task task}) {
    return datasource.createTask(task: task);
  }

  @override
  Future<void> deleteTask({required String id}) {
    return datasource.deleteTask(id: id);
  }

  @override
  Future<List<Task>> getAllTask({required String mail}) {
    return datasource.getAllTask(mail: mail);
  }

  @override
  Future<Task> editTask({required Task task}) {
    return datasource.editTask(task: task);
  }

  @override
  Future<Task?> getOneById({required String id}) {
    return datasource.getOneById(id: id);
  }
}
