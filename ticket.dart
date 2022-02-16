import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  void fetchData() {}

  @override
  Widget build(BuildContext context) {
    var services = Provider.of<Trips>(context);
    User? currentUser = FirebaseAuth.instance.currentUser;
    services.loadData(currentUser!.uid);
    var data = services.trips;
    List<dynamic> bigD = [];
    for (var v in data) {
      if (data[v]["user"] == currentUser.uid) {
        bigD.add([
          data[v]["coach"],
          data[v]["travelDetails"],
          data[v]["price"],
          data[v]["time"],
          data[v]["date"],
        ]);
      }
    }
    Future.delayed(const Duration(seconds: 5), () {
      // services.clearData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Material(
        child: bigD.isNotEmpty
            ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListCard(ticketNumber: index, data: bigD[index]);
                })
            : const Center(
                child: Text("There is no booked ticket"),
              ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  final ticketNumber;
  final data;
  const ListCard({Key? key, required this.ticketNumber, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(left: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 5),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Ticket " + ticketNumber.toString() + " (${data})",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                "Travel destination: ${data[1]}",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "Travel Date: ${data[3]} ${data[4]}",
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              Text(
                "Price: ${data[2]} ",
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
