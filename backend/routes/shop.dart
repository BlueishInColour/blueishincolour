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
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getOneGood(RequestContext context) async {
  final short = await context.read<Db>().collection('good').findOne(['id']);
  return Response.json(body: short.toString());
}

Future<Response> _getGood(RequestContext context) async {
  final short = await context.read<Db>().collection('good').find().toList();
  return Response.json(body: short);
}

Future<Response> _createGood(RequestContext context) async {
  final goodJson = await context.request.json() as Map<String, dynamic>;
  //can manipulate the data
  final res = await context.read<Db>().collection('good').insertOne(goodJson);

  return Response.json(body: {'id': res.id});
}
