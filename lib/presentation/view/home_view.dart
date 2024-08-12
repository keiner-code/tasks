import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/domain/entities/user.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/widget/block_listener_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BlockListenerWidget(),
      floatingActionButton:
          BlocBuilder<FormCubit, FormCubitState>(builder: (context, formState) {
        final User? user = formState.user;
        return FloatingActionButton(
          onPressed: user != null
              ? () {
                  context
                      .read<TasksBloc>()
                      .add(const ChangeShowDialog(DialogStatus.create));
                }
              : null,
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}
