import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key, required this.task});
  final Task task;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  Color? changeColor(String status) {
    if (status == 'trabajo') {
      return const Color.fromARGB(53, 0, 140, 255);
    }
    if (status == 'pendiente') {
      return const Color.fromARGB(49, 255, 4, 0);
    }
    return const Color.fromARGB(49, 1, 255, 9);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.task.estatus == 'trabajo') {
          context
              .read<TasksBloc>()
              .add(ChangeStatusTask(widget.task.id!, 'pendiente'));
        }
        if (widget.task.estatus == 'pendiente') {
          context
              .read<TasksBloc>()
              .add(ChangeStatusTask(widget.task.id!, 'terminada'));
        }
      },
      child: Card(
        shadowColor: changeColor(widget.task.estatus!),
        elevation: 4,
        color: changeColor(widget.task.estatus!),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.task.title!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<TasksBloc>()
                              .add(TaskDeleteRequest(widget.task.id!));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<TasksBloc>()
                              .add(TaskGetOneRequest(widget.task.id!));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      Text(widget.task.estatus!)
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -7,
              left: 5,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  widget.task.date!.toString(),
                  style: const TextStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
