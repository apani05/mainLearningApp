import 'package:flutter/material.dart';

class DisscussionPage extends StatefulWidget {
  const DisscussionPage({super.key});

  @override
  State<DisscussionPage> createState() => _DisscussionPageState();
}

class _DisscussionPageState extends State<DisscussionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back_ios,color: Colors.white,),
        title: Text("Disscussion",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(child: DCarad()),
    );
  }
}

class DCarad extends StatefulWidget {
  const DCarad({
    super.key,
  });

  @override
  State<DCarad> createState() => _DCaradState();
}

class _DCaradState extends State<DCarad> {
  final List<Item> _data = generateItems(25);
  @override
  Widget build(BuildContext context) {
    // return Card(
    //   margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    //   child: Container(
    //     height: 60,
    //     child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           const CircleAvatar(
    //             foregroundColor: Colors.green,
    //             backgroundImage: AssetImage('assets/person_2.jpg'),
    //           ),
    //           const Text(
    //             "Name",
    //             style: TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //           const Text(
    //             "Score",
    //             style: TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.bold),
    //           )
    //         ]
    //     ),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList(
        materialGapSize: 20,
        expandedHeaderPadding: EdgeInsets.only(top: 0),
      expansionCallback: (int index, bool isExpanded) {
        print("value of index $index with isexpanded: $isExpanded");
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      // children: [
      //   ExpansionPanel(
      //     backgroundColor: Colors.white,
      //     headerBuilder: (BuildContext context, bool isExpanded) {
      //       return ListTile(
      //         title: const Text('Expansion Panel 1'),
      //       );
      //     },
      //     body: const ListTile(
      //         title: Text('Hello world!'),
      //         subtitle: Text('SubTitle'),
      //         trailing: Icon(Icons.delete),
      //         onTap: null),
      //     isExpanded: false,
      //   ),
      // ],
        children:  _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return SizedBox(
                height: 80,
                child:  Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.green,
                        backgroundImage: AssetImage('assets/person_2.jpg'),
                      ),
                      SizedBox(width: 10,),
                      Container(
                      //  color: Colors.grey,
                        width: MediaQuery.of(context).size.width/1.5,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            "Qustion tht need to be disscussed may be long",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // const Text(
                      //   "Score",
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold),
                      // )
                    ]
                ),
              );
            },
            // body: ListTile(
            //     title: Text(item.expandedValue),
            //     subtitle:
            //     const Text('To delete this panel, tap the trash can icon'),
            //     trailing: const Icon(Icons.delete),
            //     onTap: () {
            //       setState(() {
            //         _data.removeWhere((Item currentItem) => item == currentItem);
            //       });
            //     }),
            body: Container(
              child: ListView.builder(itemBuilder: (context,index){
                return ListTile(
                  title: Text(item.expandedValue),
                  subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
                  trailing: const Icon(Icons.delete),
                  onTap: () {
                    setState(() {
                      _data.removeWhere((Item currentItem) => item == currentItem);
                    });
                  },
                );
              },),
              height: 250,
              color: Colors.grey[200],
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
        ),
    );
  }
}
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'qustion that need to be disscussed ',
      expandedValue: 'This is item number $index',
    );
  });
}