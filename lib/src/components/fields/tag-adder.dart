import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/accounttags.dart';
import 'package:flutter/material.dart';

class TagAdderField extends StatefulWidget {
  TagAdderField({required this.onChanged, this.filter});
  _TagAdderFieldState createState() => _TagAdderFieldState();

  Function(List<AccountTag>) onChanged;
  AccountType? filter;
}

class _TagAdderFieldState extends State<TagAdderField> {
  List<AccountTag?> _tags = [null];

  void _onChangeHandler(AccountTag t, int index) {
    setState(() {
      _tags[index] = t;
      widget.onChanged(_tags
          .where((e) => e != null)
          .toList()
          .map<AccountTag>((e) => e!)
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List<int>.generate(_tags.length, (index) => index)
              .map<Widget>(
                (i) => Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: SingleTagAdderField(
                    onChanged: (t) => _onChangeHandler(t, i),
                    value: _tags[i],
                    filter: widget.filter,
                  ),
                ),
              )
              .toList() +
          <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xe0e0e0ff), width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
              padding: EdgeInsets.all(0),
              child: IconButton(
                iconSize: 12.0,
                onPressed: () {
                  if (!_tags.contains(null)) setState(() => _tags.add(null));
                  // else
                },
                icon: Icon(Icons.add),
                padding: EdgeInsets.all(1.0),
              ),
            ),
          ],
    );
  }
}

class SingleTagAdderField extends StatefulWidget {
  SingleTagAdderField({this.value, this.filter, required this.onChanged});
  _SingleTagAdderFieldState createState() => _SingleTagAdderFieldState();

  Function(AccountTag) onChanged;
  AccountTag? value;
  AccountType? filter;
}

class _SingleTagAdderFieldState extends State<SingleTagAdderField> {
  bool _errored = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DropdownButtonFormField<AccountTag>(
        value: widget.value,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) {
          if (_errored) {
            return "";
          }
          return null;
        },
        style: TextStyle(fontSize: 12.0),
        onChanged: (value) {
          if (value != null) {
            widget.onChanged(value);
          } else {
            setState(() {
              _errored = true;
            });
          }
        },
        items: AccountTag.valuesByType(widget.filter)
            .toList()
            .map<DropdownMenuItem<AccountTag>>(
              (t) => DropdownMenuItem(
                value: t,
                child: Text(
                  t.toString().replaceAll("_", " "),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
            .toList(),
        hint: Text("Account Tag"),
        disabledHint: Text("Choose an Account Type"),
        decoration: InputDecoration(
          isDense: true,
          errorStyle: TextStyle(fontSize: 0),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Color(0xe0e0e0ff), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Color(0xd0d0d0ff), width: 1),
          ),
        ),
      ),
    );
  }
}
