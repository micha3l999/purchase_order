import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {Key? key,
      required this.searchFunction,
      this.continuouslySearching = true,
      this.hintText = "Buscar Productos"})
      : super(key: key);

  final void Function(String value) searchFunction;
  final String hintText;
  final bool continuouslySearching;

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final TextEditingController _textEditingController = TextEditingController();
  ValueNotifier<bool> _showSearchIcon = ValueNotifier(true);
  String? _oldValueSearch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        onChanged: (String value) {
          if (value.isNotEmpty) {
            _showSearchIcon.value = false;
          } else {
            _showSearchIcon.value = true;
          }

          if (_oldValueSearch != value &&
              value != "" &&
              widget.continuouslySearching) {
            widget.searchFunction(value);
          }
          _oldValueSearch = value;
        },
        controller: _textEditingController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.blueGrey)),
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 13),
            hintText: widget.hintText,
            suffixIcon: ValueListenableBuilder(
                valueListenable: _showSearchIcon,
                builder: (_, __, ___) {
                  return IconButton(
                    icon: AnimatedSwitcher(
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _showSearchIcon.value
                          ? const Icon(
                              Icons.search,
                              key: ValueKey<int>(0),
                              color: Colors.blueGrey,
                            )
                          : const Icon(
                              Icons.close,
                              key: ValueKey<int>(1),
                              color: Colors.blueGrey,
                            ),
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                    ),
                    onPressed: () {
                      if (!_showSearchIcon.value) {
                        _textEditingController.text = "";
                        _showSearchIcon.value = true;
                        if (widget.continuouslySearching) {
                          widget.searchFunction(
                              _textEditingController.value.text);
                        }
                      }
                    },
                  );
                })),
      ),
    );
  }

  String get valueText => _textEditingController.value.text;
}
