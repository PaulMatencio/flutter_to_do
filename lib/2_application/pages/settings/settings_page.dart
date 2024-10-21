import 'package:flutter/material.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';

import '../home/home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const pageConfig =
      PageConfig(icon: Icons.settings, name: 'settings', child: SettingsPage());

  @override
  Widget build(BuildContext context) {
    PageConfig dashBoardPageConfig = DashboardPage().getPageConfig();
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () =>
              //context.canPop()? context.pop():context.push('${HomePage.pageConfig.name}/${dashBoardPageConfig.name}') ,
              context.canPop()? context.pop():context.pushNamed(
                HomePage.pageConfig.name,
                pathParameters:
                {'tab': DashboardPage.pageConfig.name}
              ) ,
              child: Icon(dashBoardPageConfig.icon))
        ],
      ),
      body: Container(color: Colors.yellowAccent),
    );
  }

  getPageConfig() => pageConfig;
}
