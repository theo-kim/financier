final List<String> month = <String>[
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

abstract class DateFormatter {
  String formatDate(DateTime d);
  String getName() {
    return formatDate(DateTime(2000, 8, 1));
  }

  static Map<String, DateFormatter> available = {
    MilitaryDateFormatter().getName(): MilitaryDateFormatter(),
  };

  static DateFormatter getAvailable(String? key) {
    if (key != null && available.containsKey(key)) {
      return available[key]!;
    }
    return MilitaryDateFormatter();
  }
}

class MilitaryDateFormatter extends DateFormatter {
  @override
  String formatDate(DateTime d) {
    return "${d.day} ${month[d.month]} ${d.year}";
  }
}
