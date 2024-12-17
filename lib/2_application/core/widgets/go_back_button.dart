
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackButton(
        color: theme.colorScheme.onPrimary,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.primary),
        ),
        onPressed: () => context.canPop()? context.pop(): context.goNamed(
          HomePage.pageConfig.name,
          pathParameters: {'tab': OverviewPage.pageConfig.name},
        )
    );
  }
}
