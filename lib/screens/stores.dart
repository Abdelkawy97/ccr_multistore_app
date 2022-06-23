import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Stores"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 120,
                              width: 120,
                              child: Image.network(
                                snapshot.data?.docs[i]['profileImageUrl'],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data?.docs[i]['storeName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    );
                  });
            }
            return const Center(
              child: Text("No Stores"),
            );
          }),
    );
  }
}
