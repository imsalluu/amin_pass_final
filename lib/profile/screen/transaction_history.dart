import 'package:amin_pass/profile/controller/transaction_history_controller.dart';
import 'package:amin_pass/profile/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionHistoryController controller = Get.find<TransactionHistoryController>();

  @override
  void initState() {
    super.initState();
    // Refetch on enter just in case, though onInit handles it. 
    // Usually onInit is enough if controller is alive, but safe to call if needed.
    // The controller logic already calls it on Init and on branch change.
    // If the controller is lazyPut, it will be created now and onInit will run.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    Widget buildCard(TransactionModel tx) {
      return Container(
        // height: 115, // Removed fixed height to prevent overflow
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.black12 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image: tx.cafeImage != null && tx.cafeImage!.isNotEmpty 
                          ? DecorationImage(
                              image: NetworkImage(tx.cafeImage!),
                              fit: BoxFit.cover,
                              onError: (_, __) {},
                            )
                          : null,
                    ),
                    child: (tx.cafeImage == null || tx.cafeImage!.isEmpty) 
                        ? const Icon(Icons.store, color: Colors.grey) 
                        : null,
                  ),
                  const SizedBox(width: 10),
                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.branchName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyMedium?.color),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Earned ${tx.earnedPoints} points",
                          style: TextStyle(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Date
                  Text(
                    tx.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
              if (tx.transactionId.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  "Transaction ID: ${tx.transactionId}",
                  style: const TextStyle(color: Color(0xFFE53935), fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final bodyContent = Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                "No transactions found for this branch",
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      if (isDesktop) {
        return Center(
          child: SizedBox(
            width: 800,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) => buildCard(controller.transactions[index]),
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: controller.transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => buildCard(controller.transactions[index]),
      );
    });

    // Desktop layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "Transaction History",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bodyContent,
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Transaction History", style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18),),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.textTheme.bodyMedium?.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: bodyContent,
    );
  }
}
