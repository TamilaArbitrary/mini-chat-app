import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const FiltersScreen({super.key, this.initialFilters});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String selectedGender = "all";    
  RangeValues ageRange = const RangeValues(18, 28);
  double distance = 50;             

  final Map<String, int> _genderOptionsMap = {
    "male": 0,    
    "female": 1,  
    "all": 2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1B1918), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Filters",
          style: TextStyle(
            color: Color(0xFF1B1918),
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedGender = "all";
                ageRange = const RangeValues(18, 28);
                distance = 0;
              });
            },
            child: const Text(
              "Clear",
              style: TextStyle(
                color: Color(0xFF1B1918),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "I want to see",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            _buildGenderSelector(),
            const Divider(height: 40, thickness: 1.2),
            _buildAgeFilter(),
            const Divider(height: 40, thickness: 1.2),
            _buildDistanceFilter(),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildGenderSelector() {
  final int selectedIndex = _genderOptionsMap[selectedGender] ?? 2;
  const int totalOptions = 3;

  return LayoutBuilder(
    builder: (context, constraints) {
      final double itemWidth = constraints.maxWidth / totalOptions;

      return Container(
        height: 55,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF3F3F3),
        ),
        child: Stack(
          children: [
            // Анімована підсвітка
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: itemWidth * selectedIndex,
              top: 0,
              bottom: 0,
              child: Container(
                width: itemWidth - 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.06).round()),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Кнопки
            Row(
              children: [
                _genderOption("male", "Men"),
                _genderOption("female", "Women"),
                _genderOption("all", "Everyone"),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _genderOption(String value, String text) {
  final bool active = selectedGender == value;

  return Expanded(
    child: GestureDetector(
      onTap: () => setState(() => selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: active ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildAgeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.cake, size: 20),
                SizedBox(width: 6),
                Text(
                  "Age",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              "${ageRange.start.round()} - ${ageRange.end.round()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RangeSlider(
                values: ageRange,
                min: 18,
                max: 60,
                activeColor: const Color(0xFF1B1918),
                inactiveColor: Colors.grey.shade300,
                onChanged: (val) => setState(() => ageRange = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 6),
                Text(
                  "Distance (km)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              distance == 0 ? "Whole country" : "${distance.round()} km",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: distance,
                min: 0,
                max: 300,
                activeColor: const Color(0xFF1B1918),
                inactiveColor: Colors.grey.shade300,
                onChanged: (val) => setState(() => distance = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, -1),
            color: Colors.black12,
          )
        ],
      ),
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, {
              "gender": selectedGender,
              "age_min": ageRange.start.round(),
              "age_max": ageRange.end.round(),
              "distance": distance.round(),
            });
          },
          child: const Text(
            "Save",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF3F3F3)),
          ),
        ),
      ),
    );
  }
}
