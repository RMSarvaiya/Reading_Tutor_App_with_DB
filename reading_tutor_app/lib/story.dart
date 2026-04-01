class Story {
  final String id;
  final String title;
  final String content;
  final int level; // 1-5, difficulty level
  final String category;
  final int estimatedMinutes;
  final List<Question> questions;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.level,
    required this.category,
    required this.estimatedMinutes,
    required this.questions,
  });
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer; // index of correct option
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

// Sample stories database
class StoriesDatabase {
  static List<Story> getAllStories() {
    return [
      Story(
        id: '1',
        title: 'The Clever Fox',
        level: 1,
        category: 'Fables',
        estimatedMinutes: 3,
        content: '''
One sunny day, a clever fox was walking through the forest. He was very hungry and looking for food.

Suddenly, he saw a crow sitting on a tree branch. The crow had a piece of cheese in her beak. The fox wanted that cheese!

"Hello, beautiful crow!" said the fox. "Your feathers are so shiny and black. I bet you have a beautiful voice too. Will you sing for me?"

The crow felt very proud. She opened her beak to sing, "Caw! Caw!" But when she opened her beak, the cheese fell down!

The fox quickly grabbed the cheese and ran away. "Thank you for the cheese!" he laughed.

The crow learned an important lesson: Don't trust everyone who gives you compliments.
''',
        questions: [
          Question(
            question: 'What did the crow have in her beak?',
            options: ['An apple', 'A piece of cheese', 'A worm', 'A nut'],
            correctAnswer: 1,
            explanation: 'The crow had a piece of cheese in her beak.',
          ),
          Question(
            question: 'How did the fox get the cheese?',
            options: [
              'He climbed the tree',
              'He asked nicely',
              'He tricked the crow with compliments',
              'He scared the crow'
            ],
            correctAnswer: 2,
            explanation:
            'The fox tricked the crow by complimenting her, making her open her beak to sing.',
          ),
          Question(
            question: 'What lesson did the crow learn?',
            options: [
              'Always share food',
              'Don\'t trust everyone who compliments you',
              'Never sing in public',
              'Foxes are mean'
            ],
            correctAnswer: 1,
            explanation:
            'The crow learned not to trust everyone who gives compliments.',
          ),
        ],
      ),
      Story(
        id: '2',
        title: 'The Little Seed',
        level: 1,
        category: 'Nature',
        estimatedMinutes: 2,
        content: '''
There was once a tiny seed buried deep in the ground. It was dark and lonely underground.

"I want to see the sun!" said the little seed. So it started to grow.

First, it grew a small root down into the earth to get water. Then it pushed a tiny green shoot up through the soil.

Day by day, the shoot grew taller. It stretched toward the warm sunshine. Rain came and watered it. The wind gently swayed it back and forth.

Soon, the shoot had leaves. Then it grew bigger and stronger. After many days, something wonderful happened.

A beautiful yellow flower bloomed! Bees came to visit. Birds sang nearby.

The little seed had become a beautiful sunflower, tall and bright, reaching up to the sky.
''',
        questions: [
          Question(
            question: 'Where was the seed at the beginning?',
            options: [
              'In a pot',
              'Underground',
              'In a tree',
              'In a flower shop'
            ],
            correctAnswer: 1,
            explanation: 'The seed was buried deep in the ground.',
          ),
          Question(
            question: 'What did the seed grow first?',
            options: ['Flowers', 'Leaves', 'A root', 'Branches'],
            correctAnswer: 2,
            explanation:
            'The seed first grew a small root down into the earth to get water.',
          ),
          Question(
            question: 'What kind of flower did the seed become?',
            options: ['A rose', 'A tulip', 'A sunflower', 'A daisy'],
            correctAnswer: 2,
            explanation: 'The little seed became a beautiful sunflower.',
          ),
        ],
      ),
      Story(
        id: '3',
        title: 'The Rainbow Fish',
        level: 2,
        category: 'Friendship',
        estimatedMinutes: 4,
        content: '''
Deep in the ocean lived a beautiful fish. He had shiny, colorful scales that sparkled like jewels. All the other fish called him Rainbow Fish.

Rainbow Fish was very proud of his beautiful scales. Whenever other fish came to play, he would swim away. "I'm too special to play with you," he would say.

Soon, Rainbow Fish had no friends. He was lonely. The other fish swam together and had fun, but nobody wanted to play with Rainbow Fish anymore.

One day, a little blue fish asked, "Rainbow Fish, will you give me one of your shiny scales? They are so beautiful!"

Rainbow Fish became angry. "Never! These scales make me special!" he shouted.

Feeling sad and alone, Rainbow Fish went to visit the wise octopus. "Why doesn't anyone like me?" he asked.

The wise octopus said, "True beauty comes from sharing and being kind. Your scales are pretty, but a kind heart is more beautiful."

Rainbow Fish thought about this. He found the little blue fish and gave her one of his shiny scales. Her face lit up with joy!

Soon, Rainbow Fish was giving scales to all the fish. With each scale he gave away, he felt happier. Even though he had fewer scales now, he had something better – lots of friends!

Rainbow Fish learned that sharing and kindness are more valuable than being the most beautiful.
''',
        questions: [
          Question(
            question: 'Why was Rainbow Fish lonely?',
            options: [
              'He lived far away',
              'He was too proud to play with others',
              'He was sick',
              'He was too busy'
            ],
            correctAnswer: 1,
            explanation:
            'Rainbow Fish was lonely because he was too proud and wouldn\'t play with other fish.',
          ),
          Question(
            question: 'Who gave Rainbow Fish advice?',
            options: [
              'A little blue fish',
              'His mother',
              'A wise octopus',
              'A dolphin'
            ],
            correctAnswer: 2,
            explanation: 'The wise octopus gave Rainbow Fish advice.',
          ),
          Question(
            question: 'What did Rainbow Fish learn?',
            options: [
              'Scales are very valuable',
              'It\'s better to be alone',
              'Sharing and kindness are more important than beauty',
              'Never give away your belongings'
            ],
            correctAnswer: 2,
            explanation:
            'Rainbow Fish learned that sharing and kindness are more valuable than being beautiful.',
          ),
        ],
      ),
      Story(
        id: '4',
        title: 'The Ant and the Grasshopper',
        level: 2,
        category: 'Fables',
        estimatedMinutes: 3,
        content: '''
It was a beautiful summer day. An ant was working hard, carrying grains of wheat to his home. He was preparing food for the winter.

A grasshopper hopped by, playing his fiddle and singing songs. "Why are you working so hard?" asked the grasshopper. "Come and play with me! Summer is for fun!"

The ant stopped and wiped his forehead. "I must store food for winter," he explained. "Winter is coming, and there won't be any food then. You should prepare too."

The grasshopper laughed. "Winter is far away! There's plenty of time. I want to enjoy the sunshine!" He hopped away, playing his music.

All summer long, the ant worked hard every day. The grasshopper played and had fun, not storing any food at all.

Then winter came. Snow covered the ground. It was cold, and there was no food anywhere.

The grasshopper was hungry and cold. He had nothing to eat because he hadn't prepared. He remembered the ant and hopped to his home.

"Please, can you spare some food?" the grasshopper asked sadly. "I'm so hungry."

The kind ant shared his food with the grasshopper. "Next time, remember to prepare for the future," said the ant.

The grasshopper thanked the ant and promised to work hard next summer.
''',
        questions: [
          Question(
            question: 'What was the ant doing in summer?',
            options: [
              'Playing music',
              'Sleeping',
              'Storing food for winter',
              'Building a house'
            ],
            correctAnswer: 2,
            explanation:
            'The ant was working hard to store food for winter.',
          ),
          Question(
            question: 'What did the grasshopper do all summer?',
            options: [
              'He worked with the ant',
              'He played and had fun',
              'He slept',
              'He traveled'
            ],
            correctAnswer: 1,
            explanation:
            'The grasshopper played his fiddle and had fun all summer.',
          ),
          Question(
            question: 'What is the lesson of this story?',
            options: [
              'Always play and never work',
              'Winter is bad',
              'Prepare for the future and work hard',
              'Ants are better than grasshoppers'
            ],
            correctAnswer: 2,
            explanation:
            'The lesson is to prepare for the future and work hard instead of only having fun.',
          ),
        ],
      ),
      Story(
        id: '5',
        title: 'The Magic Library',
        level: 3,
        category: 'Adventure',
        estimatedMinutes: 5,
        content: '''
Emma loved books more than anything. Every day after school, she would visit the old library in her town. The librarian, Mrs. Chen, always had a warm smile and would recommend the best books.

One rainy afternoon, Emma was exploring the oldest section of the library. She noticed a door she had never seen before. It was small and wooden, with strange symbols carved into it.

"I wonder what's behind there," Emma whispered to herself. She tried the handle, and to her surprise, it opened!

Behind the door was a spiral staircase going up. Emma climbed the stairs carefully. At the top, she found an amazing room filled with glowing books. The books sparkled with different colors – blue, gold, silver, and purple.

"Welcome, Emma," said a gentle voice. Mrs. Chen appeared from behind a bookshelf. "I've been waiting for the right person to show this room. These are magical books."

Emma's eyes widened. "Magical? What do they do?"

"Each book takes you inside the story," Mrs. Chen explained. "You become part of the adventure. But remember, you must help the characters solve their problems to return home."

Emma picked up a blue glowing book called "The Crystal Cave." As soon as she opened it, a bright light surrounded her. In a flash, she was standing in a beautiful cave filled with sparkling crystals!

A small dragon appeared. "Help! An evil wizard has trapped my family. Only someone brave and kind can free them."

Emma spent what felt like hours helping the dragon solve riddles and overcome obstacles. She used her cleverness and courage to defeat the wizard and free the dragon's family.

Suddenly, Emma was back in the library, the book closed in her hands. Mrs. Chen smiled knowingly. "You did well. These books teach us that we're braver and smarter than we think."

From that day on, Emma had a magical secret. But she also learned that the real magic wasn't just in the glowing books – it was in the courage and kindness she found within herself.
''',
        questions: [
          Question(
            question: 'Where did Emma find the mysterious door?',
            options: [
              'In the new section',
              'In the oldest section of the library',
              'In Mrs. Chen\'s office',
              'Outside the library'
            ],
            correctAnswer: 1,
            explanation:
            'Emma found the mysterious door in the oldest section of the library.',
          ),
          Question(
            question: 'What made the books in the secret room special?',
            options: [
              'They were very old',
              'They were expensive',
              'They took you inside the story',
              'They were very large'
            ],
            correctAnswer: 2,
            explanation:
            'The magical books took you inside the story and made you part of the adventure.',
          ),
          Question(
            question: 'What did Emma learn from her adventure?',
            options: [
              'Libraries are boring',
              'Dragons are scary',
              'She was braver and smarter than she thought',
              'Magic isn\'t real'
            ],
            correctAnswer: 2,
            explanation:
            'Emma learned that she was braver and smarter than she thought, and that courage and kindness were her real magic.',
          ),
        ],
      ),
    ];
  }

  static List<Story> getStoriesByLevel(int level) {
    return getAllStories().where((story) => story.level == level).toList();
  }

  static Story? getStoryById(String id) {
    try {
      return getAllStories().firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }
}
