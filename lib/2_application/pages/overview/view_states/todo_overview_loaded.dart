import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/2_application/core/widgets/crash_button.dart';
import 'package:todo_app/2_application/core/widgets/profile_button.dart';
import 'package:todo_app/2_application/core/widgets/switch_button.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/todo_detail_page.dart';
import 'package:todo_app/2_application/pages/home/bloc/cubit/navigation_todo_cubit.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/bloc/cubit/todo_overview_cubit.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';

class ToDoOverviewLoaded extends StatelessWidget {
  const ToDoOverviewLoaded({
    super.key,
    required this.collections,
    //required this.onDeleted
  });

  final List<ToDoCollection> collections;
  //final Function()  onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ///  not used for the moment
    final shouldDisplayAddItemButton = Breakpoints.small.isActive(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: colorScheme.primaryContainer,
          title: Center(
              child: Text(context.tr(OverviewPage.pageConfig.name),
                  style: theme.textTheme.titleMedium)),
          actions: [ProfileButton(), SwitchButton()],
          leading: BackButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.goNamed(HomePage.pageConfig.name,
                      pathParameters: {'tab': DashboardPage.pageConfig.name}))),
      body: Container(
        color: colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            ListView.builder(
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final item = collections[index];
                // final colorScheme = Theme.of(context).colorScheme;
                return BlocBuilder<NavigationToDoCubit,
                    NavigationToDoCubitState>(
                  ///  ----------------------------------------------------------------
                  ///  condition to rebuild the overview page
                  ///  Only rebuild the  overview  page when
                  ///        another collection is selected
                  ///------------------------------------------------------------------
                  buildWhen: (previous, current) =>
                      (previous.selectedCollectionId !=
                          current.selectedCollectionId) &&
                      collections.isNotEmpty,
                  builder: (context, state) {
                    // debugPrint('build item ${item.id.value}');
                    return Card.outlined(
                      child: Row(
                        children: [
                          Tooltip(
                              message: context.tr('todo_delete'),
                              child: TextButton(
                                  onPressed: () {
                                    final navigationCubit =
                                        context.read<NavigationToDoCubit>();
                                    showAlertDialog(
                                        context: context,
                                        navigationCubit: navigationCubit,
                                        collection: item);
                                  },
                                  child: Icon(Icons.delete))),
                          Expanded(
                            child: ListTile(
                              tileColor: colorScheme.surface,
                              selectedTileColor:
                                  colorScheme.surfaceContainerHighest,
                              iconColor: item.color.getColor(),
                              selectedColor: item.color.getColor(),

                              ///
                              ///  selected is set to TRUE
                              ///     when the item.id is the same
                              ///
                              selected: state.selectedCollectionId == item.id,
                              onTap: () {
                                ///------------------------------------------------
                                /// when pressed => change the state of
                                ///  the  selected item.id  to the  current item.id
                                ///   change  the  state of
                                ///       collectionId = item.id
                                ///
                                ///   Important to avoid building the
                                ///        overview page everytime
                                ///        a collectionId is changed
                                ///    see   buildWhen  previous != current
                                ///-----------------------------------------------
                                context
                                    .read<NavigationToDoCubit>()
                                    .selectedToDoCollectionChanged(item.id);
                                //--------------------------------------------
                                //   if screen is small  =>  display the
                                //   detailPage of the selected collection
                                //-----------------------------------------------
                                if (Breakpoints.small.isActive(context)) {
                                  context.pushNamed(
                                      ToDoDetailPage.pageConfig.name,
                                      pathParameters: {
                                        'collectionId': item.id.value
                                      });
                                }
                              },
                              leading: Tooltip(
                                  message: context.tr('click_for_details'),
                                  child: const Icon(Icons.circle)),
                              title: Text(item.title),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            ///   if (shouldDisplayAddItemButton)

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  key: const Key('create-todo-collection'),
                  heroTag: 'create-todo-collection',
                  tooltip: context.tr('overview_add_collection'),
                  onPressed: () {
                    context
                        .pushNamed(CreateToDoCollectionPage.pageConfig.name)
                        .then((value) {
                      if (value == true) {
                        // it was == null
                        if (context.mounted) {
                          context
                              .read<ToDoOverviewCubit>()
                              .readToDoCollections();
                        }
                      }
                    });
                  },
                  child: Icon(CreateToDoCollectionPage.pageConfig.icon),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

showAlertDialog({
  required BuildContext context,
  required ToDoCollection collection,
  required NavigationToDoCubit navigationCubit,
}) {
  /// set up the Cancel button
  Widget cancelButton =
      TextButton(child: Text('cancel'.tr()), onPressed: () => context.pop());

  ///  Setup the continue button
  Widget continueButton = TextButton(
      child: Text(context.tr('continue')),
      onPressed: () async {
        final overviewCubit = context.read<ToDoOverviewCubit>();
        final message =
            context.tr('todo_check_every');
        try {
          await overviewCubit
              .deleteCollection(collectionId: collection.id)
              .then((value) async {
            if (value) {
              ///  remove the given collection from the collections
              navigationCubit.selectedToDoCollectionChanged(null);
              await overviewCubit.readToDoCollections();
            } else {
              showScaffoldMessage(context: context, message: message);
            }
          });
        } on GeneralFailure catch (e) {
          if (context.mounted) {
            showScaffoldMessage(
                context: context, message: e.stackTrace ?? message);
          }
        } on ServerFailure catch (e) {
          if (context.mounted) {
            showScaffoldMessage(
                context: context,
                message: e.stackTrace ?? 'Ups server a failure!');
          }
        }
        if (context.mounted) context.pop();
      });

  ///
  /// Set up the AlertDialog
  ///
  AlertDialog alert = AlertDialog(
    title: Text('AlertDialog'),
    content: Text(context.tr('delete_confirmation_message')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog

  ///
  ///    Build the AlertDialog
  ///
  showDialog(
    context: context,
    useRootNavigator: false, //  use go router instead
    builder: (BuildContext context) {
      return alert; //
    },
  );
}

void showScaffoldMessage(
    {required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: TextStyle(fontSize: 18)),
    duration: const Duration(milliseconds: 3000),
    action: SnackBarAction(label: 'Ok', onPressed: () {}),
    behavior: SnackBarBehavior.floating,
  ));
}
