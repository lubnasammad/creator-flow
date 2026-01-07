import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/barter_collaboration.dart';
import '../services/barter_collaboration_service.dart';
import '../services/session_manager.dart';

class AddBarterScreen extends StatefulWidget {
  final BarterCollaboration? collaboration;

  const AddBarterScreen({super.key, this.collaboration});

  @override
  State<AddBarterScreen> createState() => _AddBarterScreenState();
}

class _AddBarterScreenState extends State<AddBarterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productValueController = TextEditingController();
  final _barterCollaborationService = BarterCollaborationService();
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
      _productValueController.text = widget.collaboration!.productValue
          .toString();
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
    _productValueController.dispose();
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
      final collaboration = BarterCollaboration(
        id: widget.collaboration?.id,
        userId: _userId!,
        brandName: _brandNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        productValue: double.parse(_productValueController.text.trim()),
        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate),
        status: _status,
        createdAt:
            widget.collaboration?.createdAt ?? DateTime.now().toIso8601String(),
      );

      if (widget.collaboration == null) {
        await _barterCollaborationService.create(collaboration);
      } else {
        await _barterCollaborationService.update(collaboration);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.collaboration == null
                  ? 'Barter collaboration created!'
                  : 'Barter collaboration updated!',
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
              ? 'Add Barter Collaboration'
              : 'Edit Barter Collaboration',
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
                        labelText: 'Description (Product/Service received)',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'What did you receive in exchange?',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _productValueController,
                      decoration: InputDecoration(
                        labelText: 'Estimated Product Value *',
                        prefixIcon: const Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText:
                            'Estimated market value of products/services',
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
                          return 'Please enter product value';
                        }
                        final productValue = double.tryParse(value);
                        if (productValue == null || productValue < 0) {
                          return 'Please enter a valid product value';
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
