import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/withdraw_controller.dart';

class WithdrawView extends GetView<WithdrawController> {
  const WithdrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: backgroundColorLinear(
        child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Container(
              padding: EdgeInsets.only(
             
                  left: context.width * .05,
                  right: context.width * .05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Get.height * .04,
                children: [
                 
              
                  Obx(() {
                    final summary = controller.withdraws;
                    if (summary.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      width: Get.width,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Completed Tasks:')),
                            DataCell(Text('${summary['completed_tasks'] ?? '0'}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Pending Tasks:')),
                            DataCell(Text('${summary['pending_tasks'] ?? '0'}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Rejected Tasks:')),
                            DataCell(Text('${summary['rejected_tasks'] ?? '0'}')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Total Pending Amount:')),
                            DataCell(Text('${summary['total_pending_amount'] ?? '0'}')),
                          ]),
                         
                          DataRow(cells: [
                            DataCell(Text('Total Amount:')),
                            DataCell(Text('${summary['total_amount'] ?? '0'}',)),
                          ]),
                           DataRow(cells: [
                            DataCell(Text('Total Withdrawable Amount:',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(
                                '${summary['total_withdrawable_amount'] ?? '0'}',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                          ]),

                        ],
                      ),
                    );
                  }),
                 Expanded(
                  child:  Obx(() {
                    final withdrawals = controller.withdrawals;
                    if (withdrawals.isEmpty) {
                      return Padding(padding: EdgeInsets.only(top: Get.height * .05),child: Text('No withdrawal records found.', style: TextStyle(fontSize: 16)));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Withdrawals:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ...withdrawals.map((w) => Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text('Amount: ${w['amount'] ?? '-'}'),
                                subtitle: Text('Date: ${w['date'] ?? '-'}'),
                                trailing: Text(w['status'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ))
                      ],
                    );
                  }),
                 ),
                ],
              ),
            )),
      ),
    );
  }
}
