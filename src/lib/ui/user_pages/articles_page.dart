import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/cubit/article_cubit.dart';
import 'package:src/models/article_model.dart';
import 'package:src/ui/user_pages/detail_article_page.dart';
import 'package:src/ui/widgets/article_tile_card.dart';

import '../../shared/theme.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    context.read<ArticleCubit>().fetchArticles();
    super.initState();
  }

  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        toolbarHeight: 70,
        backgroundColor: white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: secondaryColor,
          iconSize: 16,
        ),
        title: Text(
          'Articles',
          style: secondaryColorText.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget articleList(List<ArticleModel> articles) {
      return Container(
          margin: EdgeInsets.only(bottom: 24),
          padding: EdgeInsets.only(top: 4, left: 4, right: 4),
          decoration: BoxDecoration(color: white),
          //height: 269,
          width: 315,
          child: Column(
            children: articles.map((ArticleModel article) {
              return Column(
                children: [ArticleTileCard(article: article)],
              );
            }).toList(),
          ));
    }

    return BlocConsumer<ArticleCubit, ArticleState>(
      listener: (context, state) {
        if (state is ArticleFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: red,
          ));
        }
      },
      builder: (context, state) {
        if (state is ArticleSuccess) {
          return Scaffold(
            appBar: header(),
            body: SingleChildScrollView(
              child: Column(
                children: [Center(child: articleList(state.articles))],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
