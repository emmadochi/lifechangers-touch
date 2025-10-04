import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isRepeating = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 45);
  double _playbackSpeed = 1.0;
  bool _isMuted = false;
  double _volume = 1.0;
  int _currentTrackIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  // Mock playlist - replace with actual playlist data
  final List<ContentModel> _playlist = [
    ContentModel(
      id: 'audio_1',
      title: 'Sunday Service - Faith and Hope',
      description: 'Join us for an inspiring message about faith, hope, and love.',
      type: ContentType.audio,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sermons',
      tags: ['faith', 'hope'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 2700, // 45 minutes
      viewCount: 1250,
      downloadCount: 45,
      rating: 4.8,
      isDownloadable: true,
      isLive: false,
    ),
    ContentModel(
      id: 'audio_2',
      title: 'Prayer and Meditation',
      description: 'A peaceful time of prayer and reflection.',
      type: ContentType.audio,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'prayer',
      tags: ['prayer', 'meditation'],
      author: 'Pastor Sarah Johnson',
      createdAt: DateTime.now(),
      duration: 1800, // 30 minutes
      viewCount: 890,
      downloadCount: 32,
      rating: 4.9,
      isDownloadable: true,
      isLive: false,
    ),
    ContentModel(
      id: 'audio_3',
      title: 'Worship Music Collection',
      description: 'Beautiful worship songs to lift your spirit.',
      type: ContentType.audio,
      status: ContentStatus.premium,
      coinCost: 5,
      category: 'music',
      tags: ['worship', 'music'],
      author: 'Worship Team',
      createdAt: DateTime.now(),
      duration: 3600, // 1 hour
      viewCount: 2100,
      downloadCount: 78,
      rating: 4.7,
      isDownloadable: true,
      isLive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ContentModel get _currentTrack => _playlist[_currentTrackIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  Text(
                    'Now Playing',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showPlaylist,
                    icon: const Icon(Icons.queue_music),
                  ),
                ],
              ),
            ),
            
            // Album Art
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Track Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    _currentTrack.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentTrack.author,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Progress Bar
                  Column(
                    children: [
                      Slider(
                        value: _currentPosition.inSeconds.toDouble(),
                        max: _totalDuration.inSeconds.toDouble(),
                        onChanged: _seekTo,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.border,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_currentPosition),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _formatDuration(_totalDuration),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Shuffle
                      IconButton(
                        onPressed: _toggleShuffle,
                        icon: Icon(
                          Icons.shuffle,
                          color: _isShuffled ? AppColors.primary : AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                      
                      // Previous
                      IconButton(
                        onPressed: _previousTrack,
                        icon: const Icon(
                          Icons.skip_previous,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                      ),
                      
                      // Play/Pause
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      
                      // Next
                      IconButton(
                        onPressed: _nextTrack,
                        icon: const Icon(
                          Icons.skip_next,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                      ),
                      
                      // Repeat
                      IconButton(
                        onPressed: _toggleRepeat,
                        icon: Icon(
                          _isRepeating ? Icons.repeat : Icons.repeat,
                          color: _isRepeating ? AppColors.primary : AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Secondary Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Volume
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleMute,
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Slider(
                              value: _isMuted ? 0.0 : _volume,
                              onChanged: _changeVolume,
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.border,
                            ),
                          ),
                        ],
                      ),
                      
                      // Speed
                      PopupMenuButton<double>(
                        icon: Text(
                          '${_playbackSpeed}x',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onSelected: _changePlaybackSpeed,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                          const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                          const PopupMenuItem(value: 1.0, child: Text('1x')),
                          const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                          const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                          const PopupMenuItem(value: 2.0, child: Text('2x')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _downloadTrack,
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareTrack,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _likeTrack,
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Like'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
  }

  void _previousTrack() {
    if (_currentTrackIndex > 0) {
      setState(() {
        _currentTrackIndex--;
      });
    }
  }

  void _nextTrack() {
    if (_currentTrackIndex < _playlist.length - 1) {
      setState(() {
        _currentTrackIndex++;
      });
    }
  }

  void _seekTo(double seconds) {
    setState(() {
      _currentPosition = Duration(seconds: seconds.toInt());
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _changeVolume(double volume) {
    setState(() {
      _volume = volume;
      _isMuted = volume == 0.0;
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
  }

  void _downloadTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share options coming soon'),
      ),
    );
  }

  void _likeTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showPlaylist() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playlist',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _playlist.length,
                itemBuilder: (context, index) {
                  final track = _playlist[index];
                  final isCurrentTrack = index == _currentTrackIndex;
                  
                  return ListTile(
                    selected: isCurrentTrack,
                    selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isCurrentTrack ? AppColors.primary : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.music_note,
                        color: isCurrentTrack ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                    title: Text(
                      track.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isCurrentTrack ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      track.author,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Text(
                      track.formattedDuration,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _currentTrackIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
