import 'package:flutter/material.dart';

class MyWidgetOne extends StatefulWidget {
  const MyWidgetOne({super.key});

  @override
  State<MyWidgetOne> createState() => _MyWidgetOneState();
}

class _MyWidgetOneState extends State<MyWidgetOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DROP Channels'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.local_movies_outlined,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'English Movies',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          CustomCheckbox(
            value: true,
            onChanged: (newValue) {},
            label: 'MNX',
            channel: 'Ch. 426',
            icon: Icons.sd_outlined,
            price: '₹5.90/month',
          ),
          const SizedBox(
            height: 20,
          ),
          CustomCheckbox(
            value: true,
            onChanged: (newValue) {},
            label: '&Priv ',
            channel: 'Ch. 123',
            icon: Icons.hd_outlined,
            price: '₹9.99/month',
          ),
          const SizedBox(
            height: 20,
          ),
          CustomCheckbox(
            value: true,
            onChanged: (newValue) {},
            label: 'MN+   ',
            channel: 'Ch. 789',
            icon: Icons.sd_outlined,
            price: '₹4.50/month',
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String channel;
  final IconData icon;
  final String price;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.channel,
    required this.icon,
    required this.price,
  }) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Material(
        child: InkWell(
          onTap: () {
            setState(() {
              _value = !_value;
              widget.onChanged(_value);
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
                      height: 73,
                      width: 150,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.deepPurple,
                                value: _value,
                                onChanged: (newValue) {
                                  setState(() {
                                    _value = newValue!;
                                    widget.onChanged(newValue);
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
                      width: 75,
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
