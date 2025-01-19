import 'package:flutter/material.dart';
import '../main.dart';
import 'com1.dart';
import 'com_5.dart';
import 'package:hive/hive.dart';
import 'models/joined_community.dart';

class CommunitiesListScreen extends StatelessWidget {
  const CommunitiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          CommunityCard(
            title: 'Anti Drug',
            rating: 4.3,
            members: '10K+',
            backgroundImage: 'assets/anti_drug.jpg',
          ),
          SizedBox(height: 16),
          CommunityCard(
            title: 'Work',
            rating: 4.3,
            members: '10K+',
            backgroundImage: 'assets/work.jpg',
          ),
        ],
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
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
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

class CommunityCard extends StatefulWidget {
  final String title;
  final double rating;
  final String members;
  final String backgroundImage;

  const CommunityCard({
    super.key,
    required this.title,
    required this.rating,
    required this.members,
    required this.backgroundImage,
  });

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  late Box<JoinedCommunity> _joinedBox;
  bool _hasJoined = false;

  @override
  void initState() {
    super.initState();
    _joinedBox = Hive.box<JoinedCommunity>('joined_communities');
    _checkIfJoined();
  }

  void _checkIfJoined() {
    _hasJoined = _joinedBox.values.any(
      (community) => community.communityName == widget.title,
    );
  }

  Future<void> _joinCommunity() async {
    if (!_hasJoined) {
      await _joinedBox.add(
        JoinedCommunity(communityName: widget.title),
      );
      setState(() {
        _hasJoined = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to the community!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already joined this community'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow[700], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.people, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.members,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _joinCommunity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasJoined ? Colors.grey : Colors.purple,
                    ),
                    child: Text(_hasJoined ? 'Joined' : 'Join'),
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
