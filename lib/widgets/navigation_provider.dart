import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_manager/fabs/fabs.dart';
import 'package:flutter_money_manager/widgets/categories.dart';
import 'package:flutter_money_manager/widgets/dashboard.dart';
import 'package:flutter_money_manager/widgets/trash.dart';
import 'package:flutter_money_manager/widgets/transactions.dart';

class NavigationProvider with ChangeNotifier {
  NavigationItem currentNav = NavigationItem.DASHBOARD;

  Widget get getNav {
    switch (currentNav) {
      case NavigationItem.TRANSACTIONS:
        return Report();
      case NavigationItem.CATEGORIES:
        return Categories();
      case NavigationItem.TRASH:
        return Trash();
      default:
        return Dashboard();
    }
  }

  Widget getAppBarTitle() {
    switch (currentNav) {
      case NavigationItem.TRANSACTIONS:
        return Text('Transactions');
      case NavigationItem.CATEGORIES:
        return Text('Categories');
      case NavigationItem.TRASH:
        return Text('Trash');
      default:
        // Do not show title in Home.
        return Text('');
    }
  }

  Widget getFab(BuildContext context) {
    switch (currentNav) {
      case NavigationItem.CATEGORIES:
        return Fab().categoryFab(context);
      case NavigationItem.TRASH:
        return Container();
      default:
        return Fab().transactionFab(context);
    }
  }

  void changeNavigation(NavigationItem newNav) {
    currentNav = newNav;
    notifyListeners();
  }
}

enum NavigationItem {
  DASHBOARD,
  TRANSACTIONS,
  CATEGORIES,
  TRASH,
}
