import 'package:cinepass_admin/controllers/view_revenue_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/bookings_section/screen_view_bookings.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_revenue_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewRevenueScreen extends StatelessWidget {
  const ViewRevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revenueController =
        Provider.of<ViewRevenueController>(context, listen: false);
    revenueController.getAllValues();
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar:
                appBar.cinePassAppBar(context: context, title: 'View Revenue'),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: FutureBuilder(
                  future: revenueController.getAllValues(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Column(children: [
                          sizedBoxHeight20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CinePassRevenueTop(
                                  title: 'Daily Sale',
                                  value: snapshot.data!.dailySale.toString()),
                              CinePassRevenueTop(
                                  title: 'Monthly Sale',
                                  value: snapshot.data!.monthlySale.toString()),
                              CinePassRevenueTop(
                                  title: 'Yearly Sale',
                                  value: snapshot.data!.yearlySale.toString()),
                            ],
                          ),
                          sizedBoxHeight20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GlassmorphicContainer(
                                  width: Adaptive.w(60),
                                  height: Adaptive.h(31),
                                  borderRadius: 8,
                                  blur: 20,
                                  alignment: Alignment.bottomCenter,
                                  border: 1,
                                  linearGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color.fromRGBO(84, 168, 229, 0.1)
                                            .withOpacity(0.1),
                                        const Color(0xFFFFFFFF)
                                            .withOpacity(0.05),
                                      ]),
                                  borderGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFffffff).withOpacity(0.5),
                                      const Color((0xFFFFFFFF))
                                          .withOpacity(0.5),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Adaptive.h(26.5),
                                        width: Adaptive.w(100),
                                        child: Consumer<ViewRevenueController>(
                                          builder: (context, value, child) {
                                            return PieChart(
                                              PieChartData(
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  pieTouchData: PieTouchData(
                                                      touchCallback:
                                                          (FlTouchEvent event,
                                                              pieTouchResponse) {
                                                    if (!event
                                                            .isInterestedForInteractions ||
                                                        pieTouchResponse ==
                                                            null ||
                                                        pieTouchResponse
                                                                .touchedSection ==
                                                            null) {
                                                      Provider.of<ViewRevenueController>(
                                                              context,
                                                              listen: false)
                                                          .changeTouchedIndex(
                                                              -1);
                                                      return;
                                                    }
                                                    Provider.of<ViewRevenueController>(
                                                            context,
                                                            listen: false)
                                                        .changeTouchedIndex(
                                                            pieTouchResponse
                                                                .touchedSection!
                                                                .touchedSectionIndex);
                                                  }),
                                                  centerSpaceRadius: 1,
                                                  sections: [
                                                    PieChartSectionData(
                                                        title: revenueController
                                                                    .touchedIndex ==
                                                                0
                                                            ? snapshot
                                                                .data!.booked
                                                                .toString()
                                                            : '${snapshot.data!.bookedPercentage!.roundToDouble()}%',
                                                        titleStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                        value: snapshot.data!
                                                            .bookedPercentage!
                                                            .roundToDouble(),
                                                        color: Colors.green,
                                                        radius: revenueController
                                                                    .touchedIndex ==
                                                                0
                                                            ? 100
                                                            : 90),
                                                    PieChartSectionData(
                                                        title: revenueController
                                                                    .touchedIndex ==
                                                                1
                                                            ? snapshot
                                                                .data!.cancelled
                                                                .toString()
                                                            : '${snapshot.data!.cancelledPercentage!.roundToDouble()}%',
                                                        titleStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                        value: snapshot.data!
                                                            .cancelledPercentage!
                                                            .roundToDouble(),
                                                        color: Colors.red,
                                                        radius: revenueController
                                                                    .touchedIndex ==
                                                                1
                                                            ? 100
                                                            : 90)
                                                  ]),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                height: Adaptive.h(1.4),
                                                width: Adaptive.w(3),
                                              ),
                                              SizedBox(
                                                width: Adaptive.w(2),
                                              ),
                                              const Text(
                                                'Booked',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                height: Adaptive.h(1.4),
                                                width: Adaptive.w(3),
                                              ),
                                              SizedBox(
                                                width: Adaptive.w(2),
                                              ),
                                              const Text(
                                                'Cancelled',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                              Column(
                                children: [
                                  CinePassRevenueSide(
                                      title: 'Total Revenue',
                                      value: snapshot.data!.totalRevenue
                                          .toString(),
                                      ruppeesSymbol: true),
                                  sizedBoxHeight10,
                                  CinePassRevenueSide(
                                      title: 'Total Users',
                                      value:
                                          snapshot.data!.totalUsers.toString()),
                                  sizedBoxHeight10,
                                  CinePassRevenueSide(
                                      title: 'Total Theaters',
                                      value: snapshot.data!.totalTheaters
                                          .toString()),
                                  sizedBoxHeight10,
                                  CinePassRevenueSide(
                                      title: 'Running Movies',
                                      value: snapshot.data!.runningMovies
                                          .toString()),
                                ],
                              )
                            ],
                          ),
                          sizedBoxHeight20,
                          GlassmorphicContainer(
                            padding: EdgeInsets.only(top: Adaptive.h(2)),
                            width: Adaptive.w(100),
                            height: Adaptive.h(38),
                            borderRadius: 8,
                            blur: 20,
                            alignment: Alignment.bottomCenter,
                            border: 1,
                            linearGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color.fromRGBO(84, 168, 229, 0.1)
                                      .withOpacity(0.1),
                                  const Color(0xFFFFFFFF).withOpacity(0.05),
                                ]),
                            borderGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFffffff).withOpacity(0.5),
                                const Color((0xFFFFFFFF)).withOpacity(0.5),
                              ],
                            ),
                            child: Consumer<ViewRevenueController>(
                              builder: (context, value, child) {
                                List<FlSpot> listSpots = List.generate(
                                    12,
                                    (index) => FlSpot(
                                        index.toDouble(),
                                        ((value.allMonthsProfits[index]
                                                    .toDouble()) *
                                                7) /
                                            56000));

                                return SizedBox(
                                  width: Adaptive.w(85),
                                  height: Adaptive.h(80),
                                  child: LineChart(LineChartData(
                                      minX: 0,
                                      maxX: 11,
                                      minY: 0,
                                      maxY: 6,
                                      titlesData: FlTitlesData(
                                          show: true,
                                          topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: false)),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return const Text('0',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));

                                                case 1:
                                                  return const Text('8k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 2:
                                                  return const Text('16k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 3:
                                                  return const Text('24k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 4:
                                                  return const Text('32k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 5:
                                                  return const Text('48k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 6:
                                                  return const Text('56k',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                default:
                                                  return const SizedBox();
                                              }
                                            },
                                          )),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return const Text('Jan',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));

                                                case 1:
                                                  return const Text('Feb',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 2:
                                                  return const Text('Mar',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 3:
                                                  return const Text('Apr',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 4:
                                                  return const Text('May',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 5:
                                                  return const Text('Jun',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 6:
                                                  return const Text('Jul',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 7:
                                                  return const Text('Aug',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 8:
                                                  return const Text('Sep',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 9:
                                                  return const Text('Oct',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 10:
                                                  return const Text('Nov',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                case 11:
                                                  return const Text('Dec',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white));
                                                default:
                                              }
                                              return const SizedBox();
                                            },
                                          ))),
                                      gridData: FlGridData(
                                        show: true,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                              color: Color.fromARGB(
                                                  255, 49, 85, 54),
                                              strokeWidth: 2);
                                        },
                                        getDrawingVerticalLine: (value) {
                                          return const FlLine(
                                              color: Color.fromARGB(
                                                  255, 49, 85, 54),
                                              strokeWidth: 2);
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(color: Colors.green),
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                            spots: listSpots,
                                            isCurved: true,
                                            barWidth: 3,
                                            belowBarData: BarAreaData(
                                                show: true,
                                                color: Colors.blue
                                                    .withOpacity(0.8)),
                                            color: Colors.blue)
                                      ])),
                                );
                              },
                            ),
                          ),
                          sizedBoxHeight10,
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewBookingsScreen()));
                              },
                              child: const Text('Manage Transactions'))
                        ]);
                      } else {
                        return const Center(
                            child: Text('No data found',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)));
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor:
                                const Color.fromARGB(255, 207, 234, 255),
                            color: primaryColor,
                            strokeWidth: 6),
                      );
                    }
                  },
                ))));
  }
}
