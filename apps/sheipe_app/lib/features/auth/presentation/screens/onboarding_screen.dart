import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../data/local/auth_local_data_source.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _Slide(title: 'Track Your Workouts', body: 'Log every session and monitor your progress.'),
    _Slide(title: 'Work With a Trainer', body: 'Get personalized plans from certified coaches.'),
    _Slide(title: 'Share Your Journey', body: 'Celebrate milestones with your community.'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    await GetIt.I<AuthLocalDataSource>().markOnboardingSeen();
    if (mounted) context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _SlideWidget(slide: _slides[i]),
              ),
            ),
            _Dots(count: _slides.length, current: _currentPage),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentPage == _slides.length - 1
                      ? _onGetStarted
                      : () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                  child: Text(_currentPage == _slides.length - 1 ? 'Get Started' : 'Next'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({required this.title, required this.body});
  final String title;
  final String body;
}

class _SlideWidget extends StatelessWidget {
  const _SlideWidget({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80),
            const SizedBox(height: 32),
            Text(slide.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(slide.body, textAlign: TextAlign.center),
          ],
        ),
      );
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == current ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == current ? Theme.of(context).colorScheme.primary : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
}
