import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _courseController = TextEditingController();

  bool _isFormSubmitted = false;
  bool _isCompleted = false;

  // the "sticky" chip currently just stays wherever you last left it, anywhere on its card.
  
  final _boardKey = GlobalKey();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    setState(() => _isFormSubmitted = true);
  }

  void _editForm() {
    setState(() {
      _isFormSubmitted = false;
      _isCompleted = false;
    });
  }

  void _handleDrop() {
    setState(() => _isCompleted = true);
  }

  void _reset() {
    setState(() {
      _isCompleted = false;
      _isFormSubmitted = false;
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _studentIdController.clear();
      _courseController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('You\'re In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1B2128),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            Text(
              'Welcome!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B2128),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You unlocked this screen by dragging the handle on '
              'the previous one. Fill in the registration form below, '
              'then drag the task card into the drop zone to finish '
              'onboarding.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            _SectionLabel(
              icon: Icons.school_outlined,
              text: 'Student Registration',
            ),
            const SizedBox(height: 12),
            _RegistrationForm(
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              studentIdController: _studentIdController,
              courseController: _courseController,
              enabled: !_isFormSubmitted,
            ),
            const SizedBox(height: 16),

            if (!_isFormSubmitted)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F7CFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save details'),
                ),
              )
            else
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Details saved',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _editForm,
                    child: const Text('Edit'),
                  ),
                ],
              ),

            const SizedBox(height: 36),
            const Divider(height: 1),
            const SizedBox(height: 28),

            _SectionLabel(
              icon: Icons.task_alt_outlined,
              text: 'Finish Onboarding',
            ),
            const SizedBox(height: 16),

            // The draggable task card. Free movement (not axis-locked),Disabled until the form is submitted.
            if (!_isCompleted)
              Center(
                child: Opacity(
                  opacity: _isFormSubmitted ? 1 : 0.4,
                  child: IgnorePointer(
                    ignoring: !_isFormSubmitted,
                    child: Draggable<String>(
                      data: 'task_card',
                      feedback: const _TaskCard(dragging: true),
                      childWhenDragging: const Opacity(
                        opacity: 0.3,
                        child: _TaskCard(dragging: false),
                      ),
                      child: const _TaskCard(dragging: false),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Task completed',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            if (!_isFormSubmitted && !_isCompleted)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    'Save your details first to unlock dragging',
                    style: TextStyle(color: Colors.black38, fontSize: 13),
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // The drop target "bin".
            DragTarget<String>(
              onWillAcceptWithDetails: (_) => _isFormSubmitted && !_isCompleted,
              onAcceptWithDetails: (_) => _handleDrop(),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? Colors.green.withOpacity(0.08)
                        : Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHovering ? Colors.green : Colors.black12,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        color: isHovering ? Colors.green : Colors.black38,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Drop here to complete',
                        style: TextStyle(
                          color: isHovering ? Colors.green.shade700 : Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 36),
            const Divider(height: 1),
            const SizedBox(height: 28),

            _SectionLabel(
              icon: Icons.push_pin_outlined,
              text: 'Drag Anywhere & Stick',
            ),
            const SizedBox(height: 8),
            Text(
              'A third drag style: no drop zone needed. Drag the chip '
              'anywhere on the board below and it stays exactly where '
              'you leave it.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // The "board" the sticky chip can be dragged around on.
            Container(
              key: _boardKey,
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned(
                    left: _stickyPosition.dx,
                    top: _stickyPosition.dy,
                    child: Draggable<String>(
                      data: 'sticky_chip',
                      feedback: const _StickyChip(),
                      childWhenDragging: const SizedBox.shrink(),
                      onDragEnd: (details) {
                        // details.offset is in GLOBAL screen coordinates. Convert to the board's local coordinates so the chip lands under the finger instead of jumping.
                        final box =
                            _boardKey.currentContext!.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(details.offset);
                        setState(() {
                          // Keep the chip inside the board's bounds.
                          _stickyPosition = Offset(
                            local.dx.clamp(0, box.size.width - 90),
                            local.dy.clamp(0, box.size.height - 40),
                          );
                        });
                      },
                      child: const _StickyChip(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_isCompleted)
              Center(
                child: TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset demo'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small label used to title each section of the screen (registration vs. the drag-to-finish step).
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4F7CFF)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF1B2128),
          ),
        ),
      ],
    );
  }
}

/// The student registration form: name, email, student ID, and course. Kept as its own widget so SecondScreen stays readable. 
class _RegistrationForm extends StatelessWidget {
  const _RegistrationForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.studentIdController,
    required this.courseController,
    required this.enabled,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController studentIdController;
  final TextEditingController courseController;
  final bool enabled;

  static const _emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            enabled: enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: emailController,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(_emailPattern).hasMatch(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: studentIdController,
            enabled: enabled,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your student ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: courseController,
            enabled: enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Course / Program',
              prefixIcon: Icon(Icons.menu_book_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your course';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

/// The chip used in the "drag anywhere and stick" section. 
class _StickyChip extends StatelessWidget {
  const _StickyChip();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 90,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF4F7CFF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Drag me',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// The card the user drags toward the drop zone.
class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.dragging});

  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(dragging ? 0.18 : 0.08),
              blurRadius: dragging ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.drag_indicator, color: Colors.black38),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Finish onboarding',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
