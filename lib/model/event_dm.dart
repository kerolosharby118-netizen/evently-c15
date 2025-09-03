import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c15/model/category_dm.dart';
import 'package:flutter/material.dart';

class EventDM {
  static const String collectionName = "events";
  late String id;
  late String title;
  late String categoryId;
  late DateTime date;
  late String description;
  late double? lat;
  late double? lng;
  late String ownerId;

  EventDM({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.ownerId,
    this.lat,
    this.lng,
  });

  EventDM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['categoryId'];
    var timeStamp = json['date'] as Timestamp;
    date = timeStamp.toDate();
    description = json['description'];
    ownerId = json['ownerId'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'date': date,
      'description': description,
      'lat': lat,
      'lng': lng,
      'ownerId': ownerId,
    };
  }
}
