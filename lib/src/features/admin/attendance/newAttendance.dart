import 'package:flutter/material.dart';

class NewAttendanceScreen extends StatefulWidget {
  const NewAttendanceScreen({super.key});

  @override
  State<NewAttendanceScreen> createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends State<NewAttendanceScreen> {
  DateTime _selectedDate = DateTime(2026, 04, 26);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  List<Map<String, dynamic>> students = [
    {
      "name": "Alexander Vance",
      "id": "STD_88291",
      "email": "vance.a@esoft.edu",
      "present": true
    },
    {
      "name": "Elena Rodriguez",
      "id": "STD_88304",
      "email": "rodriguez.e@esoft.edu",
      "present": false
    },
    {
      "name": "Julian Thorne",
      "id": "STD_88412",
      "email": "thorne.j@esoft.edu",
      "present": null
    },
    {
      "name": "Sophia Lin",
      "id": "STD_88556",
      "email": "lin.s@esoft.edu",
      "present": true
    },
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  void markAllPresent() {
    setState(() {
      for (var s in students) {
        s["present"] = true;
      }
    });
  }

  void setAttendance(int index, bool value) {
    setState(() {
      students[index]["present"] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Module Attendance"),
        actions: const [
          Icon(Icons.more_vert),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ATTENDANCE REGISTRY",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Advanced\nMacroeconomics",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// Date + Time
            Row(
              children: [
                _tappableChip(
                  icon: Icons.calendar_today,
                  text: _formatDate(_selectedDate),
                  onTap: _pickDate,
                ),
                const SizedBox(width: 10),
                _tappableChip(
                  icon: Icons.access_time,
                  text: _formatTime(_selectedTime),
                  onTap: _pickTime,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search student name or ID...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student Roll (${students.length})",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: markAllPresent,
                  child: const Text("MARK ALL PRESENT"),
                )
              ],
            ),

            const SizedBox(height: 10),

            /// List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final s = students[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 12),

                        /// Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                s["id"],
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                s["email"],
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        /// Actions
                        Row(
                          children: [
                            _statusButton(
                              icon: Icons.check,
                              color: Colors.green,
                              active: s["present"] == true,
                              onTap: () => setAttendance(index, true),
                            ),
                            const SizedBox(width: 8),
                            _statusButton(
                              icon: Icons.close,
                              color: Colors.red,
                              active: s["present"] == false,
                              onTap: () => setAttendance(index, false),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.check_box_outlined, color: Colors.white),
                label: const Text("SUBMIT ATTENDANCE", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tappableChip({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E3A8A).withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1E3A8A)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.edit, size: 11, color: Color(0xFF1E3A8A)),
          ],
        ),
      ),
    );
  }

  Widget _statusButton({
    required IconData icon,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18, color: active ? color : Colors.grey.shade600),
      ),
    );
  }
}