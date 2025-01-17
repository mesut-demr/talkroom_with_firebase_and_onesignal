import 'package:comment_system/feature/auth/auth_view.dart';
import 'package:comment_system/feature/auth/cubit/auth_cubit.dart';
import 'package:comment_system/feature/home/cubit/home_cubit.dart';
import 'package:comment_system/feature/home/view/home_detail_view.dart';
import 'package:comment_system/feature/home/view/home_view.dart';
import 'package:comment_system/feature/profile/cubit/profile_cubit.dart';
import 'package:comment_system/feature/profile/view/profile_view.dart';
import 'package:comment_system/feature/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

//? app router

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'auth',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => AuthCubit(),
              child: const AuthView(),
            );
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => HomeCubit(),
              child: HomeView(),
            );
          },
        ),
        GoRoute(
          path: 'home_detail',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            final homeCubit = extra['cubit'] as HomeCubit;
            final roomId = extra['roomId'] as String;
            return BlocProvider.value(
              value: homeCubit,
              child: HomeDetailView(roomId: roomId),
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => ProfileCubit(),
              child: ProfileView(),
            );
          },
        ),
      ],
    ),
  ],
);
