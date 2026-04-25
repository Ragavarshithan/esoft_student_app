import 'package:flutter/material.dart';

class NewMarksScreen extends StatefulWidget {
  const NewMarksScreen({super.key});

  @override
  State<NewMarksScreen> createState() => _NewMarksScreenState();
}
final TextEditingController _marksController = TextEditingController();
class _NewMarksScreenState extends State<NewMarksScreen> {
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
        title: const Text("Module Marks"),
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
              "MARKS REGISTRY",
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
                _chip(Icons.calendar_today, "Monday, 23 October 2023"),
                const SizedBox(width: 10),
                _chip(Icons.access_time, "10:00 AM"),
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
                          Container(
                            width: 60,
                            height: 40,
                            color: Colors.grey.shade200,
                            child: TextFormField(
                              controller: _marksController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "",
                              ),
                            ),
                          )
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
                  backgroundColor: const Color(0xFF0D1B2A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.people),
                label: const Text("SUBMIT ATTENDANCE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
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