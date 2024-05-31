import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/presentation/edit.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:flutter/material.dart';

class CropListManagement extends StatelessWidget {
  final Crop  crop;

  const CropListManagement({super.key, required this.crop});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Center(
                  child: Image.asset(
                    'assets/fruits.jpg',
                width: 150,
              ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop.price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: myColor.tertiary),
                  ),
                  Text(
                    crop.cropName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: myColor.tertiary),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditPage(crop: crop,)));
                },
                icon: Icon(Icons.shopping_cart, color: myColor.tertiary),
                label: const Text(''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
