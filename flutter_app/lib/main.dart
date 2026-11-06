import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MedicalApp());

class MedicalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical AI App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: DiagnosisScreen(),
    );
  }
}

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomsController = TextEditingController();
  
  String _result = "";
  bool _isLoading = false;

  Future<void> _sendDiagnosisRequest() async {
    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/diagnose'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "patient_name": _nameController.text,
          "age": int.tryParse(_ageController.text) ?? 0,
          "symptoms": _symptomsController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = "النتيجة: ${data['initial_diagnosis']}\nمستوى الاستعجال: ${data['urgency_level']}";
        });
      } else {
        setState(() {
          _result = "خطأ في الاتصال بالخادم الطبي.";
        });
      }
    } catch (e) {
      setState(() {
        _result = "حدث خطأ: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('التشخيص الطبي الذكي')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'اسم المريض')),
            TextField(controller: _ageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'العمر')),
            TextField(controller: _symptomsController, maxLines: 3, decoration: InputDecoration(labelText: 'أدخل الأعراض التي تعاني منها')),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _sendDiagnosisRequest,
                    child: Text('تحليـل التشـخيص بالذكـاء الاصطناعي'),
                  ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800])),
          ],
        ),
      ),
    );
  }
}
