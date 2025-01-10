import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/core/go_router_observer.dart';
import 'package:todo_app/2_application/core/widgets/go_back_button.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/create_todo_entry/create_todo_entry_page.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/login/confirmation_result_page.dart';
import 'package:todo_app/2_application/pages/login/login_with_email_and_password_page.dart';
import 'package:todo_app/2_application/pages/login/login_with_phone_number_page.dart';
import 'package:todo_app/2_application/pages/modify_todo_entry/modify_todo_entry_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/register/register_page.dart';
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
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
              appBar: AppBar(
                title: Text('Login Page', style: theme.textTheme.titleMedium),
                actions: [const GoBackButton()],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginWithEmailAndPasswordPage(),
              ));
        }),
    GoRoute(
        name: 'login_phone',
        path: '/login_phone',
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
              appBar: AppBar(
                title: Text('Login with Phone Page',
                    style: theme.textTheme.titleMedium),
                actions: [const GoBackButton()],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginWithPhoneNumberPage(),
              ));
        }),
    GoRoute(
        name: 'confirmation_result',
        path: '/confirmation_result',
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConfirmationResultPage(),
          ));
        }),
    GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
              appBar: AppBar(
                title:
                    Text('Register Page', style: theme.textTheme.titleMedium),
                actions: [const GoBackButton()],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegisterPage(),
              ));
        }),
    GoRoute(

        /// login with Firebase Auth_ui  ( not used)
        name: 'login_ui',
        path: '/login_ui',
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen(
            showPasswordVisibilityToggle: true,
            showAuthActionSwitch: true,
            breakpoint: 600,
            footerBuilder: (context, constraint) {
              return Container(
                height: 100,
                color: Theme.of(context).colorScheme.onPrimary,
                child: Center(
                  child: Text('Thank you for Sign in',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              );
            },
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

        ///   profile page of firebase auth_ui
        name: 'profile',
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return ProfileScreen(
            appBar: AppBar(
              actions: [const GoBackButton()],
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
          builder: (BuildContext context, GoRouterState state) {
           // debugPrint( 'path :${state.pathParameters['tab']}');
            return HomePageProvider(
              key: state.pageKey,
              //  tab: state.pathParameters['tab'] ?? 'dashboard',
              tab: state.pathParameters['tab']!,
            );
          },
        ),
      ],
    ),
    GoRoute(
        name: CreateToDoCollectionPage.pageConfig.name,
        path: '$_basePath/overview/${CreateToDoCollectionPage.pageConfig.name}',
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title:
                  Text('create collection', style: theme.textTheme.titleMedium),
              backgroundColor: theme.colorScheme.primaryContainer,
              leading: GoBackButton(),
            ),
            body: SafeArea(
              child: CreateToDoCollectionPage.pageConfig.child,
            ),
          );
        }),
    GoRoute(
      name: CreateToDoEntryPage.pageConfig.name,
      path: '$_basePath/overview/${CreateToDoEntryPage.pageConfig.name}',
      builder: (context, state) {
        // final collectionId = state.extra as CollectionId;
        final castedExtras = state.extra as CreateToDoEntryPageExtra;
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
              title: Text('create entry', style: theme.textTheme.titleMedium),
              backgroundColor: theme.colorScheme.primaryContainer,
              leading: GoBackButton()),
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
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
              title: const Text('update entry'),
              backgroundColor: theme.colorScheme.primaryContainer,
              leading: GoBackButton()),
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
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
                title: Text('Details', style: theme.textTheme.displayMedium),
                backgroundColor: theme.colorScheme.primaryContainer,
                leading: GoBackButton()),
            body: ToDoDetailPageProvider(
              collectionId: CollectionId.fromUniqueString(collectionId ?? ''),
            ),
          );
        }),
  ],
);
