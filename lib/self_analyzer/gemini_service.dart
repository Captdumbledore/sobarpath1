import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyDQ5ISNFWbuWnSGdsh_TTugOIsLN3A9Imw',
  );

  Future<String> analyzeSelfReflection(List<String> responses) async {
    try {
      final prompt = '''
      As a creative life coach and storyteller, craft an engaging and insightful narrative about this person's journey. 
      Transform their responses into a cohesive story of self-discovery.

      Context (to be woven naturally into the narrative):
      🔋 Energy: ${responses[0]}/10
      🌟 Qualities: ${responses[1]}
      🎯 Growth Areas: ${responses[2]}
      🧘‍♂️ Stress Approach: ${responses[3]}
      ✨ Aspirations: ${responses[4]}

      Create an engaging narrative following this flow:

      **✨ Life's Current Chapter**
      • Paint a vivid picture of their present moment using metaphors
      • Weave their energy levels into an engaging narrative
      • Reveal hidden patterns in their journey

      **💫 Inner Light**
      • Transform their qualities into a unique constellation of strengths
      • Reveal unexpected connections between their abilities
      • Show how their strengths could create magical possibilities

      **🌱 Growth's Garden**
      • Present challenges as seeds of transformation
      • Draw parallels with nature's growth patterns
      • Suggest innovative paths forward

      **🎭 Life's Rhythm**
      • Create metaphors for their stress management style
      • Suggest mindfulness practices through storytelling
      • Connect inner peace with life's symphony

      **🎯 Future's Canvas**
      • Paint their aspirations in vivid colors
      • Create stepping stones through storytelling
      • Weave current strengths into future dreams

      **💡 Wisdom's Whispers**
      • Share insights through gentle metaphors
      • Offer perspective shifts through stories
      • Present alternatives as plot twists in their journey

      **🚀 Journey Ahead**
      • Frame next steps as exciting plot points
      • Create a trilogy of immediate adventures
      • Sketch the epic saga of their long-term path

      Use creative metaphors, engaging storytelling, and vivid imagery. Transform data points into an inspiring narrative. Keep the tone warm, encouraging, and genuine while maintaining professional insight.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      String analysisText =
          response.text ?? 'Analysis generation failed. Please try again.';

      // Ensure proper markdown formatting and spacing
      analysisText = analysisText
          .replaceAll('•', '\n•')
          .replaceAll('**', '\n\n**')
          .replaceAll('*.', '•')
          .replaceAll('\n\n\n', '\n\n') // Remove extra line breaks
          .trim();

      return analysisText;
    } catch (e) {
      return '''
      ⚠️ Connection Hiccup!

      We hit a small bump while crafting your personal insights. 
      This might be due to:
      • A brief network pause
      • A moment of server reflection
      • A temporary API meditation

      Take a deep breath, and let's try again in a moment. 
      Your journey of self-discovery awaits! ✨
      ''';
    }
  }
}
