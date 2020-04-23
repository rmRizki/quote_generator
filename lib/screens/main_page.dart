import 'package:flutter/material.dart';
import 'package:quote_generator/models/quote.dart';
import 'package:quote_generator/services/quote_api.dart';
import 'package:share/share.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  QuoteApi quoteApi = QuoteApi();
  Future<Quote> futureQuote;
  String quote, author;
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: futureQuote,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    quote = snapshot.data.content;
                    author = snapshot.data.author;
                    return Column(
                      children: <Widget>[
                        Text(
                          "\"$quote\"",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "-- $author --",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Text('');
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        futureQuote = quoteApi.fetchRandomQuote();
                        setState(() {
                          opacity = 1.0;
                        });
                      });
                    },
                    child: Text('Get Quote'),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: opacity,
                    child: RaisedButton(
                      onPressed: () {
                        if (quote.length != 0) {
                          Share.share("\"$quote\"\n-$author");
                        }
                      },
                      child: Text('Share'),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
