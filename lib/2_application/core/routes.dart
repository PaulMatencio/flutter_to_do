import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/core/go_router_observer.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/create_todo_entry/create_todo_entry_page.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/modify_todo_entry/modify_todo_entry_page.dart';
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
        name: 'login',
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen(
            showPasswordVisibilityToggle: true,
            showAuthActionSwitch: true,
            actions: [
              AuthStateChangeAction<SignedIn>((context, signedIn) {
                context.goNamed(HomePage.pageConfig.name,
                    pathParameters: {'tab': OverviewPage.pageConfig.name});
              }),
              AuthStateChangeAction<UserCreated>(
                (context, userCreated) {
                  context.goNamed(HomePage.pageConfig.name, pathParameters: {
                    'tab': DashboardPage.pageConfig.name,
                  });
                },
              ),
              AuthStateChangeAction<AuthFailed>((context, state) {
                ErrorText.localizeError = (BuildContext context, Exception e) {
                  return e.toString();
                };
              }),

            ],
          );
        }),

    GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return ProfileScreen(
            appBar: AppBar(
              actions: [
                BackButton(
                  onPressed: () {
                    context.canPop() ? context.pop() : null;
                  },
                )
              ],
            ),
            actions: [
              SignedOutAction((context) {
                // context.goNamed('login');
                context.goNamed(HomePage.pageConfig.name,
                    pathParameters: {'tab': OverviewPage.pageConfig.name});
              }),
            ],
          );
        }),
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
          builder: (BuildContext context, GoRouterState state) =>
              HomePageProvider(
            key: state.pageKey,
            //  tab: state.pathParameters['tab'] ?? 'dashboard',
            tab: state.pathParameters['tab']!,
          ),
        ),
      ],
    ),
    GoRoute(
      name: CreateToDoCollectionPage.pageConfig.name,
      path: '$_basePath/overview/${CreateToDoCollectionPage.pageConfig.name}',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('create collection',style: Theme.of(context).textTheme.titleMedium ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          leading: BackButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(
                  HomePage.pageConfig.name,
                  pathParameters: {'tab': OverviewPage.pageConfig.name},
                );
              }
            },
          ),
        ),
        body: SafeArea(
          child: CreateToDoCollectionPage.pageConfig.child,
        ),
      ),
    ),
    GoRoute(
      name: CreateToDoEntryPage.pageConfig.name,
      path: '$_basePath/overview/${CreateToDoEntryPage.pageConfig.name}',
      builder: (context, state) {
        // final collectionId = state.extra as CollectionId;
        final castedExtras = state.extra as CreateToDoEntryPageExtra;
        return Scaffold(
          appBar: AppBar(
            title: Text('create entry', style: Theme.of(context).textTheme.titleMedium ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            leading: BackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(
                    HomePage.pageConfig.name,
                    pathParameters: {'tab': OverviewPage.pageConfig.name},
                  );
                }
              },
            ),
          ),
          body: SafeArea(
              child: CreateToDoEntryPageProvider(
                  toDoEntryItemAddedCallback:
                      castedExtras.toDoEntryItemAddedCallback,
                  collectionId: castedExtras.collectionId)),
        );
      },
    ),
    GoRoute(
      name: ModifyToDoEntryPage.pageConfig.name,
      path: '$_basePath/overview/${ModifyToDoEntryPage.pageConfig.name}',
      builder: (context, state) {
        // final collectionId = state.extra as CollectionId;
        final castedExtras = state.extra as ModifyToDoEntryPageExtra;
        return Scaffold(
          appBar: AppBar(
            title: const Text('update entry'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            leading: BackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(
                    HomePage.pageConfig.name,
                    pathParameters: {'tab': OverviewPage.pageConfig.name},
                  );
                }
              },
            ),
          ),
          body: SafeArea(
              child: ModifyToDoEntryPageProvider(
                  toDoEntryItemModifiedCallback:
                      castedExtras.toDoEntryItemModifiedCallback,
                  todoEntry: castedExtras.toDoEntry,
                  collectionId: castedExtras.collectionId)),
        );
      },
    ),
    GoRoute(
        name: ToDoDetailPage.pageConfig.name,
        path: '$_basePath/overview/:collectionId',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId'];
          return Scaffold(
            appBar: AppBar(
                title: Text('Details', style: Theme.of(context).textTheme.displayMedium ),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                leading: BackButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.goNamed(HomePage.pageConfig.name,
                            pathParameters: {
                                'tab': OverviewPage.pageConfig.name
                              }))),
            body: ToDoDetailPageProvider(
              collectionId: CollectionId.fromUniqueString(collectionId ?? ''),
            ),
          );
        }),
  ],
);

/*

GoRoute(
        name: ToDoDetailPage.pageConfig.name,
        path: '$_basePath/overview/:collectionId',
        builder: (context, state) {
          final collectionId = state.pathParameters['collectionId'];
          return BlocListener<NavigationToDoCubit, NavigationToDoCubitState>(
              //  -------------------------------------------------------
              //  pop the  detail_page when the   second display  state
              //  is changed
              //
              //  ------------------------------------------------------
              listenWhen: (previous, current) =>
                  previous.isSecondBodyDisplayed !=
                  current.isSecondBodyDisplayed,
              listener: (context, state) {
                // TODO: implement listener}
                if (context.canPop() &&
                    (state.isSecondBodyDisplayed ?? false)) {
                  context.pop();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                    title: Text('Details'),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    leading: BackButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.goNamed(HomePage.pageConfig.name,
                                pathParameters: {
                                    'tab': OverviewPage.pageConfig.name
                                  }))),
                body: ToDoDetailPageProvider(
                  collectionId: CollectionId.fromUniqueString(
                      collectionId ?? ''),
                ),
              ));
        }),




 */
