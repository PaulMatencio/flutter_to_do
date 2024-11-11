import 'package:flutter/material.dart';

class CreateOrderForm extends StatefulWidget {
  const CreateOrderForm({super.key});

  @override
  CreateOrderFormState createState() => CreateOrderFormState();
}

class CreateOrderFormState extends State<CreateOrderForm> {
  final _formKey = GlobalKey<FormState>();

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    print('initState selectedDate = ${selectedDate.toLocal()}');
  }

  @override
  Widget build(BuildContext context) {
    print('build prepare selectedDate: ${selectedDate.toLocal()}');

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  //initialValue: "${selectedDate.toLocal()}",
                  controller:
                      TextEditingController(text: '${selectedDate.toLocal()}'),
                  decoration: InputDecoration(
                      icon: Icon(Icons.event),
                      border: OutlineInputBorder(),
                      labelText: 'Assignment Date & Time',
                      suffixIcon: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.event))),
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                Align(
                  alignment: Alignment.bottomRight,
                  child:
                      ElevatedButton(onPressed: (() {}), child: Text('Submit')),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1970),
            lastDate: DateTime(9999))
        .then((value) {
      if (value != null && value != selectedDate) {
        setState(() {
          selectedDate = value;
          print('New date ${selectedDate.toLocal()}');
        });
      }
    });
  }
}
