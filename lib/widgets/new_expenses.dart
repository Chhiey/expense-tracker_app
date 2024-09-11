import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/widgets.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenses();
  }
}

class _NewExpenses extends State<NewExpenses> {
final _titileController = TextEditingController();
final _amountController = TextEditingController();
DateTime? _selectedDate ;
Category _selectedCetegory = Category.leisure;

void _presentDatePicker() async{
final now = DateTime.now();
final firstDate = DateTime(now.year - 1,now.month ,now.day);
final pickedDate = await showDatePicker(
    context: context,
    initialDate: now, 
    firstDate: firstDate, 
    lastDate: now);
  setState(() {
    _selectedDate = pickedDate;
  });
}

void _showDialog(){
  if(Platform.isAndroid){
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title:const Text('Invalid Input'),
      content:const Text('Please make sure to input the correct title amount date and category'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(ctx);
        }, child: const Text('Okay'),
        ),
      ],
     ),
    );
  }else{
    showCupertinoDialog(context: context, builder: (ctx)=> CupertinoAlertDialog(
    title:const Text('Invalid Input'),
      content:const Text('Please make sure to input the correct title amount date and category'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(ctx);
        }, child: const Text('Okay'),
        ),
      ],
     ),
  );
  }
}

void _summitExpenseData (){
  final enteredAmount = double.tryParse(_amountController.text);
  final amoutIsInvalid = enteredAmount == null || enteredAmount < 0;
  if(_titileController.text.trim().isEmpty || 
      amoutIsInvalid || 
      _selectedDate == null){
     _showDialog();
    return;
  }
  widget.onAddExpense(Expense(
    amount: enteredAmount, 
    date: _selectedDate!, 
    title: _titileController.text, 
    category: _selectedCetegory),
    );
  Navigator.pop(context);
}


@override
  void dispose() {
    _titileController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.fromLTRB(16,16,16,16),
      child: Column(
        children:[
          TextField(
            controller: _titileController,
            maxLength: 50,
            decoration:const InputDecoration(
              label: Text("Title")
            ),
          ),
           Row(
             children: [
              Expanded(child:
               TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration:const InputDecoration(
                  prefixText: "\$",
                  label: Text("Amount")
                ),
                  ),
                ),
              const SizedBox(height: 16,),
              Expanded(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!),),
                  IconButton(
                    onPressed: _presentDatePicker, 
                    icon:const Icon(Icons.calendar_month))
                ],
                ),
              ),
             ], 
           ),
          const SizedBox(height: 16,),
          Row(children: [
            DropdownButton(
              value: _selectedCetegory,
              items: Category.values.map(
              (category) => DropdownMenuItem(
                value: category, 
                child: Text(
                  category.name.toUpperCase(),),),
            ).toList(),
            onChanged: (value){
              if(value == null) {
                return;
              }
              setState(() {
                _selectedCetegory = value;
              });
            }),
            const Spacer(),
            ElevatedButton(onPressed: _summitExpenseData, 
              child:const Text("Save Expense")),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, 
              child:const Text("Cancel"),),
          ],)
        ],
      ),
    );
  }
}