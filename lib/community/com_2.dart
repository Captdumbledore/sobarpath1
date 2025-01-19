import 'package:flutter/material.dart';
import '../main.dart';
import 'com1.dart';
import 'com_3.dart';
import 'com_4.dart';
import 'package:hive/hive.dart';
import 'models/post.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  late Box<Post> _postsBox;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postsBox = Hive.box<Post>('posts');
  }

  Future<void> _createPost() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_postController.text.isNotEmpty) {
                final post = Post(
                  content: _postController.text,
                  authorName: 'User',
                  location: 'Location',
                );
                _postsBox.add(post);
                _postController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = _postsBox.values.toList().reversed.toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Communities Header
            const SizedBox(height: 40),
            const Row(
              children: [
                Icon(Icons.people),
                SizedBox(width: 8),
                Text(
                  'Communities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // All Communities Section
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All communities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement view all functionality
                  },
                  child: const Text('View all'),
                ),
              ],
            ),

            // Community Circles
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CommunityCircle(
                    image: 'assets/work.jpg',
                    label: 'Work',
                  ),
                  CommunityCircle(
                    image: 'assets/anti_drug.jpg',
                    label: 'Anti drug',
                  ),
                  CommunityCircle(
                    image: 'assets/spirituality.jpg',
                    label: 'Spirituality',
                  ),
                  CommunityCircle(
                    image: 'assets/coming_soon.jpg',
                    label: 'Coming soon',
                  ),
                ],
              ),
            ),

            // Navigation Tabs
            const SizedBox(height: 20),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'My feed'),
                        Tab(text: 'My communities'),
                        Tab(text: 'Q&A'),
                      ],
                      labelColor: Colors.purple,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.purple,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // My Feed Tab
                          MyFeedTab(onTap: _createPost),
                          // My Communities Tab
                          const CommunitiesListScreen(),
                          // Q&A Tab
                          const QAScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityCircle extends StatelessWidget {
  final String image;
  final String label;

  const CommunityCircle({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class CreatePostWidget extends StatelessWidget {
  final VoidCallback onTap;

  const CreatePostWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Share your thoughts...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String authorName;
  final String location;
  final String content;
  final DateTime? date;

  const PostWidget({
    super.key,
    required this.authorName,
    required this.location,
    required this.content,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (date != null)
                  Text(
                    '${date!.day}/${date!.month}/${date!.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class MyFeedTab extends StatefulWidget {
  final VoidCallback onTap;

  const MyFeedTab({
    super.key,
    required this.onTap,
  });

  @override
  State<MyFeedTab> createState() => _MyFeedTabState();
}

class _MyFeedTabState extends State<MyFeedTab> {
  late Box<Post> _postsBox;

  @override
  void initState() {
    super.initState();
    _postsBox = Hive.box<Post>('posts');
  }

  @override
  Widget build(BuildContext context) {
    final posts = _postsBox.values.toList().reversed.toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length + 1, // +1 for CreatePostWidget
        itemBuilder: (context, index) {
          if (index == 0) {
            return CreatePostWidget(onTap: widget.onTap);
          }
          final post = posts[index - 1];
          return PostWidget(
            authorName: post.authorName,
            location: post.location,
            content: post.content,
            date: post.dateCreated,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const CommunityScreen()),
              (route) => false,
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
