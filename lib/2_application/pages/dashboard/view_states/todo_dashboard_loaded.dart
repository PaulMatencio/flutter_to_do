import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_dashboard.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/core/widgets/profile_button.dart';
import 'package:todo_app/2_application/core/widgets/switch_button.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

class TodoDashboardLoaded extends StatelessWidget {
  const TodoDashboardLoaded({super.key, required this.toDoDashboard});
  static const pageConfig = PageConfig(
      icon: Icons.dashboard_rounded, name: 'dashboard', child: DashboardPage());
  final ToDoDashboard toDoDashboard;

  @override
  Widget build(BuildContext context) {
    final collections = toDoDashboard.collections;
    final theme = Theme.of(context);
    /*
    final List<double> percent = collections
        .map((collection) => (collection.isDone + collection.isNotDone) > 0
            ? (collection.isDone / (collection.isDone + collection.isNotDone))
            : 0.0)
        .toList();
     */
    List<double> percent = [];
    double tasks = 0;
    for (int i = 0; i < collections.length; i++) {
      int isDone = collections[i].isDone;
      int isNotDone = collections[i].isNotDone;
      int task = isDone + isNotDone;
      if (task > 0) {
        tasks += task.toDouble();
        percent.add(isDone / task);
      } else {
        percent.add(0.0);
      }
    }

    Size size = MediaQuery.of(context).size;
    int crossAxisCount = 2;
    double width = 2.5;
    double pieWidth = 2.0;
    double height = size.height;
    bool showLegendInRow = false;
    debugPrint('Width: ${size.width} - Height: $height');
    switch (size.width) {
      case < 600.0:
        crossAxisCount = 1;
        showLegendInRow = false;
        width = 2.5;
      case >= 600 && < 900:
        showLegendInRow = false;
          crossAxisCount = 2;
          width = 3.0;
      case >= 900 && < 1200:
        crossAxisCount = 3;
        showLegendInRow = false;
        width = 3.5;
      case >= 1200:
        crossAxisCount = 4;
        showLegendInRow = true;
        width = 4.0;
      default:
    }

    if (height < 400) {
      crossAxisCount = 2;
      width = 6;
      pieWidth = 6.0;
      showLegendInRow = true;
    }

    Map<String, double> dataMap = {
      '#Tasks areDone': toDoDashboard.areDone.toDouble(),
      '#Tasks areNotDone': toDoDashboard.areNotDone.toDouble(),
    };
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
                  : context.goNamed(HomePage.pageConfig.name,
                      pathParameters: {'tab': OverviewPage.pageConfig.name})),
          actions: [
            ProfileButton(),SwitchButton()
          ],
        ),
        body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Card(
                  elevation: 8,
                  shadowColor: ToDoColor.predefinedColors[0],
                  color: theme.colorScheme.primaryContainer,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 16,
                    chartRadius: size.width / width,
                    colorList: ToDoColor.predefinedColors,
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    ringStrokeWidth: 8,
                    totalValue: tasks,
                    centerText: '$tasks tasks',
                    centerTextStyle: TextStyle(
                        color: ToDoColor.predefinedColors[0], fontSize: 20),
                    legendOptions: LegendOptions(
                      showLegendsInRow: showLegendInRow,
                      legendPosition: LegendPosition.top,
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    // gradientList: ---To add gradient colors---
                    // emptyColorGradient: ---Empty Color gradient---
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GridView.custom(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = collections[index];
                      final title = item.title;
                      final tasks = item.isDone + item.isNotDone;
                      Map<String, double> dataMap = {
                        '# isDone': item.isDone.toDouble(),
                        '# isNotDone': item.isNotDone.toDouble(),
                      };
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 8),
                        child: Card(
                          shadowColor: Color(item.colorIndex),
                          elevation: 8,
                          color: theme.colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          borderOnForeground: true,
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 16,
                            chartRadius: size.width / pieWidth,
                            colorList: [
                              Color(item.colorIndex),
                              theme.colorScheme.primary
                            ],
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 8,
                            totalValue: tasks.toDouble(),
                            centerText: '$title - $tasks tasks',
                            centerTextStyle: TextStyle(
                                color: Color(item.colorIndex), fontSize: 20),
                            legendOptions: LegendOptions(
                              showLegendsInRow: showLegendInRow,
                              legendPosition: LegendPosition.top,
                              showLegends: true,
                              legendShape: BoxShape.rectangle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                            // gradientList: ---To add gradient colors---
                            // emptyColorGradient: ---Empty Color gradient---
                          ),
                        ),
                      );
                    },
                    childCount: toDoDashboard.collections.length,
                ),
              ),
              )],
          ),
        );
  }
}


