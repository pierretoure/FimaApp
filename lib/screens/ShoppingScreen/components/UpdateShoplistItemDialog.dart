import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/widgets/FimaDialog/FimaDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

import 'ShoplistItemDialogContent.dart';

class UpdateShoplistItemDialog extends HookWidget {
    const UpdateShoplistItemDialog({
        Key key,
        @required this.item,
        this.onShoplistItemWillBeUpdated,
        this.onShoplistItemUpdated,
    }) : super(key: key);

    final ShoplistItem item;
    final void Function(ShoplistItem toBeUpdatedItem) onShoplistItemWillBeUpdated;
    final void Function(ShoplistItem updatedItem) onShoplistItemUpdated;

    @override
    Widget build(BuildContext context) {
        final updateShoplistItem = useApi<Future<ShoplistItem> Function(ShoplistItem)>
            ((api) => (_item) => api.updateShoplistItem(_item));
        final user = useSelector<AppState, User>((state) => state.user);
        
        final productNameController = useTextEditingController(text: item.product);
        final quantityController = useTextEditingController(text: item.quantity);
        
        return FimaDialog(
            title: 'Modifier un produit',
            content: ShoplistItemDialogContent(
                productNameController: productNameController,
                quantityController: quantityController,
            ),
            validButtonTitle: 'Sauvegarder',
            onValidButtonPressedAsync: () async {
                final toBeUpdatedItem = ShoplistItem(
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
            },
        );
    }
}
