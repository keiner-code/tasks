import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/widget/block_listener_widget.dart';

class TerminateView extends StatelessWidget {
  const TerminateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BlockListenerWidget(
        status: TasksGetStatus.terminated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<TasksBloc>()
              .add(const ChangeShowDialog(DialogStatus.create));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
