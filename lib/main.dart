import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_app/blocs/auth_cubit.dart';
import 'package:tv_app/screens/show_screen.dart';
import 'package:tv_app/screens/home.dart';
import 'package:tv_app/screens/login.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProviderScope(child: BlocksProvider()));
}

class BlocksProvider extends StatelessWidget {
  const BlocksProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/Home/:userId',
          builder: (context, state) =>
              HomeScreen(userId: state.pathParameters['userId']!),
        ),
        GoRoute(
          path: '/Home/Show/:showName/:userId',
          builder: (context, state) => ShowDetailsScreen(
              showName: int.parse(state.pathParameters['showName']!),
              userId: state.pathParameters['userId']!),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      title: 'TV APP',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 180, 21, 9),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 199, 0, 0)),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 180, 21, 9),
        ),
      ),
    );
  }
}
