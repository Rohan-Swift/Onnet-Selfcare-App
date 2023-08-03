import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tataplayclone/API%20Classes/api.dart';

class AddChannels extends StatefulWidget {
  const AddChannels({Key? key}) : super(key: key);

  @override
  State<AddChannels> createState() => _AddChannelsState();
}

class CheckboxItem {
  final String title;
  bool isChecked;

  CheckboxItem({required this.title, required this.isChecked});
}

class CheckboxList extends StatefulWidget {
  final List<CheckboxItem> checkboxItems;

  const CheckboxList({Key? key, required this.checkboxItems}) : super(key: key);

  @override
  State<CheckboxList> createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: widget.checkboxItems.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(widget.checkboxItems[index].title),
            value: widget.checkboxItems[index].isChecked,
            onChanged: (value) {
              setState(() {
                widget.checkboxItems[index].isChecked = value ?? false;
              });
            },
          );
        },
      ),
    );
  }
}

class _AddChannelsState extends State<AddChannels> {
  AddBouquet addBouquet = AddBouquet();
  List<String> bouquetData = ["item1", "item2"];
  List<CheckboxItem> checkboxItems = [];
  bool isLoading = true;

  void buttonClick() {
    final data = {
      "subscriberCode": "BAN0000001",
      "stbId": 10,
      "bouquets": [
        {"bouquetId": 1, "endDate": "2023-06-30", "status": 1},
        {"bouquetId": 2, "endDate": "2023-07-30", "status": 1},
      ]
    };

    addBouquet.putRequest('', data).then((response) {
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('PUT request successful!');
        }
      } else {
        if (kDebugMode) {
          print('PUT request failed with status: ${response.statusCode}');
        }
      }
    });
  }

  Future<void> fetchBouquets() async {
    try {
      List<String> data = await addBouquet.fetchBouquets();
      setState(() {
        bouquetData = data;
        isLoading = false;
        checkboxItems = bouquetData
            .map((title) => CheckboxItem(title: title, isChecked: false))
            .toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch bouquet details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      fetchBouquets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD channels'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          Column(
            children: [
              if (!isLoading) CheckboxList(checkboxItems: checkboxItems),
              if (!isLoading)
                ElevatedButton(
                  onPressed: buttonClick,
                  child: const Text('Submit'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
