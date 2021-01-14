import 'package:flutter/material.dart';

class ShoplistItemDialogContent extends StatelessWidget {

    const ShoplistItemDialogContent({
        @required this.productNameController,
        @required this.quantityController,
    });

    final TextEditingController productNameController;
    final TextEditingController quantityController;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                TextField(
                    controller: productNameController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Produit'
                    ),
                ),
                TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                        labelText: 'Quantité'
                    ),
                ),
            ],
            mainAxisSize: MainAxisSize.min,
        );
    }
}