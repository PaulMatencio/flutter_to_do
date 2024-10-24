import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

import '../../core/page_config.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required String tab,
  }) : index = tabs.indexWhere((element) => element.name == tab);

  static const PageConfig pageConfig = PageConfig(
    icon: Icons.home_rounded,
    name: 'home',
  );

  final int index;

  // list of all tabs that should be displayed inside our navigation bar
  static const tabs = [
    DashboardPage.pageConfig,
    OverviewPage.pageConfig,
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final destinations = HomePage.tabs
      .map(
        (page) =>
            NavigationDestination(icon: Icon(page.icon), label: page.name),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // print(SettingsPage.pageConfig.name);
    return Scaffold(
      body: SafeArea(
          child: AdaptiveLayout(
            primaryNavigation: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.mediumAndUp: SlotLayout.from(
                  key: const Key('primary-navigation-medium'),
                  builder: (context) => AdaptiveScaffold.standardNavigationRail(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Menus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () =>
                          context.pushNamed(SettingsPage.pageConfig.name),
                      icon: Icon(SettingsPage.pageConfig.icon),
                    ),
                    backgroundColor: colorScheme.inversePrimary,
                    selectedLabelTextStyle:
                        TextStyle(color: colorScheme.onSurface),
                    selectedIconTheme:
                        IconThemeData(color: colorScheme.onSurface),
                    unselectedIconTheme: IconThemeData(
                        color: colorScheme.onSurface.withOpacity(0.5)),
                    onDestinationSelected: (index) =>
                        _tapOnNavigationDestination(context, index),
                    selectedIndex: widget.index,
                    destinations: destinations
                        .map(
                          (_) => AdaptiveScaffold.toRailDestination(_),
                        )
                        .toList(),
                  ),
                ),
              },
            ),
            bottomNavigation: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.small: SlotLayout.from(
                  key: const Key('bottom-navigation-small'),
                  builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
                    destinations: destinations,
                    currentIndex: widget.index,
                    onDestinationSelected: (value) =>
                        _tapOnNavigationDestination(context, value),
                  ),
                ),
              },
            ),
            body: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.smallAndUp: SlotLayout.from(
                  key: const Key('primary-body-small'),
                  builder: (_) => HomePage.tabs[widget.index].child,
                ),
              },
            ),
            secondaryBody: secondaryBodyLayout(),
          ),
        ),
    );
  }

  SlotLayout secondaryBodyLayout() {
    final colorScheme = Theme.of(context).colorScheme;
    return SlotLayout(
      config: <Breakpoint, SlotLayoutConfig>{
        Breakpoints.mediumAndUp: SlotLayout.from(
          key: const Key('secondary-body-medium'),
          // builder: AdaptiveScaffold.emptyBuilder,
          builder: widget.index != 1
              ? null
              // ? AdaptiveScaffold.emptyBuilder
              : (_) =>
                  BlocBuilder<NavigationToDoCubit, NavigationToDoCubitState>(
                    builder: (context, state) {
                      final selectedId = state.selectedCollectionId;

                      final isSecondBodyDisplayed =
                          Breakpoints.mediumAndUp.isActive(context);
                      //---------------------------------------------------------
                      //
                      //    Set  the state of the isSecondBodyDisplayed property
                      //----------------------------------------------------------
                      context.read<NavigationToDoCubit>().secondBodyHasChanged(
                            isSecondBodyDisplayed: isSecondBodyDisplayed,
                          );

                      if (selectedId == null) {
                        //return const Placeholder();
                        return Container();
                      }

                      return Scaffold(
                        appBar: AppBar(
                          title: Center(
                              child: Text(
                                  'Details for collection ${selectedId.value}')),
                          backgroundColor: colorScheme.inversePrimary,
                        ),
                        body: ToDoDetailPageProvider(
                          //--------------------------------------------------------
                          //  use key attribute to tell Flutter to rebuild the
                          //  detail page  when click on a different collection
                          //!  uniqueId class must be an extension of  the
                          //!      Equatable class
                          //------------------------------------------------------
                          key: Key(selectedId.value),
                          collectionId: selectedId,
                        ),
                      );
                    },
                  ),
        ),
      },
    );
  }

  //void _tapOnNavigationDestination(BuildContext context, int index) => context.go('/home/${HomePage.tabs[index].name.toLowerCase()}');
  void _tapOnNavigationDestination(BuildContext context, int index) {
    //   HomePage.pageConfig.name/:tab
    context.goNamed(HomePage.pageConfig.name,
        pathParameters: {'tab': HomePage.tabs[index].name});
  }
}
