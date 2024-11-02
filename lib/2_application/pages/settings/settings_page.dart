import 'package:flutter/material.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/widgets/switch_button.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

import '../home/home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const pageConfig =
      PageConfig(icon: Icons.settings, name: 'settings', child: SettingsPage());

  @override
  Widget build(BuildContext context) {
    //PageConfig settingsPageConfig = SettingsPage.pageConfig;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(pageConfig.name,
          style: theme.textTheme.titleMedium,),
        backgroundColor: theme.colorScheme.primaryContainer ,
          leading: BackButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.goNamed(HomePage.pageConfig.name,
                  pathParameters: {'tab': OverviewPage.pageConfig.name})),
        actions: [
          SwitchButton()
        ],
      ),
      body: Container(color: theme.colorScheme.inversePrimary),
    );
  }

  getPageConfig() => pageConfig;
}
