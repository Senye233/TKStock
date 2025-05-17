import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tkstock/common/ui/std_color.dart';

class LoadingIndicator extends StatelessWidget {
  final IndicatorState state;
  const LoadingIndicator({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: state.offset, width: double.infinity),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 40,
            child: const SpinKitCircle(size: 24, color: StdColor.c_282828),
          ),
        )
      ],
    );
  }
}
