import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../screens/news_details.dart';
import 'news_detail_preview.dart';

class NewsListView extends StatefulWidget {
  final String category;
  const NewsListView({super.key, required this.category});

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  List articles = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasError = false;
  String errorMessage = '';

  final String apiKey = 'cdcbb7ed8c894e238f142782401e7cc2';

  int currentPage = 1;
  final int pageSize = 5;
  bool hasMore = true;
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant NewsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _resetAndFetch();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetAndFetch() {
    currentPage = 1;
    hasMore = true;
    articles.clear();
    fetchNews();
  }

  Future<void> fetchNews({bool isLoadMore = false}) async {
    if (!hasMore && isLoadMore) return;

    if (isLoadMore) {
      setState(() => isLoadingMore = true);
    } else {
      setState(() {
        isLoading = true;
        hasError = false;
      });
    }

    try {
      final dio = Dio();

      final queryParameters = {
        'country': 'us',
        'category': widget.category,
        'page': currentPage.toString(),
        'pageSize': pageSize.toString(),
        'apiKey': apiKey,
      };

      if (searchQuery.isNotEmpty) {
        queryParameters['q'] = searchQuery;
      }

      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: queryParameters,
      );

      final data = response.data;

      if (response.statusCode == 200 && data['articles'] != null) {
        final fetchedArticles = List.from(data['articles']);

        setState(() {
          if (isLoadMore) {
            for (var article in fetchedArticles) {
              if (!articles.any((a) => a['title'] == article['title'])) {
                articles.add(article);
              }
            }
            isLoadingMore = false;
          } else {
            articles = fetchedArticles;
            isLoading = false;
          }

          currentPage++;
          hasMore = fetchedArticles.length == pageSize;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
        hasError = true;
        errorMessage = 'حدث خطأ أثناء تحميل الأخبار.';
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore &&
        hasMore &&
        !isLoading) {
      fetchNews(isLoadMore: true);
    }
  }

  Future<void> _onRefresh() async {
    _resetAndFetch();
  }

  void _onSearchChanged(String value) {
    searchQuery = value;
    _resetAndFetch();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError && articles.isEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        // 🔍 Search input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search news...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              )
                  : null,
            ),
          ),
        ),

        // 📰 News list with pull-to-refresh & infinite scroll
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: articles.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == articles.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetails(article: article),
                      ),
                    );
                  },
                  child: NewsDetailPreview(
                    title: article['title'] ?? 'No Title',
                    description: article['description'] ?? 'No Description',
                    imagePath: article['urlToImage'] ??
                        'https://via.placeholder.com/400x200.png?text=No+Image',
                    publishedAt:
                    (article['publishedAt'] ?? '').toString().split('T').first,
                    onReadMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetails(article: article),
                        ),
                      );
                    },
                    article: article,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
