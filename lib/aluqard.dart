library aluqard;

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AluqardResult {
  bool isLoading = true;
  dynamic result;
  Error error;
  Function refetch;

  AluqardResult();

  AluqardResult.pending(Future<QueryResult> f, Function fetcher) {
    isLoading = true;
    result = null;
    error = null;
    refetch = fetcher;
  }

  AluqardResult.error(Error e, Function fetcher) {
    isLoading = false;
    result = null;
    error = e;
    refetch = fetcher;
  }

  AluqardResult.result(dynamic result, Function fetcher) {
    isLoading = false;
    this.result = result;
    error = null;
    refetch = fetcher;
  }
}

AluqardResult useQuery(BuildContext ctx, String query,
    {GraphQLClient gqlClient, Map<String, dynamic> variables}) {
  final state = useState<AluqardResult>(null);
  final client = gqlClient ?? GraphQLProvider.of(ctx)?.value;

  Function fetcher;
  fetcher = () {
    final future = client
        .query(QueryOptions(document: query, fetchPolicy: FetchPolicy.noCache));
    state.value = AluqardResult.pending(future, fetcher);

    future.then((r) {
      state.value = AluqardResult.result(r.data, fetcher);
    }, onError: (e) {
      state.value = AluqardResult.error(e, fetcher);
    });
  };

  useEffect(() {
    fetcher();

    return () {};
  }, [variables]);

  return state.value;
}
