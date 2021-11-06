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

bool _validMonth(String m) {
  return month.contains(m);
}

abstract class DateFormatter {
  String formatDate(DateTime d);
  DateTime unformatDate(String d);
  String getName() {
    return formatDate(DateTime(2000, 8, 1));
  }

  static Map<String, DateFormatter> available = {
    MilitaryDateFormatter().getName(): MilitaryDateFormatter(),
    StandardDateFormatter().getName(): StandardDateFormatter(),
  };

  static DateFormatter getAvailable(String? key) {
    if (key != null && available.containsKey(key)) {
      return available[key]!;
    }
    return MilitaryDateFormatter();
  }

  @override
  bool operator ==(Object other) => other.hashCode == this.hashCode;

  @override
  int get hashCode => getName().hashCode;
}

class MilitaryDateFormatter extends DateFormatter {
  @override
  String formatDate(DateTime d) {
    return "${d.day} ${(month[d.month - 1])} ${d.year}";
  }

  @override
  DateTime unformatDate(String d) {
    final parsed = d.split(" ");
    if (parsed.length != 3 ||
        int.tryParse(parsed[2]) == null ||
        int.tryParse(parsed[0]) == null ||
        !_validMonth(parsed[1])) {
      throw "Invalid date input string";
    }
    return DateTime(int.parse(parsed[2]), month.indexOf(parsed[1]) + 1,
        int.parse(parsed[0]));
  }
}

class StandardDateFormatter extends DateFormatter {
  @override
  String formatDate(DateTime d) {
    return "${d.month}/${d.day}/${d.year}";
  }

  @override
  DateTime unformatDate(String d) {
    final parsed = d.split("/");
    if (parsed.length != 3 ||
        int.tryParse(parsed[2]) == null ||
        int.tryParse(parsed[0]) == null ||
        int.tryParse(parsed[1]) == null) {
      throw "Invalid date input string";
    }
    return DateTime(
        int.parse(parsed[2]), int.parse(parsed[0]), int.parse(parsed[1]));
  }
}
