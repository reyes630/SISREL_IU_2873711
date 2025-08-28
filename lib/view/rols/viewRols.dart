import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/apiBienestar.dart';
import '../../main.dart';


class Viewroles extends StatefulWidget {
  const Viewroles({super.key});

  @override
  State<Viewroles> createState() => _ViewrolesState();
}

class _ViewrolesState extends State<Viewroles> {
  @override
void initState(){
  super.initState();
  fetchRoles(); // metodo del api que trae los ambientes
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: myReactController.getListRols.length,
            itemBuilder: (BuildContext context, int index) {
              final itemList = myReactController.getListRols[index];
              return Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store),
                      Text(itemList["id"].toString())
                    ],
                  ),
                  title: Text(itemList["name"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                   
                  ),
                ),
              );
            },
          )),
          
  );
}
}