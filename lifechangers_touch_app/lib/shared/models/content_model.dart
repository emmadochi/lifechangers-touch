enum ContentType {
  video,
  audio,
  book,
  message,
}

enum ContentStatus {
  free,
  premium,
  locked,
}

enum DownloadStatus {
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

class ContentModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? mediaUrl;
  final ContentType type;
  final ContentStatus status;
  final int coinCost;
  final String category;
  final List<String> tags;
  final String author;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final int duration; // in seconds
  final int viewCount;
  final int downloadCount;
  final double rating;
  final bool isDownloadable;
  final bool isLive;
  final String? streamUrl;
  final DateTime? scheduledAt;

  const ContentModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.mediaUrl,
    required this.type,
    required this.status,
    required this.coinCost,
    required this.category,
    required this.tags,
    required this.author,
    required this.createdAt,
    this.publishedAt,
    required this.duration,
    required this.viewCount,
    required this.downloadCount,
    required this.rating,
    required this.isDownloadable,
    required this.isLive,
    this.streamUrl,
    this.scheduledAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      type: ContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContentType.message,
      ),
      status: ContentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ContentStatus.free,
      ),
      coinCost: json['coinCost'] as int,
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List),
      author: json['author'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt'] as String) 
          : null,
      duration: json['duration'] as int,
      viewCount: json['viewCount'] as int,
      downloadCount: json['downloadCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      isDownloadable: json['isDownloadable'] as bool,
      isLive: json['isLive'] as bool,
      streamUrl: json['streamUrl'] as String?,
      scheduledAt: json['scheduledAt'] != null 
          ? DateTime.parse(json['scheduledAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'mediaUrl': mediaUrl,
      'type': type.name,
      'status': status.name,
      'coinCost': coinCost,
      'category': category,
      'tags': tags,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'publishedAt': publishedAt?.toIso8601String(),
      'duration': duration,
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'rating': rating,
      'isDownloadable': isDownloadable,
      'isLive': isLive,
      'streamUrl': streamUrl,
      'scheduledAt': scheduledAt?.toIso8601String(),
    };
  }

  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  bool get isPremium => status == ContentStatus.premium;
  bool get isLocked => status == ContentStatus.locked;
  bool get isFree => status == ContentStatus.free;
}
