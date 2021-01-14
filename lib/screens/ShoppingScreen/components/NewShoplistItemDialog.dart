import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShopItem.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/utils/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class NewShoplistItemDialog extends HookWidget {
    const NewShoplistItemDialog({
        Key key,
        this.onShoplistItemCreated,
        this.onShoplistItemSubmited,
    }) : super(key: key);

    final void Function(ShopItem item) onShoplistItemCreated;
    final void Function(ShopItem item) onShoplistItemSubmited;

    @override
    Widget build(BuildContext context) {
        final createShoplistItem = useApi<Future<ShopItem> Function(ShopItem)>
            ((api) => (_item) => api.createShoplistItem(_item));
        final user = useSelector<AppState, User>((state) => state.user);
        
        final productNameController = useTextEditingController(text: '');
        final quantityController = useTextEditingController(text: '');

        return AlertDialog(
            title: Text(
                'Ajouter un produit',
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
                        'Ajouter',
                        style: TextStyle(
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () async {
                        final newItem = ShopItem(
                            id: 'WILL_BE_CREATED_BY_AIRTABLE',
                            product: productNameController.value.text,
                            quantity: quantityController.value.text,
                            username: user.name,
                        );
                        if (onShoplistItemSubmited != null) onShoplistItemSubmited(newItem);
                        final createdItem = await createShoplistItem(newItem);
                        if(onShoplistItemCreated != null) onShoplistItemCreated(createdItem);
                        Navigator.of(context).pop();
                    },
                ),
            ],
        );
    }
}
