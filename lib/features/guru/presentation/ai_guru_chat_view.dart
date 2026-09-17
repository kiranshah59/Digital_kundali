import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/guru_chat_bloc.dart';
import '../bloc/guru_chat_event.dart';
import '../bloc/guru_chat_state.dart';
import '../models/guru_message_model.dart';
import '../../home/presentation/upgrade_to_paid_screen.dart';

class AIGuruChatView extends StatefulWidget {
  final VoidCallback onBack;
  final int profileId;

  const AIGuruChatView({
    super.key,
    required this.onBack,
    required this.profileId,
  });

  @override
  State<AIGuruChatView> createState() => _AIGuruChatViewState();
}

class _AIGuruChatViewState extends State<AIGuruChatView> {
  late GuruChatBloc _chatBloc;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatBloc = GuruChatBloc()..add(LoadGuruChat(widget.profileId));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _chatBloc.add(SendGuruMessage(profileId: widget.profileId, message: text));
    _textController.clear();
    
    // Slight delay to allow list to rebuild before scrolling
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: BlocConsumer<GuruChatBloc, GuruChatState>(
              listener: (context, state) {
                if (state is GuruChatLoaded || (state is GuruChatLoading && state.isSending)) {
                  Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                }
                if (state is GuruChatError) {
                  if (state.statusCode == 402) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const UpgradeToPaidScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is GuruChatInitial || (state is GuruChatLoading && !state.isSending && state.messages.isEmpty)) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFA88143)));
                }

                List<GuruMessageModel> messages = [];
                bool isSending = false;

                if (state is GuruChatLoading) {
                  messages = state.messages;
                  isSending = state.isSending;
                } else if (state is GuruChatLoaded) {
                  messages = state.messages;
                } else if (state is GuruChatError) {
                  messages = state.messages;
                }

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Ask the AI Guru a question!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        color: const Color(0xFF8A8A8A),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: messages.length + (isSending ? 1 : 0),
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isSending) {
                      return _buildTypingIndicator();
                    }
                    
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                );
              },
            ),
          ),
          _buildSuggestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFFFAF9F5),
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 16.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
          // Icon Stack
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191B21), // Dark color
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.auto_awesome, color: const Color(0xFFF6D69F), size: 20.sp),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF9F5),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC78B2E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.star, color: Colors.white, size: 8.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Guru',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF11141A),
                  ),
                ),
                Text(
                  'Vedic Astro Intelligence',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<GuruChatBloc, GuruChatState>(
            builder: (context, state) {
              int remaining = -1;
              if (state is GuruChatLoaded) {
                remaining = (state.quota.limit - state.quota.used).clamp(0, 9999);
              } else if (state is GuruChatError && state.quota != null) {
                remaining = (state.quota!.limit - state.quota!.used).clamp(0, 9999);
              }
              
              if (remaining >= 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: remaining > 0 ? const Color(0xFFF6D69F).withValues(alpha: 0.3) : const Color(0xFFFFD4D4),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    remaining > 0 ? '$remaining left' : 'Quota Exceeded',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: remaining > 0 ? const Color(0xFF8B6420) : Colors.red,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(GuruMessageModel msg) {
    bool isUser = msg.role == 'user';
    
    // Parse time if possible for the label
    String timeLabel = '';
    try {
      if (msg.createdAt.isNotEmpty) {
        final dt = DateTime.parse(msg.createdAt).toLocal();
        int hr = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        String ampm = dt.hour >= 12 ? 'PM' : 'AM';
        String min = dt.minute.toString().padLeft(2, '0');
        timeLabel = '$hr:$min $ampm';
      }
    } catch (e) {
      timeLabel = '';
    }

    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (timeLabel.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              timeLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                color: const Color(0xFF8A8A8A),
              ),
            ),
          ),
        Container(
          margin: isUser ? EdgeInsets.only(left: 48.w) : EdgeInsets.only(right: 48.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xFF11141A) : const Color(0xFFF9F6F0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomRight: isUser ? Radius.circular(4.r) : Radius.circular(16.r),
              bottomLeft: isUser ? Radius.circular(16.r) : Radius.circular(4.r),
            ),
            border: isUser ? null : Border.all(color: const Color(0xFFEAE6DF)),
          ),
          child: Text(
            msg.content,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: isUser ? Colors.white : const Color(0xFF11141A),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 48.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          ),
          border: Border.all(color: const Color(0xFFEAE6DF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16.w, 
              height: 16.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2, 
                color: Color(0xFFA88143),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Guru is meditating...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF8A8A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return BlocBuilder<GuruChatBloc, GuruChatState>(
      builder: (context, state) {
        // Disable suggestions if limit reached or sending
        bool isDisabled = false;
        if (state is GuruChatLoading && state.isSending) isDisabled = true;
        if (state is GuruChatLoaded && state.quota.isLimitReached) isDisabled = true;
        if (state is GuruChatError && (state.quota?.isLimitReached ?? false)) isDisabled = true;
        
        return Container(
          height: 36.h,
          margin: EdgeInsets.only(bottom: 16.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              _buildSuggestionChip(Icons.access_time, 'When is my Shubh Muhurat?', isDisabled),
              SizedBox(width: 8.w),
              _buildSuggestionChip(Icons.work_outline, 'Analyze my career...', isDisabled),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSuggestionChip(IconData icon, String text, bool isDisabled) {
    return GestureDetector(
      onTap: isDisabled ? null : () {
        _textController.text = text;
        _sendMessage();
      },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFEAE6DF)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: const Color(0xFF11141A)),
              SizedBox(width: 6.w),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  color: const Color(0xFF11141A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<GuruChatBloc, GuruChatState>(
      builder: (context, state) {
        bool isLimitReached = false;
        bool isSending = false;
        
        if (state is GuruChatLoaded) {
          isLimitReached = state.quota.isLimitReached;
        } else if (state is GuruChatLoading) {
          isSending = state.isSending;
          if (state.quota != null) isLimitReached = state.quota!.isLimitReached;
        } else if (state is GuruChatError) {
          if (state.quota != null) isLimitReached = state.quota!.isLimitReached;
        }

        if (isLimitReached) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(color: Color(0xFFFAF9F5)),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => const UpgradeToPaidScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA88143),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: const Text('Upgrade to Continue Chatting', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF9F5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6F0),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFEAE6DF)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          enabled: !isSending,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Ask Guru about your stars...',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              color: const Color(0xFF8A8A8A),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.mic_none, color: const Color(0xFF8A8A8A), size: 20.sp),
                        onPressed: isSending ? null : () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSending ? const Color(0xFF8A8A8A) : const Color(0xFF12141D),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
                  onPressed: isSending ? null : _sendMessage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
