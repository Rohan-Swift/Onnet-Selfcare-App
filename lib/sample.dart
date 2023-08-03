import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> items = ['Public TV', 'MNX', 'Republic TV', 'Colors Kannada'];
  List<String> checkedItems = [];

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: checkedItems.length,
          itemBuilder: (BuildContext context, int index) {
            final item = checkedItems[index];
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  checkedItems.remove(item);
                });
                Navigator.pop(context); // Close the bottom sheet
                checkedItems.isEmpty ? null : _showBottomSheet();
              },
            );
          },
        );
      },
    );
  }

  void _onCheckboxChanged(String item, bool? value) {
    setState(() {
      if (value != null && value) {
        checkedItems.add(item);
      } else {
        checkedItems.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return ListTile(
            leading: Checkbox(
              value: checkedItems.contains(item),
              onChanged: (bool? value) {
                _onCheckboxChanged(item, value);
              },
            ),
            title: Row(
              children: [
                const Icon(Icons.movie),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 8),
                Text(
                  'Subtitle $item',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkedItems.isEmpty ? null : _showBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
