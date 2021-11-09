import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/models/product_selected.dart';
import 'package:share_plus/share_plus.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/no_scroll_behavior.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/global_widgets/search_bar.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/client/models/client.dart';
import 'package:purchase_order/src/ui/client/models/create_order_response.dart';
import 'package:purchase_order/src/ui/client/repository/client_repository.dart';
import 'package:purchase_order/src/ui/client/widgets/checkbox_final_consumer.dart';
import 'package:purchase_order/src/ui/client/widgets/create_client_form.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ClientPage extends StatefulWidget {
  const ClientPage({Key? key}) : super(key: key);

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final ClientRepository _repository = ClientRepository();
  final GlobalKey<SearchBarState> _searchBarKey = GlobalKey();
  final GlobalKey<CreateClientFormState> _createClientFormKey = GlobalKey();
  final GlobalKey<FinalConsumerCheckBoxState> _finalConsumerKey = GlobalKey();
  late CartModel _cartModelProvider;

  final ValueNotifier<Client?> _client = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final TextEditingController _controllerObservation = TextEditingController();
  String? _clientCode;

  @override
  void initState() {
    super.initState();

    _cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  @override
  void dispose() {
    _loading.dispose();
    _client.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode focusNode = FocusScope.of(context);
        if (!focusNode.hasPrimaryFocus && focusNode.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: primaryColor,
              label: const Text("Crear pedido"),
              icon: const Icon(Icons.done),
              onPressed: () async {
                createOrder();
              },
            ),
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: const Text("XIAO"),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: ScrollConfiguration(
                behavior: NoScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Spacer(),
                          const Icon(Icons.person),
                          const SizedBox(width: 8),
                          Text("Agregar cliente a la nota de pedido",
                              style: Fonts.title.copyWith(fontSize: 20)),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SearchBar(
                        key: _searchBarKey,
                        continuouslySearching: false,
                        searchFunction: (String value) {},
                        hintText: "Cédula de identidad",
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        children: [
                          PrimaryButton(
                              title: Row(
                                children: const [
                                  Text("Buscar cliente"),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.person_search,
                                    size: 20,
                                  ),
                                ],
                              ),
                              onTap: searchClient),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: _client,
                        builder: (_, Client? value, Widget? child) {
                          if (value != null) {
                            return showClientInformation();
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      CreateClientForm(
                        key: _createClientFormKey,
                      ),
                      const SizedBox(height: 12),
                      FinalConsumerCheckBox(
                        key: _finalConsumerKey,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const MyIconProforma(),
                          const SizedBox(width: 8),
                          Text(
                            "Proforma",
                            style: Fonts.title.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        maxLines: null,
                        maxLength: 330,
                        controller: _controllerObservation,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _controllerObservation.clear();
                              },
                            ),
                            labelText: "Observaciones",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          PrimaryButton(
                            title: Row(
                              children: const [
                                Text("Compartir proforma"),
                                const SizedBox(width: 5),
                                Icon(Icons.share),
                              ],
                            ),
                            onTap: () async {
                              String? proformaCreatedCode =
                                  await createProforma();
                              if (proformaCreatedCode != null) {
                                shareProforma(proformaCreatedCode);
                              }
                              //shareProforma("1");
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, bool value, child) {
                if (value) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }

  // Search client by the identification
  Future<void> searchClient() async {
    String identification = _searchBarKey.currentState!.valueText;

    _client.value = await _repository.searchClient(identification);

    if (_client.value != null) {
      _cartModelProvider.client = _client.value!;
      _cartModelProvider.client!.identification = identification;
    } else {
      Dialogs.informationDialog(context,
          title:
              "No se encontró un cliente con la identificación proporcionada");
      _cartModelProvider.client = null;
    }
  }

  // Show client information after search him
  Widget showClientInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nombre: " +
                    (_client.value!.name!.isNotEmpty
                        ? _client.value!.name!
                        : "N/A"),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Celular: " +
                  (_client.value!.telephone!.isNotEmpty
                      ? _client.value!.telephone!
                      : "N/A")),
              const SizedBox(
                height: 10,
              ),
              Text("Dirección: " +
                  (_client.value!.address!.isNotEmpty
                      ? _client.value!.address!
                      : "N/A")),
              const SizedBox(
                height: 10,
              ),
              Text("Correo Electrónico: " +
                  (_client.value!.email!.isNotEmpty
                      ? _client.value!.email!
                      : "N/A")),
            ],
          ),
        ],
      ),
    );
  }

  // Create order and validate the client
  Future<void> createOrder() async {
    _loading.value = true;
    bool clientAdded = false;
    if (_finalConsumerKey.currentState!.checkboxValue.value) {
      if (_cartModelProvider.totalPrice >= 200) {
        Dialogs.informationDialog(context,
            title:
                "No se puede crear como consumidor final porque la orden supera los \$200");
        _loading.value = false;
        return;
      }
      _cartModelProvider.client = Client("1", "Consumidor Final");
      clientAdded = true;
    } else {
      clientAdded = await _createClientFormKey.currentState!.createClient();
    }

    if (clientAdded) {
      CreateOrderResponse? createOrderResponse =
          await _repository.createPurchaseOrder(
              _cartModelProvider.client!.code!, _cartModelProvider.products);
      //_searchBarKey.currentState!.build(context);

      if (createOrderResponse != null) {
        _loading.value = false;
        _repository.printOrderTicker(_cartModelProvider.client!.name!,
            _cartModelProvider.products, createOrderResponse.code);
        String orderCodeCreated = createOrderResponse.code;

        await Dialogs.informationDialog(context,
            title: "Orden de compra N° $orderCodeCreated creada");
        _cartModelProvider.removeAll();
        _cartModelProvider.clearClient();

        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home, (Route<dynamic> route) => false);
      } else {
        _loading.value = false;
        Dialogs.informationDialog(context,
            title: "Por favor vuelva a intentarlo");
      }
      _loading.value = false;
    } else {
      _loading.value = false;
      Dialogs.informationDialog(context, title: "Añade un cliente a la orden");
    }
  }

  // Generate and share the proforma in pdf
  Future<void> shareProforma(String orderNumber) async {
    pw.Document pdf = pw.Document();

    List futures = await Future.wait([
      getTemporaryDirectory(),
      rootBundle.load('assets/images/xiao_logo.jpg')
    ]);
    final output = futures[0];
    ByteData imageLogoBytes = futures[1];
    final imageLogoPdf = imageLogoBytes.buffer.asUint8List();

    pdf.addPage(pw.MultiPage(
      margin: const pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return <pw.Widget>[
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(
                  height: 220,
                  child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Column(children: [
                            pw.Container(
                              padding: pw.EdgeInsets.only(right: 70),
                              alignment: pw.Alignment.centerLeft,
                              height: 80,
                              child: pw.Image(
                                pw.MemoryImage(imageLogoPdf),
                                fit: pw.BoxFit.fitHeight,
                              ),
                            ),
                            pw.Container(
                              color: const PdfColor.fromInt(0xFFF8F8F8),
                              padding: pw.EdgeInsets.all(9),
                              margin: pw.EdgeInsets.only(right: 5),
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    richTextPdf(
                                        "Nombre Comercial:", "XIAO ENTERPRISE"),
                                    richTextPdf("Razón Social: ",
                                        "XIAO ENTERPRISE C.LTDA."),
                                    richTextPdf("RUC/CI: ", "0993111686001"),
                                    richTextPdf("Dirección: ",
                                        "Guayas / Durán / CDLA 12 de Noviembre MZ G Solar 11B"),
                                    richTextPdf("Correo: ",
                                        "contabilidad@xioenterprise.com"),
                                    richTextPdf(
                                        "Teléfono: ", "042320114 / 04613170"),
                                  ]),
                              height: 140,
                            ),
                          ]),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                  margin: pw.EdgeInsets.only(left: 5),
                                  width: double.infinity,
                                  color: const PdfColor.fromInt(0xFFF8F8F8),
                                  height: 15),
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 3),
                                child: pw.Row(children: [
                                  pw.Text(
                                    "COTIZACIÓN:",
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Spacer(),
                                  pw.Text(
                                    "No. $orderNumber",
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  )
                                ]),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  margin: pw.EdgeInsets.only(left: 5),
                                  padding: pw.EdgeInsets.all(9),
                                  width: double.infinity,
                                  color: const PdfColor.fromInt(0xFFF8F8F8),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      titleBoldPdf("Cliente:"),
                                      bodyNormalPdf(
                                          _cartModelProvider.client?.name ??
                                              "N/A"),
                                      titleBoldPdf("CI/RUC:"),
                                      bodyNormalPdf(_cartModelProvider
                                              .client?.identification ??
                                          "N/A"),
                                      titleBoldPdf("Dirección:"),
                                      bodyNormalPdf(
                                          _cartModelProvider.client?.address ??
                                              "N/A"),
                                      titleBoldPdf("Teléfono:"),
                                      bodyNormalPdf(_cartModelProvider
                                              .client?.telephone ??
                                          "N/A"),
                                      titleBoldPdf("Fecha Emisión:"),
                                      bodyNormalPdf(getCurrentTime()),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  children: [
                    headerProductPdf("#", 32),
                    pw.Container(
                      width: 2,
                      color: const PdfColor.fromInt(0xFFF8F8F8),
                    ),
                    headerProductPdf("Item", 159),
                    pw.Container(
                      width: 2,
                      color: const PdfColor.fromInt(0xFFF8F8F8),
                    ),
                    headerProductPdf("Descripción", 159),
                    pw.Container(
                      width: 2,
                      color: const PdfColor.fromInt(0xFFF8F8F8),
                    ),
                    headerProductPdf("Cantidad", 65),
                    pw.Container(
                      width: 2,
                      color: const PdfColor.fromInt(0xFFF8F8F8),
                    ),
                    headerProductPdf("Precio", 72),
                    pw.Container(
                      width: 2,
                      color: const PdfColor.fromInt(0xFFF8F8F8),
                    ),
                    headerProductPdf("Subtotal", 78),
                  ],
                ),
                pw.SizedBox(height: 4),
                ...productsWidget(),
                pw.SizedBox(height: 25),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        color: const PdfColor.fromInt(0xFFF8F8F8),
                        padding: pw.EdgeInsets.all(8),
                        margin: pw.EdgeInsets.only(right: 5),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              richTextPdf(
                                  "Observación: ",
                                  _controllerObservation.value.text.isEmpty
                                      ? "N/A"
                                      : _controllerObservation.value.text),
                            ]),
                        height: 124,
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 5),
                            child: pw.Row(children: [
                              pw.Expanded(
                                child: pw.Container(
                                  margin: const pw.EdgeInsets.only(right: 2.5),
                                  child: pw.Column(
                                    children: [
                                      fieldsTotalPrices(textTotalPrices(
                                          "Descuento: ",
                                          bold: true)),
                                      fieldsTotalPrices(textTotalPrices(
                                          "Subtotal 12%: ",
                                          bold: true)),
                                      fieldsTotalPrices(textTotalPrices(
                                          "Subtotal 0%: ",
                                          bold: true)),
                                      fieldsTotalPrices(
                                          textTotalPrices("IVA: ", bold: true)),
                                      fieldsTotalPrices(textTotalPrices(
                                          "Total: ",
                                          bold: true)),
                                      fieldsTotalPrices(textTotalPrices(
                                          "Saldo: ",
                                          bold: true)),
                                    ],
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  margin: const pw.EdgeInsets.only(left: 2.5),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.end,
                                    children: [
                                      bodyTotalPrices(
                                        textTotalPrices("\$0.00 "),
                                      ),
                                      bodyTotalPrices(
                                        textTotalPrices(
                                            "\$${getSubtotalPriceOrder()}"),
                                      ),
                                      bodyTotalPrices(
                                        textTotalPrices("\$0.00"),
                                      ),
                                      bodyTotalPrices(
                                        textTotalPrices(
                                            "\$${getSubtotalIVAOrder()}"),
                                      ),
                                      bodyTotalPrices(
                                        textTotalPrices(
                                            "\$${_cartModelProvider.totalPrice.toStringAsFixed(2)}"),
                                      ),
                                      bodyTotalPrices(
                                        textTotalPrices(
                                            "\$${_cartModelProvider.totalPrice.toStringAsFixed(2)}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]))),
                  ],
                ),
                pw.SizedBox(height: 50),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child:
                      pw.Text("Atentamente.", style: pw.TextStyle(fontSize: 9)),
                ),
              ]),
        ];
      },
    ));

    final file = File("${output.path}/Proforma.pdf");

    await file.writeAsBytes(await pdf.save());
    Share.shareFiles(["${output.path}/Proforma.pdf"], text: "Proforma");
  }

  // Get the products table
  List<pw.Widget> productsWidget() {
    List<pw.Widget> productsList = [];
    for (int i = 0; i < _cartModelProvider.products.length; i++) {
      productsList.add(productRowPdf(_cartModelProvider.products[i], (i + 1)));
    }
    return productsList;
  }

  // a row of the products table
  pw.Widget productRowPdf(ProductSelected product, int itemNumber) {
    return pw.Container(
      color: const PdfColor.fromInt(0xFFF8F8F8),
      margin: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          productFieldPdf(itemNumber.toString(), 32),
          pw.Container(
              width: 2,
              child: pw.Expanded(
                  child: pw.Container(
                width: 1,
                color: const PdfColor.fromInt(0xFFCFA833),
              ))),
          productFieldPdf(product.description!, 159),
          pw.Container(
              width: 2,
              child: pw.Expanded(
                  child: pw.Container(
                width: 1,
                color: const PdfColor.fromInt(0xFFCFA833),
              ))),
          productFieldPdf(product.description!, 159),
          pw.Container(
              width: 2,
              child: pw.Expanded(
                  child: pw.Container(
                width: 1,
                color: const PdfColor.fromInt(0xFFCFA833),
              ))),
          productFieldQuantityPdf(product.quantity!, 65),
          pw.Container(
              width: 2,
              child: pw.Expanded(
                  child: pw.Container(
                width: 1,
                color: const PdfColor.fromInt(0xFFCFA833),
              ))),
          productFieldPricePdf(product.price!, 72),
          pw.Container(
              width: 2,
              child: pw.Expanded(
                  child: pw.Container(
                width: 1,
                color: const PdfColor.fromInt(0xFFCFA833),
              ))),
          productFieldPricePdf(
              getSubtotalPrice(product.price!, product.quantity!), 78),
        ],
      ),
    );
  }

  // a normal cell of the products table
  pw.Widget productFieldPdf(String text, double width) {
    return pw.Container(
      alignment: pw.Alignment.center,
      width: width,
      child: pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  // a cell of the products table for price
  pw.Widget productFieldPricePdf(String text, double width) {
    return pw.Container(
      alignment: pw.Alignment.center,
      width: width,
      child: pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: pw.Text(
          "\$" + text,
          style: pw.TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  // a cell of the products table for quantity
  pw.Widget productFieldQuantityPdf(String text, double width) {
    return pw.Container(
      alignment: pw.Alignment.center,
      width: width,
      child: pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: pw.Text(
          text + " Unid.",
          style: pw.TextStyle(fontSize: 9),
        ),
      ),
    );
  }

  // rich text for text in a single line
  richTextPdf(String title, String body) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.RichText(
          text: pw.TextSpan(
        text: title,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        children: [
          pw.TextSpan(
            text: body,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ],
      )),
    );
  }

  // text and style of title text
  titleBoldPdf(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  // text and style of normal text
  bodyNormalPdf(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 9)),
    );
  }

  // header of products table
  pw.Widget headerProductPdf(String textHeader, double widthHeader) {
    return pw.Container(
      alignment: pw.Alignment.center,
      width: widthHeader,
      color: const PdfColor.fromInt(0xFFEFEFEF),
      child: titleBoldPdf(textHeader),
    );
  }

  // get the current day time
  String getCurrentTime() {
    DateTime currentTime = DateTime.now();
    return "${currentTime.day.toString()}/${currentTime.month.toString()}/${currentTime.year.toString()}";
  }

  Future<String?> createProforma() async {
    _loading.value = true;
    bool clientAdded = false;
    //_cartModelProvider.client = null;
    if (_finalConsumerKey.currentState!.checkboxValue.value) {
      if (_cartModelProvider.totalPrice >= 200) {
        Dialogs.informationDialog(context,
            title:
                "No se puede crear como consumidor final porque la orden supera los \$200");
        _loading.value = false;

        return null;
      }
      _cartModelProvider.client = Client("1", "Consumidor Final");
      clientAdded = true;
    } else {
      clientAdded = await _createClientFormKey.currentState!.createClient();
    }

    if (clientAdded) {
      CreateOrderResponse? createOrderResponse = await _repository.saveProforma(
          _cartModelProvider.client!.code!, _cartModelProvider.products);

      if (createOrderResponse != null) {
        _loading.value = false;
        return createOrderResponse.code;
      } else {
        Dialogs.informationDialog(context,
            title: "Por favor vuelva a intentarlo");
      }
      _loading.value = false;
      return null;
    } else {
      _loading.value = false;
      Dialogs.informationDialog(context, title: "Añade un cliente a la orden");
      return null;
    }
  }

  // calculate subtotal of one product, multiplies quantity by unit price
  String getSubtotalPrice(String price, String quantity) {
    return (double.parse(price) * int.parse(quantity)).toStringAsFixed(2);
  }

  // calculate the subtotal of the total order
  String getSubtotalPriceOrder() {
    double subtotalOrder = (_cartModelProvider.totalPrice -
        (_cartModelProvider.totalPrice * 0.12));
    return subtotalOrder.toStringAsFixed(2);
  }

  // calculate the subtotal IVA of the total order
  String getSubtotalIVAOrder() {
    return (_cartModelProvider.totalPrice * 0.12).toStringAsFixed(2);
  }

  // fields of total prices proforma
  pw.Widget fieldsTotalPrices(dynamic child) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      margin: const pw.EdgeInsets.only(bottom: 2),
      color: const PdfColor.fromInt(0xFFF8F8F8),
      alignment: pw.Alignment.centerLeft,
      width: double.infinity,
      child: child,
    );
  }

  // Body of total prices order
  pw.Widget bodyTotalPrices(dynamic child) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(bottom: 2),
      color: const PdfColor.fromInt(0xFFF8F8F8),
      width: double.infinity,
      child: child,
    );
  }

  // Text and style for total prices text
  pw.Widget textTotalPrices(String text, {bool bold = false}) {
    return pw.Text(
      text,
      style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
    );
  }
}
