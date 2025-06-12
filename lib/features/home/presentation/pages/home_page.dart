import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../../transactions/presentation/bloc/mpesa_messages_cubit.dart';
import '../../../transactions/data/models/transaction_entity.dart'; // Import TransactionEntity
import '../../../transactions/presentation/pages/test_parser_page.dart'; // Import TestParserPage
import '../../../categories/presentation/pages/category_management_page.dart'; // Import the new category management page
import '../../../categories/presentation/bloc/category_cubit.dart'; // Import CategoryCubit

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Predefined categories for transactions - REMOVE THIS LATER ONCE DYNAMIC CATEGORIES ARE INTEGRATED
  // static const List<String> _categories = [
  //   'Groceries',
  //   'Transport',
  //   'Utilities',
  //   'Rent',
  //   'Salary',
  //   'Business Income',
  //   'Entertainment',
  //   'Health',
  //   'Education',
  //   'Shopping',
  //   ''Dining Out'',
  //   'Miscellaneous',
  // ];

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
      case TransactionType.tillPayment:
      case TransactionType.withdrawal:
        return Colors.red.shade700;
      case TransactionType.unknown:
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    // These are initialized here but are managed by main.dart's MultiBlocProvider
    // final smsInboxService = SmsInboxService();
    // final smsRepository = SmsRepositoryImpl(smsInboxService);
    // final fetchMpesaMessages = FetchMpesaMessages(smsRepository);
    // final transactionRepository = TransactionRepositoryImpl();
    // final updateTransactionCategory = UpdateTransactionCategory(transactionRepository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryManagementPage()),
              );
            },
            tooltip: 'Manage Categories',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestParserPage()),
              );
            },
            tooltip: 'Test Parser',
          ),
        ],
      ),
      body: BlocBuilder<MpesaMessagesCubit, MpesaMessagesState>(
        builder: (context, state) {
          if (state is MpesaMessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MpesaMessagesLoaded) {
            if (state.messages.isEmpty) {
              return const Center(child: Text('No M-Pesa messages found.'));
            } else {
              return ListView.builder(
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final transaction = state.messages[index];
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
                                    color: _getAmountTextColor(transaction.transactionType), // Apply text color
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
                              ],
                            ),
                          ),
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
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is MpesaMessagesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Welcome to M-Pesa Finance Tracker'));
        },
      ),
    );
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
                      .updateCategory(transactionId, null); // Clear category
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        );
      },
    );
  }
} 