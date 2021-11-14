import 'dart:math';

import 'package:pincher/src/components/appbar.dart';
import 'package:pincher/src/components/fields/account-dropdown.dart';
import 'package:pincher/src/components/fields/transaction-date.dart';
import 'package:pincher/src/components/modal.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  SummaryPage() : super();

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      StandardAppBar(title: "Summary"),
      Expanded(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: Icon(Icons.layers_outlined),
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => _NewReportForm());
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class _NewReportForm extends StatefulWidget {
  _NewReportFormState createState() => _NewReportFormState();
}

class _NewReportFormState extends State<_NewReportForm>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      initialIndex: selectedIndex,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Modal(
      title: "Create Report",
      bottom: TabBar(
        controller: _controller,
        tabs: <Tab>[
          Tab(text: "Profit / Loss"),
          Tab(text: "Balance Sheet"),
          Tab(text: "Custom Report"),
        ],
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
            _controller.animateTo(index);
          });
        },
      ),
      onSubmit: () {},
      acceptButtonText: "Create Report",
      body: IndexedStack(
        children: [
          Visibility(
            child: ProfitLossReportForm(),
            visible: selectedIndex == 0,
          ),
          Visibility(
            child: CustomReportForm(),
            visible: selectedIndex == 1,
          ),
          Visibility(
            child: CustomReportForm(),
            visible: selectedIndex == 2,
          ),
        ],
        index: selectedIndex,
      ),
    );
  }
}

class ProfitLossReportForm extends StatelessWidget {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          children: <Widget>[
        TransactionDateField(
          _startDateController,
          label: "Report Start Date",
          onChanged: (date) {},
        ),
        TransactionDateField(
          _endDateController,
          label: "Report End Date",
          onChanged: (date) {},
        ),
      ]
              .map<Widget>((w) => Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: w,
                  ))
              .toList()),
    );
  }
}

class CustomReportForm extends StatelessWidget {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          children: <Widget>[
        TransactionDateField(
          _startDateController,
          label: "Report Start Date",
          onChanged: (date) {},
        ),
        TransactionDateField(
          _endDateController,
          label: "Report End Date",
          onChanged: (date) {},
        ),
        AccountDropdownField(
          onChanged: (a) {},
          errorMessage: "You need to specify an account",
          label: "Account",
        ),
      ]
              .map<Widget>((w) => Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: w,
                  ))
              .toList()),
    );
  }
}
