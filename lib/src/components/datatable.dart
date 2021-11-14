import 'package:flutter/material.dart';

class FilterOptions<T> {
  FilterOptions({
    required this.name,
    required this.options,
    required this.readable,
    required this.onFiltered,
  });

  final String name;
  final List<T> options;
  final String Function(T v) readable;
  final Function(T value) onFiltered;
}

class FormattedDataTable extends StatefulWidget {
  FormattedDataTable({
    required this.columns,
    required this.rows,
    this.maxWidth,
    this.onSelectAll,
    this.showCheckboxColumn = false,
    this.checkboxHorizontalMargin = 10,
    this.headingRowColor = Colors.transparent,
    this.isLoading = false,
    this.filters,
    this.onSearch,
    required this.onDelete,
    required this.title,
    this.isMain = false,
    this.compress = false,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool showCheckboxColumn;
  final double? maxWidth;
  final Function(bool?)? onSelectAll;
  final double checkboxHorizontalMargin;
  final Color headingRowColor;
  final bool isLoading;
  final List<FilterOptions>? filters;
  final Function(String)? onSearch;
  final Function() onDelete;
  final String title;
  final bool isMain;
  final bool compress;

  _FormattedDataTableState createState() => _FormattedDataTableState();
}

class _FormattedDataTableState extends State<FormattedDataTable> {
  bool? _isAllSelected;
  List<int> filtered = [];

  Widget _createHeaderCell({
    required Widget child,
  }) {
    return SizedBox(
      height: 56,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.compress ? 8.0 : 16.0, vertical: 0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: widget.compress ? 12.0 : 16.0,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _headerRow() {
    List<Widget> filterChips = filtered
        .map<Widget>((i) => Chip(
              onDeleted: () {
                setState(() {
                  filtered.remove(i);
                });
              },
              deleteIcon: Icon(Icons.remove_circle_outline),
              label: PopupMenuButton(
                child: Text(widget.filters![i].name),
                onSelected: (s) {},
                itemBuilder: (context) => widget.filters![i].options
                    .map(
                      (e) => PopupMenuItem(
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
              ),
            ))
        .toList();

    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      elevation: 6,
      color: widget.headingRowColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: AnimatedOpacity(
                  curve: Curves.easeOut,
                  opacity: (filtered.length == 0) ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.isMain)
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: IconButton(
                              tooltip: 'Open Navigation',
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            widget.title,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ]),
                ),
              ),
              if (widget.filters != null)
                AnimatedAlign(
                  curve: Curves.easeOut,
                  alignment: filtered.length == 0
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(right: 57, top: 10, bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: PopupMenuButton<int>(
                            tooltip: "Filter options",
                            itemBuilder: (context) {
                              int i = 0;
                              return widget.filters!
                                  .map<PopupMenuEntry<int>>(
                                    (e) => PopupMenuItem<int>(
                                      child: Text(e.name),
                                      value: i++,
                                    ),
                                  )
                                  .toList();
                            },
                            icon: Icon(Icons.filter_list),
                            onSelected: (index) {
                              setState(() {
                                filtered.add(index);
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: 1000, maxHeight: 57),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: filterChips
                                    .map((c) => Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: c,
                                        ))
                                    .toList()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(milliseconds: 500),
                ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  height: 56,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PopupMenuButton<String>(
                      itemBuilder: (context) => ["Delete"]
                          .map(
                            (o) => PopupMenuItem(
                              child: Text(o),
                              value: o,
                            ),
                          )
                          .toList(),
                      tooltip: "More Options",
                      icon: Icon(Icons.more_vert),
                      onSelected: (option) {},
                    ),
                  ),
                ),
              )
            ],
          ),
          Divider(
            indent: 0,
            endIndent: 0,
            height: 0,
            thickness: 1,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
                  if (widget.showCheckboxColumn)
                    _createHeaderCell(
                      child: Checkbox(
                        tristate: true,
                        value: _isAllSelected,
                        onChanged: (b) {
                          if (widget.onSelectAll != null)
                            widget.onSelectAll!(
                                !(_isAllSelected ?? false) ? true : null);
                          setState(() => _isAllSelected =
                              !(_isAllSelected ?? false) ? true : null);
                        },
                      ),
                    )
                ] +
                widget.columns
                    .map<Widget>(
                      (c) => Expanded(
                        child: _createHeaderCell(
                          child: Row(
                            children: [
                              if (c.onSort != null)
                                IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: () {},
                                ),
                              c.label,
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          if (widget.isLoading) LinearProgressIndicator(),
        ],
      ),
    );
  }

  Column _tableRow() {
    return Column(
      children: widget.rows.map<_FormattedTableRow>((r) {
        return _FormattedTableRow(
          compress: widget.compress,
          showCheckbox: widget.showCheckboxColumn,
          cells: r.cells,
          onSelected: r.onSelectChanged,
          isSelected: r.selected,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 152),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: widget.maxWidth,
                  child: Card(
                    child: _tableRow(),
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10),
                  )),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: widget.maxWidth,
              child: _headerRow(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormattedTableRow extends StatefulWidget {
  _FormattedTableRow({
    required this.cells,
    this.onSelected,
    this.isSelected = false,
    this.showCheckbox = false,
    this.isNumeric = false,
    this.compress = false,
  });

  final Function(bool?)? onSelected;
  final bool isSelected;
  final List<DataCell> cells;
  final bool showCheckbox;
  final bool isNumeric;
  final bool compress;

  _FormattedTableRowState createState() => _FormattedTableRowState();
}

class _FormattedTableRowState extends State<_FormattedTableRow> {
  Widget _row() {
    return Row(
      children: <Widget>[
            if (widget.showCheckbox)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 0, horizontal: widget.compress ? 8 : 16),
                child: Checkbox(
                  value: widget.isSelected,
                  onChanged: (b) {
                    if (widget.onSelected != null)
                      widget.onSelected!(!widget.isSelected);
                  },
                ),
              )
          ] +
          widget.cells
              .map<Widget>(
                (c) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: widget.compress ? 8 : 16),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: widget.compress ? 12.0 : 16.0,
                      ),
                      child: c.child,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onSelected != null) widget.onSelected!(!widget.isSelected);
      },
      child: SizedBox(
        height: 52,
        child: _row(),
      ),
    );
  }
}


// class FormattedDataColumn extends StatefulWidget {}

// class FormattedDataRow extends StatefulWidget {}
