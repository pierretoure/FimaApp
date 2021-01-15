import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/core/FimaApi.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

/// A hook to access the redux store's state.api. 
///
/// ### Example
///
/// ```
/// class ServicesScreen extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final services = useApi<List<Service>>((api) => api.services);
///     return ListView(
///       children: api.services.map((_service) => Text(_service.title)).toList(),
///     );
///   }
/// }
/// ```
Output useApi<Output>(Selector<Output> selector) => selector(useStore<AppState>().state.api);

typedef Selector<Output> = Output Function(FimaApi api);
