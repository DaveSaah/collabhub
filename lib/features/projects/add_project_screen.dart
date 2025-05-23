import 'package:collabhub/core/project_service.dart' show ProjectService;
import 'package:flutter/material.dart';
import 'package:collabhub/features/projects/my_project_screen.dart';
import 'package:collabhub/models/project.dart';

class AddProjectScreen extends StatefulWidget {
  final Project? projectToEdit;

  const AddProjectScreen({super.key, this.projectToEdit});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();
  final _skillsController = TextEditingController();

  bool _isSubmitting = false;
  bool _isEditMode = false;
  String? _projectId;
  final _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    // Check if we're in edit mode and populate fields
    if (widget.projectToEdit != null) {
      _isEditMode = true;
      _projectId = widget.projectToEdit!.id;
      _titleController.text = widget.projectToEdit!.title;
      _summaryController.text = widget.projectToEdit!.summary;
      _descriptionController.text = widget.projectToEdit!.description;
      _linkController.text = widget.projectToEdit!.link ?? '';
      _skillsController.text = widget.projectToEdit!.skills;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    final actionText = _isEditMode ? "Updated" : "Created";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Project $actionText!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your project "${_titleController.text}" has been successfully $actionText.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyProjectScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Go to My Projects',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        if (_isEditMode) {
          // Update existing project
          await _projectService.updateProject(
            projectId: _projectId!,
            title: _titleController.text,
            summary: _summaryController.text,
            description: _descriptionController.text,
            link: _linkController.text,
            skills: _skillsController.text,
          );
        } else {
          // Create new project
          await _projectService.createProject(
            title: _titleController.text,
            summary: _summaryController.text,
            description: _descriptionController.text,
            link: _linkController.text,
            skills: _skillsController.text,
          );
        }

        setState(() {
          _isSubmitting = false;
        });

        _showSuccessDialog();
      } catch (error) {
        setState(() {
          _isSubmitting = false;
        });

        final action = _isEditMode ? "update" : "create";
        _showErrorDialog('Failed to $action project: ${error.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionText = _isEditMode ? "Edit" : "Create New";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('$actionText Project'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEditMode
                        ? 'Update the information below to edit your project'
                        : 'Fill in the information below to create your new project',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  _buildLabel('Title'),
                  _buildTextField(
                    controller: _titleController,
                    hint: 'Enter project title',
                    validatorMsg: 'Please enter a project title',
                  ),
                  const SizedBox(height: 24),

                  // Summary
                  _buildLabel('Summary'),
                  _buildTextField(
                    controller: _summaryController,
                    hint: 'Brief summary of your project',
                    validatorMsg: 'Please enter a project summary',
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _buildLabel('Description'),
                  _buildTextField(
                    controller: _descriptionController,
                    hint: 'Detailed description of your project',
                    validatorMsg: 'Please enter a project description',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),

                  // Skills Required
                  _buildLabel('Skills Required'),
                  _buildTextField(
                    controller: _skillsController,
                    hint: 'e.g., Flutter, Firebase, UI/UX',
                    validatorMsg: 'Please enter required skills',
                  ),
                  const SizedBox(height: 24),

                  // Project Link
                  _buildLabel('Project Link'),
                  TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      hintText: 'https://',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.link),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a project link';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                _isEditMode
                                    ? 'Update Project'
                                    : 'Create Project',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }
}
