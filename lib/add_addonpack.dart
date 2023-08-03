import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'API Classes/api.dart';
import 'Global Data/global.dart';
import 'add_channel_confirm.dart';
import 'models/channels.dart';

class AddAddonPack extends StatefulWidget {
  const AddAddonPack({super.key});

  @override
  State<AddAddonPack> createState() => _AddAddonPackState();
}

class _AddAddonPackState extends State<AddAddonPack> {
  List<AddonPack> addonPacks = [];
  AddonPack? selectedAddonPack;
  List<String?> selectedAddonPackID = [];
  List<String> selectedPackNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      AddonPackAPIs.fetchData().then((data) {
        setState(() {
          addonPacks = data;
          isLoading = false;
        });
      }).catchError((error) {
        if (kDebugMode) {
          print('Error: $error');
        }
      });
    });
  }

  void showBottomSheet() {
    allItemNames.clear();
    allItemID.clear();
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
          height: 450,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Here are the items in your cart',
                style: TextStyle(fontSize: 22),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'To be added',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                // Wrap Expanded with Flex widget
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      globalBasePack.selectedBasePackNamesG.isNotEmpty
                          ? const Text('Base Pack')
                          : const SizedBox(),
                      buildBasePackListView(),
                      globalAddonPack.selectedAddonPackNamesG.isNotEmpty
                          ? const Text('Addon Pack')
                          : const SizedBox(),
                      buildAddonPackListView(),
                      globalAlaCarte.selectedAlacarteNamesG.isNotEmpty
                          ? const Text('Alacarte')
                          : const SizedBox(),
                      buildAlacarteListView(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
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
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                          onPressed: () {
                            allItemNames
                                .addAll(globalBasePack.selectedBasePackNamesG);
                            allItemNames.addAll(
                                globalAddonPack.selectedAddonPackNamesG);
                            allItemNames
                                .addAll(globalAlaCarte.selectedAlacarteNamesG);

                            allItemID
                                .addAll(globalBasePack.selectedBasePackIDG);
                            allItemID
                                .addAll(globalAddonPack.selectedAddonPackIDG);
                            allItemID
                                .addAll(globalAlaCarte.selectedAlacarteIDG);

                            allItemPrices.addAll(globalBasePack.price);
                            allItemPrices.addAll(globalAddonPack.price);
                            allItemPrices.addAll(globalAlaCarte.price);

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => ChannelConfirm(
                                  selectedChannels: allItemNames,
                                  selectedChannelsPrice: allItemPrices,
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
                        onPressed: () {},
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

  Widget buildBasePackListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: globalBasePack.selectedBasePackNamesG.length,
      itemBuilder: (BuildContext context, int index) {
        final item = globalBasePack.selectedBasePackNamesG[index];
        final price = globalAddonPack.price[index];
        return buildItemTile(item, () {
          // Remove item and its ID from the base pack lists
          setState(() {
            globalBasePack.selectedBasePackNamesG.removeAt(index);
            globalBasePack.selectedBasePackIDG.removeAt(index);
            count--;
            removeItemPrice(price);
          });
        });
      },
    );
  }

  void removeItemPrice(double price) {
    setState(() {
      allItemPrices.remove(price);
    });
  }

  Widget buildAddonPackListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: globalAddonPack.selectedAddonPackNamesG.length,
      itemBuilder: (BuildContext context, int index) {
        final item = globalAddonPack.selectedAddonPackNamesG[index];
        final price = globalAddonPack.price[index]; // Get the price of the item

        return buildItemTile(item, () {
          // Remove item and its ID from the addon pack lists
          setState(() {
            globalAddonPack.selectedAddonPackNamesG.removeAt(index);
            globalAddonPack.selectedAddonPackIDG.removeAt(index);
            count--;

            // Call the method to remove the price from allItemPrices
            removeItemPrice(price);
          });
        });
      },
    );
  }

  Widget buildAlacarteListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: globalAlaCarte.selectedAlacarteNamesG.length,
      itemBuilder: (BuildContext context, int index) {
        final item = globalAlaCarte.selectedAlacarteNamesG[index];
        final price = globalAlaCarte.price[index];
        return buildItemTile(item, () {
          // Remove item and its ID from the alacarte lists
          setState(() {
            globalAlaCarte.selectedAlacarteNamesG.removeAt(index);
            globalAlaCarte.selectedAlacarteIDG.removeAt(index);
            count--;
            removeItemPrice(price);
          });
        });
      },
    );
  }

  Widget buildItemTile(String itemName, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 18, right: 18, bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(itemName),
                const Text('₹5.90/month'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(''),
                InkWell(
                  onTap: () {
                    onRemove();
                    setState(() {
                      Navigator.pop(context);
                      allItemNames.isNotEmpty ? showBottomSheet() : null;
                    });
                  },
                  child: const Text(
                    'Remove from cart',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
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
        title: const Text('Addon Packs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print(selectedPackNames);
                      print(selectedAddonPackID);
                    }
                  },
                  child: Text(
                    'Choose from the following packs:',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: addonPacks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final pack = addonPacks[index];
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Checkbox(
                              value: globalAddonPack.selectedAddonPackNamesG
                                  .contains(pack.name),
                              activeColor: Colors.deepPurple,
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected != null) {
                                    if (selected) {
                                      globalAddonPack.selectedAddonPackNamesG
                                          .add(pack.name);
                                      globalAddonPack.selectedAddonPackIDG
                                          .add(pack.id);
                                      globalAddonPack.price.add(pack.price);
                                      count++;
                                    } else {
                                      globalAddonPack.selectedAddonPackNamesG
                                          .remove(pack.name);
                                      globalAddonPack.selectedAddonPackIDG
                                          .remove(pack.id);
                                      final index = addonPacks.indexWhere(
                                          (p) => p.name == pack.name);
                                      if (index != -1) {
                                        globalAddonPack.price
                                            .remove(addonPacks[index].price);
                                      }
                                      count--;
                                    }
                                  }
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pack.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Price ₹ ${pack.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        textColor: Colors.black,
                        children: pack.channels.map<Widget>((channel) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 70),
                            leading: Image.asset(
                              'assets/images/onnetshield.png',
                              width: 40,
                              height: 40,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(channel.name),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(channel.description),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: count > 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              showBottomSheet();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                badges.Badge(
                                  badgeContent: Text(
                                    count.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  badgeStyle: const badges.BadgeStyle(
                                    badgeColor: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
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
    );
  }
}


// class Channel {
//   final String name;
//   final String description;
//   final int number;

//   Channel({
//     required this.name,
//     required this.description,
//     required this.number,
//   });
// }

// class AddonPack {
//   final String name;
//   final double price;
//   final String id;
//   final List<Channel> channels;

//   AddonPack({
//     required this.name,
//     required this.price,
//     required this.id,
//     required this.channels,
//   });

//   @override
//   String toString() {
//     return name;
//   }
// }

// List<AddonPack> parseAddonPacks(String responseBody) {
  //   final parsed = json.decode(responseBody)['data'];
  //   return parsed
  //       .where((pack) => pack['packType'] == 'ADD_ON_PACK')
  //       .map<AddonPack>((pack) {
  //     final channels = (pack['channels'] as List<dynamic>)
  //         .map<Channel>((channel) => Channel(
  //               name: channel['name'],
  //               description: channel['description'],
  //               number: channel['number'],
  //             ))
  //         .toList();

  //     return AddonPack(
  //       name: pack['name'],
  //       price: pack['price'],
  //       id: pack['id'].toString(),
  //       channels: channels,
  //     );
  //   }).toList();
  // }