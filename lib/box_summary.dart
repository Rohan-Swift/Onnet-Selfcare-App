import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tataplayclone/API%20Classes/api.dart';
import 'package:tataplayclone/main.dart';
import 'package:tataplayclone/sample.dart';

import 'Global Data/global.dart';

class BoxSummary extends StatefulWidget {
  const BoxSummary({Key? key}) : super(key: key);

  @override
  State<BoxSummary> createState() => _BoxSummaryState();
}

class _BoxSummaryState extends State<BoxSummary> {
  BoxDetails boxDetails = BoxDetails();
  GetUserSubscription getUserSubscription = GetUserSubscription();
  String id = '';
  String hdCount = '';
  String sdCount = '';
  String monthlyCharges = '';
  String boxName = '';
  String boxID = '';
  String expiry = '';
  String wallet = '';
  String status = '';
  bool isLoading = true;

  Future<void> fetchBoxData() async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> jsonResponse = await boxDetails.fetchBoxData();

      setState(() {
        id = jsonResponse['data']['boxId'].toString();
        hdCount = jsonResponse['data']['hdChannelCount'].toString();
        sdCount = jsonResponse['data']['sdChannelCount'].toString();
        monthlyCharges = jsonResponse['data']['MonthlyCharges'].toString();
        boxName = jsonResponse['data']['boxName'].toString();
        boxID = jsonResponse['data']['boxId'].toString();
        expiry = jsonResponse['data']['expiryDate'].toString();
        wallet = jsonResponse['data']['walletAmt'].toString();
        status = jsonResponse['status'].toString();

        isLoading = false;
      });
    } catch (e) {
      throw Exception('Failed to fetch box details: $e');
    }
  }

  Future<void> fetchUserPacksAndChannels() async {
    try {
      setState(() {});

      Map<String, dynamic> requestBody = {
        "subscriberCode": "BAN0000004",
        "stbId": 40,
      };

      Map<String, dynamic> jsonResponse =
          await getUserSubscription.fetchUserChannelAndPacks(requestBody);

      setState(() {
        List<dynamic> data = jsonResponse['data'];
        userSelectedChannels = List<String>.from(
            data.map((item) => item['bouquet_name'] as String).toList());
      });
    } catch (e) {
      throw Exception('Failed to fetch user packs and channels: $e');
    }
  }

  void showChannelsBottomSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Here are your packs and channels...',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (userSelectedChannels.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'Nothing to show...',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                          'Choose a wide range of packs and channels from'),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ManagePack()));
                        },
                        child: const Text(
                          'here',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: userSelectedChannels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          "assets/images/onnetshield.png",
                          height: 30,
                          width: 30,
                        ),
                        title: Text(userSelectedChannels[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserPacksAndChannels();
    Future.delayed(const Duration(seconds: 2), () {
      fetchBoxData();
    });
  }

  @override
  Widget build(BuildContext context) {
    //var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Summary'),
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
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyWidget()));
                          },
                          child: Text(
                            'Subscriber ID: $boxID',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print('Base Pack');
                                print(globalBasePack.selectedBasePackNamesG);
                                print(globalBasePack.selectedBasePackIDG);
                                print(globalBasePack.price);

                                print('Addon Pack');
                                print(globalAddonPack.selectedAddonPackNamesG);
                                print(globalAddonPack.selectedAddonPackIDG);
                                print(globalAddonPack.price);

                                print('Ala Carte');
                                print(globalAlaCarte.selectedAlacarteNamesG);
                                print(globalAlaCarte.selectedAlacarteIDG);
                                print(globalAlaCarte.price);
                                print('Count is $count');
                                print(
                                    ' Selected Channels: $userSelectedChannels');
                              }
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => const MyWidgetOne()));
                            },
                            child: const Text('Recharge with ₹300')),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text('Account Balance'),
                                      GestureDetector(
                                        onTap: () {
                                          isLoading = true;
                                          fetchBoxData();
                                        },
                                        child: const Icon(
                                          Icons.refresh,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('₹$wallet')
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: 60,
                              width: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 60,
                              width: 140,
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Recharge due on'),
                                      Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(expiry)
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 412.2,
                          width: w * 0.95,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 0.1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 0.5,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Primary Box',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.deepPurple,
                                    ),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.deepPurple),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Icon(
                                      Icons.settings,
                                      color: Colors.deepPurple,
                                    ),
                                    Text('Upgrade Availab...'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Text('Primary Box ID: $boxID'),
                                    const SizedBox(
                                      width: 120,
                                    ),
                                    Text(boxName),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 30,
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 170,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('My Channels:'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.hd,
                                              color: Colors.deepPurple,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(hdCount),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Icon(
                                              Icons.sd,
                                              color: Colors.deepPurple,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(sdCount),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          '(Incl 274 FREE Channels)',
                                          style: TextStyle(fontSize: 13.5),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    height: 85,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    height: 90,
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Monthly Charges:'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text('₹ $monthlyCharges'),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('(Incl all taxes)'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: w * 0.05,
                                  ),
                                  InkWell(
                                    onTap: () => showChannelsBottomSheet(),
                                    child: const Text(
                                      'View My Channels',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.14,
                                  ),
                                  const Text(
                                    'View Details',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ManagePack()));
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(255, 255, 0, 146),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Modify Packs & Channels',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Expanded(
                                child: Container(
                                  width: w * 0.95,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 203, 223, 237),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.thumb_up),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 235,
                                          child: Text(
                                            'Make your own pack based on language and genre preferences',
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const VerticalDivider(
                                          thickness: 2,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.deepPurple),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            "Explore",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
