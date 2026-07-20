// Disaster Preparedness & Response — Advanced App
// Copy this entire file into DartPad (dartpad.dev), switch to "Flutter" mode,
// and press Run. Single file, no external packages required.

import 'package:flutter/material.dart';

void main() => runApp(const DisasterPrepApp());

// ---------------------------------------------------------------------------
// ROOT APP
// ---------------------------------------------------------------------------

class DisasterPrepApp extends StatefulWidget {
  const DisasterPrepApp({super.key});
  @override
  State<DisasterPrepApp> createState() => _DisasterPrepAppState();
}

class _DisasterPrepAppState extends State<DisasterPrepApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Preparedness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1F3864),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B8DEF),
        brightness: Brightness.dark,
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeShell(
        darkMode: darkMode,
        onToggleDark: (v) => setState(() => darkMode = v),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DATA MODELS
// ---------------------------------------------------------------------------

enum Priority { high, medium, low }

extension PriorityX on Priority {
  String get label => switch (this) {
        Priority.high => 'High',
        Priority.medium => 'Medium',
        Priority.low => 'Low',
      };
  Color get color => switch (this) {
        Priority.high => Colors.red.shade600,
        Priority.medium => Colors.orange.shade700,
        Priority.low => Colors.green.shade600,
      };
}

class ChecklistItem {
  final String label;
  Priority priority;
  bool done;
  String notes;
  ChecklistItem(this.label,
      {this.priority = Priority.medium, this.done = false, this.notes = ''});
}

class ChecklistCategory {
  final String title;
  final IconData icon;
  final List<ChecklistItem> items;
  ChecklistCategory(this.title, this.icon, this.items);
  double get progress =>
      items.isEmpty ? 0 : items.where((i) => i.done).length / items.length;
}

class HazardGuide {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> steps;
  HazardGuide(this.name, this.icon, this.color, this.steps);
}

class EmergencyContact {
  final String name;
  final String role;
  final String phone;
  EmergencyContact(this.name, this.role, this.phone);
}

class DrillLog {
  final String type;
  final DateTime date;
  final String notes;
  DrillLog(this.type, this.date, this.notes);
}

// ---------------------------------------------------------------------------
// SHARED APP DATA (in-memory "store")
// ---------------------------------------------------------------------------

class AppData {
  static final List<ChecklistCategory> categories = [
    ChecklistCategory('Mitigation & Prevention', Icons.shield_outlined, [
      ChecklistItem('Building safety inspection completed',
          priority: Priority.high),
      ChecklistItem('Fire suppression systems & smoke detectors checked',
          priority: Priority.high),
      ChecklistItem('Visitor sign-in / access control system in place',
          priority: Priority.medium),
      ChecklistItem('Threat assessment team established',
          priority: Priority.medium),
    ]),
    ChecklistCategory('Preparedness', Icons.backpack_outlined, [
      ChecklistItem('Classroom emergency kits stocked', priority: Priority.high),
      ChecklistItem('Building-wide emergency supply cache stocked',
          priority: Priority.high),
      ChecklistItem('AED locations identified and checked',
          priority: Priority.high),
      ChecklistItem('Backup communication devices tested',
          priority: Priority.medium),
      ChecklistItem('Staff completed annual emergency training',
          priority: Priority.medium),
      ChecklistItem('Family emergency communication plan distributed',
          priority: Priority.low),
    ]),
    ChecklistCategory('Drills Scheduled', Icons.event_repeat_outlined, [
      ChecklistItem('Fire evacuation drill completed', priority: Priority.high),
      ChecklistItem('Lockdown / active threat drill completed',
          priority: Priority.high),
      ChecklistItem('Shelter-in-place / severe weather drill completed',
          priority: Priority.medium),
      ChecklistItem('Earthquake drop-cover-hold drill completed',
          priority: Priority.medium),
      ChecklistItem('Full-scale tabletop exercise completed',
          priority: Priority.low),
    ]),
    ChecklistCategory('Response Readiness', Icons.emergency_outlined, [
      ChecklistItem('Incident Commander & backup assigned',
          priority: Priority.high),
      ChecklistItem('Communications Officer & backup assigned',
          priority: Priority.high),
      ChecklistItem('Medical/First Aid Lead & backup assigned',
          priority: Priority.high),
      ChecklistItem('Evacuation routes posted in every room',
          priority: Priority.medium),
      ChecklistItem('Assembly point & reunification site confirmed',
          priority: Priority.medium),
    ]),
    ChecklistCategory('Recovery', Icons.healing_outlined, [
      ChecklistItem('Post-incident facility inspection process defined',
          priority: Priority.low),
      ChecklistItem('Counseling / mental health support plan in place',
          priority: Priority.medium),
      ChecklistItem('After-action review process defined',
          priority: Priority.low),
    ]),
  ];

  static final List<HazardGuide> hazards = [
    HazardGuide('Fire', Icons.local_fire_department, Colors.deepOrange, [
      'Activate the nearest fire alarm pull station.',
      'Evacuate immediately via the posted route — do not use elevators.',
      'Close doors behind you to slow fire spread.',
      'Proceed to the designated assembly point.',
      'Take attendance and report anyone missing to the Incident Commander.',
      'Do not re-enter the building until cleared by the fire department.',
    ]),
    HazardGuide('Lockdown / Active Threat', Icons.lock_outline, Colors.red, [
      'Announce the lockdown code over the PA system.',
      'Lock and barricade doors; turn off lights.',
      'Move away from windows and doors; stay silent.',
      'Silence phones; do not open the door for anyone.',
      'Wait for an official all-clear from law enforcement.',
    ]),
    HazardGuide('Earthquake', Icons.public, Colors.brown, [
      'Drop to the ground immediately.',
      'Take Cover under sturdy furniture.',
      'Hold On until the shaking completely stops.',
      'Stay away from windows and heavy objects.',
      'After shaking stops, check for injuries and structural damage before evacuating.',
    ]),
    HazardGuide('Severe Weather', Icons.thunderstorm, Colors.indigo, [
      'Move to designated interior shelter areas away from windows.',
      'Get low and cover your head and neck.',
      'Stay in shelter until the all-clear is announced.',
      'Monitor official weather alerts for updates.',
    ]),
    HazardGuide('Medical Emergency', Icons.medical_services, Colors.pink, [
      'Call 911 immediately.',
      'Notify the Medical/First Aid Lead.',
      'Begin first aid or CPR if trained and safe to do so.',
      'Retrieve the nearest AED if needed.',
      'Keep the area clear until EMS arrives.',
    ]),
    HazardGuide('Hazmat / Air Quality', Icons.masks_outlined, Colors.teal, [
      'Shelter-in-place; seal doors and windows.',
      'Shut down HVAC systems if instructed.',
      'Avoid the affected area; do not evacuate outdoors unless told to.',
      'Wait for guidance from emergency responders.',
    ]),
  ];

  static final List<EmergencyContact> contacts = [
    EmergencyContact('Emergency Services', 'Fire / Police / EMS', '911'),
    EmergencyContact('[Name]', 'Non-Emergency Police', '[Phone]'),
    EmergencyContact('[Name]', 'Local Fire Department', '[Phone]'),
    EmergencyContact('[Name]', 'District Superintendent\'s Office', '[Phone]'),
    EmergencyContact('[Name]', 'School Nurse', '[Phone]'),
    EmergencyContact('[Name]', 'Local Emergency Management Agency', '[Phone]'),
  ];

  static final List<DrillLog> drillLogs = [];
}

// ---------------------------------------------------------------------------
// HOME SHELL — bottom navigation across 4 tabs
// ---------------------------------------------------------------------------

class HomeShell extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleDark;
  const HomeShell({super.key, required this.darkMode, required this.onToggleDark});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;

  final titles = const [
    'Readiness Checklist',
    'Hazard Response Guide',
    'Emergency Contacts',
    'Drill Tracker',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[tab]),
        centerTitle: false,
        actions: [
          Row(
            children: [
              Icon(widget.darkMode ? Icons.dark_mode : Icons.light_mode, size: 20),
              Switch(value: widget.darkMode, onChanged: widget.onToggleDark),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: const [
          ChecklistTab(),
          HazardGuideTab(),
          ContactsTab(),
          DrillTrackerTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Checklist'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Guide'),
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.event_note), label: 'Drills'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 1 — CHECKLIST (search, priority, notes, progress)
// ---------------------------------------------------------------------------

class ChecklistTab extends StatefulWidget {
  const ChecklistTab({super.key});
  @override
  State<ChecklistTab> createState() => _ChecklistTabState();
}

class _ChecklistTabState extends State<ChecklistTab> {
  String query = '';

  int get totalItems =>
      AppData.categories.fold(0, (s, c) => s + c.items.length);
  int get doneItems => AppData.categories.fold(
      0, (s, c) => s + c.items.where((i) => i.done).length);
  double get overallProgress => totalItems == 0 ? 0 : doneItems / totalItems;

  List<ChecklistCategory> get filtered {
    if (query.isEmpty) return AppData.categories;
    final q = query.toLowerCase();
    return AppData.categories
        .map((c) => ChecklistCategory(
            c.title,
            c.icon,
            c.items.where((i) => i.label.toLowerCase().contains(q)).toList()))
        .where((c) => c.items.isNotEmpty)
        .toList();
  }

  void _editNotes(ChecklistItem item) async {
    final controller = TextEditingController(text: item.notes);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.label),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Add a note...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save')),
        ],
      ),
    );
    if (result != null) setState(() => item.notes = result);
  }

  void _cyclePriority(ChecklistItem item) {
    setState(() {
      item.priority = switch (item.priority) {
        Priority.high => Priority.medium,
        Priority.medium => Priority.low,
        Priority.low => Priority.high,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final percent = (overallProgress * 100).round();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overall Readiness',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('$percent%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Text('$doneItems of $totalItems items complete',
                      style: TextStyle(color: Colors.white.withOpacity(0.85))),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: overallProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search checklist items...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            children: filtered.map((category) {
              final pct = (category.progress * 100).round();
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Icon(category.icon,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text(category.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: category.progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(
                              category.progress == 1.0
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    trailing: Text('$pct%'),
                    children: category.items.map((item) {
                      return ListTile(
                        leading: Checkbox(
                          value: item.done,
                          onChanged: (v) => setState(() => item.done = v ?? false),
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            decoration: item.done ? TextDecoration.lineThrough : null,
                            color: item.done ? Colors.grey : null,
                          ),
                        ),
                        subtitle: item.notes.isNotEmpty
                            ? Text(item.notes,
                                style: const TextStyle(fontStyle: FontStyle.italic))
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => _cyclePriority(item),
                              child: Chip(
                                label: Text(item.priority.label,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11)),
                                backgroundColor: item.priority.color,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_note, size: 20),
                              onPressed: () => _editNotes(item),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 2 — HAZARD RESPONSE GUIDE (step-by-step, per-hazard)
// ---------------------------------------------------------------------------

class HazardGuideTab extends StatelessWidget {
  const HazardGuideTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: AppData.hazards.length,
      itemBuilder: (context, index) {
        final h = AppData.hazards[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: h.color.withOpacity(0.15),
                child: Icon(h.icon, color: h.color),
              ),
              title: Text(h.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              children: h.steps.asMap().entries.map((entry) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: h.color,
                    child: Text('${entry.key + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  title: Text(entry.value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 3 — EMERGENCY CONTACTS (tap to view / simulate call)
// ---------------------------------------------------------------------------

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: AppData.contacts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final c = AppData.contacts[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(c.name),
            subtitle: Text(c.role),
            trailing: TextButton.icon(
              icon: const Icon(Icons.call, size: 18),
              label: Text(c.phone),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Would call ${c.phone} (${c.name})')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// TAB 4 — DRILL TRACKER (log drills with date, see history)
// ---------------------------------------------------------------------------

class DrillTrackerTab extends StatefulWidget {
  const DrillTrackerTab({super.key});
  @override
  State<DrillTrackerTab> createState() => _DrillTrackerTabState();
}

class _DrillTrackerTabState extends State<DrillTrackerTab> {
  final drillTypes = const [
    'Fire Evacuation',
    'Lockdown / Active Threat',
    'Shelter-in-Place',
    'Earthquake',
    'Tabletop Exercise',
  ];

  Future<void> _logDrill() async {
    String selectedType = drillTypes.first;
    DateTime selectedDate = DateTime.now();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Log a Drill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: selectedType,
                items: drillTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(hintText: 'Notes (optional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                setState(() {
                  AppData.drillLogs.add(
                      DrillLog(selectedType, selectedDate, notesController.text));
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logs = List<DrillLog>.from(AppData.drillLogs)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _logDrill,
        icon: const Icon(Icons.add),
        label: const Text('Log Drill'),
      ),
      body: logs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text('No drills logged yet', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              itemCount: logs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final d = logs[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.check)),
                    title: Text(d.type),
                    subtitle: Text(
                      '${d.date.month}/${d.date.day}/${d.date.year}'
                      '${d.notes.isNotEmpty ? ' — ${d.notes}' : ''}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
