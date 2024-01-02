import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) {
  //
  final parameters = context.request.uri.queryParameters;

  final id = parameters['id'] ?? '';

  //
  if (id.isNotEmpty) {
    _getOneGood(context);
  }

  return switch (context.request.method) {
    HttpMethod.get => _getGood(context),
    HttpMethod.post => _createGood(context),
    HttpMethod.delete => _deleteGood(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getOneGood(RequestContext context) async {
  final short = await context.read<Db>().collection('cart').findOne(['goodId']);
  return Response.json(body: short.toString());
}

Future<Response> _getGood(RequestContext context) async {
  final short = await context.read<Db>().collection('cart').find().toList();
  return Response.json(body: short);
}

Future<Response> _createGood(RequestContext context) async {
  final cartJson = await context.request.json() as Map<String, dynamic>;
  //can manipulate the data
  final res = await context.read<Db>().collection('cart').insertOne(cartJson);

  return Response.json(body: {'id': res.id});
}

Future<Response> _deleteGood(RequestContext context, String id) async {
  final cartItem = await context.read<Db>().collection('cart').deleteOne([id]);
  return Response();
}
