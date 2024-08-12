import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/domain/datasources/task_datasource.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/infrastructure/mapper/task_mapper.dart';

class TaskDatasourceImpl extends TaskDatasource {
  late FirebaseFirestore db;
  TaskDatasourceImpl() {
    db = FirebaseFirestore.instance;
  }

  @override
  Future<bool> changeStatus(
      {required String status, required String id}) async {
    try {
      final docRef = db.collection('tasks').doc(id);
      await docRef.update({'estatus': status});
      final updateDoc = await docRef.get();
      if (!updateDoc.exists) {
        throw Exception('No Existe');
      }
      return true;
    } catch (e) {
      throw Exception('error-> $e');
    }
  }

  @override
  Future<String> createTask({required Task task}) async {
    final docRef = db
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: TaskMapper.fromFirestore,
            toFirestore: (task, _) => TaskMapper.toFirestore(task))
        .doc();
    try {
      await docRef.set(task);
      final idDoc = await docRef.get();
      return idDoc.id;
    } catch (e) {
      throw Exception('error-> $e');
    }
  }

  @override
  Future<void> deleteTask({required String id}) async {
    try {
      await db.collection('tasks').doc(id).delete();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Task>> getAllTask({required String mail}) async {
    final List<Task> tasks = [];
    try {
      final response = await db
          .collection('tasks')
          .where('email', isEqualTo: mail)
          .withConverter<Task>(
              fromFirestore: TaskMapper.fromFirestore,
              toFirestore: (task, _) => TaskMapper.toFirestore(task))
          .get();
      for (final docSnapshot in response.docs) {
        final data = docSnapshot.data();
        final task = Task(
            id: docSnapshot.id,
            date: data.date,
            estatus: data.estatus,
            title: data.title);
        tasks.add(task);
      }
      return tasks;
    } catch (e) {
      throw Exception('eror-> $e');
    }
  }

  @override
  Future<Task> editTask({required Task task}) async {
    try {
      final docRef = db
          .collection('tasks')
          .withConverter<Task>(
              fromFirestore: TaskMapper.fromFirestore,
              toFirestore: (task, _) => TaskMapper.toFirestore(task))
          .doc(task.id);
      await docRef.update(TaskMapper.toFirestore(task));
      final updateDoc = await docRef.get();
      if (!updateDoc.exists) {
        throw Exception('No Existe');
      }
      final doc = updateDoc.data()!;
      final updateTask = Task(
        id: updateDoc.id,
        date: doc.date,
        estatus: doc.estatus,
        title: doc.title,
      );
      return updateTask;
    } catch (e) {
      throw Exception('error-> $e');
    }
  }

  @override
  Future<Task?> getOneById({required String id}) async {
    try {
      final ref = db.collection('tasks').doc(id).withConverter<Task>(
          fromFirestore: TaskMapper.fromFirestore,
          toFirestore: (task, _) => TaskMapper.toFirestore(task));

      final docSnap = await ref.get();
      if (!docSnap.exists) {
        throw Exception('No Existe');
      }
      final task = docSnap.data()!;
      final Task updateTask = Task(
          date: task.date,
          estatus: task.estatus,
          id: docSnap.id,
          title: task.title);
      return updateTask;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
