import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:src/cubit/article_cubit.dart';
import 'package:src/cubit/auth_cubit.dart';
import 'package:src/cubit/consultant_cubit.dart';
import 'package:src/models/article_model.dart';
import 'package:src/services/time_converter.dart';
import 'package:src/shared/theme.dart';
import 'package:src/ui/user_pages/articles_page.dart';
import 'package:src/ui/user_pages/consult_room_page.dart';
import 'package:src/ui/user_pages/course_videos_page.dart';
import 'package:src/ui/user_pages/detail_article_page.dart';
import 'package:src/ui/user_pages/detail_journey_page.dart';
import 'package:src/ui/user_pages/journey_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header(String name, String photoUrl) {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          right: defaultMargin,
          left: defaultMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey there,\nwelcome back',
                    style: secondaryColorText.copyWith(
                      fontWeight: medium,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    name,
                    style: primaryColorText.copyWith(
                      fontWeight: medium,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: photoUrl.isEmpty
                    ? const DecorationImage(
                        image: AssetImage('assets/profile_image_default.png'),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      );
    }

    Widget quotes() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: defaultMargin),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(
            defaultRadius,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '“Mental health is not a destination, it\'s a process. It\'s about how you drive, not where you\'re going”',
                style: secondaryColorText,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Image.asset(
              'assets/quote_icon.png',
              width: 24,
            )
          ],
        ),
      );
    }

    Widget newArticleCard(ArticleModel article) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailArticlePage(article: article),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(
            right: defaultMargin,
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Container(
                  width: 200,
                  height: 250,
                  color: white,
                  child: Container(
                    margin: const EdgeInsets.only(top: 130),
                    color: primaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      child: Image.network(
                        article.thumbnail,
                        width: 184,
                        height: 139,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ConvertTime().convertToAgo(article.date),
                      style: secondaryColorText.copyWith(fontSize: 8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.author,
                      style: secondaryColorText.copyWith(fontSize: 8),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            article.title,
                            style: whiteText.copyWith(
                                fontWeight: semibold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget newArticles() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: defaultMargin,
              left: defaultMargin,
              bottom: 8,
            ),
            child: Text(
              'New Articles',
              style: secondaryColorText.copyWith(
                fontWeight: semibold,
                fontSize: 16,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<ArticleCubit, ArticleState>(
              builder: (context, state) {
                if (state is ArticleSuccess) {
                  List<ArticleModel> articles = state.articles;
                  articles.sort(
                    (b, a) => a.date.compareTo(b.date),
                  );
                  articles = articles.getRange(0, 3).toList();
                  return Container(
                    margin: EdgeInsets.only(left: defaultMargin),
                    child: Row(
                        children:
                            articles.map((e) => newArticleCard(e)).toList()),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      );
    }

    Widget feature(Color color, String iconAssets, String text1, String text2,
        Function() onPressed) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(
            top: 24,
            left: defaultMargin,
            right: defaultMargin,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          height: 92,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Row(
            children: [
              Image.asset(
                iconAssets,
                width: 44,
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text1,
                    style: whiteText.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  Text(
                    text2,
                    style: whiteText.copyWith(
                      fontWeight: semibold,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Scaffold(
            backgroundColor: white2,
            body: SafeArea(
              child: ListView(
                children: [
                  header(state.user.name, state.user.photoUrl),
                  quotes(),
                  newArticles(),
                  feature(secondaryColor, 'assets/consult_room_icon.png',
                      'Meet Our Professionals', 'Consult Room', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsultRoomPage()));
                  }),
                  feature(tosca, 'assets/journey_icon.png', 'Let\'s Write Your',
                      'Journey', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JourneyPage(
                                  user_id: state.user.id,
                                )));
                  }),
                  feature(primaryColor, 'assets/article_icon.png',
                      'Open Your Mind', 'See More Articles', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticlesPage()));
                  }),
                  feature(red, 'assets/course_video_icon.png',
                      'Look New Insights', 'Take Course Videos', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourseVideosPage()));
                  }),
                  const SizedBox(height: 50)
                ],
              ),
            ),
          );
        } else {
          print(state);
          return SizedBox();
        }
      },
    );
  }
}
