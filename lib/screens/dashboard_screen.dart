import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';
import 'add_shooting_screen.dart';
import 'add_posting_screen.dart';
import 'add_brand_screen.dart';
import 'add_barter_screen.dart';
import 'shooting_list_screen.dart';
import 'posting_list_screen.dart';
import 'brand_list_screen.dart';
import 'barter_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _sessionManager = SessionManager();
  String _username = '';
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await _sessionManager.getUsername();
    setState(() {
      _username = username ?? 'User';
    });
  }

  Future<void> _handleLogout() async {
    await _sessionManager.clearSession();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Flow'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildCalendarView() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Lists',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hello, $_username!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: _onFormatChanged,
                    onPageChanged: _onPageChanged,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildSelectedDaySchedules(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.camera_alt_outlined,
                  label: 'Shooting',
                  color: Colors.purple,
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => const AddShootingScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.post_add_outlined,
                  label: 'Posting',
                  color: Colors.blue,
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => const AddPostingScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.handshake_outlined,
                  label: 'Brand',
                  color: Colors.orange,
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => const AddBrandScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.swap_horiz_outlined,
                  label: 'Barter',
                  color: Colors.teal,
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) => const AddBarterScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDaySchedules() {
    if (_selectedDay == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedules for ${_getSelectedDayText()}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No schedules for this day',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap + to add your first schedule',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Schedules & Collaborations',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildListCard(
                  context,
                  'Shooting Schedules',
                  'Manage your content shooting schedules',
                  Icons.camera_alt_outlined,
                  Colors.purple,
                  const ShootingListScreen(),
                ),
                const SizedBox(height: 12),
                _buildListCard(
                  context,
                  'Posting Schedules',
                  'Track your posting timelines',
                  Icons.post_add_outlined,
                  Colors.blue,
                  const PostingListScreen(),
                ),
                const SizedBox(height: 12),
                _buildListCard(
                  context,
                  'Brand Collaborations',
                  'View your paid brand partnerships',
                  Icons.handshake_outlined,
                  Colors.orange,
                  const BrandListScreen(),
                ),
                const SizedBox(height: 12),
                _buildListCard(
                  context,
                  'Barter Collaborations',
                  'Manage your barter deals',
                  Icons.swap_horiz_outlined,
                  Colors.teal,
                  const BarterListScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => screen));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSelectedDayText() {
    if (_selectedDay == null) return '';
    final now = DateTime.now();
    if (isSameDay(_selectedDay, now)) {
      return 'Today';
    } else if (isSameDay(_selectedDay, now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else {
      return '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}';
    }
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Add Shooting Schedule'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddShootingScreen(),
                  ),
                );
                if (result == true && mounted) {
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_outlined),
              title: const Text('Add Posting Schedule'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddPostingScreen(),
                  ),
                );
                if (result == true && mounted) {
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.handshake_outlined),
              title: const Text('Add Brand Collaboration'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddBrandScreen(),
                  ),
                );
                if (result == true && mounted) {
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_outlined),
              title: const Text('Add Barter Collaboration'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const AddBarterScreen(),
                  ),
                );
                if (result == true && mounted) {
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
