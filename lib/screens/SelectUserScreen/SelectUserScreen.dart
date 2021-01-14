import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

import 'components/UserCard.dart';

class SelectUserScreen extends HookWidget {
    @override
    Widget build(BuildContext context) {
        final users = useSelector<AppState, List<User>>((state) => state.users);
        // useEffect(() {
        //     var isDisposed = false;
        //     final fetchUsers = () async {
        //         final _users = await Api.getUsers();
        //         if (!isDisposed) users.value = _users;
        //     };
        //     fetchUsers();
        //     return () {
        //         isDisposed = true;
        //     };
        // }, []);

        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 46),
            child: CustomScrollView(
                slivers: [
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: buildTitle(),
                        )
                    ),
                    buildUserGrid(users),
                ],
            ),
        );
    }

    SliverGrid buildUserGrid(List<User> users) {
        return SliverGrid.extent(
            maxCrossAxisExtent: 200,
            children: users.map((_user) => UserCard(_user)).toList(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 0,
        );
    }

    Center buildTitle() {
        return Center(
            child: Text(
                'Choisissez votre profil',
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500]
                ),
            ),
        );
    }
}