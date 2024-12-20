class FilterState {
  final String? selectedType;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedShopCodes;

  const FilterState({
    this.selectedType,
    this.selectedCategories = const [],
    this.minAmount,
    this.maxAmount,
    this.startDate,
    this.endDate,
    this.selectedShopCodes = const [],
  });

  FilterState copyWith({
    String? Function()? selectedType,
    List<String>? selectedCategories,
    double? Function()? minAmount,
    double? Function()? maxAmount,
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    List<String>? selectedShopCodes,
  }) {
    return FilterState(
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minAmount: minAmount != null ? minAmount() : this.minAmount,
      maxAmount: maxAmount != null ? maxAmount() : this.maxAmount,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      selectedShopCodes: selectedShopCodes ?? this.selectedShopCodes,
    );
  }

  bool get hasFilter =>
      selectedType != null ||
      selectedCategories.isNotEmpty ||
      minAmount != null ||
      maxAmount != null ||
      startDate != null ||
      endDate != null ||
      selectedShopCodes.isNotEmpty;

  FilterState clear() {
    return const FilterState();
  }
} 