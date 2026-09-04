import 'package:flutter/material.dart';
import 'package:woodyz/features/products/presentation/providers/products_provider.dart';

class ReportDialog extends StatefulWidget {
  final String reporterId;
  final String reportedId;
  final String type; // 'product' or 'artisan'

  const ReportDialog({
    super.key,
    required this.reporterId,
    required this.reportedId,
    required this.type,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final List<String> _reasons = [
    "Inappropriate content",
    "Spam or misleading",
    "Harassment",
    "Intellectual property violation",
    "Other",
  ];
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final reason = _selectedReason == "Other" 
        ? _otherReasonController.text.trim() 
        : _selectedReason;

    if (reason == null || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a reason for reporting.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ProductsProvider().reportItem(
      reporterId: widget.reporterId,
      reportedId: widget.reportedId,
      type: widget.type,
      reason: reason,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report submitted successfully. Thank you for keeping Woodyz safe.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit report. Please try again later.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Report ${widget.type[0].toUpperCase()}${widget.type.substring(1)}",
        style: const TextStyle(fontFamily: "Saira", fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Why are you reporting this?",
              style: TextStyle(fontFamily: "Saira", fontSize: 14),
            ),
            const SizedBox(height: 16),
            ..._reasons.map((reason) => RadioListTile<String>(
              title: Text(reason, style: const TextStyle(fontSize: 14, fontFamily: "Saira")),
              value: reason,
              groupValue: _selectedReason,
              activeColor: theme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => setState(() => _selectedReason = value),
            )),
            if (_selectedReason == "Other") ...[
              const SizedBox(height: 8),
              TextField(
                controller: _otherReasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Tell us more...",
                  hintStyle: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("CANCEL", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSubmitting 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text("SUBMIT REPORT"),
        ),
      ],
    );
  }
}
