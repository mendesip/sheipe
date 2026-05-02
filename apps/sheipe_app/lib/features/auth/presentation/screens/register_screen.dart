import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _step1Key = GlobalKey<FormState>();
  String _selectedRole = 'athlete';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (_step1Key.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    await context.read<AuthViewModel>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmController.text,
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocConsumer<AuthViewModel, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _Step1(
                formKey: _step1Key,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmController: _confirmController,
                onNext: _goToStep2,
                error: state is AuthError ? state.message : null,
              ),
              _Step2(
                selectedRole: _selectedRole,
                onRoleChanged: (r) => setState(() => _selectedRole = r),
                onSubmit: state is AuthLoading ? null : _submit,
                isLoading: state is AuthLoading,
                error: state is AuthError ? state.message : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  const _Step1({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.onNext,
    this.error,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final VoidCallback onNext;
  final String? error;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (v) => v != passwordController.text ? 'Passwords must match' : null,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onNext, child: const Text('Next')),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/auth/login'),
                child: const Text('Already have an account?'),
              ),
            ],
          ),
        ),
      );
}

class _Step2 extends StatelessWidget {
  const _Step2({
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSubmit,
    required this.isLoading,
    this.error,
  });

  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('I am a...', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            _RoleTile(
              label: 'Athlete',
              subtitle: 'Track workouts and follow plans',
              value: 'athlete',
              selected: selectedRole == 'athlete',
              onTap: () => onRoleChanged('athlete'),
            ),
            const SizedBox(height: 12),
            _RoleTile(
              label: 'Trainer',
              subtitle: 'Manage athletes and create plans',
              value: 'trainer',
              selected: selectedRole == 'trainer',
              onTap: () => onRoleChanged('trainer'),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: onSubmit,
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Account'),
            ),
          ],
        ),
      );
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.grey,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
}
