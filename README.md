# Aluqard - a Hooks-based client for GraphQL

Aluqard is a library for [Flutter Hooks](https://github.com/rrousselGit/flutter_hooks)-based apps to use GraphQL, heavily based on [Draqula](https://github.com/vadimdemedes/draqula).

### A compelling example

```dart
const CONTINENT_LIST_QUERY = r'''
query {
  continents {
    name
  }
}
''';

class ContinentsWidget extends HookWidget {
  final client = GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri: 'https://countries.trevorblades.com'));

  @override
  Widget build(BuildContext context) {
    final continentList = useQuery(context, CONTINENT_LIST_QUERY, gqlClient: client);

    if (continentList.isLoading) {
      return Text("Loading!");
    }

    return ListView(
      children: continentList.data['continents'].map(c => Text(c['name']));
    )
  }
}
```

### License

Aluqard is free to use for non-commercial projects, and is free to use for a 30-day trial in commercial software. If you would like to use this library in a commercial product, please contact the author at anais@anaisbetts.org to negotiate a license.
