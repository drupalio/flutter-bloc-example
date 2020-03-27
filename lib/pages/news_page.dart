import 'package:bloc_example/blocs/news_bloc/news_bloc.dart';
import 'package:bloc_example/blocs/news_bloc/news_events.dart';
import 'package:bloc_example/blocs/news_bloc/news_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnpwa_client/hnpwa_client.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsBloc _newsBloc = NewsBloc();

  @override
  void dispose() {
    _newsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _newsBloc,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              BlocBuilder<NewsBloc, NewsState>(
                builder: (_, state) {
                  print("build list");
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      final FeedItem item = state.news[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.timeAgo),
                        onLongPress: () {
                          _newsBloc.add(DeleteEvent(index));
                        },
                      );
                    },
                    itemCount: state.news.length,
                  );
                },
                condition: (prevState, newState) {
                  return prevState.news.length != newState.news.length;
                },
              ),
              BlocBuilder<NewsBloc, NewsState>(
                builder: (_, state) {
                  print("build loading");
                  if (state.loading) {
                    return Positioned.fill(
                        child: Container(
                      color: Colors.black12,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 15,
                        ),
                      ),
                    ));
                  } else {
                    return Container();
                  }
                },
                condition: (prevState, newState) {
                  return prevState.loading != newState.loading;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
