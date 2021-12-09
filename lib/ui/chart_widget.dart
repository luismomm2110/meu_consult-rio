import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartWidget extends StatelessWidget {
  final String chart;
  final DateTime date;
  final String doctorName;
  final String medicalId;

  const ChartWidget(this.chart, this.date, this.doctorName, this.medicalId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
        child: Column(
          children: [
            ...[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.topRight,
                ),
              ),
            ],
            Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          blurRadius: 2.0,
                          offset: const Offset(0, 1.0))
                    ],
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white),
                child: MaterialButton(
                    disabledTextColor: Colors.black87,
                    padding: const EdgeInsets.only(left: 18),
                    onPressed: null,
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(chart),
                          ],
                        ),
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$doctorName $medicalId',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Validade: " +
                    DateFormat('dd/MM/yyyy').format(date).toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
