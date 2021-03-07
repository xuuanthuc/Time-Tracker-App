import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/models/job.dart';
import 'package:time_tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;

  const EditJobPage({Key key, this.database, this.job}) : super(key: key);
  final Job job;
  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  String _name;
  int _rateHour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.job != null){
      _name = widget.job.name;
      _rateHour = widget.job.rateHour;
    }
  }
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
        if(widget.job != null){
          allName.remove(widget.job.name);
        }
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
          final id = widget.job?.id ?? documentIdformCurrentDate();
          final job = Job(id: id,name: _name, rateHour: _rateHour);
          await widget.database.setJobs(job);
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
        title: Text(widget.job == null ? 'Add New Job': 'Edit Job'),
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
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Job hour'),
        initialValue: _rateHour != null ? '$_rateHour' : '',
        keyboardType:

            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _rateHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
