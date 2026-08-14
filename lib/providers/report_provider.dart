import 'package:flutter/foundation.dart';
import '../models/analytics_model.dart';
import '../services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _service;

  WeeklyReportModel? _weeklyReport;
  bool _isLoading = false;

  ReportProvider({ReportService? service}) : _service = service ?? ReportService();

  WeeklyReportModel? get weeklyReport => _weeklyReport;
  bool get isLoading => _isLoading;

  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();

    _weeklyReport = await _service.getWeeklyReport();

    _isLoading = false;
    notifyListeners();
  }

  Future<String> exportReport(String format) async {
    return await _service.exportReportSummary(format: format);
  }
}
