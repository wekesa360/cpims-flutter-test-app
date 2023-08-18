// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:cpims_flutter_test_app/widgets/snackBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../tokenProvider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Map<String, dynamic> dashboardData = {};

  Future<void> fetchData() async {
    final String url =
        dotenv.env["API_BASE_URL"]! + dotenv.env["DASHBOARD_ENDPOINT"]!;

    final String? token =
        Provider.of<TokenProvider>(context, listen: false).token;
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(url as Uri, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        dashboardData = json.decode(response.body);
      });
    } else {
      snackBarWidget(context, "Error fetching data: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var entry in dashboardData.entries)
                DashboardItem(
                  title: entry.key,
                  value: entry.value,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final dynamic value;

  const DashboardItem({super.key, 
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // You can add onTap functionality here if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
