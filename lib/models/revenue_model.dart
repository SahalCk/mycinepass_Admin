class RevenueModel {
  final dynamic dailySale;
  final dynamic monthlySale;
  final dynamic yearlySale;
  final dynamic totalRevenue;
  final dynamic totalUsers;
  final dynamic totalTheaters;
  final dynamic runningMovies;
  final dynamic booked;
  final dynamic cancelled;
  double? bookedPercentage;
  double? cancelledPercentage;

  RevenueModel(
      this.dailySale,
      this.monthlySale,
      this.yearlySale,
      this.totalRevenue,
      this.totalUsers,
      this.totalTheaters,
      this.runningMovies,
      this.booked,
      this.cancelled) {
    int total = booked + cancelled;
    bookedPercentage = booked / total * 100;
    cancelledPercentage = cancelled / total * 100;
  }
}
