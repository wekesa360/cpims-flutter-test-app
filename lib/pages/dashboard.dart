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
  bool isLoadng = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String? apiBaseUrl = dotenv.env["API_BASE_URL"];
    final String? dashboardEndpoint = dotenv.env["DASHBOARD_ENDPOINT"];

    if (apiBaseUrl == null || dashboardEndpoint == null) {
      print(
          "API_BASE_URL or DASHBOARD_ENDPOINT is not defined in your .env file.");
      return;
    }

    final String? token =
        Provider.of<TokenProvider>(context, listen: false).token;
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(Uri.parse("$apiBaseUrl$dashboardEndpoint"),
        headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        dashboardData = json.decode(response.body);
        isLoadng = false;
      });
    } else {
      snackBarWidget(context, "Error fetching data: ${response.statusCode}");
      isLoadng = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Summary Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isLoadng)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
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
  late dynamic value;

  DashboardItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Widget itemWidget;

    if ((value is List || value is Map) &&
        ((value is List && value.isNotEmpty) ||
            (value is Map && value.isNotEmpty))) {
      itemWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getRenamedTitle(title),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (value is List)
            for (var item in value)
              Text(
                item.toString(),
                style: const TextStyle(fontSize: 14),
              ),
          if (value is Map)
            for (var entry in value.entries)
              Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(fontSize: 14),
              ),
        ],
      );
    } else {
      // Display the value normally
      if (value is List && value.isEmpty) {
        // Display "No Details" if the list is empty
        value = "No Summary Details";
      } else if (value is Map && value.isEmpty) {
        // Display "No Details" if the dictionary is empty
        value = "No Summary Details";
      }
      itemWidget = InkWell(
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
                _getRenamedTitle(title),
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

    return itemWidget;
  }

  String _getRenamedTitle(String originalTitle) {
    switch (originalTitle) {
      case "children":
        return "Children";
      case "children_all":
        return "All Children";
      case "caregivers":
        return "Caregiver Count";
      case "government":
        return "Government Cases";
      case "ngo":
        return "NGO Cases";
      case "case_records":
        return "Case Records";
      case "pending_cases":
        return "Pending Cases";
      case "org_units":
        return "Organization Units";
      case "workforce_members":
        return "Workforce Members";
      case "household":
        return "Household Count";
      case "ovc_summary":
        return "OVC Summary";
      case "ovc_regs":
        return "OVC Registered";
      case "case_regs":
        return "Registered Cases";
      case "case_cats":
        return "Case Categories";
      case "criteria":
        return "Criteria";
      case "org_unit":
        return "Organization Unit";
      case "org_unit_id":
        return "Organization Unit ID";
      case "details":
        return "Details";
      default:
        return originalTitle; // Return the original title if no match
    }
  }
}
