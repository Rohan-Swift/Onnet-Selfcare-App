import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:tataplayclone/add_addonpack.dart';
import 'package:tataplayclone/add_alacarte.dart';
import 'package:tataplayclone/add_basepack.dart';
import 'package:tataplayclone/drop_channels.dart';
import 'package:tataplayclone/login_screen.dart';
import 'package:tataplayclone/modify_channels.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: const MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    return FlutterSplashScreen.fadeIn(
      duration: const Duration(seconds: 5),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 11, 2, 91),
          Color.fromARGB(255, 34, 2, 104),
        ],
      ),
      childWidget: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset('assets/images/onnetlogo.png')
          // Lottie.asset('assets/videos/Onnet_loader_portrait.json',
          //     fit: BoxFit.cover),
          ),
      defaultNextScreen: const LoginScreen(),
    );

    // FlutterSplashScreen.gif(
    //   gifPath: 'assets/videos/splash.gif',
    //   backgroundColor: Colors.deepPurple,
    //   gifWidth: w,
    //   gifHeight: h,
    //   defaultNextScreen: const LoginScreen(),
    //   duration: const Duration(milliseconds: 3515),
    //   onInit: () async {
    //     debugPrint("onInit 1");
    //     await Future.delayed(const Duration(milliseconds: 2000));
    //     debugPrint("onInit 2");
    //   },
    //   onEnd: () async {
    //     debugPrint("onEnd 1");
    //     debugPrint("onEnd 2");
    //   },
    // );
  }
}

class ManagePack extends StatefulWidget {
  const ManagePack({super.key});

  @override
  State<ManagePack> createState() => _ManagePackState();
}

void _showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text('Onnet Systems'),
        ),
        content: const Text(
          'Choose what you want to add from the options below',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: const Text('Base Pack'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddBasepack(),
                      ),
                    );
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: const Text('Addon Packs'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddAddonPack(),
                      ),
                    );
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: const Text('À la Carte'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddAlaCarte(),
                      ),
                    );
                  },
                ),
                // TextButton(
                //   child: const Text('Test'),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => const ChannelList(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class _ManagePackState extends State<ManagePack> {
  @override
  Widget build(BuildContext context) {
    //var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Packs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'What do you want to do today?',
                style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: Text(
                  'Manage your packs and channels by choosing from the options below',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: w * 0.9,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showCustomDialog(context);
                      },
                      child: const ManagePackOption(
                        icon: Icons.add,
                        text: 'QUICK ADD CHANNELS',
                        subText:
                            'Quickly add you favorite channels & Tata Play Services',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DropChannels(),
                          ),
                        );
                      },
                      child: const ManagePackOption(
                        icon: Icons.delete_outline,
                        text: 'DROP Channels',
                        subText:
                            'Drop channels or packs from your current subscription',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ModifyChannels(),
                          ),
                        );
                      },
                      child: const ManagePackOption(
                        icon: Icons.edit_outlined,
                        text: 'MODIFY Current Pack',
                        subText:
                            'Add / Drop a wide range of packs, OTT Combos, channels or Onnet Services',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ManagePackOption(
                      icon: Icons.thumb_up_outlined,
                      text: 'MAKE Your Own Pack',
                      subText:
                          'Create a pack based on your langauge & genre preferences',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ManagePackOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;

  const ManagePackOption({
    super.key,
    required this.icon,
    required this.text,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          height: 120,
          width: 370,
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
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.deepPurple),
          ),
          height: 50,
          width: 50,
          child: Icon(
            icon,
            size: 30,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
