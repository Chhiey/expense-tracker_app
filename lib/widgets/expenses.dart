
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expenses.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget{
 const Expenses({super.key});

  @override
  State<Expenses> createState() {
   return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
   final List<Expense> _registeredExpenses = [
  ];

  void _openAddExpensesOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => NewExpenses(onAddExpense: _addExpense,));
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content:const Text('Expense removed'),
      duration:const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo', 
        onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        }),
     ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent =const Center(
      child: Text("No expenses found add some dumbass!"),
        );
    if(_registeredExpenses.isNotEmpty){
      mainContent =ExpensesList(
            expense:_registeredExpenses,
            onRemoveExpense: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        title:const Text("Expenses Tracker"),
        actions: [
          IconButton(onPressed:_openAddExpensesOverlay, 
          icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
      children: [
          const SizedBox(height: 16,),
          Chart(expenses: _registeredExpenses),
          const SizedBox(height: 16,),
          Expanded(child:mainContent
          ),
        ],
      ),
    );
  }
}