import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/models/job.dart';
import 'package:time_tracker_app/services/database.dart';

class AddJobPage extends StatefulWidget {
  final Database database;

  const AddJobPage({Key key, this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => AddJobPage(
        database: database,
      ),
    ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  String _name;
  int _rateHour;
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //TODO: Validate & Save form
    if (_validateAndSaveForm()) {
      //TODO: submit data to Firestore
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((e) => e.name).toList();
        if (allName.contains(_name)) {
          showDialog(
              context: (context),
              builder: (context) => AlertDialog(
                    title: Text('Name already used'),
                    content: Text('Please choose a different job name'),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
                    ],
                  ));
        } else {
          final job = Job(name: _name, rateHour: _rateHour);
          await widget.database.createJobs(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (error) {
        showDialog(
            context: (context),
            builder: (context) => AlertDialog(
                  title: Text('Operation failed'),
                  content: Text(error.message),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Job'),
        actions: [
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child:
              Padding(padding: const EdgeInsets.all(16.0), child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Job hour'),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _rateHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
