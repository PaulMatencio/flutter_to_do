import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
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
    PageConfig pageConfig = SettingsPage().getPageConfig();
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
             // onPressed: () => context.push('/home/${pageConfig.name}'),
              onPressed: () => context.pushNamed(
               HomePage.pageConfig.name,
               pathParameters: {
                 'tab': pageConfig.name}
              ),
              child: Icon(pageConfig.icon))
        ],
      ),
      body: Container(color: Colors.purpleAccent),
    );
  }
  getPageConfig() => pageConfig;
}
