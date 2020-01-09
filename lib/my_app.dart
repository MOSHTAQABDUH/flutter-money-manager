import 'package:flutter/material.dart';
import 'package:flutter_money_manager/widgets/navigation_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, _) =>
              navigationProvider.getAppBarTitle(),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Money Manager',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Divider(),
              ListTile(
                selected: nav.currentNav == NavigationItem.DASHBOARD,
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.DASHBOARD);
                },
              ),
              ListTile(
                selected: nav.currentNav == NavigationItem.TRANSACTIONS,
                leading: Icon(Icons.assignment),
                title: Text('Transactions'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.TRANSACTIONS);
                },
              ),
              ListTile(
                selected: nav.currentNav == NavigationItem.CATEGORIES,
                leading: Icon(Icons.category),
                title: Text('Categories'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.CATEGORIES);
                },
              ),
              ListTile(
                selected: nav.currentNav == NavigationItem.TRASH,
                leading: Icon(Icons.restore_from_trash),
                title: Text('Trash'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.TRASH);
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) => navigationProvider.getNav,
      ),
      floatingActionButton: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) =>
            navigationProvider.getFab(context),
      ),
    );
  }
}
