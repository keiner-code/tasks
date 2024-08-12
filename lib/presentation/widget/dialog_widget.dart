import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/domain/entities/task.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';

class DialogWidget extends StatefulWidget {
  final Task? task;
  const DialogWidget({super.key, this.task});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final TextEditingController _tastController = TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      _tastController.text = widget.task!.title ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Agregar Tarea',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _tastController,
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    labelText: 'Ingrese su tarea aqui'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context
                          .read<TasksBloc>()
                          .add(const ChangeShowDialog(DialogStatus.none));
                    },
                  ),
                  TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        if (_tastController.text.isNotEmpty) {
                          if (widget.task == null) {
                            final String email =
                                context.read<FormCubit>().state.user!.email;
                            context.read<TasksBloc>().add(TasksAddRequest(Task(
                                  email: email,
                                  title: _tastController.text,
                                  date: DateTime.now(),
                                  estatus: 'trabajo',
                                )));
                          } else {
                            context
                                .read<TasksBloc>()
                                .add(TaskUpdateRequest(Task(
                                  id: widget.task!.id,
                                  title: _tastController.text,
                                  date: DateTime.now(),
                                  estatus: widget.task!.estatus,
                                )));
                          }
                          context
                              .read<TasksBloc>()
                              .add(const ChangeShowDialog(DialogStatus.none));
                          Navigator.of(context).pop();
                        }
                      }),
                ],
              )
            ])));
  }
}
