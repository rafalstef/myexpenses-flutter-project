import 'package:flutter/material.dart';

class OperationPreferences extends StatefulWidget {
  const OperationPreferences({Key? key}) : super(key: key);
  @override
  _OperationPreferencesState createState() => _OperationPreferencesState();
}

class _OperationPreferencesState extends State<OperationPreferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Filter operations",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO implement navigation to homescreen
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _titleContainer("Sort by date"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: SortByDateChoiceChip(names: ['Newest', 'Oldest'])),
          ),
          const Divider(
            color: Colors.blueGrey,
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

class SortByDateChoiceChip extends StatefulWidget {
  final List<String> names;
  const SortByDateChoiceChip({
    Key? key,
    required this.names,
  }) : super(key: key);

  @override
  _SortByDateChoiceChipState createState() => _SortByDateChoiceChipState();
}

class _SortByDateChoiceChipState extends State<SortByDateChoiceChip> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: List<Widget>.generate(
        widget.names.length,
        (int index) {
          return ChoiceChip(
            label: Text(widget.names[index]),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = index;
              });
            },
          );
        },
      ).toList(),
    );
  }
}
