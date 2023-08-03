import 'package:flutter/material.dart';

class ModifyChannels extends StatefulWidget {
  const ModifyChannels({super.key});

  @override
  State<ModifyChannels> createState() => _ModifyChannelsState();
}

class _ModifyChannelsState extends State<ModifyChannels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MODIFY Channels'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text('Modify'),
      ),
    );
  }
}
