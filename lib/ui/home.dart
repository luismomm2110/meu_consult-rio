import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/data/user_dao.dart';
import 'package:provider/provider.dart';

import '../models/chart.dart';
import '../data/chart_dao.dart';
import 'chart_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _chartController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? email;


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final chartDao = Provider.of<ChartDao>(context, listen: false);
    final userDao = Provider.of<UserDao>(context, listen: false);
    email = userDao.email();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Olguens"),
        actions: [
          IconButton(
            onPressed: () {
              userDao.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getChartList(chartDao),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _chartController,
                      onSubmitted: (input) {
                        _sendChart(chartDao);
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new recipe'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendChart()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendChart(chartDao);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendChart(ChartDao chartDao) {
    if (_canSendChart()) {
      final chart = Chart(
        text: _chartController.text,
        date: DateTime.now(),
      );
      chartDao.saveChart(chart);
      _chartController.clear();
      setState(() {});
    }
  }

  Widget _getChartList(ChartDao chartDao) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: chartDao.getChartStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: LinearProgressIndicator());

          return _buildList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    // 1
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      // 2
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    // 1
    final chart = Chart.fromSnapshot(snapshot);
    // 2
    return ChartWidget(
      chart.text,
      chart.date,
    );
  }

  bool _canSendChart() => _chartController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
