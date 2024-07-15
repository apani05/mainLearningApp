import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class Acknowledegement extends StatefulWidget {
  const Acknowledegement({super.key});

  @override
  State<Acknowledegement> createState() => _AcknowledegementState();
}

class _AcknowledegementState extends State<Acknowledegement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context: context, title: 'Acknowledgements'),

        // AppBar(
        //   leading: IconButton(
        //     icon: const Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   title: const Text(
        //     'Acknowledgement',
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   backgroundColor: const Color(0xffbdbcfd),
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(
        //       bottom: Radius.circular(30),
        //     ),
        //   ),
        // ),
        body: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffbdbcfd),
              ),
              // color: Color(0xffbdbcfd),
              child: const Center(
                child: Text(
                  'Acknowledgments',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Container(
                // margin: EdgeInsets.fromLTRB(10,30,10,10),
                height: 300,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffbdbcfd),
                ),
                // color: Color(0xffbdbcfd),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    nameForAck("Ms. Rosella Many Bears (Speaker)"),
                    nameForAck("Mr. Jesse DesRosier (Speaker)"),
                    nameForAck("Piegan Institute"),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Text(
                        'Thank you for your invaluable contributions.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                )),
          ),
        ])));
  }

  Padding nameForAck(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
