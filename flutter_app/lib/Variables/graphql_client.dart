import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink =
    HttpLink('https://hasura-skripsi-binus.herokuapp.com/v1/graphql');

final AuthLink authLink = AuthLink(
  headerKey: 'x-hasura-admin-secret',
  getToken: () async => 'mythesis',
  // OR
  // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
);

final Link link = authLink.concat(httpLink);

GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: link,
);

ValueNotifier<GraphQLClient> valueNotifierClient = ValueNotifier(
  GraphQLClient(
    link: link,
    // The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(store: HiveStore()),
  ),
);
