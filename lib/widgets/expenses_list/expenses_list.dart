import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget{
  const ExpensesList({super.key,required this.expense, required this.onRemoveExpense});
  final List<Expense> expense ;
  final void Function(Expense expense) onRemoveExpense;

@override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: expense.length,
    itemBuilder: (ctx , index) =>
      Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.60),
          margin:EdgeInsets.symmetric(horizontal:Theme.of(context).cardTheme.margin!.horizontal), 
          ),
        key: ValueKey(expense[index]), 
        onDismissed: (direction){
          onRemoveExpense(expense[index]);
        },
        child:  ExpensesItem(expense[index]),
        ),
    );
  } 
}