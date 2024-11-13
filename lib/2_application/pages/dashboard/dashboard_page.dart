import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/widgets/switch_button.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/settings/settings_page.dart';

import '../../core/page_config.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.dashboard_rounded,
    name: 'dashboard',
    child: DashboardPage(),
  );

  @override
  Widget build(BuildContext context) {
    PageConfig pageConfig = DashboardPage.pageConfig;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageConfig.name,
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        leading: BackButton(
            onPressed: () => context.canPop()
                ? context.pop()
                : context.goNamed(HomePage.pageConfig.name, pathParameters: {'tab': OverviewPage.pageConfig.name})),
        actions: [SwitchButton()],
      ),
      body: Container(color: theme.colorScheme.surfaceContainer),
    );
  }

  getPageConfig() => pageConfig;
}
