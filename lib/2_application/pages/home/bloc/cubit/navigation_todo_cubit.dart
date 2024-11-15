import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
part 'navigation_todo_cubit_state.dart';

class NavigationToDoCubit extends Cubit<NavigationToDoCubitState> {
  NavigationToDoCubit() : super(const NavigationToDoCubitState());

  /// ------------------------------------------------------------
  ///   change the  state of the collectionId to another id
  ///   This is  to  avoid rebuilding the overview page
  ///   everytime  you click on another item  of
  ///   overview page
  ///-----------------------------------------------------------------
  void selectedToDoCollectionChanged(CollectionId ? collectionId) {
    emit(NavigationToDoCubitState(selectedCollectionId: collectionId));
  }

  ///  ------------------------------------------------------------
  ///  - called in home_page.dart  secondaryBody  to  change the stat
  ///  when  BreakPoints change
  ///     if  Breakpoints.mediumAndUp  ->  true
  ///     otherwise false
  /// - referenced in route.dart
  /// -------------------------------------------------------------
  void secondBodyHasChanged({required bool isSecondBodyDisplayed}) {
    //  emit only when  not yet displayed
    if (state.isSecondBodyDisplayed != isSecondBodyDisplayed) {
      emit(NavigationToDoCubitState(
        isSecondBodyDisplayed: isSecondBodyDisplayed,
        selectedCollectionId: state.selectedCollectionId,
      ));
    }
  }
}
