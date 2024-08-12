import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/firebase_options.dart';
import 'package:tasks/infrastructure/datasources/task_datasource_impl.dart';
import 'package:tasks/infrastructure/repositories/task_repository_impl.dart';
import 'package:tasks/presentation/cubit/form_cubit.dart';
import 'package:tasks/presentation/cubit/theme_cubit.dart';
import 'package:tasks/presentation/tasks_bloc/tasks_bloc.dart';
import 'package:tasks/presentation/view/home_view.dart';
import 'package:tasks/presentation/view/job_view.dart';
import 'package:tasks/presentation/view/pending_view.dart';
import 'package:tasks/presentation/view/terminate_view.dart';
import 'package:tasks/presentation/widget/custom_drawer_widget.dart';
import 'domain/entities/user.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final taskRepository = TaskRepositoryImpl(TaskDatasourceImpl());
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => ThemeCubit()),
    BlocProvider(
      create: (_) => FormCubit(),
    ),
    BlocProvider(create: (context) {
      final formCubit = context.read<FormCubit>();
      if (formCubit.state.user == null) {
        return TasksBloc(repository: taskRepository);
      }
      return TasksBloc(repository: taskRepository)
        ..add(TasksGetAllRequest(formCubit.state.user!.email));
    })
  ], child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  void _checkUserSession() {
    firebase.User? user = firebase.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final formCubit = context.read<FormCubit>();
      final validUser = User(
          displayName: user.displayName!, email: user.email!, uid: user.uid);
      formCubit.isLogin(validUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, appTheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DefaultTabController(
          length: 4,
          child: _MainScaffold(),
        ),
        theme: appTheme.getTheme(),
      );
    });
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold();

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);

    return Scaffold(
      appBar: const _AppBarView(),
      drawer: CustomDrawerWidget(tabController: tabController),
      body: const TabBarView(
        children: [
          HomeView(),
          JobViews(),
          PendindView(),
          TerminateView(),
        ],
      ),
    );
  }
}

class _AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const _AppBarView();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state.isDarkMode;
    return AppBar(
      bottom: const TabBar(tabs: [
        Tab(
          icon: Icon(Icons.home),
          text: 'Tareas',
        ),
        Tab(
          icon: Icon(Icons.work),
          text: 'Trabajo',
        ),
        Tab(
          icon: Icon(
            Icons.pending_actions,
          ),
          text: 'Pendientes',
        ),
        Tab(
          icon: Icon(Icons.file_download_done_sharp),
          text: 'Terminada',
        )
      ]),
      title: const Text('Tareas'),
      actions: [
        IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode))
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
