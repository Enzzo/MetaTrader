#property indicator_chart_window

extern string Pair1 = "EURUSD";
extern string Pair2 = "GBPUSD";
extern string Pair3 = "USDCHF";
extern string Pair4 = "USDJPY";
extern string Pair5 = "EURCHF";
extern string Pair6 = "AUDCAD";
extern bool EMA_OnBar = FALSE;
extern ENUM_TIMEFRAMES EMA_Timeframe = 1440;
extern int EMA_Period = 13;
extern int EMA_Shift = 0;
extern int EMA_Applied_Price = 0;
extern bool MACD_OnBar = FALSE;
extern ENUM_TIMEFRAMES MACD_Timeframe = 1440;
extern int MACD_Fast_Period = 12;
extern int MACD_Slow_Period = 26;
extern int MACD_Signal_Period = 9;
extern int MACD_AppliedPrice = 0;
extern bool Stoch1_OnBar = FALSE;
extern bool Stoch2_OnBar = FALSE;
extern ENUM_TIMEFRAMES Stochastic_Timeframe = 240;
extern int Stochastic_K = 5;
extern int Stochastic_D = 3;
extern int Stochastic_Slowing = 3;
extern int Stochastic_Method = 0;
extern int Stochastic_Price = 0;
extern int Stochastic_High1 = 80;
extern int Stochastic_Low1 = 20;
extern int Stochastic_High2 = 70;
extern int Stochastic_Low2 = 30;
extern color Font_Color = Black;
extern color No_Trend_Color = Yellow;
extern color Trend_Up_Color = LimeGreen;
extern color Trend_Down_Color = Red;

extern string password = "";
extern bool PopUpAlerts = TRUE;
extern bool SoundAlerts = TRUE;
extern bool EmailAlerts = TRUE;
extern string AdvanceAlertSound = "alert.wav";
extern string MainAlertSound = "alert.wav";
extern int AlertInterval = 1;
string Gsa_292[1];
int Gi_296 = 0;
int G_shift_300 = 0;
int G_shift_304 = 0;
bool G_shift_308 = FALSE;
int Gia_312[];
int Gia_316[];
int init() {
if (EMA_OnBar) Gi_296 = 1;
   if (MACD_OnBar) G_shift_300 = 1;
   if (Stoch1_OnBar) G_shift_304 = 1;
   if (Stoch2_OnBar) G_shift_308 = TRUE;
   Comment("");
   ArrayResize(Gsa_292, 0);
   if (Pair1 != "") f0_0(Gsa_292, Pair1);
   if (Pair2 != "") f0_0(Gsa_292, Pair2);
   if (Pair3 != "") f0_0(Gsa_292, Pair3);
   if (Pair4 != "") f0_0(Gsa_292, Pair4);
   if (Pair5 != "") f0_0(Gsa_292, Pair5);
   if (Pair6 != "") f0_0(Gsa_292, Pair6);
   Print("Pairs: ", ArraySize(Gsa_292));
   return (0);
}

int deinit() {
   switch (UninitializeReason()) {
   case REASON_CHARTCLOSE:
   case REASON_REMOVE:
   case REASON_RECOMPILE:
   case REASON_ACCOUNT:
      f0_3();
   case REASON_CHARTCHANGE: break;
   case REASON_PARAMETERS: break;
   }
   Comment("");
   return (0);
}

int f0_3() {
   int objs_total_0 = ObjectsTotal();
   for (int Li_4 = objs_total_0 - 1; Li_4 >= 0; Li_4--)
      if (StringFind(ObjectName(Li_4), "fake") != -1) ObjectDelete(ObjectName(Li_4));
   return (0);
}

int start() {
   int color_0;
   double imacd_4;
   double imacd_12;
   double ima_20;
   double ima_28;
   double istochastic_36;
   double istochastic_44;
   string Lsa_76[4];
   int Lia_80[4];
   int Lia_104[];
   int Lia_108[];
   int Lia_112[];
   int Lia_116[];
   bool Li_120;
   bool Li_124;
   int Li_unused_128;
   string name_52 = "";
   int Li_60 = 0;
   int index_64 = 0;
   int index_68 = 0;
   int ind_counted_72 = IndicatorCounted();
   
   Lia_80[0] = f0_2(PERIOD_MN1, PERIOD_W1);
   Lia_80[1] = f0_2(PERIOD_W1, PERIOD_D1);
   Lia_80[2] = f0_2(PERIOD_D1, PERIOD_H4);
   Lia_80[3] = f0_2(PERIOD_H4, PERIOD_H1);
   Lsa_76[0] = "D1";
   Lsa_76[1] = "H4";
   Lsa_76[2] = "H1";
   Lsa_76[3] = "M5";
   f0_3();
   int Li_84 = 32;
   int Li_88 = 16;
   int Li_92 = 12;
   int Li_96 = 4;
   int arr_size_100 = ArraySize(Gsa_292);
   ArrayResize(Lia_104, arr_size_100 + 1);
   ArrayResize(Lia_108, arr_size_100 + 1);
   ArrayResize(Lia_112, arr_size_100 + 1);
   ArrayResize(Lia_116, arr_size_100 + 1);
   if (ArraySize(Gia_312) < arr_size_100 + 1) {
      ArrayResize(Gia_312, arr_size_100 + 1);
      ArrayResize(Gia_316, arr_size_100 + 1);
      ArrayInitialize(Gia_312, 0);
      ArrayInitialize(Gia_316, 0);
   }
   index_64 = 0;
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      name_52 = "label_fake" + (6 * index_64) + index_68;
      if (ObjectFind(name_52) == -1) {
         ObjectCreate(name_52, OBJ_LABEL, 0, 0, 0);
         ObjectSet(name_52, OBJPROP_CORNER, 1);
         ObjectSet(name_52, OBJPROP_XDISTANCE, (arr_size_100 + 1) * (Li_84 + Li_92) - index_68 * (Li_84 + Li_92) + 0);
         ObjectSet(name_52, OBJPROP_YDISTANCE, index_64 * (Li_88 + Li_96) + 15);
      }
      ObjectSet(name_52, OBJPROP_COLOR, Font_Color);
      ObjectSet(name_52, OBJPROP_FONTSIZE, 7);
      ObjectSetText(name_52, Gsa_292[index_68 - 1]);
      Li_60 = StringLen(Lsa_76[index_64]) + 1;
   }
   index_64 = 1;
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      imacd_4 = iMACD(Gsa_292[index_68 - 1], MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, PRICE_CLOSE, MODE_MAIN, G_shift_300);
      imacd_12 = iMACD(Gsa_292[index_68 - 1], MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, PRICE_CLOSE, MODE_MAIN, G_shift_300 + 1);
      color_0 = No_Trend_Color;
      if (imacd_4 > imacd_12) {
         color_0 = Trend_Up_Color;
         Lia_104[index_68] = 1;
      } else {
         if (imacd_4 < imacd_12) {
            color_0 = Trend_Down_Color;
            Lia_104[index_68] = -1;
         }
      }
      f0_1(0, "fake" + (6 * index_64) + index_68, (arr_size_100 + 1) * (Li_84 + Li_92) - index_68 * (Li_84 + Li_92), index_64 * (Li_88 + Li_96) + 4, Li_84, Li_88, color_0);
   }
   index_64 = 2;
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      ima_20 = iMA(Gsa_292[index_68 - 1], EMA_Timeframe, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, Gi_296);
      ima_28 = iMA(Gsa_292[index_68 - 1], EMA_Timeframe, EMA_Period, 0, MODE_EMA, PRICE_CLOSE, Gi_296 + 1);
      color_0 = No_Trend_Color;
      if (ima_20 > ima_28) {
         color_0 = Trend_Up_Color;
         Lia_108[index_68] = 1;
      } else {
         if (ima_20 < ima_28) {
            color_0 = Trend_Down_Color;
            Lia_108[index_68] = -1;
         }
      }
      f0_1(0, "fake" + (6 * index_64) + index_68, (arr_size_100 + 1) * (Li_84 + Li_92) - index_68 * (Li_84 + Li_92), index_64 * (Li_88 + Li_96) + 4, Li_84, Li_88, color_0);
   }
   index_64 = 3;
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      istochastic_36 = iStochastic(Gsa_292[index_68 - 1], Stochastic_Timeframe, Stochastic_K, Stochastic_D, Stochastic_Slowing, Stochastic_Method, Stochastic_Price, MODE_MAIN,
         G_shift_304);
      istochastic_44 = iStochastic(Gsa_292[index_68 - 1], Stochastic_Timeframe, Stochastic_K, Stochastic_D, Stochastic_Slowing, Stochastic_Method, Stochastic_Price, MODE_MAIN,
         G_shift_304 + 1);
      color_0 = No_Trend_Color;
      if (istochastic_36 <= Stochastic_Low1) {
         color_0 = Trend_Up_Color;
         Lia_112[index_68] = 1;
      } else {
         if (istochastic_36 >= Stochastic_High1) {
            color_0 = Trend_Down_Color;
            Lia_112[index_68] = -1;
         }
      }
      f0_1(0, "fake" + (6 * index_64) + index_68, (arr_size_100 + 1) * (Li_84 + Li_92) - index_68 * (Li_84 + Li_92), index_64 * (Li_88 + Li_96) + 4, Li_84, Li_88, color_0);
   }
   index_64 = 4;
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      Li_120 = TRUE;
      Li_124 = TRUE;
      Li_unused_128 = G_shift_308;
      for (int shift_132 = G_shift_308; shift_132 < 100; shift_132++) {
         istochastic_36 = iStochastic(Gsa_292[index_68 - 1], Stochastic_Timeframe, Stochastic_K, Stochastic_D, Stochastic_Slowing, Stochastic_Method, Stochastic_Price, MODE_MAIN,
            shift_132);
         istochastic_44 = iStochastic(Gsa_292[index_68 - 1], Stochastic_Timeframe, Stochastic_K, Stochastic_D, Stochastic_Slowing, Stochastic_Method, Stochastic_Price, MODE_SIGNAL,
            shift_132);
         if (istochastic_44 < Stochastic_High2 && istochastic_44 > Stochastic_Low2) {
            Li_120 = FALSE;
            Li_124 = FALSE;
            Li_unused_128 = shift_132;
            break;
         }
         if (istochastic_44 < Stochastic_High2) Li_120 = FALSE;
         if (istochastic_44 > Stochastic_Low2) Li_124 = FALSE;
         if (istochastic_44 >= istochastic_36 && istochastic_44 >= Stochastic_High2 && istochastic_36 >= Stochastic_High2) {
            Li_unused_128 = shift_132;
            break;
         }
         if (istochastic_44 <= istochastic_36 && istochastic_44 <= Stochastic_Low2 && istochastic_36 <= Stochastic_Low2) {
            Li_unused_128 = shift_132;
            break;
         }
      }
      color_0 = No_Trend_Color;
      if (istochastic_36 <= Stochastic_Low2 && istochastic_44 <= Stochastic_Low2 && Li_124 && istochastic_36 >= istochastic_44) {
         color_0 = Trend_Up_Color;
         Lia_116[index_68] = 1;
      } else {
         if (istochastic_36 >= Stochastic_High2 && istochastic_44 >= Stochastic_High2 && Li_120 && istochastic_36 <= istochastic_44) {
            color_0 = Trend_Down_Color;
            Lia_116[index_68] = -1;
         }
      }
      f0_1(0, "fake" + (6 * index_64) + index_68, (arr_size_100 + 1) * (Li_84 + Li_92) - index_68 * (Li_84 + Li_92), index_64 * (Li_88 + Li_96) + 4, Li_84, Li_88, color_0);
   }
   for (index_68 = 1; index_68 < arr_size_100 + 1; index_68++) {
      if (Lia_104[index_68] > 0 && Lia_108[index_68] > 0 && Lia_116[index_68] > 0) {
         if (TimeCurrent() >= Gia_312[index_68] + 60 * AlertInterval) {
            Gia_312[index_68] = TimeCurrent();
            if (PopUpAlerts) Alert("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : сигнал на покупку");
            if (SoundAlerts) PlaySound(MainAlertSound);
            if (EmailAlerts) SendMail("Alert", StringConcatenate("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : сигнал на покупку"));
         }
      } else {
         if (Lia_104[index_68] > 0 && Lia_108[index_68] > 0 && Lia_112[index_68] > 0) {
            if (TimeCurrent() >= Gia_316[index_68] + 60 * AlertInterval) {
               Gia_316[index_68] = TimeCurrent();
               if (PopUpAlerts) Alert("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : Предв. cигнал на покупку");
               if (SoundAlerts) PlaySound(AdvanceAlertSound);
               if (EmailAlerts) SendMail("Alert", StringConcatenate("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : Предв. сигнал на покупку"));
            }
         }
      }
      if (Lia_104[index_68] < 0 && Lia_108[index_68] < 0 && Lia_116[index_68] < 0) {
         if (TimeCurrent() >= Gia_312[index_68] + 60 * AlertInterval) {
            Gia_312[index_68] = TimeCurrent();
            if (PopUpAlerts) Alert("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : сигнал на продажу");
            if (SoundAlerts) PlaySound(MainAlertSound);
            if (EmailAlerts) SendMail("Alert", StringConcatenate("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : сигнал на продажу"));
         }
      } else {
         if (Lia_104[index_68] < 0 && Lia_108[index_68] < 0 && Lia_112[index_68] < 0) {
            if (TimeCurrent() >= Gia_316[index_68] + 60 * AlertInterval) {
               Gia_316[index_68] = TimeCurrent();
               if (PopUpAlerts) Alert("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : Предв. cигнал на продажу");
               if (SoundAlerts) PlaySound(AdvanceAlertSound);
               if (EmailAlerts) SendMail("Alert", StringConcatenate("Три экрана Элдера: ", Gsa_292[index_68 - 1], " : Предв. сигнал на продажу"));
            }
         }
      }
   }
   index_68 = 0;
   for (index_64 = 1; index_64 < 5; index_64++) {
      name_52 = "label_fake" + (6 * index_64) + index_68;
      if (ObjectFind(name_52) == -1) {
         ObjectCreate(name_52, OBJ_LABEL, 0, 0, 0);
         ObjectSet(name_52, OBJPROP_CORNER, 1);
         ObjectSet(name_52, OBJPROP_XDISTANCE, (arr_size_100 + 1) * (Li_84 + Li_92) + index_68 * (Li_84 + Li_92) + 10);
         ObjectSet(name_52, OBJPROP_YDISTANCE, index_64 * (Li_88 + Li_96) + 15);
      }
      ObjectSet(name_52, OBJPROP_COLOR, Font_Color);
      ObjectSet(name_52, OBJPROP_FONTSIZE, 7);
      if (index_64 == 1) ObjectSetText(name_52, "MACD");
      else {
         if (index_64 == 2) ObjectSetText(name_52, "EMA");
         else {
            if (index_64 == 3) ObjectSetText(name_52, "STOCH1");
            else
               if (index_64 == 4) ObjectSetText(name_52, "STOCH2");
         }
      }
      Li_60 = StringLen(Lsa_76[index_64]) + 1;
   }
   return (0);
}

int f0_2(int A_timeframe_0, int A_timeframe_4) {
   double ima_8 = iMA(NULL, A_timeframe_0, EMA_Period, EMA_Shift, MODE_EMA, EMA_Applied_Price, 1);
   double ima_16 = iMA(NULL, A_timeframe_0, EMA_Period, EMA_Shift, MODE_EMA, EMA_Applied_Price, 2);
   double imacd_24 = iMACD(NULL, A_timeframe_0, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_AppliedPrice, MODE_MAIN, 1);
   double imacd_32 = iMACD(NULL, A_timeframe_0, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_AppliedPrice, MODE_MAIN, 2);
   double istochastic_40 = iStochastic(NULL, A_timeframe_4, Stochastic_K, Stochastic_D, Stochastic_Slowing, Stochastic_Method, Stochastic_Price, MODE_MAIN, 1);
   if (ima_8 > ima_16 && Close[1] > ima_8 && imacd_24 > imacd_32 && istochastic_40 <= Stochastic_Low1) return (1);
   if (ima_8 < ima_16 && Close[1] < ima_8 && imacd_24 < imacd_32 && istochastic_40 >= Stochastic_High1) return (-1);
   return (0);
}

void f0_1(int A_window_0, string As_4, double A_x_12, double A_y_20, double Ad_28, double Ad_36, color A_color_44) {
   double fontsize_48;
   double fontsize_56;
   double Ld_64;
   int Li_72;
   if (Ad_28 > Ad_36) {
      Li_72 = MathCeil(Ad_28 / Ad_36);
      fontsize_48 = MathRound(100.0 * Ad_36 / 77.0);
      fontsize_56 = MathRound(100.0 * Ad_28 / 77.0);
      Ld_64 = fontsize_56 / Li_72 - 2.0 * (fontsize_48 / (9 - Ad_36 / 100.0));
      for (int count_76 = 0; count_76 < Li_72; count_76++) {
         ObjectCreate(As_4 + count_76, OBJ_LABEL, A_window_0, 0, 0);
         ObjectSet(As_4 + count_76, OBJPROP_CORNER, 1);
         ObjectSetText(As_4 + count_76, CharToStr(110), fontsize_48, "Wingdings", A_color_44);
         ObjectSet(As_4 + count_76, OBJPROP_XDISTANCE, A_x_12 + Ld_64 * count_76);
         ObjectSet(As_4 + count_76, OBJPROP_YDISTANCE, A_y_20);
         ObjectSet(As_4 + count_76, OBJPROP_BACK, TRUE);
      }
   } else {
      Li_72 = MathCeil(Ad_36 / Ad_28);
      fontsize_48 = MathRound(100.0 * Ad_36 / 77.0);
      fontsize_56 = MathRound(100.0 * Ad_28 / 77.0);
      Ld_64 = fontsize_48 / Li_72 - 2.0 * (fontsize_56 / (9 - Ad_28 / 100.0));
      for (count_76 = 0; count_76 < Li_72; count_76++) {
         ObjectCreate(As_4 + count_76, OBJ_LABEL, A_window_0, 0, 0);
         ObjectSet(As_4 + count_76, OBJPROP_CORNER, 1);
         ObjectSetText(As_4 + count_76, CharToStr(110), fontsize_56, "Wingdings", A_color_44);
         ObjectSet(As_4 + count_76, OBJPROP_XDISTANCE, A_x_12);
         ObjectSet(As_4 + count_76, OBJPROP_YDISTANCE, A_y_20 + Ld_64 * count_76);
         ObjectSet(As_4 + count_76, OBJPROP_BACK, TRUE);
      }
   }
}

void f0_0(string &Asa_0[1], string As_4) {
   ArrayResize(Asa_0, ArrayRange(Asa_0, 0) + 1);
   Asa_0[ArrayRange(Asa_0, 0) - 1] = As_4;
}