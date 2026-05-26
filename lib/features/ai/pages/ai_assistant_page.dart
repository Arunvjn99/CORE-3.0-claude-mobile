import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _isTyping = false;

  final List<_Message> _messages = [
    _Message(
      text: "Hello! I'm your AI Retirement Assistant. I can help you understand your 401(k), explain contribution strategies, answer questions about loans and withdrawals, and help you plan for retirement. What would you like to know?",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      suggestions: [
        'How much should I contribute?',
        'Explain Traditional vs Roth',
        'What is employer match?',
        'How do I take a loan?',
      ],
    ),
  ];

  static const _responses = {
    'contribution': [
      "A common rule of thumb is to contribute **at least enough to get your full employer match** — that's free money! Beyond that, financial advisors often recommend saving **10–15% of your income** for retirement.\n\nYour current contribution rate is **6%** with a **3% employer match**, giving you **9% total**. Consider gradually increasing by 1% each year.",
    ],
    'traditional': [
      "Here's the key difference:\n\n**Traditional 401(k)**\n• Contributions are pre-tax (reduces taxable income now)\n• Taxes paid when you withdraw in retirement\n• Best if you expect to be in a lower tax bracket in retirement\n\n**Roth 401(k)**\n• Contributions are after-tax (no immediate tax break)\n• Withdrawals in retirement are **tax-free**\n• Best if you expect to be in a higher tax bracket in retirement\n\nMany experts recommend splitting contributions between both for tax diversification.",
    ],
    'employer': [
      "Your employer match is essentially **free money** added to your 401(k).\n\n**Your current plan:**\n• You contribute 6% → Employer adds 3%\n• That's a **50% instant return** on matched contributions!\n\n⚠️ If you're not contributing at least 6%, you're leaving money on the table. Always contribute enough to capture the full match before anything else.",
    ],
    'loan': [
      "You can borrow from your 401(k) under certain conditions:\n\n**Key facts:**\n• Borrow up to **50% of your vested balance** or \$50,000, whichever is less\n• Current balance: \$30,000 → Max loan: **\$15,000**\n• Repaid via payroll deductions over 1–5 years\n• Interest rate: **prime rate + 1%** (currently ~9.5%)\n\n⚠️ You're paying yourself back, but the money misses out on market growth. Consider this a last resort.\n\nWant me to walk you through the loan application?",
    ],
    'withdrawal': [
      "Withdrawing from your 401(k) early has significant costs:\n\n**Under age 59½:**\n• 10% early withdrawal penalty\n• Plus ordinary income taxes (could be 22–37%)\n• Total cost: potentially **30–47%** of the amount\n\n**Alternatives to consider:**\n1. 401(k) loan (pay yourself back)\n2. Hardship withdrawal (waives penalty for qualified reasons)\n3. HELOC or personal loan\n\nFor your \$30,000 balance, an early withdrawal of \$10,000 could cost you ~\$4,000 in penalties and taxes.",
    ],
    'readiness': [
      "Based on your current account:\n\n**Your Retirement Snapshot:**\n• Current balance: **\$30,000**\n• Monthly contribution: **\$450** (6%)\n• Employer match: **\$225** (3%)\n• Total monthly savings: **\$675**\n\n📈 **Projected at retirement (age 65):**\n• Assuming 7% annual return\n• Estimated balance: **~\$890,000**\n\n🎯 **Retirement Readiness Score: 78/100**\n\nTo improve your score:\n1. Increase contribution to 10%\n2. Consider a Roth conversion\n3. Diversify into target-date funds",
    ],
    'investment': [
      "Your current allocation:\n\n• **Large Cap Equity** — 40% (growth)\n• **International Growth** — 25% (diversification)\n• **Stable Value Bond** — 20% (stability)\n• **Target Date 2050** — 15% (auto-adjust)\n\n**For your age (42):** This is a reasonable balance, but you could consider:\n\n✅ **Aggressive** (age 42): 80% stocks / 20% bonds\n✅ **Current**: ~65% stocks / 35% bonds (slightly conservative)\n\nWant me to suggest a rebalancing strategy?",
    ],
    'default': [
      "That's a great question about your retirement planning! Here's what I can help you with:\n\n• **Contribution strategies** — how much to save\n• **Investment allocation** — where to invest\n• **Loan options** — borrowing from your 401(k)\n• **Withdrawal rules** — accessing your money\n• **Retirement readiness** — are you on track?\n\nCould you be more specific about what you'd like to know?",
      "I understand you're asking about your retirement account. Let me provide some relevant information.\n\nYour 401(k) is one of the most powerful tools for building retirement wealth. Key features include:\n\n• **Tax-advantaged growth** — money grows tax-deferred\n• **Employer contributions** — free money through matching\n• **Investment options** — diversify across fund types\n• **Compound growth** — time in market matters most\n\nWhat specific aspect would you like to explore?",
    ],
  };

  String _getResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('contribut') || lower.contains('how much') || lower.contains('percent')) {
      return _responses['contribution']!.first;
    } else if (lower.contains('traditional') || lower.contains('roth') || lower.contains('difference')) {
      return _responses['traditional']!.first;
    } else if (lower.contains('employer') || lower.contains('match') || lower.contains('free')) {
      return _responses['employer']!.first;
    } else if (lower.contains('loan') || lower.contains('borrow')) {
      return _responses['loan']!.first;
    } else if (lower.contains('withdraw') || lower.contains('cash out') || lower.contains('early')) {
      return _responses['withdrawal']!.first;
    } else if (lower.contains('retire') || lower.contains('ready') || lower.contains('readiness') || lower.contains('track')) {
      return _responses['readiness']!.first;
    } else if (lower.contains('invest') || lower.contains('allocat') || lower.contains('portfolio') || lower.contains('fund')) {
      return _responses['investment']!.first;
    } else {
      final defaults = _responses['default']!;
      return defaults[Random().nextInt(defaults.length)];
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.add(_Message(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(700)));
    if (!mounted) return;

    final response = _getResponse(text);
    setState(() {
      _isTyping = false;
      _messages.add(_Message(text: response, isUser: false, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CORE AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                Text('Retirement intelligence', style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() {
              _messages.clear();
              _messages.add(_Message(
                text: "Hello! I'm your AI Retirement Assistant. How can I help you today?",
                isUser: false,
                time: DateTime.now(),
                suggestions: [
                  'How much should I contribute?',
                  'Explain Traditional vs Roth',
                  'Am I on track for retirement?',
                  'How do loans work?',
                ],
              ));
            }),
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingBubble();
                }
                return _MessageBubble(
                  message: _messages[index],
                  onSuggestionTap: _sendMessage,
                );
              },
            ),
          ),

          // Quick suggestions row
          if (!_isTyping && _messages.length == 1)
            Container(
              height: 36,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'Retirement readiness',
                  'Investment strategy',
                  'Loan eligibility',
                  'Tax strategies',
                ].map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _sendMessage(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ),
                  ),
                )).toList(),
              ),
            ),

          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              border: Border(top: BorderSide(color: scheme.outline.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Ask about your retirement…',
                        hintStyle: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.chartPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<String>? suggestions;

  _Message({required this.text, required this.isUser, required this.time, this.suggestions});
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  final void Function(String) onSuggestionTap;

  const _MessageBubble({required this.message, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.chartPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 6),
                Text('AI Assistant', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant)),
                const SizedBox(width: 6),
                Text(
                  _formatTime(message.time),
                  style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isUser) const SizedBox(width: 48),
              Flexible(
                child: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : scheme.surfaceContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                    ),
                    child: _RichText(text: message.text, isUser: isUser),
                  ),
                ),
              ),
              if (!isUser) const SizedBox(width: 48),
            ],
          ),

          if (isUser) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(_formatTime(message.time), style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
            ),
          ],

          // Suggestions chips
          if (!isUser && message.suggestions != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: message.suggestions!.map((s) => GestureDetector(
                onTap: () => onSuggestionTap(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

class _RichText extends StatelessWidget {
  final String text;
  final bool isUser;

  const _RichText({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseColor = isUser ? Colors.white : scheme.onSurface;

    // Simple markdown-like bold parsing (**text**)
    final spans = <InlineSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i % 2 == 1 ? FontWeight.w700 : FontWeight.w400,
          color: baseColor,
          fontSize: 13.5,
          height: 1.5,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final delay = i / 3;
                    final v = ((_ctrl.value - delay) % 1.0);
                    final scale = v < 0.5 ? 0.6 + v * 0.8 : 1.0 - (v - 0.5) * 0.8;
                    return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 7, height: 7,
                      decoration: BoxDecoration(
                        color: scheme.onSurfaceVariant.withValues(alpha: 0.5 + scale * 0.5),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
