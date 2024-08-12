import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/domain/entities/user.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/widget/card_widget.dart';
import 'package:tasks/presentation/widget/dialog_widget.dart';

enum TasksGetStatus { all, job, pending, terminated }

class BlockListenerWidget extends StatelessWidget {
  final TasksGetStatus status;
  const BlockListenerWidget({super.key, this.status = TasksGetStatus.all});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state.openDialog != DialogStatus.none) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogWidget(
                task: state.openDialog == DialogStatus.edit ? state.task : null,
              );
            },
          );
        }
      },
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state.tasks.isEmpty) {
            final User? user = context.read<FormCubit>().state.user;
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ));
                }
                return Center(
                  child: Text(
                    user == null
                        ? 'Inicie Session Para Cargar Las Tareas'
                        : 'Agrege una tarea',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                );
              },
            );
          }

          List<Task> filteredTasks = state.tasks.where((task) {
            switch (status) {
              case TasksGetStatus.job:
                return task.estatus == 'trabajo';
              case TasksGetStatus.pending:
                return task.estatus == 'pendiente';
              case TasksGetStatus.terminated:
                return task.estatus == 'terminada';
              default:
                return true;
            }
          }).toList();

          return ListView.builder(
            itemCount: filteredTasks.length, //state.tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 4.0, top: 4.0, left: 2.0, right: 2.0),
                child:
                    CardWidget(task: filteredTasks[index] //state.tasks[index],
                        ),
              );
            },
          );
        },
      ),
    );
  }
}
