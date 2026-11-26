class MockCommentsData {
  static List<Map<String, dynamic>> comments = [
    {
      'id': 1,
      'post_id': 1,
      'post_title': 'Mastering Laravel 11 REST APIs with Clean Architecture',
      'user': {
        'name': 'Alex Rivera',
        'avatar_url': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=120&q=80',
      },
      'body': 'This guide saved our team hours during our Laravel 11 upgrade. The repository pattern section in particular is top tier!',
      'is_hidden': false,
      'created_at': '2026-03-12T11:42:00Z',
    },
    {
      'id': 2,
      'post_id': 1,
      'post_title': 'Mastering Laravel 11 REST APIs with Clean Architecture',
      'user': {
        'name': 'Liam Chen',
        'avatar_url': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=120&q=80',
      },
      'body': 'How do you handle nested relations inside API Resources without running into the N+1 problem?',
      'is_hidden': false,
      'created_at': '2026-03-13T16:15:00Z',
    },
    {
      'id': 3,
      'post_id': 2,
      'post_title': 'Flutter 3 State Management: Provider vs Riverpod in 2026',
      'user': {
        'name': 'Emma Watson',
        'avatar_url': 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=120&q=80',
      },
      'body': 'Provider paired with a well-structured clean architecture has always been my favorite. So glad to see it still thriving!',
      'is_hidden': false,
      'created_at': '2026-03-25T10:05:00Z',
    },
    {
      'id': 4,
      'post_id': 3,
      'post_title': '10 Micro-Animations to Make Your Mobile Apps Feel Premium',
      'user': {
        'name': 'Carlos Gomez',
        'avatar_url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=120&q=80',
      },
      'body': 'Would love to see a companion GitHub repo with these custom animation curve examples.',
      'is_hidden': false,
      'created_at': '2026-04-03T09:30:00Z',
    },
  ];
}

