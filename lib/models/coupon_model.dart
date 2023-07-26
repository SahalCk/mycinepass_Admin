class CouponModel {
  final String couponCode;
  final String couponDescription;
  final DateTime expDate;
  final String selectedOption;
  final String? discountAmount;
  final String? discountPercentage;
  final String? uptoAmount;
  final String minAmount;

  CouponModel(
      this.couponCode,
      this.couponDescription,
      this.expDate,
      this.selectedOption,
      this.discountAmount,
      this.discountPercentage,
      this.uptoAmount,
      this.minAmount);
}
