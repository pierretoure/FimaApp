import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/reducers/UserReducer.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:FimaApp/utils/Api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

void main() async {
    // Load in locale
    // await initializeDateFormatting('fr_FR', null);

    // Initialize state persistor
    final persistor = Persistor<AppState>(
        storage: FlutterStorage(),
        serializer: JsonSerializer<AppState>(AppState.fromJson),
    );

    WidgetsFlutterBinding.ensureInitialized();
    // Load persisted state
    final initialState = await persistor.load();

    // Create store with loaded state
    final store = Store<AppState>(
        userReducer,
        initialState: initialState,
        middleware: [persistor.createMiddleware()],
    );

    // Load users
    final users = await FimaApi.getUsers();
    store.dispatch(SetUsersAction(users));

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
            runApp(FimaAppWithAuthentication(store: store));
        });
}

class FimaAppWithAuthentication extends StatelessWidget {
    final Store<AppState> store;

    const FimaAppWithAuthentication({Key key, this.store}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
                title: 'Fima',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: AuthenticationScreen(),
                localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate
                ],
                supportedLocales: [
                    const Locale('en'),
                    const Locale('fr')
                ],
            ),
        );
    }
}
