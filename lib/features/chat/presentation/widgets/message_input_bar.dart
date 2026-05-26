import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class MessageInputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInputBar({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateSendState);
  }

  void _updateSendState() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _canSend) {
      setState(() {
        _canSend = hasText;
      });
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  void _wrapSelection(String prefix, String suffix) {
    final text = _controller.text;
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);

    final newText = text.replaceRange(start, end, '$prefix$selectedText$suffix');

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start + prefix.length,
        extentOffset: start + prefix.length + selectedText.length,
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSendState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                style: AppTextStyles.bodyText.copyWith(color: colorScheme.onSurface, fontSize: 16),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                  final List<ContextMenuButtonItem> buttonItems = editableTextState.contextMenuButtonItems;
                  buttonItems.addAll([
                    ContextMenuButtonItem(
                      label: 'Жирный',
                      onPressed: () {
                        editableTextState.hideToolbar();
                        _wrapSelection('**', '**');
                      },
                    ),
                    ContextMenuButtonItem(
                      label: 'Курсив',
                      onPressed: () {
                        editableTextState.hideToolbar();
                        _wrapSelection('*', '*');
                      },
                    ),
                    ContextMenuButtonItem(
                      label: 'Заголовок',
                      onPressed: () {
                        editableTextState.hideToolbar();
                        _wrapSelection('# ', '');
                      },
                    ),
                    ContextMenuButtonItem(
                      label: 'Цитата',
                      onPressed: () {
                        editableTextState.hideToolbar();
                        _wrapSelection('> ', '');
                      },
                    ),
                  ]);

                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: buttonItems,
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Сообщение...',
                  hintStyle: AppTextStyles.bodyText.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _canSend ? _handleSend : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _canSend ? colorScheme.primary : colorScheme.primary.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}