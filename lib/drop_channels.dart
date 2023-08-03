import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import 'API Classes/api.dart';
import 'Global Data/global.dart';
import 'drop_channel_confirm.dart';
import 'models/channels.dart';

class DropChannels extends StatefulWidget {
  const DropChannels({super.key});

  @override
  State<DropChannels> createState() => _DropChannelsState();
}

class _DropChannelsState extends State<DropChannels> {
  List<RemovePacksChannels> removePacksChannelsList = [];
  List<String> bouquetNames = [];
  List<String> ids = [];
  List<String> selectedItemName = [];
  List<String> selectedItemID = [];
  bool isLoading = true;

  Future<void> fetchDataAndPopulateLists() async {
    try {
      List<RemovePacksChannels> data = await RemoveChannelsAPI.fetchData();
      setState(() {
        removePacksChannelsList = data;
        bouquetNames = data.map((channel) => channel.name).toList();
        ids = data.map((channel) => channel.id).toList();
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      fetchDataAndPopulateLists();
      RemoveChannelsAPI.fetchData().then((data) {}).catchError((error) {
        if (kDebugMode) {
          print('Error: $error');
        }
      });
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Here are the items in your cart',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Expanded(
                // Wrap Expanded with Flex widget
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 0; i < globalRemoveChannels.length; i++)
                        buildCartItemTile(
                            globalRemoveChannels[i], globalRemoveChannelIDs[i]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurple),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DropChannelsConfirm(
                                  selectedChannels: globalRemoveChannels,
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Proceed',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const Text(
                        'Click Proceed to make changes to your pack',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCartItemTile(String itemName, String itemID) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 18, right: 18, bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(itemName),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        globalRemoveChannels.remove(itemName);
                        globalRemoveChannelIDs.remove(itemID);
                        count--;
                        Navigator.pop(context);
                        globalRemoveChannels.isNotEmpty
                            ? showBottomSheet()
                            : null;
                      });
                    },
                    icon: const Icon(Icons.remove_circle_outline_outlined),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop Channels'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print(ids);
                          print('Global Name: $globalRemoveChannels');
                          print('Global ID: $globalRemoveChannelIDs');
                        }
                      },
                      child: const Text(
                        'Here are the packs and channels in your subscription',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: bouquetNames.length,
                      itemBuilder: (context, index) {
                        final bouquetName = bouquetNames[index];
                        final id = ids[index];
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: !globalRemoveChannelIDs.contains(id),
                          activeColor: Colors.deepPurple,
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue == false) {
                                selectedItemName.add(bouquetName);
                                selectedItemID.add(id);
                                globalRemoveChannels.add(bouquetName);
                                globalRemoveChannelIDs.add(id);
                                count++;
                              } else {
                                selectedItemName.remove(bouquetName);
                                selectedItemID.remove(id);
                                globalRemoveChannels.remove(bouquetName);
                                globalRemoveChannelIDs.remove(id);
                                count--;
                              }
                            });
                          },
                          title: Text(bouquetName),
                        );
                      },
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: globalRemoveChannels.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  showBottomSheet();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    badges.Badge(
                                      badgeContent: Text(
                                        globalRemoveChannelIDs.length
                                            .toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor: Colors.white,
                                        padding: EdgeInsets.all(3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      badgeAnimation:
                                          const badges.BadgeAnimation.fade(),
                                      stackFit: StackFit.loose,
                                      child: const Icon(Icons.shopping_cart),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text('$count items'),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text(
                                      'Proceed to checkout',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
