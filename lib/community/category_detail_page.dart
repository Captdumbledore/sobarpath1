import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/community_question.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;
  final Box<CommunityQuestion> questionsBox;

  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.questionsBox,
  });

  @override
  Widget build(BuildContext context) {
    final categoryQuestions =
        questionsBox.values.where((q) => q.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Description
            _buildCategoryDescription(category),
            const SizedBox(height: 24),

            // Common Questions Section
            const Text(
              'Common Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // List of Questions
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryQuestions.length,
              itemBuilder: (context, index) {
                final question = categoryQuestions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      question.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          question.answer,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Resources Section
            const SizedBox(height: 24),
            const Text(
              'Additional Resources',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildResourcesList(category),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDescription(String category) {
    final Map<String, String> descriptions = {
      'Feeling of loss or grief':
          'Grief and loss are natural responses to losing someone or something important to you. '
              'This can include the death of a loved one, end of a relationship, loss of a job, or other significant life changes. '
              'While everyone experiences grief differently, there are healthy ways to cope with the pain and move forward while honoring your loss.',
      'Panic attacks':
          'Panic attacks are sudden episodes of intense fear or anxiety that can include physical symptoms like rapid heartbeat, '
              'shortness of breath, and dizziness. While frightening, panic attacks are not life-threatening and can be managed with '
              'proper techniques and support.',
      'Depressive thoughts':
          'Depression can manifest as persistent negative thoughts, feelings of hopelessness, or loss of interest in activities. '
              'While challenging, depression is treatable through various approaches including therapy, lifestyle changes, and professional support.',
      'Constant stress or anxiety':
          'Chronic stress and anxiety can affect both mental and physical health. Learning to recognize triggers and develop healthy '
              'coping mechanisms is essential for managing daily stressors and maintaining overall wellbeing.',
      'Sleep problems':
          'Sleep issues can significantly impact mental and physical health. Whether you have trouble falling asleep, staying asleep, '
              'or getting quality rest, there are various strategies and techniques that can help improve your sleep patterns.',
      'Emotional exhaustion or apathy':
          'Emotional exhaustion can result from prolonged stress, overwhelming responsibilities, or caring for others. '
              'It\'s important to recognize the signs and take steps to protect your emotional wellbeing.',
      'Outburst of anger or irritability':
          'Anger and irritability can strain relationships and affect daily life. Understanding triggers and learning healthy ways to '
              'express emotions can help manage these feelings more effectively.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          descriptions[category] ?? '',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesList(String category) {
    final Map<String, List<Map<String, String>>> resources = {
      'Feeling of loss or grief': [
        {
          'title': 'Grief Support Groups',
          'description': 'Find local support groups'
        },
        {
          'title': 'Professional Counseling',
          'description': 'Connect with grief counselors'
        },
        {
          'title': 'Online Resources',
          'description': 'Access helpful articles and materials'
        },
      ],
      // Add resources for other categories similarly
    };

    final categoryResources = resources[category] ?? [];

    return Column(
      children: categoryResources
          .map((resource) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(resource['title']!),
                  subtitle: Text(resource['description']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ))
          .toList(),
    );
  }
}
