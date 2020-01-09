import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/widgets/categories.dart';

class TransactionRoute extends StatefulWidget {
  final MyTransaction transaction;

  const TransactionRoute({
    Key key,
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionRouteState createState() => _TransactionRouteState(transaction);
}

class _TransactionRouteState extends State<TransactionRoute> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  MyTransaction _transaction;

  _TransactionRouteState(this._transaction);

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: _transaction.date,
      firstDate: DateTime(1996),
      lastDate: DateTime(3000),
    );

    if (dateTime == null) {
      return;
    }

    TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay(
        hour: _transaction.date.hour,
        minute: _transaction.date.minute,
      ),
      context: context,
    );

    if (dateTime != null) {
      int hour;
      int minute;

      if (selectedTime != null) {
        hour = selectedTime.hour;
        minute = selectedTime.minute;
      } else {
        hour = _transaction.date.hour;
        minute = _transaction.date.minute;
      }

      setState(() {
        _transaction.date = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          hour,
          minute,
        );
      });
    }
  }

  void _showCategoryChooserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          child: Categories(
            shrinkWrap: true,
            onTap: (context, category) {
              setState(() {
                _transaction.category = category;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveTransaction(BuildContext context) async {
    // Checking frontend validation.
    if (_transaction.category == null) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Please choose category!')));
      return;
    }

    if (_formKey.currentState.validate()) {
      _transaction.amount = double.parse(_amountController.text);
      _transaction.description = _descriptionController.text;

      try {
        await TransactionTable().insert(_transaction);
        Navigator.pop(context);
      } catch (exception) {
        print('_saveCategory() : Fail to save transaction! $exception');
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Fail to save transaction!')));
      }
    }
  }

  @override
  void initState() {
    if (_transaction == null) {
      _transaction = MyTransaction(date: DateTime.now(), deleted: false);
    } else {
      _amountController.text = excludeZeroDecimal(_transaction.amount);
      _descriptionController.text = _transaction.description;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Transaction'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () => _saveTransaction(context),
        ),
      ],
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => _showDateTimePicker(context),
                leading: Icon(Icons.date_range),
                title: Text(standardDateFormat(_transaction.date)),
              ),
              Divider(),
              ListTile(
                onTap: () => _showCategoryChooserDialog(context),
                leading: Icon(Icons.category),
                title: Text(
                  _transaction.category == null
                      ? 'Choose Category'
                      : _transaction.category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_drop_down),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Amount',
                  ),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter amount!';
                    }

                    try {
                      double.parse(value);
                    } catch (formatException) {
                      return 'Invalid amount!';
                    }

                    return null;
                  },
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.description),
                title: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                  ),
                  maxLines: 4,
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: body,
    );
  }
}
