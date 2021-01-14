import 'package:flutter/material.dart';

class ShoplistItem {
    final String id;
    final String product;
    final String username;
    final String quantity;

    const ShoplistItem({
        @required this.id,
        @required this.product,
        this.username,
        this.quantity
    });

    // !!!
    static ShoplistItem fromJson(json) => ShoplistItem(
        id: json['id'] != null ? json['id'] : 'unknow id',
        product: json['produit'] != null ? json['produit'] : '',
        username: json['utilisateur'],
        quantity: json['quantité']
    );

    // !!!
    dynamic toJson() => {
        'id': id,
        'produit': product,
        'utilisateur': username,
        'quantité': quantity,
    };
}