import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/onboarding/presentation/main_page_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/kundali/bloc/kundali_bloc.dart';
import 'features/kundali/bloc/insight_bloc.dart';


void main() {

  // widgetsFlutterBinding.ensureInitialized();

  runApp(const DigitalKundaliApp());
}

class DigitalKundaliApp extends StatelessWidget {
  const DigitalKundaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
            BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
            BlocProvider<KundaliBloc>(create: (_) => KundaliBloc()),
            BlocProvider<InsightBloc>(create: (_) => InsightBloc()),
          ],
          child: MaterialApp(
            title: 'Digital Kundali',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFFAF9F5),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFF11141A)),
              ),
            ),
            home: const MainPageView(),
          ),
        );
      },
    );
  }
}
