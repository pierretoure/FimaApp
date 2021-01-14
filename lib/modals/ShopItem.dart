import 'package:flutter/material.dart';

class ShopItem {
    final String id;
    final String product;
    final String username;
    final String quantity;

    const ShopItem({
        @required this.id,
        @required this.product,
        this.username,
        this.quantity
    });

    // !!!
    static ShopItem fromJson(json) => ShopItem(
        id: json['id'] != null ? json['id'] : 'unknow id',
        product: json['produit'] != null ? json['produit'] : 'non renseigné',
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