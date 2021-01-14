import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShopItem.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class UpdateShoplistItemDialog extends HookWidget {
    const UpdateShoplistItemDialog({
        Key key,
        @required this.item,
        this.onShoplistItemWillBeUpdated,
        this.onShoplistItemUpdated,
    }) : super(key: key);

    final ShopItem item;
    final void Function(ShopItem toBeUpdatedItem) onShoplistItemWillBeUpdated;
    final void Function(ShopItem updatedItem) onShoplistItemUpdated;

    @override
    Widget build(BuildContext context) {
        final updateShoplistItem = useApi<Future<ShopItem> Function(ShopItem)>
            ((api) => (_item) => api.updateShoplistItem(_item));
        final user = useSelector<AppState, User>((state) => state.user);
        
        final productNameController = useTextEditingController(text: item.product);
        final quantityController = useTextEditingController(text: item.quantity);

        return AlertDialog(
            title: Text(
                'Modifier un produit',
                style: TextStyle(
                    color: Colors.grey[700],
                ),
            ),
            content: Column(
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
            ),
            actions: [
                FlatButton(
                    child: Text(
                        'Annuler',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: Text(
                        'Sauvegarder',
                        style: TextStyle(
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () async {
                        final toBeUpdatedItem = ShopItem(
                            id: item.id,
                            product: productNameController.value.text,
                            quantity: quantityController.value.text,
                            username: user.name,
                        );
                        if (onShoplistItemWillBeUpdated != null) 
                            onShoplistItemWillBeUpdated(toBeUpdatedItem);
                        final updatedItem = await updateShoplistItem(toBeUpdatedItem);
                        if(onShoplistItemUpdated != null) 
                            onShoplistItemUpdated(updatedItem);
                        Navigator.of(context).pop();
                    },
                ),
            ],
        );
    }
}
