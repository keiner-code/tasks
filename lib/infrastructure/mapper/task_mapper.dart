import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/domain/entities/task.dart';

class TaskMapper {
  static Task fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Task(
      email: data?['email'],
      date: data?['date']?.toDate(),
      title: data?['title'],
      estatus: data?['estatus'],
    );
  }

  static Map<String, dynamic> toFirestore(Task task) {
    return {
      if (task.date != null) 'date': task.date,
      if (task.email != null) 'email': task.email,
      if (task.title != null) 'title': task.title,
      if (task.estatus != null) 'estatus': task.estatus,
    };
  }
}
