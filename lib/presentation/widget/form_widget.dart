import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/widget/custom_text_form_field.dart';

class FormWidget extends StatefulWidget {
  final String title;
  final String btnTitle;
  final IconData icon;
  const FormWidget(
      {super.key,
      required this.title,
      required this.btnTitle,
      required this.icon});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  String errorLogin = '';
  @override
  Widget build(BuildContext context) {
    final formCubit = context.watch<FormCubit>();
    final email = formCubit.state.email;
    final password = formCubit.state.password;

    return Dialog(
        child: Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                height: 10.0,
                width: widget.title == 'Registrarse' ? 115.0 : 100,
              ),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 25),
              ),
              SizedBox(
                width: widget.title == 'Registrarse' ? 60.0 : 49.7,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          widget.title == 'Registrarse'
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomTextFormField(
                    label: 'Ingrese su nombre',
                    onChanged: formCubit.nameChange,
                    errorMessage: formCubit.state.name.errorMessage,
                  ))
              : const SizedBox.shrink(),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextFormField(
                label: 'Ingrese su correo',
                onChanged: formCubit.emailChange,
                errorMessage: email.errorMessage,
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextFormField(
                label: 'Ingrese Su Contraseña',
                obscureText: true,
                onChanged: formCubit.passwordChange,
                errorMessage: password.errorMessages,
              )),
          errorLogin.isNotEmpty
              ? Text(
                  errorLogin,
                  style: const TextStyle(color: Colors.red),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.tonalIcon(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 188, 225, 255))),
                onPressed: () async {
                  if (widget.title == 'Registrarse') {
                    formCubit.onSubmit('Registrarse');
                  }
                  if (widget.title == 'Iniciar Sesion') {
                    formCubit.onSubmit('Login');
                  }
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    if (formCubit.state.user != null) {
                      Navigator.of(context).pop();
                      errorLogin = '';
                      context
                          .read<TasksBloc>()
                          .add(TasksGetAllRequest(formCubit.state.user!.email));
                    }

                    if (widget.title == 'Iniciar Sesion') {
                      errorLogin = 'Credenciales incorrectas';
                    }
                    if (widget.title == 'Registrarse') {
                      errorLogin = 'El correo ya esta registrado';
                    }
                  });
                },
                icon: Icon(widget.icon),
                label: Text(
                  widget.btnTitle,
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 48, 48, 48)),
                )),
          ),
        ],
      ),
    ));
  }
}
