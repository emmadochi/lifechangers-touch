import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class ActiveLivestreamScreen extends StatefulWidget {
  const ActiveLivestreamScreen({super.key});

  @override
  State<ActiveLivestreamScreen> createState() => _ActiveLivestreamScreenState();
}

class _ActiveLivestreamScreenState extends State<ActiveLivestreamScreen>
    with TickerProviderStateMixin {
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _isChatVisible = true;
  bool _isMuted = false;
  double _volume = 1.0;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock stream data - replace with actual stream data
  final ContentModel _stream = ContentModel(
    id: 'live_1',
    title: 'Sunday Morning Service',
    description: 'Join us for our weekly Sunday service with worship, prayer, and an inspiring message.',
    type: ContentType.video,
    status: ContentStatus.free,
    coinCost: 0,
    category: 'sunday-service',
    tags: ['sunday', 'service', 'worship', 'live'],
    author: 'Pastor John Doe',
    createdAt: DateTime.now(),
    duration: 0,
    viewCount: 1250,
    downloadCount: 0,
    rating: 4.8,
    isDownloadable: false,
    isLive: true,
    streamUrl: 'https://example.com/stream1',
    scheduledAt: DateTime.now().subtract(const Duration(minutes: 30)),
  );

  // Mock chat messages - replace with actual chat data
  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: '1',
      user: 'John Smith',
      message: 'Great message so far!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isModerator: false,
    ),
    ChatMessage(
      id: '2',
      user: 'Sarah Johnson',
      message: 'Amen! 🙏',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isModerator: false,
    ),
    ChatMessage(
      id: '3',
      user: 'Moderator',
      message: 'Welcome everyone to our Sunday service!',
      timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
      isModerator: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isFullscreen ? _buildFullscreenView() : _buildNormalView(),
    );
  }

  Widget _buildNormalView() {
    return Column(
      children: [
        // Video Player Area
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: _toggleControls,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Stack(
                children: [
                  // Video Placeholder
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  
                  // Live Indicator
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // View Count
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_stream.viewCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Controls Overlay
                  if (_showControls)
                    _StreamControlsOverlay(
                      onFullscreen: _toggleFullscreen,
                      onMute: _toggleMute,
                      onVolumeChange: _changeVolume,
                      isMuted: _isMuted,
                      volume: _volume,
                    ),
                ],
              ),
            ),
          ),
        ),
        
        // Chat and Info Section
        Expanded(
          flex: 2,
          child: Row(
            children: [
              // Stream Info
              Expanded(
                flex: 2,
                child: _StreamInfoSection(
                  stream: _stream,
                  onShare: _shareStream,
                  onNotify: _notifyStream,
                ),
              ),
              
              // Chat
              if (_isChatVisible)
                Expanded(
                  flex: 1,
                  child: _ChatSection(
                    messages: _chatMessages,
                    controller: _chatController,
                    scrollController: _chatScrollController,
                    onSendMessage: _sendMessage,
                    onToggleChat: _toggleChat,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullscreenView() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          children: [
            // Video Placeholder
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 120,
                color: Colors.white,
              ),
            ),
            
            // Live Indicator
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // View Count
            Positioned(
              top: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_stream.viewCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Fullscreen Controls
            if (_showControls)
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _toggleFullscreen,
                      icon: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleMute,
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
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

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
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

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      // TODO: Send message to chat
      _chatController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _shareStream() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing stream'),
      ),
    );
  }

  void _notifyStream() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications enabled'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _StreamControlsOverlay extends StatelessWidget {
  final VoidCallback onFullscreen;
  final VoidCallback onMute;
  final Function(double) onVolumeChange;
  final bool isMuted;
  final double volume;

  const _StreamControlsOverlay({
    required this.onFullscreen,
    required this.onMute,
    required this.onVolumeChange,
    required this.isMuted,
    required this.volume,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          IconButton(
            onPressed: onMute,
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Slider(
              value: isMuted ? 0.0 : volume,
              onChanged: onVolumeChange,
              activeColor: AppColors.primary,
              inactiveColor: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          IconButton(
            onPressed: onFullscreen,
            icon: const Icon(
              Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreamInfoSection extends StatelessWidget {
  final ContentModel stream;
  final VoidCallback onShare;
  final VoidCallback onNotify;

  const _StreamInfoSection({
    required this.stream,
    required this.onShare,
    required this.onNotify,
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
              stream.title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stream.author,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              stream.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
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
                    onPressed: onNotify,
                    icon: const Icon(Icons.notifications),
                    label: const Text('Notify'),
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

class _ChatSection extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController controller;
  final ScrollController scrollController;
  final Function(String) onSendMessage;
  final VoidCallback onToggleChat;

  const _ChatSection({
    required this.messages,
    required this.controller,
    required this.scrollController,
    required this.onSendMessage,
    required this.onToggleChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Live Chat',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onToggleChat,
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _ChatMessageWidget(message: message);
              },
            ),
          ),
          
          // Chat Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: onSendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => onSendMessage(controller.text),
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: message.isModerator 
                ? AppColors.primary 
                : AppColors.surfaceVariant,
            child: Text(
              message.user[0].toUpperCase(),
              style: AppTextStyles.bodySmall.copyWith(
                color: message.isModerator 
                    ? Colors.white 
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.user,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: message.isModerator 
                            ? AppColors.primary 
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (message.isModerator) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'MOD',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatTime(message.timestamp),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else {
      return '${difference.inHours}h';
    }
  }
}

class ChatMessage {
  final String id;
  final String user;
  final String message;
  final DateTime timestamp;
  final bool isModerator;

  const ChatMessage({
    required this.id,
    required this.user,
    required this.message,
    required this.timestamp,
    required this.isModerator,
  });
}
