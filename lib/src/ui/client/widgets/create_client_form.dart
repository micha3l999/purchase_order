import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/client/models/client.dart';
import 'package:purchase_order/src/ui/client/models/create_client_response.dart';
import 'package:purchase_order/src/ui/client/repository/client_repository.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class CreateClientForm extends StatefulWidget {
  const CreateClientForm({Key? key}) : super(key: key);

  @override
  CreateClientFormState createState() => CreateClientFormState();
}

class CreateClientFormState extends State<CreateClientForm> {
  final ClientRepository _repository = ClientRepository();
  late CartModel cartModelProvider;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<TextEditingController> controllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final Map<String, String> _formData = {
    "name": "",
    "identification": "",
    "phone": "",
    "address": "",
    "email": "",
  };

  @override
  void initState() {
    super.initState();

    cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person_add),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Nuevo cliente",
                style: Fonts.title.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "";
              }
            },
            controller: controllerList[0],
            onSaved: (String? value) {
              if (value != null && value.isNotEmpty) {
                _formData["name"] = controllerList[0].value.text;
              }
            },
            decoration: getEditTextDecoration(
                hinText: "Nombre", icon: Icons.drive_file_rename_outline),
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "";
              }
            },
            controller: controllerList[1],
            onSaved: (String? value) {
              if (value != null && value.isNotEmpty) {
                _formData["identification"] = controllerList[1].value.text;
              }
            },
            decoration: getEditTextDecoration(
                hinText: "Cédula de identidad", icon: Icons.person),
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "";
              }
            },
            controller: controllerList[2],
            onSaved: (String? value) {
              if (value != null && value.isNotEmpty) {
                _formData["phone"] = controllerList[2].value.text;
              }
            },
            decoration:
                getEditTextDecoration(hinText: "Teléfono", icon: Icons.phone),
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "";
              }
            },
            controller: controllerList[3],
            onSaved: (String? value) {
              if (value != null && value.isNotEmpty) {
                _formData["address"] = controllerList[3].value.text;
              }
            },
            decoration:
                getEditTextDecoration(hinText: "Dirección", icon: Icons.house),
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "";
              }
            },
            controller: controllerList[4],
            onSaved: (String? value) {
              if (value != null && value.isNotEmpty) {
                _formData["email"] = controllerList[4].value.text;
              }
            },
            decoration:
                getEditTextDecoration(hinText: "Email", icon: Icons.email),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future<bool> createClient() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CreateClientResponse? clientCreated = await _repository.createClient({
        "nombre": _formData["name"]!,
        "ci_ruc": _formData["identification"]!,
        "direccion": _formData["address"]!,
        "telefono": _formData["phone"]!,
        "email": _formData["email"]!,
      });

      if (clientCreated != null) {
        cartModelProvider.client = Client(
            clientCreated.code,
            _formData["name"],
            _formData["address"],
            _formData["phone"],
            _formData["email"],
            _formData["identification"]);
        return true;
      } else {
        Dialogs.informationDialog(context,
            title: "Por favor vuelve a intentarlo");
      }
    } else if (cartModelProvider.client != null) {
      return true;
    }
    return false;
  }

  InputDecoration getEditTextDecoration(
      {required String hinText, required IconData icon}) {
    return InputDecoration(
        border: const UnderlineInputBorder(),
        hintStyle: TextStyle(fontSize: 13),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: blackColor, width: 1.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: blackColor, width: 1),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: blackColor, width: 1),
        ),
        hintText: hinText,
        suffixIcon: Icon(
          icon,
        ));
  }
}
