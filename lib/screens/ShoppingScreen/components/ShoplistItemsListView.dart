import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/HomeScreen/components/UserTag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'UpdateShoplistItemDialog.dart';

class ShoplistItemsListView extends HookWidget {
    const ShoplistItemsListView({
        Key key,
        @required this.controller,
        this.onRefresh,
    }) : super(key: key);

    final ValueNotifier<List<ShoplistItem>> controller;
    final Future<void> Function() onRefresh;

    @override
    Widget build(BuildContext context) {
        final deleteShoplistItem = useApi<Future<void> Function(ShoplistItem)>
            ((api) => (_item) => api.deleteShoplistItem(_item));
        final users = useSelector<AppState, List<User>>((state) => state.users);

        final refreshController = RefreshController();

        return SmartRefresher(
            child: controller.value.length > 0
                ? ListView.separated(
                    itemCount: controller.value.length,
                    itemBuilder: (context, index) {
                        ShoplistItem item = controller.value.elementAt(index);
                        final user = item.username != null
                            ? users.firstWhere((_user) => _user.name.toLowerCase() == item.username.toLowerCase(), orElse: () => null)
                            : null;
                        return ShoplistItemDismissible(
                            item: item, 
                            user: user,
                            onTap: () => 
                                showUpdateShoplistItemDialog(context, item), 
                            onDismissed: (_) => cleanDeleteShoplistItem(deleteShoplistItem, item));
                    },
                    separatorBuilder: (context, index) => Divider(height: 1),
                    padding: EdgeInsets.only(bottom: 96))
                : ListView(
                    children: [
                        EmptyShoplistIndicator(),
                    ],
                    padding: EdgeInsets.all(64),
                ),
            controller: refreshController,
            onRefresh: () async {
                await onRefresh();
                refreshController.refreshCompleted();
            },
            enablePullUp: false,
        );
    }

    void showUpdateShoplistItemDialog(BuildContext context, ShoplistItem item) {
        showDialog(
            context: context,
            child: UpdateShoplistItemDialog(
                item: item,
                onShoplistItemUpdated: (updatedItem) {
                    List<ShoplistItem> updatedShoplistItems = controller.value.map((_item) {
                        if (_item.id == updatedItem.id) return updatedItem;
                        else return _item;
                    }).toList();
                    return controller.value = updatedShoplistItems;
                },
            ),
        );
    }

    void cleanDeleteShoplistItem(Future<void> Function(ShoplistItem) deleteShoplistItem, ShoplistItem item) {
        deleteShoplistItem(item);
        controller.value = controller.value.where((_item) => _item.id != item.id).toList();
    }
}

class EmptyShoplistIndicator extends StatelessWidget {
    const EmptyShoplistIndicator({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: [
                    Icon(
                        Icons.no_food_rounded,
                        size: 128,
                        color: Colors.blueGrey,
                    ),
                    Padding(
                        child: Center(
                            child: Text(
                                'Liste de courses vide',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ),
                        padding: const EdgeInsets.only(top: 32),
                    ),
                    Padding(
                        child: Text(
                            'Commencez par ajouter des produits à votre liste de courses avec le bouton +',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600]
                            ),
                            textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.only(top: 16),
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
            ),
            height: MediaQuery.of(context).size.height - 328, // 100(bottomAppBar ?) + 128(padding 64(top) + 64(bottom)) + 100(to center top)
        );
    }
}

class ShoplistItemDismissible extends StatelessWidget {
    const ShoplistItemDismissible({
        Key key,
        @required this.item,
        @required this.user,
        this.onTap,
        this.onDismissed,
    }) : super(key: key);

    final ShoplistItem item;
    final User user;
    final void Function() onTap;
    final void Function(DismissDirection) onDismissed;

    @override
    Widget build(BuildContext context) {
        return Dismissible(
            key: ValueKey(item.id),
            child: GestureDetector(
                child: Padding(
                    child: ListTile(
                        title: Row(
                            children: [
                                buildLabel(item),
                                buildUserTag(user),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                ),
                onTap: onTap,
            ),
            background: Container(color: Colors.red),
            onDismissed: onDismissed,
        );
    }

    Flexible buildLabel(ShoplistItem item) {
        return Flexible(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700]
                    ),
                    children: <TextSpan>[
                        TextSpan(text: item.product),
                        TextSpan(
                            text: item.quantity != null 
                                ? ' (${item.quantity.replaceAll(' ', '')})' 
                                : '', 
                            style: TextStyle(
                                fontWeight: FontWeight.bold)
                            ),
                    ],
                ),
            ),
        );
    }

    Widget buildUserTag(User user) => user != null
        ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: UserTag(user: user),
            )
        : Container();
}
