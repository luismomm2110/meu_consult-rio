import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../data/chart.dart';
import '../data/chart_dao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _chartController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final chartDao = Provider.of<ChartDao>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clinic'),
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
    return const SizedBox.shrink();
  }

  // TODO: Add _buildList

  // TODO: Add _buildListItem

  bool _canSendChart() => _chartController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
