import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'API Classes/api.dart';
import 'Global Data/global.dart';
import 'box_summary.dart';

class ChannelConfirm extends StatefulWidget {
  final List<String> selectedChannels;
  final List<double> selectedChannelsPrice;
  const ChannelConfirm(
      {super.key,
      required this.selectedChannels,
      required this.selectedChannelsPrice});

  @override
  State<ChannelConfirm> createState() => _ChannelConfirmState();
}

class _ChannelConfirmState extends State<ChannelConfirm> {
  String boxID = '';
  String monthlyCharges = '';
  String boxName = '';
  bool isLoading = true;
  double sum = 0;

  BoxDetails boxDetails = BoxDetails();

  Future<void> fetchBoxData() async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> jsonResponse = await boxDetails.fetchBoxData();

      setState(() {
        monthlyCharges = jsonResponse['data']['MonthlyCharges'].toString();
        boxID = jsonResponse['data']['boxId'].toString();
        boxName = jsonResponse['data']['boxName'].toString();
        isLoading = false;
      });
    } catch (e) {
      throw Exception('Failed to fetch box details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      fetchBoxData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.selectedChannels);
      print(allItemID);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
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
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Here is the updated summary',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: 300,
                      child: Text(
                        'Revised monthly charges & charges to your subscription would be as follows',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          boxName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Monthly Charges',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Primary Box ID: $boxID',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '₹ $monthlyCharges',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 297,
                              child: Text(
                                'The below items will get added to/ dropped from your box. The rest will remain the same',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Items to be added:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.selectedChannels.length,
                        itemBuilder: (BuildContext context, int index) {
                          final channelName = widget.selectedChannels[index];
                          final channelPrice =
                              widget.selectedChannelsPrice[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/onnetshield.png",
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(channelName),
                                      ],
                                    ),
                                  ],
                                ),
                                Text('₹ $channelPrice'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Total Amount is ₹ ${calculateTotalSum(allItemPrices)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurple,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await AddChannels().makePutRequest();
                              setState(() {
                                cancelItems();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BoxSummary()),
                                  (route) => false,
                                );
                              });
                            },
                            child: const Text(
                              'Confirm & Proceed',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                          onPressed: () {
                            cancelItems();
                            allItemPrices.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BoxSummary()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  double calculateTotalSum(List<double> prices) {
    return prices.reduce((value, element) => value + element);
  }

  void cancelItems() {
    allItemNames.clear();
    allItemID.clear();
    allItemPrices.clear();
    globalBasePack.selectedBasePackNamesG.clear();
    globalBasePack.selectedBasePackIDG.clear();
    globalBasePack.price.clear();
    globalAddonPack.selectedAddonPackNamesG.clear();
    globalAddonPack.selectedAddonPackIDG.clear();
    globalAddonPack.price.clear();
    globalAlaCarte.selectedAlacarteNamesG.clear();
    globalAlaCarte.selectedAlacarteIDG.clear();
    globalAlaCarte.price.clear();
    count = 0;
  }
}
