import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _isMuted = false;
  double _volume = 1.0;

  // Mock content - replace with actual content from parameters
  final ContentModel _content = ContentModel(
    id: 'video_1',
    title: 'Sunday Service - Faith and Hope',
    description: 'Join us for an inspiring message about faith, hope, and love in our daily lives.',
    thumbnailUrl: null,
    mediaUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    type: ContentType.video,
    status: ContentStatus.free,
    coinCost: 0,
    category: 'sermons',
    tags: ['faith', 'hope', 'sunday'],
    author: 'Pastor John Doe',
    createdAt: DateTime.now(),
    publishedAt: DateTime.now(),
    duration: 3600, // 1 hour
    viewCount: 1250,
    downloadCount: 45,
    rating: 4.8,
    isDownloadable: true,
    isLive: false,
    streamUrl: null,
    scheduledAt: null,
  );

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    // Mock video URL - replace with actual video URL
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4'),
    );
    
    await _controller.initialize();
    _controller.addListener(_videoListener);
    
    setState(() {
      _totalDuration = _controller.value.duration;
    });
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _currentPosition = _controller.value.position;
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player
            Expanded(
              child: GestureDetector(
                onTap: _toggleControls,
                child: Stack(
                  children: [
                    // Video Display
                    Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                    ),
                    
                    // Controls Overlay
                    if (_showControls)
                      _VideoControlsOverlay(
                        controller: _controller,
                        isPlaying: _isPlaying,
                        currentPosition: _currentPosition,
                        totalDuration: _totalDuration,
                        playbackSpeed: _playbackSpeed,
                        isMuted: _isMuted,
                        volume: _volume,
                        onPlayPause: _togglePlayPause,
                        onSeek: _seekTo,
                        onSpeedChange: _changePlaybackSpeed,
                        onMuteToggle: _toggleMute,
                        onVolumeChange: _changeVolume,
                        onFullscreenToggle: _toggleFullscreen,
                        onBack: () => context.pop(),
                      ),
                  ],
                ),
              ),
            ),
            
            // Content Info
            if (!_isFullscreen)
              _ContentInfoSection(
                content: _content,
                onDownload: _downloadContent,
                onShare: _shareContent,
                onLike: _likeContent,
              ),
          ],
        ),
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _seekTo(Duration position) {
    _controller.seekTo(position);
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _controller.setPlaybackSpeed(speed);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : _volume);
    });
  }

  void _changeVolume(double volume) {
    setState(() {
      _volume = volume;
      if (!_isMuted) {
        _controller.setVolume(volume);
      }
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _downloadContent() {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareContent() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share options coming soon'),
      ),
    );
  }

  void _likeContent() {
    // TODO: Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _VideoControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;
  final bool isMuted;
  final double volume;
  final VoidCallback onPlayPause;
  final Function(Duration) onSeek;
  final Function(double) onSpeedChange;
  final VoidCallback onMuteToggle;
  final Function(double) onVolumeChange;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onBack;

  const _VideoControlsOverlay({
    required this.controller,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.isMuted,
    required this.volume,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSpeedChange,
    required this.onMuteToggle,
    required this.onVolumeChange,
    required this.onFullscreenToggle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          // Top Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onFullscreenToggle,
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Center Play Button
          Center(
            child: IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Bottom Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppColors.primary,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Control Buttons
                Row(
                  children: [
                    // Play/Pause
                    IconButton(
                      onPressed: onPlayPause,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    
                    // Time Display
                    Text(
                      '${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Volume Control
                    IconButton(
                      onPressed: onMuteToggle,
                      icon: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: isMuted ? 0.0 : volume,
                        onChanged: onVolumeChange,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    
                    // Speed Control
                    PopupMenuButton<double>(
                      icon: Text(
                        '${playbackSpeed}x',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onSelected: onSpeedChange,
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
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}

class _ContentInfoSection extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onLike;

  const _ContentInfoSection({
    required this.content,
    required this.onDownload,
    required this.onShare,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Author
            Text(
              content.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'by ${content.author}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Stats
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${content.viewCount} views',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  content.formattedDuration,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (content.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM',
                      style: AppTextStyles.premiumBadge,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              content.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLike,
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Like'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
