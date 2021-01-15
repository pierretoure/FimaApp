import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'components/NewShoplistItemDialog.dart';
import 'components/ShoplistItemsListView.dart';

class ShoppingScreen extends HookWidget {
    @override
    Widget build(BuildContext context) {
        final shoplistItemController = useState<List<ShoplistItem>>([]);
        final isLoadingController = useState<bool>(true);
        final getShoplistItems = useApi<Future<List<ShoplistItem>> Function()>
            ((api) => () => api.getShoplistItems());

        useEffect(() {
            bool isDisposed = false;
            final fetchShoplistItems = () async {
                final _shoplistItems = await getShoplistItems();
                if (!isDisposed) {
                    shoplistItemController.value = _shoplistItems;
                    isLoadingController.value = false;
                }
            };
            fetchShoplistItems();
            return () => isDisposed = true;
        }, []);

        return Scaffold(
            body: isLoadingController.value
                ? Center(
                    child: CircularProgressIndicator(),
                )
                : ShoplistItemsListView(
                    controller: shoplistItemController,
                    onRefresh: () async {
                        final _shoplistItems = await getShoplistItems();
                        shoplistItemController.value = _shoplistItems;
                    }),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add_rounded, size: 32),
                onPressed: () => showDialog(
                    context: context,
                    child: NewShoplistItemDialog(
                        onShoplistItemCreated: (item) => 
                            shoplistItemController.value = [...shoplistItemController.value, item],
                    ),
                ),
            ),
            backgroundColor: Color(0xfff5f5f5),
            resizeToAvoidBottomInset: false,
        );
    }
}
