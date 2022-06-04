import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlertData data = ModalRoute.of(context)!.settings.arguments as AlertData;
    const double textSize = 30.0;
    const TextStyle myTextStyle =
    TextStyle(color: Colors.grey, fontSize: textSize);

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        const Text(
          'Please check on patient at:',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              height: 4,
              fontWeight: FontWeight.bold,
              fontSize: 30
              ),
        ),
        InfoCard(
            title: Text(
              "Room: ${data.room}",
              style: myTextStyle,
            )),
        InfoCard(
            title: Text(
              "Bed: ${data.bed}",
              style: myTextStyle,
            ))
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartBed Alert"),
      ),
      body: Container(
        // Sets the padding in the main container
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Center(
          child: SingleChildScrollView(child: column),
        ),
      ),
    );
    ;
  }
}

// Create a reusable stateless widget
class InfoCard extends StatelessWidget {
  final Widget title;

  // Constructor. {} here denote that they are optional values i.e you can use as: MyCard()
  InfoCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[this.title],
          ),
        ),
      ),
    );
  }
}

class AlertData {
  String room = 'undefined';
  String bed = 'undefined';

  AlertData(this.room, this.bed);
}