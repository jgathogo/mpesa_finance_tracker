import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../../data/mpesa_message_parser.dart';
import '../../data/models/transaction_entity.dart';
import '../../data/test_mpesa_messages.dart';
import '../../data/mock_sms_message.dart';

class TestParserPage extends StatefulWidget {
  const TestParserPage({super.key});

  @override
  State<TestParserPage> createState() => _TestParserPageState();
}

class _TestParserPageState extends State<TestParserPage> {
  final TextEditingController _smsController = TextEditingController();
  final MpesaMessageParser _parser = MpesaMessageParser();
  TransactionEntity? _parsedTransaction;
  String? _errorMessage;
  List<String> _logs = [];

  void _parseSms() {
    setState(() {
      _parsedTransaction = null;
      _errorMessage = null;
      _logs = [];
    });

    final sms = _smsController.text.trim();
    if (sms.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an SMS message';
      });
      return;
    }

    try {
      // Create a mock SmsMessage
      final mockSms = MockSmsMessage(
        id: 1,
        sender: 'MPESA',
        body: sms,
        date: DateTime.now(),
      );

      _logs.add('Attempting to parse SMS...');
      final transaction = _parser.parseMessage(mockSms);
      
      if (transaction != null) {
        _logs.add('Successfully parsed transaction:');
        _logs.add('Transaction ID: ${transaction.transactionId}');
        _logs.add('Amount: KES ${transaction.amount}');
        _logs.add('Type: ${transaction.transactionType}');
        _logs.add('Sender/Recipient: ${transaction.senderRecipient}');
        _logs.add('Date: ${transaction.dateTime}');
        
        setState(() {
          _parsedTransaction = transaction;
        });
      } else {
        _logs.add('Failed to parse transaction');
        setState(() {
          _errorMessage = 'Failed to parse SMS message';
        });
      }
    } catch (e) {
      _logs.add('Error: $e');
      setState(() {
        _errorMessage = 'Error parsing SMS: $e';
      });
    }
  }

  void _loadExampleMessage(String message) {
    setState(() {
      _smsController.text = message;
      _parsedTransaction = null;
      _errorMessage = null;
      _logs = [];
    });
  }

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Parser Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Example messages section
            const Text(
              'Real M-Pesa Messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildExampleButton('Money In (Phone)', TestMpesaMessages.moneyInWithPhone),
                _buildExampleButton('Money In (Business)', TestMpesaMessages.moneyInFromBusiness),
                _buildExampleButton('Money Out', TestMpesaMessages.moneyOutToPerson),
                _buildExampleButton('PayBill (Safaricom)', TestMpesaMessages.payBillSafaricom),
                _buildExampleButton('PayBill (Medical)', TestMpesaMessages.payBillMedical),
                _buildExampleButton('PayBill (KPLC)', TestMpesaMessages.payBillKPLC),
                _buildExampleButton('PayBill (School)', TestMpesaMessages.payBillSchool),
                _buildExampleButton('Till (Individual)', TestMpesaMessages.tillPaymentIndividual),
                _buildExampleButton('Till (Business)', TestMpesaMessages.tillPaymentBusiness),
              ],
            ),
            const SizedBox(height: 16),
            
            // SMS input section
            TextField(
              controller: _smsController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter M-Pesa SMS',
                border: OutlineInputBorder(),
                hintText: 'Paste your M-Pesa SMS here...',
              ),
            ),
            const SizedBox(height: 16),
            
            // Parse button
            ElevatedButton(
              onPressed: _parseSms,
              child: const Text('Parse SMS'),
            ),
            const SizedBox(height: 16),
            
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade100,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            
            // Parsed transaction details
            if (_parsedTransaction != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Parsed Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Transaction ID', _parsedTransaction!.transactionId),
                      _buildDetailRow('Amount', 'KES ${_parsedTransaction!.amount}'),
                      _buildDetailRow('Type', _parsedTransaction!.transactionType.toString()),
                      _buildDetailRow('Sender/Recipient', _parsedTransaction!.senderRecipient),
                      _buildDetailRow('Date', _parsedTransaction!.dateTime.toString()),
                    ],
                  ),
                ),
              ),
            ],
            
            // Logs section
            if (_logs.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Parsing Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _logs.map((log) => Text(log)).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleButton(String label, String message) {
    return ElevatedButton(
      onPressed: () => _loadExampleMessage(message),
      child: Text(label),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 