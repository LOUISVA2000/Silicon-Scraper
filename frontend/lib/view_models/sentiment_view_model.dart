import 'package:silicon_scraper/injectors/sentiment_service_injector.dart';
import 'package:silicon_scraper/models/sentiment_model.dart';
import 'package:silicon_scraper/views/widgets/sentiment_widget.dart';

class SentimentViewModel
{
  SentimentInjector injector= SentimentInjector();
  List <SentimentWidget> sentiments=[];

  Future getSentiment()async
  {
    var json=await injector.dependency.SentimentRequest("", "");
    for(int i=0;i<json.length;i++)
    {
      sentiments.add(SentimentWidget(Sentiment.fromJSON(json[i])));
    }
    return true;
  }

}