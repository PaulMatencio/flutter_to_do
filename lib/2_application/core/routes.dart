import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/core/go_router_observer.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';

import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/settings/settings_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
const String _basePath = '/home';

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '$_basePath/${DashboardPage.pageConfig.name}',
  observers: [GoRouterObserver()],
  routes: [
    GoRoute(
      name: SettingsPage.pageConfig.name,
      path: '$_basePath/${SettingsPage.pageConfig.name}',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          child,
      routes: <RouteBase>[
        GoRoute(
          name: HomePage.pageConfig.name, //
          path: '$_basePath/:tab',
          builder: (BuildContext context, GoRouterState state) => HomePage(
            key: state.pageKey,
            //  tab: state.pathParameters['tab'] ?? 'dashboard',
            tab: state.pathParameters['tab']!,
          ),
        ),
      ],
    ),
    GoRoute(
        name: ToDoDetailPage.pageConfig.name,
        path: '$_basePath/overview/:collectionId',
        builder: (context, state) {
          return BlocListener<NavigationToDoCubit, NavigationToDoCubitState>(
            //  -------------------------------------------------------
            //  pop the  detail_page when the   second display  state
            //  is changed
            //
            //  ------------------------------------------------------
            listenWhen: (previous, current) =>
            previous.isSecondBodyDisplayed != current.isSecondBodyDisplayed,
            listener: (context, state) {
              // TODO: implement listener}
              if (context.canPop() && (state.isSecondBodyDisplayed ?? false)) {
                context.pop();
              }
            },
            child: Scaffold(
                appBar: AppBar(
                    title: const Text('details'),
                    leading: BackButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.goNamed(HomePage.pageConfig.name,
                                pathParameters: {
                                    'tab': OverviewPage.pageConfig.name
                                  }))),
                body: ToDoDetailPageProvider(
                  collectionId: CollectionId.fromUniqueString(
                      state.pathParameters['collectionId'] ?? ''),
                )),
          );
        }),
  ],
);
