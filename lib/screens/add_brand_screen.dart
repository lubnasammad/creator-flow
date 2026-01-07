import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/brand_collaboration.dart';
import '../services/brand_collaboration_service.dart';
import '../services/session_manager.dart';

class AddBrandScreen extends StatefulWidget {
  final BrandCollaboration? collaboration;

  const AddBrandScreen({super.key, this.collaboration});

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _paymentController = TextEditingController();
  final _brandCollaborationService = BrandCollaborationService();
  final _sessionManager = SessionManager();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String _status = 'Pending';
  bool _isLoading = false;
  int? _userId;

  final List<String> _statusOptions = [
    'Pending',
    'Active',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId();
    if (widget.collaboration != null) {
      _brandNameController.text = widget.collaboration!.brandName;
      _descriptionController.text = widget.collaboration!.description ?? '';
      _paymentController.text = widget.collaboration!.payment.toString();
      _startDate = DateTime.parse(widget.collaboration!.startDate);
      _endDate = DateTime.parse(widget.collaboration!.endDate);
      _status = widget.collaboration!.status;
    }
  }

  Future<void> _loadUserId() async {
    final userId = await _sessionManager.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _descriptionController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_userId == null) {
      _showError('User session not found. Please login again.');
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      _showError('End date must be after start date.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final collaboration = BrandCollaboration(
        id: widget.collaboration?.id,
        userId: _userId!,
        brandName: _brandNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate),
        payment: double.parse(_paymentController.text.trim()),
        status: _status,
        createdAt:
            widget.collaboration?.createdAt ?? DateTime.now().toIso8601String(),
      );

      if (widget.collaboration == null) {
        await _brandCollaborationService.create(collaboration);
      } else {
        await _brandCollaborationService.update(collaboration);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.collaboration == null
                  ? 'Brand collaboration created!'
                  : 'Brand collaboration updated!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('An error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.collaboration == null
              ? 'Add Brand Collaboration'
              : 'Edit Brand Collaboration',
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brand Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _brandNameController,
                      decoration: InputDecoration(
                        labelText: 'Brand Name *',
                        prefixIcon: const Icon(Icons.business_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter brand name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _paymentController,
                      decoration: InputDecoration(
                        labelText: 'Payment Amount *',
                        prefixIcon: const Icon(Icons.attach_money_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter payment amount';
                        }
                        final payment = double.tryParse(value);
                        if (payment == null || payment < 0) {
                          return 'Please enter a valid payment amount';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collaboration Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectStartDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Start Date *',
                          prefixIcon: const Icon(Icons.event_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(_startDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectEndDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'End Date *',
                          prefixIcon: const Icon(
                            Icons.event_available_outlined,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(_endDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: InputDecoration(
                        labelText: 'Status *',
                        prefixIcon: const Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _statusOptions
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _status = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _handleSave,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.collaboration == null
                          ? 'Create Collaboration'
                          : 'Update Collaboration',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
