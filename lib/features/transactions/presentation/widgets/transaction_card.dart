import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/transactions/presentation/bloc/mpesa_messages_cubit.dart';
import 'package:mpesa_finance_tracker/features/categories/presentation/bloc/category_cubit.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:flutter_image_compress/flutter_image_compress.dart'; // Import flutter_image_compress
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:open_filex/open_filex.dart'; // Import open_filex

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  // Helper function to get color based on transaction type
  Color _getTransactionCardColor(TransactionType type) {
    switch (type) {
      case TransactionType.moneyIn:
        return Colors.green.shade50;
      case TransactionType.moneyOut:
      case TransactionType.payBill:
      case TransactionType.tillPayment:
      case TransactionType.withdrawal:
        return Colors.red.shade50;
      case TransactionType.deposit:
        return Colors.blue.shade50;
      case TransactionType.unknown:
      default:
        return Colors.grey.shade50;
    }
  }

  // Helper function to get icon based on transaction type
  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.moneyIn:
        return Icons.arrow_downward;
      case TransactionType.moneyOut:
      case TransactionType.payBill:
      case TransactionType.tillPayment:
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.deposit:
        return Icons.account_balance_wallet;
      case TransactionType.unknown:
      default:
        return Icons.help_outline;
    }
  }

  // Helper function to get amount text color
  Color _getAmountTextColor(TransactionType type) {
    switch (type) {
      case TransactionType.moneyIn:
      case TransactionType.deposit:
        return Colors.green.shade700;
      case TransactionType.moneyOut:
      case TransactionType.payBill:
      case TransactionType.withdrawal:
        return Colors.red.shade700;
      case TransactionType.unknown:
      default:
        return Colors.black87;
    }
  }

  void _showCategorySelectionDialog(
    BuildContext context,
    String transactionId,
    String? currentCategory,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (blocContext, categoryState) {
                if (categoryState is CategoryLoaded) {
                  final categories = categoryState.categories;
                  return ListBody(
                    children: categories.map((category) {
                      return ListTile(
                        title: Text(category.name),
                        trailing: currentCategory == category.name ? const Icon(Icons.check) : null,
                        onTap: () {
                          BlocProvider.of<MpesaMessagesCubit>(context)
                              .updateCategory(transactionId, category.name);
                          Navigator.of(dialogContext).pop();
                        },
                      );
                    }).toList(),
                  );
                } else if (categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (categoryState is CategoryError) {
                  return Center(child: Text('Error loading categories: ${categoryState.message}'));
                }
                return const Center(child: Text('No custom categories found.'));
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            if (currentCategory != null) // Option to clear category
              TextButton(
                child: const Text('Clear Category'),
                onPressed: () {
                  BlocProvider.of<MpesaMessagesCubit>(context)
                      .updateCategory(transactionId, null);
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        );
      },
    );
  }

  // New method to compress images
  Future<String?> _compressImage(String imagePath) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String targetPath = p.join(
        appDocDir.path,
        'compressed_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: 80, // Adjust quality as needed (0-100)
        minWidth: 1000, // Adjust minWidth if needed
        minHeight: 1000, // Adjust minHeight if needed
      );

      return result?.path;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // New method to show image source selection (camera/gallery)
  void _showImageSourceSelection(BuildContext context, String transactionId) {
    final ImagePicker _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final compressedPath = await _compressImage(image.path);
                    if (compressedPath != null) {
                      print('Picked and compressed image path: $compressedPath');
                      // Update the transaction with the receipt image reference
                      BlocProvider.of<MpesaMessagesCubit>(context)
                          .updateReceiptImage(transactionId, compressedPath);
                    } else {
                      print('Image compression failed for gallery pick.');
                    }
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    final compressedPath = await _compressImage(image.path);
                    if (compressedPath != null) {
                      print('Taken and compressed image path: $compressedPath');
                      // Update the transaction with the receipt image reference
                      BlocProvider.of<MpesaMessagesCubit>(context)
                          .updateReceiptImage(transactionId, compressedPath);
                    } else {
                      print('Image compression failed for camera shot.');
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: _getTransactionCardColor(transaction.transactionType), // Apply card color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _getTransactionIcon(transaction.transactionType), // Apply icon
              color: _getAmountTextColor(transaction.transactionType), // Icon color matches text
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${transaction.transactionId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ksh${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAmountTextColor(transaction.transactionType),
                    ),
                  ),
                  Text('Type: ${transaction.transactionType.toString().split('.').last}'),
                  Text('Sender/Recipient: ${transaction.senderRecipient}'),
                  Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.dateTime)}'),
                  // Display category if available
                  if (transaction.category != null && transaction.category!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Category: ${transaction.category}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  // Display receipt image if available
                  if (transaction.receiptImageRef != null && transaction.receiptImageRef!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () async {
                            try {
                              final file = File(transaction.receiptImageRef!);
                              if (await file.exists()) {
                                await OpenFilex.open(transaction.receiptImageRef!);
                              } else {
                                debugPrint('Receipt file does not exist: ${transaction.receiptImageRef}');
                              }
                            } catch (e) {
                              debugPrint('Error opening receipt: $e');
                            }
                          },
                          child: const Text(
                            'Receipt',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 8.0), // Spacer
                  Row(
                    children: [
                      // Category Button
                      IconButton(
                        icon: const Icon(Icons.category),
                        onPressed: () {
                          _showCategorySelectionDialog(
                            context,
                            transaction.transactionId,
                            transaction.category,
                          );
                        },
                        tooltip: 'Assign Category',
                      ),
                      // Add Receipt Button
                      IconButton(
                        icon: const Icon(Icons.receipt),
                        onPressed: () {
                          _showImageSourceSelection(context, transaction.transactionId);
                        },
                        tooltip: 'Add Receipt',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 