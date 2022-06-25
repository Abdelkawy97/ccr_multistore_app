import 'package:ccr_multistore_app/screens/store.dart';
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
                    return Material(
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreScreen(
                                              vendorId: snapshot.data?.docs[i]
                                                  ['vid'],
                                              storeName: snapshot.data?.docs[i]
                                                  ['storeName'],
                                            )));
                              },
                              child: Ink(
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
                      ),
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
