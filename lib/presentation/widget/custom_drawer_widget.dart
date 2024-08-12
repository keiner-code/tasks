import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/widget/form_widget.dart';
import 'package:tasks/presentation/widget/user_login_widget.dart';

class CustomDrawerWidget extends StatelessWidget {
  final TabController tabController;

  const CustomDrawerWidget({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormCubit>(context);
    //context.watch<FormCubit>()
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 194, 227, 255),
            ),
            child: formCubit.state.user != null
                ? UserLoginWidget(
                    name: formCubit.state.user!.displayName,
                    email: formCubit.state.user!.email)
                : const Center(
                    child: Icon(
                    Icons.face,
                    size: 100,
                    color: Colors.white,
                  )),
          ),
          ListTile(
            title: const Text('Tareas'),
            onTap: () {
              tabController.animateTo(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Trabajos'),
            onTap: () {
              tabController.animateTo(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Pendientes'),
            onTap: () {
              tabController.animateTo(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Terminadas'),
            onTap: () {
              tabController.animateTo(3);
              Navigator.pop(context);
            },
          ),
          const Divider(
            color: Colors.blue,
          ),
          formCubit.state.user == null
              ? Column(children: [
                  Tooltip(
                    message: 'Registrarse',
                    child: ListTile(
                      title: const Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const FormWidget(
                            title: 'Registrarse',
                            btnTitle: 'Crear Usuario',
                            icon: Icons.save,
                          ),
                        );
                      },
                    ),
                  ),
                  Tooltip(
                    message: 'Iniciar Sesion',
                    child: ListTile(
                      title: const Text(
                        'Iniciar Sesion',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const FormWidget(
                            title: 'Iniciar Sesion',
                            btnTitle: 'Login',
                            icon: Icons.save,
                          ),
                        );
                      },
                    ),
                  ),
                ])
              : Tooltip(
                  message: 'Cerrar Sesión',
                  child: ListTile(
                      title: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        formCubit.logout();
                        context.read<TasksBloc>().add(NewTasksState());
                      }),
                ),
          const SizedBox(
            height: 420,
          ),
          const Center(
            child: Text(
              'Todos los derechos reservados',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
