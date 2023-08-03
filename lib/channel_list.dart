import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tataplayclone/add_channel_confirm.dart';

import 'Global Data/global.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  List<bool> expansionStates = List.generate(9, (index) => false);
  List<bool> channelSelectedStates = List.generate(5, (index) => false);

  int selectedCount = 0;
  bool isItemDisabled = false;

  List<String> selectedItems = [];

  final List<String> genres = [
    "English Movies",
    "Sports",
    "Kannada Regional",
    "Telugu Regional",
    "English Entertainment",
    "Kannada News",
    "Infotainment",
    "Entertainment",
    "Kannada News",
  ];

  final List<IconData> icons = [
    Icons.movie,
    Icons.sports_cricket,
    Icons.language,
    Icons.language,
    Icons.tv,
    Icons.article,
    Icons.info,
    Icons.local_movies,
    Icons.article,
  ];

  final List<String> channelNames = [
    "Public TV",
    "MNX",
    "Republic TV",
    "Star Movies",
    "Colours",
  ];

  List<String> items = [
    'Public TV',
    'MNX',
    'Republic TV',
    'Colors Kannada',
    'Star Movies',
  ];
  List<String> checkedItems = [];

  @override
  void initState() {
    super.initState();
    selectedCount = 0;
  }

  void checkIncrement() {
    setState(() {
      selectedCount++;
    });
  }

  void checkDecrement() {
    setState(() {
      selectedCount--;
      if (selectedCount <= 0) selectedCount = 0;
    });
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

  void showBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
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
                          color: Colors.deepPurple),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: checkedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = checkedItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 18, right: 18, bottom: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(selectedItems[index]),
                                      const Text('₹5.90/month')
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Ch. 426'),
                                      InkWell(
                                        onTap: () {
                                          selectedItems
                                              .remove(channelNames[index]);
                                          checkDecrement();
                                          setState(() {
                                            checkedItems.remove(item);
                                            Navigator.pop(
                                              context,
                                            );
                                          });
                                          checkedItems.isEmpty
                                              ? null
                                              : showBottomSheet();
                                          setState(() {});
                                        },
                                        child: const Text(
                                          'Remove from cart',
                                          style: TextStyle(
                                              color: Colors.deepPurple),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                                Colors.deepPurple),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChannelConfirm(
                                selectedChannels: selectedItems,
                                selectedChannelsPrice: allItemPrices,
                              ),
                            ));
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
                        height: 3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Genres'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Add channels by category',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: genres.length,
                itemBuilder: (BuildContext context, int index) {
                  final genre = genres[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(icons[index % icons.length]),
                        title: Text(genre),
                        trailing: const Icon(
                          Icons.arrow_drop_down,
                          size: 36,
                        ),
                        onTap: () {
                          setState(() {
                            expansionStates[index] = !expansionStates[index];
                          });
                        },
                      ),
                      if (expansionStates[index])
                        ...List.generate(5, (index) {
                          final item = items[index];
                          return CustomCheckbox(
                            value: checkedItems.contains(item),
                            onChanged: (bool? value) {
                              _onCheckboxChanged(item, value);
                            },
                            label: channelNames[index],
                            channel: 'Ch. 426',
                            icon: Icons.sd_outlined,
                            price: '₹5.90/month',
                            onSelectionChanged: (isSelected) {
                              if (isSelected) {
                                checkIncrement();
                                selectedItems.add(channelNames[index]);
                              } else {
                                checkDecrement();
                                selectedItems.remove(channelNames[index]);
                              }
                            },
                          );
                        }),
                      index == genres.length - 1
                          ? const SizedBox()
                          : Container(
                              height: 0.7,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(bottom: 30),
              child: selectedCount > 0
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
                              selectedCount.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Colors.white,
                              padding: EdgeInsets.all(3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            badgeAnimation: const badges.BadgeAnimation.fade(),
                            stackFit: StackFit.loose,
                            child: const Icon(Icons.shopping_cart),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text('$selectedCount items'),
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
          ],
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ValueChanged<bool> onSelectionChanged;
  final String label;
  final String channel;
  final IconData icon;
  final String price;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.onSelectionChanged,
    required this.label,
    required this.channel,
    required this.icon,
    required this.price,
  }) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool value = false;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        value = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Material(
        child: InkWell(
          onTap: () {
            setState(() {
              value = !value;
              widget.onChanged(value);
              widget.onSelectionChanged(value);
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 150,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.deepPurple,
                                value: value,
                                onChanged: (newValue) {
                                  setState(() {
                                    value = newValue!;
                                    widget.onChanged(newValue);
                                    widget.onSelectionChanged(newValue);
                                  });
                                },
                              ),
                              Text(
                                widget.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 50),
                              Text(widget.channel),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Icon(
                      widget.icon,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      widget.price,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 1,
                    width: 350,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
