//+------------------------------------------------------------------+
//|                                                                  |
//|                                         #4X 2010 Forex Power.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern int X = 55;
extern int Y = 35;
extern int Corner = 1;
extern int window = 1;
int gi_92 = 13;
string gs_arial_96 = "Arial";
string gsa_104[] = {"USD", "EUR", "GBP", "JPY", "CHF", "CAD", "AUD", "NZD"};
//int gia_108[] = {16777215, 15570276, 13688896, 5275647, 13353215, 10025880, 13850042, 55295};
string gsa_112[] = {"USDCHF", "GBPUSD", "EURUSD", "USDJPY", "USDCAD", "NZDUSD", "AUDUSD", "AUDNZD", "AUDCAD", "AUDCHF", "AUDJPY", "CHFJPY", "EURGBP", "EURAUD", "EURCHF", "EURJPY", "EURNZD", "EURCAD", "EURNZD", "EURCAD", "GBPCHF", "GBPAUD", "GBPCAD", "GBPJPY", "CADJPY", "NZDJPY", "GBPNZD", "USDSGD"};
string gs_116 = "";
string gs_124;

int init() {
   gs_124 = WindowExpertName();
   return (0);
}

int deinit() {
   for (int l_index_0 = 0; l_index_0 <= ArraySize(gsa_104) * 2; l_index_0++) {
      ObjectDelete(gsa_104[l_index_0] + "_val");
      ObjectDelete(gsa_104[l_index_0] + "_nom");
      ObjectDelete(gsa_104[l_index_0] + "_pos");
   }
   return (0);
}

int start() {
   int l_ind_counted_0 = IndicatorCounted();
   displayMeter();
   ObjectDelete("Obj11d");
   ObjectCreate("Obj11d", OBJ_LABEL, 1, 0, 0);
   ObjectSetText("Obj11d", "FOREX POWER", 13, "Arial", Silver);
   ObjectSet("Obj11d", OBJPROP_CORNER, 1);
   ObjectSet("Obj11d", OBJPROP_XDISTANCE, 40);
   ObjectSet("Obj11d", OBJPROP_YDISTANCE, 15);
   return (0);
}

void displayMeter() {
   double lda_0[8][2];
   int lia_4[8][2];
   int li_12;
   lda_0[0][0] = currency_strength(gsa_104[0]);
   lda_0[1][0] = currency_strength(gsa_104[1]);
   lda_0[2][0] = currency_strength(gsa_104[2]);
   lda_0[3][0] = currency_strength(gsa_104[3]);
   lda_0[4][0] = currency_strength(gsa_104[4]);
   lda_0[5][0] = currency_strength(gsa_104[5]);
   lda_0[6][0] = currency_strength(gsa_104[6]);
   lda_0[7][0] = currency_strength(gsa_104[7]);
   lda_0[0][1] = 0;
   lda_0[1][1] = 1;
   lda_0[2][1] = 2;
   lda_0[3][1] = 3;
   lda_0[4][1] = 4;
   lda_0[5][1] = 5;
   lda_0[6][1] = 6;
   lda_0[7][1] = 7;
   ArraySort(lda_0, WHOLE_ARRAY, 0, MODE_DESCEND);
   int li_8 = WindowFind(gs_124);
   int li_16 = Y;
   for (int l_index_20 = 0; l_index_20 < 8; l_index_20++) {
      li_12 = lda_0[l_index_20][1];
      objectCreate(gsa_104[li_12] + "_pos", Corner, X + 85, li_16, 0, (l_index_20 + 1) + ". ", gi_92, gs_arial_96, symcolor(lda_0[l_index_20][0]));
      objectCreate(gsa_104[li_12] + "_nom", Corner, X + 45, li_16, 0, gsa_104[li_12], gi_92, gs_arial_96, symcolor(lda_0[l_index_20][0]));
      objectCreate(gsa_104[li_12] + "_val", Corner, X - 10, li_16, 0, DoubleToStr(lda_0[l_index_20][0], 2), gi_92, gs_arial_96, symcolor(lda_0[l_index_20][0]));
      li_16 += 15;
   }
}

int symcolor(double ad_0) {
   int li_ret_8;
   if (ad_0 <= 2.0) li_ret_8 = 3937500;
   if (ad_0 > 2.0) li_ret_8 = 11829830;
   if (ad_0 >= 7.0) li_ret_8 = 3329330;
   return (li_ret_8);
}

double currency_strength(string as_0) {
   int li_8;
   string ls_12;
   double ld_20;
   double ld_28;
   double ld_ret_36 = 0;
   int l_count_44 = 0;
   for (int l_index_48 = 0; l_index_48 < ArraySize(gsa_112); l_index_48++) {
      li_8 = 0;
      ls_12 = gsa_112[l_index_48];
      if (as_0 == StringSubstr(ls_12, 0, 3) || as_0 == StringSubstr(ls_12, 3, 3)) {
         ls_12 = ls_12 + gs_116;
         ld_20 = (MarketInfo(ls_12, MODE_HIGH) - MarketInfo(ls_12, MODE_LOW)) * MarketInfo(ls_12, MODE_POINT);
         if (ld_20 != 0.0) {
            ld_28 = 100.0 * ((MarketInfo(ls_12, MODE_BID) - MarketInfo(ls_12, MODE_LOW)) / ld_20 * MarketInfo(ls_12, MODE_POINT));
            if (ld_28 > 3.0) li_8 = 1;
            if (ld_28 > 10.0) li_8 = 2;
            if (ld_28 > 25.0) li_8 = 3;
            if (ld_28 > 40.0) li_8 = 4;
            if (ld_28 > 50.0) li_8 = 5;
            if (ld_28 > 60.0) li_8 = 6;
            if (ld_28 > 75.0) li_8 = 7;
            if (ld_28 > 90.0) li_8 = 8;
            if (ld_28 > 97.0) li_8 = 9;
            l_count_44++;
            if (as_0 == StringSubstr(ls_12, 3, 3)) li_8 = 9 - li_8;
            ld_ret_36 += li_8;
         }
      }
   }
   ld_ret_36 /= l_count_44;
   return (ld_ret_36);
}

void objectCreate(string a_name_0, int a_corner_8, int a_x_12, int a_y_16, int a_angle_20, string a_text_24 = "-", int a_fontsize_32 = 42, string a_fontname_36 = "Arial", color a_color_44 = -1) {
   if (ObjectFind(a_name_0) != 0) {
      ObjectCreate(a_name_0, OBJ_LABEL, window, 0, 0);
      ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_8);
      ObjectSet(a_name_0, OBJPROP_COLOR, a_color_44);
      ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_12);
      ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_16);
      ObjectSet(a_name_0, OBJPROP_ANGLE, a_angle_20);
      ObjectSetText(a_name_0, a_text_24, a_fontsize_32, a_fontname_36, a_color_44);
      return;
   }
   ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_8);
   ObjectSet(a_name_0, OBJPROP_COLOR, a_color_44);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_12);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_16);
   ObjectSet(a_name_0, OBJPROP_ANGLE, a_angle_20);
   ObjectSetText(a_name_0, a_text_24, a_fontsize_32, a_fontname_36, a_color_44);
}