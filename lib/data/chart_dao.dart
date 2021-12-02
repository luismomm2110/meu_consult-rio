import 'package:cloud_firestore/cloud_firestore.dart';
import 'chart.dart';

class ChartDao {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('charts');

  void saveChart(Chart chart) {
    collection.add(chart.toJson());
  }

  Stream<QuerySnapshot> getChartStream() {
    return collection.snapshots();
  }
}
