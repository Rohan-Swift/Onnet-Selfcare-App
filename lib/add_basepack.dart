import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'API Classes/api.dart';
import 'Global Data/global.dart';
import 'package:badges/badges.dart' as badges;
import 'add_channel_confirm.dart';
import 'models/channels.dart';

class AddBasepack extends StatefulWidget {
  const AddBasepack({super.key});

  @override
  State<AddBasepack> createState() => _AddBasepackState();
}

class _AddBasepackState extends State<AddBasepack> {
  BasePack? selectedBasePack;
  String? selectedBasePackID;

  void selectBasePack(BasePack? pack) {
    setState(() {
      selectedBasePack = pack;
      selectedBasePackID = pack?.id;
      globalBasePack.selectedBasePackNamesG.clear();
      globalBasePack.selectedBasePackIDG.clear();
      globalBasePack.price.clear();
      globalBasePack.selectedBasePackNamesG.add(pack!.name);
      globalBasePack.selectedBasePackIDG.add(pack.id);
      globalBasePack.price.add(pack.price);
      count = globalBasePack.selectedBasePackNamesG.length;
    });
  }

  List<BasePack> basePacks = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      BasePackAPIs.fetchData().then((data) {
        setState(() {
          basePacks = data;
          isLoading = false;
        });
      }).catchError((error) {
        if (kDebugMode) {
          print('Error: $error');
        }
      });
    });
  }

  List<String> basePackNames = [];
  List<String> basePackPrice = [];
  bool isLoading = true;

  int i = 0;

  void fetchBouquets() async {
    GetBouquets getBouquets = GetBouquets();
    try {
      Map<String, dynamic> response = await getBouquets.fetchBoxData();
      List<dynamic> bouquets = response['data'];
      processJsonResponse(bouquets);
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void processJsonResponse(List<dynamic> jsonResponse) {
    for (var item in jsonResponse) {
      if (item['packType'] == 'BASE_PACK') {
        basePackNames.add(item['name']);
        basePackPrice.add(item['price'].toString());
      }
    }
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
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      buildBasePackListView(),
                      globalAddonPack.selectedAddonPackNamesG.isNotEmpty
                          ? const Text('Addon Pack')
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      buildAddonPackListView(),
                      globalAlaCarte.selectedAlacarteNamesG.isNotEmpty
                          ? const Text('Alacarte')
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
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

        return buildItemTile(item, () {
          // Remove item and its ID from the base pack lists
          setState(() {
            globalBasePack.selectedBasePackNamesG.removeAt(index);
            globalBasePack.selectedBasePackIDG.removeAt(index);
            count--;
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
        title: const Text('Change Base Pack'),
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
                Text(
                  'Choose 1 Base Pack:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: basePacks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final pack = basePacks[index];
                      return ExpansionTile(
                        title: RadioListTile<BasePack?>(
                          activeColor: Colors.deepPurple,
                          title: Text(
                            pack.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: pack,
                          groupValue: selectedBasePack,
                          onChanged: (BasePack? selected) {
                            selectBasePack(selected);
                          },
                          subtitle: Text(
                            'Price: ₹${pack.price}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        textColor: Colors.black,
                        children: pack.channels
                            .map<Widget>((channel) => ListTile(
                                  contentPadding:
                                      const EdgeInsets.only(left: 70),
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
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: count > 0
                        ? ElevatedButton(
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
                          )
                        : Container(),
                  ),
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

// class BasePack {
//   final String name;
//   final double price;
//   final String id;
//   final List<Channel> channels;

//   BasePack({
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

// List<BasePack> parseBasePacks(String responseBody) {
//     final parsed = json.decode(responseBody)['data'];
//     return parsed
//         .where((pack) => pack['packType'] == 'BASE_PACK')
//         .map<BasePack>((pack) {
//       final channels = (pack['channels'] as List<dynamic>)
//           .map<Channel>((channel) => Channel(
//                 name: channel['name'],
//                 description: channel['description'],
//                 number: channel['number'],
//               ))
//           .toList();

//       return BasePack(
//         name: pack['name'],
//         price: pack['price'],
//         id: pack['id'].toString(),
//         channels: channels,
//       );
//     }).toList();
//   }

//   Future<List<BasePack>> fetchData() async {
//     String url = 'http://206.189.140.49:7070/admin/api/bouquet/getBouquets';

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization':
//               'Bearer $token', // Add the bearer token in the headers
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = response.body;
//         isLoading = false;
//         return parseBasePacks(jsonData);
//       } else {
//         throw Exception('Failed to fetch data');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error occurred: $e');
//       }
//       throw Exception('Failed to fetch data');
//     }
//   }
