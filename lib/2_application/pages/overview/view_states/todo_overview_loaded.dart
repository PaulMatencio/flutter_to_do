import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';

class ToDoOverviewLoaded extends StatelessWidget {
  const ToDoOverviewLoaded({
    super.key,
    required this.collections,
  });

  final List<ToDoCollection> collections;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          title: Center(child: Text('Overview')),
          leading: BackButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.goNamed(HomePage.pageConfig.name,
                      pathParameters: {'tab': DashboardPage.pageConfig.name}))),
      body: Container(
        color: colorScheme.onPrimary,
        child: ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final item = collections[index];
            // final colorScheme = Theme.of(context).colorScheme;
            return BlocBuilder<NavigationToDoCubit, NavigationToDoCubitState>(
              //  ----------------------------------------------------------------
              //  condition to rebuild the overview page
              //  Only rebuild the  overview  page when
              //        another collection is selected
              //------------------------------------------------------------------
              buildWhen: (previous, current) =>
                  previous.selectedCollectionId != current.selectedCollectionId,
              builder: (context, state) {
                // debugPrint('build item ${item.id.value}');
                return Card.outlined(
                  child: ListTile(
                    tileColor: colorScheme.surface,
                    selectedTileColor: colorScheme.surfaceContainerHighest,
                    iconColor: item.color.color,
                    selectedColor: item.color.color,
                    //
                    //  selected is set to TRUE
                    //     when the item.id is the same
                    //
                    selected: state.selectedCollectionId == item.id,
                    onTap: () {
                      //------------------------------------------------
                      // when pressed => change the state of
                      //  the  selected item.id  to the  current item.id
                      //-----------------------------------------------
                      context
                          .read<NavigationToDoCubit>()
                          .selectedToDoCollectionChanged(item.id);
                      //--------------------------------------------
                      //   if screen is sll  =>  display the
                      //   detailPage of the selected collection
                      //-----------------------------------------------
                      if (Breakpoints.small.isActive(context)) {
                        context.pushNamed(ToDoDetailPage.pageConfig.name,
                            pathParameters: {'collectionId': item.id.value});
                      }

                    },
                    leading: const Icon(Icons.circle),
                    title: Text(item.title),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
