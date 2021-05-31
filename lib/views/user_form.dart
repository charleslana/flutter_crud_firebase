import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    _formData['id'] = user.id;
    _formData['name'] = user.name;
    _formData['email'] = user.email;
    _formData['avatarUrl'] = user.avatarUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = ModalRoute.of(context)!.settings.arguments;

    if (user != null) {
      _loadFormData(user as User);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Formulário de Usuário'),
        actions: [
          IconButton(
            onPressed: () async {
              final isValid = _form.currentState!.validate();
              if (isValid) {
                if (_formData['id'] == null) {
                  _formData['id'] = '';
                }
                _form.currentState!.save();

                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'] as String,
                    name: _formData['name'] as String,
                    email: _formData['email'] as String,
                    avatarUrl: _formData['avatarUrl'] as String,
                  ),
                );

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _formData['name'],
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome inválido';
                        }

                        if (value.trim().length < 3) {
                          return 'Nome muito pequeno. No minímo 3 caracteres.';
                        }

                        return null;
                      },
                      onSaved: (value) => _formData['name'] = value!,
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email inválido';
                        }

                        if (!EmailValidator.validate(value)) {
                          return 'Digite um email válido';
                        }

                        return null;
                      },
                      onSaved: (value) => _formData['email'] = value!,
                    ),
                    TextFormField(
                      initialValue: _formData['avatarUrl'],
                      decoration: InputDecoration(labelText: 'URL do Avatar'),
                      validator: (value) {
                        if (value != null &&
                            value != '' &&
                            !Uri.parse(value).isAbsolute) {
                          return 'Digite uma url válida';
                        }

                        return null;
                      },
                      onSaved: (value) => _formData['avatarUrl'] = value!,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
