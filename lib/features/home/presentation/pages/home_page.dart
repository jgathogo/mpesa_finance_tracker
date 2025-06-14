import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Keep for other potential date formatting needs outside TransactionCard
import '../../../transactions/presentation/bloc/mpesa_messages_cubit.dart';
import '../../../transactions/data/models/transaction_entity.dart'; // Still needed for MpesaMessagesLoaded state
import '../../../transactions/presentation/pages/test_parser_page.dart';
import '../../../categories/presentation/pages/category_management_page.dart';
import '../../../categories/presentation/bloc/category_cubit.dart';
import '../../../transactions/presentation/widgets/transaction_card.dart'; // Import the new TransactionCard
import '../../../transactions/domain/entities/sort_option.dart'; // Import SortOption

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
            icon: const Icon(Icons.sort), // Sort icon
            onPressed: () {
              _showSortOptionsDialog(context);
            },
            tooltip: 'Sort Transactions',
          ),
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
          SortOption currentSortOption = SortOption.dateNewestFirst; // Default
          if (state is MpesaMessagesLoaded) {
            currentSortOption = state.currentSortOption;
          } else if (state is MpesaMessagesLoading) {
            currentSortOption = state.currentSortOption;
          } else if (state is MpesaMessagesError) {
            currentSortOption = state.currentSortOption;
          }

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
                  return TransactionCard(transaction: transaction); // Use the reusable widget
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

  void _showSortOptionsDialog(BuildContext context) {
    final currentSortOption = BlocProvider.of<MpesaMessagesCubit>(context).state is MpesaMessagesLoaded
        ? (BlocProvider.of<MpesaMessagesCubit>(context).state as MpesaMessagesLoaded).currentSortOption
        : SortOption.dateNewestFirst; // Default if state is not loaded

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              _buildSortOptionTile(context, 'Date (Newest First)', SortOption.dateNewestFirst, currentSortOption, Icons.date_range),
              _buildSortOptionTile(context, 'Date (Oldest First)', SortOption.dateOldestFirst, currentSortOption, Icons.date_range),
              _buildSortOptionTile(context, 'Category (A-Z)', SortOption.categoryAscending, currentSortOption, Icons.category),
              _buildSortOptionTile(context, 'Amount (Highest First)', SortOption.amountHighestFirst, currentSortOption, Icons.money),
              _buildSortOptionTile(context, 'Amount (Lowest First)', SortOption.amountLowestFirst, currentSortOption, Icons.money),
              _buildSortOptionTile(context, 'Type (Money In First)', SortOption.typeMoneyInFirst, currentSortOption, Icons.transform),
              _buildSortOptionTile(context, 'Type (Money Out First)', SortOption.typeMoneyOutFirst, currentSortOption, Icons.transform),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildSortOptionTile(BuildContext context, String title, SortOption option, SortOption currentSortOption, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: currentSortOption == option ? const Icon(Icons.check) : null,
      onTap: () {
        BlocProvider.of<MpesaMessagesCubit>(context).fetchMessages(sortOption: option);
        Navigator.pop(context);
      },
    );
  }
}