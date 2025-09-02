import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

Padding textFieldCustom(
  String ttl,
  TextEditingController ctrl, {
  bool isPrice = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ttl, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 7),
        SizedBox(
          width: double.infinity, // responsif, tidak fix 300 px
          child: TextFormField(
            controller: ctrl,
            keyboardType: isPrice ? TextInputType.number : TextInputType.text,
            inputFormatters:
                isPrice
                    ? [
                      MoneyInputFormatter(
                        thousandSeparator: ThousandSeparator.Period,
                        mantissaLength: 0,
                      ),
                    ]
                    : null,
            decoration: InputDecoration(
              prefixText: isPrice ? 'Rp ' : null,
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.deepOrange,
                  width: 2,
                ),
              ),
            ),
            validator:
                (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Input tidak boleh kosong!'
                        : null,
          ),
        ),
      ],
    ),
  );
}
