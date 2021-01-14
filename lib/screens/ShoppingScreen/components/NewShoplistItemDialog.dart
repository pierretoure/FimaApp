import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/ShoppingScreen/components/ShoplistItemDialogContent.dart';
import 'package:FimaApp/widgets/Tag/FimaDialog/FimaDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class NewShoplistItemDialog extends HookWidget {
    const NewShoplistItemDialog({
        Key key,
        this.onShoplistItemCreated,
        this.onShoplistItemSubmited,
    }) : super(key: key);

    final void Function(ShoplistItem item) onShoplistItemCreated;
    final void Function(ShoplistItem item) onShoplistItemSubmited;

    @override
    Widget build(BuildContext context) {
        final createShoplistItem = useApi<Future<ShoplistItem> Function(ShoplistItem)>
            ((api) => (_item) => api.createShoplistItem(_item));
        final user = useSelector<AppState, User>((state) => state.user);
        
        final productNameController = useTextEditingController(text: '');
        final quantityController = useTextEditingController(text: '');

        return FimaDialog(
            title: 'Ajouter un produit',
            content: ShoplistItemDialogContent(
                productNameController: productNameController,
                quantityController: quantityController,
            ),
            validButtonTitle: 'Ajouter',
            onValidButtonPressedAsync: () async {
                final newItem = ShoplistItem(
                    id: 'WILL_BE_CREATED_BY_AIRTABLE',
                    product: productNameController.value.text,
                    quantity: quantityController.value.text,
                    username: user.name,
                );
                if (onShoplistItemSubmited != null) onShoplistItemSubmited(newItem);
                final createdItem = await createShoplistItem(newItem);
                if(onShoplistItemCreated != null) onShoplistItemCreated(createdItem);
            },
        );
    }
}
