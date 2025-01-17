import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/login_button.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/settings/settings_page.dart';

class HomePageProvider extends StatelessWidget {
  const HomePageProvider({super.key, required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context) {
    debugPrint('tab: $tab');
    return BlocProvider<NavigationToDoCubit>(
      create: (_) => NavigationToDoCubit(),
      child: HomePage(tab: tab),
    );
  }
}

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
        (page) => NavigationDestination(
      icon: Icon(page.icon),
      label: page.name,
      tooltip: page.name,
    ),
  )
      .toList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<NavigationToDoCubit, NavigationToDoCubitState>(
          listenWhen: (previous, current) => previous.isSecondBodyDisplayed != current.isSecondBodyDisplayed,
          listener: (context, state) {
            if (context.canPop() && (state.isSecondBodyDisplayed ?? false)) {
              context.pop();
            }
          },
          child: AdaptiveLayout(
            primaryNavigation: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.mediumAndUp: SlotLayout.from(
                  key: const Key('primary-navigation-medium'),
                  builder: (context) => AdaptiveScaffold.standardNavigationRail(
                    width: 110,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    leading: const LoginButton(),
                    trailing: Tooltip(
                      message: SettingsPage.pageConfig.name,
                      child: IconButton(
                        onPressed: () =>
                            context.pushNamed(SettingsPage.pageConfig.name),
                        icon: Icon(SettingsPage.pageConfig.icon),
                      ),
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
            topNavigation: SlotLayout(config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('top-navigation-small'),
                builder: (context) => Container(
                  color: colorScheme.inversePrimary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Tooltip(
                        message: SettingsPage.pageConfig.name,
                        child: IconButton(
                          onPressed: () =>
                              context.pushNamed(SettingsPage.pageConfig.name),
                          icon: const Icon(Icons.settings),
                        ),
                      ),
                      const LoginButton(),
                    ],
                  ),
                ),
              ),
            }
            ),
            bottomNavigation: SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.small: SlotLayout.from(
                  key: const Key('bottom-navigation-small'),
                  builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
                    destinations: destinations,
                    currentIndex: widget.index,
                    onDestinationSelected: (value) => _tapOnNavigationDestination(context, value),
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
                : (_) => DetailPageProvider(colorScheme: colorScheme)),
      },
    );
  }
  void _tapOnNavigationDestination(BuildContext context, int index) => context.goNamed(
    HomePage.pageConfig.name,
    pathParameters: {
      'tab': HomePage.tabs[index].name,
    },
  );
}



class DetailPageProvider extends StatelessWidget {
  const DetailPageProvider({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<NavigationToDoCubit, NavigationToDoCubitState>(
      builder: (context, state) {
        final selectedId = state.selectedCollectionId;
        final isSecondBodyDisplayed = Breakpoints.mediumAndUp.isActive(context);

        ///---------------------------------------------------------
        ///    change the state of the isSecondBodyDisplayed property
        ///    for mediumAndUp
        ///----------------------------------------------------------
        context.read<NavigationToDoCubit>().secondBodyHasChanged(
          isSecondBodyDisplayed: isSecondBodyDisplayed,
        );

        if (selectedId == null) {
          //return const Placeholder();
          //return  Center(child: NetworkImageWidget(url: imageUrl));
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                    'Details',
                    style: theme.textTheme.titleMedium,
                  )),
              backgroundColor: colorScheme.primaryContainer,
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
          ),
        );
      },
    );
  }
}