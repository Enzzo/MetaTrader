/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website: h T tp: / / wWw. meTaquo TEs. N E T
   E-mail :  sU PPoRt @m eT a QUOt E S. n et
*/
#property copyright "Copyright © 2009, Stratman - Forex Factory"
#property link      "http://www.forexfactory.com/member.php?u=108824"

#property indicator_chart_window

extern string Heading_SingleMode = "## Single Mode Parameters ##";
extern string Comment_TimeFrame = " - MN1,W1,D1,H4,H1,M30,M15,etc -";
extern string TimeFrame = "H4";
extern string Comment_Corner = " - TopLeft=0,TR=1,BL=2,BR=3 -";
extern int Corner = 1;
extern string Heading_ChartParam = "## Chart Parameters ##";
extern bool MultiMode = TRUE;
extern bool CandleMode = TRUE;
extern int BarsToDisplay = 18;
extern bool AutoScale = TRUE;
extern int ATRBars = 20;
extern int ATRPixelsY = 30;
extern color WickColor = DimGray;
extern color BullBarColor = Green;
extern color BearBarColor = FireBrick;
extern color ScaleColor = DimGray;
extern string Comment_Positioning = " - Positioning (in Pixels) -";
extern int WindowNumber = 0;
extern int CornerX = 40;
extern int CornerY = 120;
extern int Width = 120;
extern int Height = 120;
extern int HeadingX = 120;
extern int HeadingY = 4;
extern int ScaleStartY = 20;
extern int BarSpacingX = 7;
extern string Comment_Fonts = " - Font Parameters -";
extern string HeadingFontName = "Verdana";
extern int HeadingFontSize = 9;
extern color HeadingFontColor = DimGray;
extern string Heading_MultiMode = "## MultiMode Parameters ##";
extern int Columns = 1;
extern int Rows = 3;
extern int SpacingColumns = 20;
extern int SpacingRows = 5;
extern string Comment_Symbols = " - to use chart Symbol() -";
extern string Comment_Symbols1 = " - leave Symbol## blank.  -";
extern string Comment_TimeFrames = " - Valid TimeFrame Values: -";
extern string Comment_TimeFrames1 = " - MN1,W1,D1,H4,H1,M30,M15,etc -";
extern string Comment_TimeFrames2 = " - Leave Blank for no chart -";
extern string Symbol01 = "";
extern string TimeFrame01 = "M15";
extern string Symbol02 = "";
extern string TimeFrame02 = "H1";
extern string Symbol03 = "";
extern string TimeFrame03 = "H4";
extern string Symbol04 = "";
extern string TimeFrame04 = "";
extern string Symbol05 = "";
extern string TimeFrame05 = "";
extern string Symbol06 = "";
extern string TimeFrame06 = "";
extern string Symbol07 = "";
extern string TimeFrame07 = "";
extern string Symbol08 = "";
extern string TimeFrame08 = "";
extern string Symbol09 = "";
extern string TimeFrame09 = "";
extern string Symbol10 = "";
extern string TimeFrame10 = "";
extern string Symbol11 = "";
extern string TimeFrame11 = "";
extern string Symbol12 = "";
extern string TimeFrame12 = "";
extern string Symbol13 = "";
extern string TimeFrame13 = "";
extern string Symbol14 = "";
extern string TimeFrame14 = "";
extern string Symbol15 = "";
extern string TimeFrame15 = "";
extern string Symbol16 = "";
extern string TimeFrame16 = "";
extern string Symbol17 = "";
extern string TimeFrame17 = "";
extern string Symbol18 = "";
extern string TimeFrame18 = "";
extern string Symbol19 = "";
extern string TimeFrame19 = "";
extern string Symbol20 = "";
extern string TimeFrame20 = "";
extern string Symbol21 = "";
extern string TimeFrame21 = "";
extern string Symbol22 = "";
extern string TimeFrame22 = "";
extern string Symbol23 = "";
extern string TimeFrame23 = "";
extern string Symbol24 = "";
extern string TimeFrame24 = "";
extern string Symbol25 = "";
extern string TimeFrame25 = "";
extern string Symbol26 = "";
extern string TimeFrame26 = "";
extern string Symbol27 = "";
extern string TimeFrame27 = "";
extern string Symbol28 = "";
extern string TimeFrame28 = "";
extern string Symbol29 = "";
extern string TimeFrame29 = "";
extern string Symbol30 = "";
extern string TimeFrame30 = "";
extern string Symbol31 = "";
extern string TimeFrame31 = "";
extern string Symbol32 = "";
extern string TimeFrame32 = "";
extern string Symbol33 = "";
extern string TimeFrame33 = "";
extern string Symbol34 = "";
extern string TimeFrame34 = "";
extern string Symbol35 = "";
extern string TimeFrame35 = "";
extern string Symbol36 = "";
extern string TimeFrame36 = "";
extern string Symbol37 = "";
extern string TimeFrame37 = "";
extern string Symbol38 = "";
extern string TimeFrame38 = "";
extern string Symbol39 = "";
extern string TimeFrame39 = "";
extern string Symbol40 = "";
extern string TimeFrame40 = "";
extern string Symbol41 = "";
extern string TimeFrame41 = "";
extern string Symbol42 = "";
extern string TimeFrame42 = "";
extern string Symbol43 = "";
extern string TimeFrame43 = "";
extern string Symbol44 = "";
extern string TimeFrame44 = "";
extern string Symbol45 = "";
extern string TimeFrame45 = "";
extern string Symbol46 = "";
extern string TimeFrame46 = "";
extern string Symbol47 = "";
extern string TimeFrame47 = "";
extern string Symbol48 = "";
extern string TimeFrame48 = "";
extern string Symbol49 = "";
extern string TimeFrame49 = "";
extern string Symbol50 = "";
extern string TimeFrame50 = "";
extern string Symbol51 = "";
extern string TimeFrame51 = "";
extern string Symbol52 = "";
extern string TimeFrame52 = "";
extern string Symbol53 = "";
extern string TimeFrame53 = "";
extern string Symbol54 = "";
extern string TimeFrame54 = "";
extern string Symbol55 = "";
extern string TimeFrame55 = "";
extern string Symbol56 = "";
extern string TimeFrame56 = "";
extern string Symbol57 = "";
extern string TimeFrame57 = "";
extern string Symbol58 = "";
extern string TimeFrame58 = "";
extern string Symbol59 = "";
extern string TimeFrame59 = "";
extern string Symbol60 = "";
extern string TimeFrame60 = "";
string Gs_1252 = "SMMC_";
string Gs_1260 = ".";
string Gs_verdana_1268 = "Verdana";
int Gi_1276 = 10;
int Gia_1280[4] = {-2, 3, -2, 3};
int Gia_1284[4] = {-11, -11, 5, 5};
string Gs_1288 = "-";
int Gi_1296 = 10;
int Gia_1300[4] = {-2, 5, -2, 5};
int Gia_1304[4] = {-8, -8, 8, 8};
string Gs_1308 = ".";
string Gs_system_1316 = "System";
int Gi_1324 = 8;
int Gi_1328 = 2;
int Gi_1332 = 2;
int Gia_1336[4] = {-1, 2, -1, 2};
int Gia_1340[4] = {-11, -11, 5, 5};
string Gs_1344 = "·";
string Gs_arial_1352 = "Arial";
int Gi_1360 = 8;
int Gi_1364 = 1;
int Gi_1368 = 1;
int Gia_1372[4] = {-1, 1, -1, 1};
int Gia_1376[4] = {-6, -6, 4, 4};
int Gia_1380[61];
int Gia_1384[61];
double Gda_1388[61];
double Gda_1392[61];
int Gia_1396[61];
int Gia_1400[61];
double Gda_1404[61];
double Gda_1408[61];
string Gsa_1412[61];
string Gsa_1416[61];
string Gsa_1420[61];
int Gia_1424[61];
int Gia_1428[61];

int init() {
   if (!MultiMode) {
      Gsa_1412[0] = Symbol();
      Gsa_1416[0] = TimeFrame;
      Gia_1424[0] = ChartX(0);
      Gia_1428[0] = ChartY(0);
      Reset(0);
   } else {
      ObjectDeleteByPrefix(Gs_1252, WindowNumber);
      for (int Li_0 = 1; Li_0 <= 60; Li_0++) Gsa_1412[Li_0] = Symbol();
      if (Symbol01 != "") Gsa_1412[1] = Symbol01;
      if (Symbol02 != "") Gsa_1412[2] = Symbol02;
      if (Symbol03 != "") Gsa_1412[3] = Symbol03;
      if (Symbol04 != "") Gsa_1412[4] = Symbol04;
      if (Symbol05 != "") Gsa_1412[5] = Symbol05;
      if (Symbol06 != "") Gsa_1412[6] = Symbol06;
      if (Symbol07 != "") Gsa_1412[7] = Symbol07;
      if (Symbol08 != "") Gsa_1412[8] = Symbol08;
      if (Symbol09 != "") Gsa_1412[9] = Symbol09;
      if (Symbol10 != "") Gsa_1412[10] = Symbol10;
      if (Symbol11 != "") Gsa_1412[11] = Symbol11;
      if (Symbol12 != "") Gsa_1412[12] = Symbol12;
      if (Symbol13 != "") Gsa_1412[13] = Symbol13;
      if (Symbol14 != "") Gsa_1412[14] = Symbol14;
      if (Symbol15 != "") Gsa_1412[15] = Symbol15;
      if (Symbol16 != "") Gsa_1412[16] = Symbol16;
      if (Symbol17 != "") Gsa_1412[17] = Symbol17;
      if (Symbol18 != "") Gsa_1412[18] = Symbol18;
      if (Symbol19 != "") Gsa_1412[19] = Symbol19;
      if (Symbol20 != "") Gsa_1412[20] = Symbol20;
      if (Symbol21 != "") Gsa_1412[21] = Symbol21;
      if (Symbol22 != "") Gsa_1412[22] = Symbol22;
      if (Symbol23 != "") Gsa_1412[23] = Symbol23;
      if (Symbol24 != "") Gsa_1412[24] = Symbol24;
      if (Symbol25 != "") Gsa_1412[25] = Symbol25;
      if (Symbol26 != "") Gsa_1412[26] = Symbol26;
      if (Symbol27 != "") Gsa_1412[27] = Symbol27;
      if (Symbol28 != "") Gsa_1412[28] = Symbol28;
      if (Symbol29 != "") Gsa_1412[29] = Symbol29;
      if (Symbol30 != "") Gsa_1412[30] = Symbol30;
      if (Symbol31 != "") Gsa_1412[31] = Symbol31;
      if (Symbol32 != "") Gsa_1412[32] = Symbol32;
      if (Symbol33 != "") Gsa_1412[33] = Symbol33;
      if (Symbol34 != "") Gsa_1412[34] = Symbol34;
      if (Symbol35 != "") Gsa_1412[35] = Symbol35;
      if (Symbol36 != "") Gsa_1412[36] = Symbol36;
      if (Symbol37 != "") Gsa_1412[37] = Symbol37;
      if (Symbol38 != "") Gsa_1412[38] = Symbol38;
      if (Symbol39 != "") Gsa_1412[39] = Symbol39;
      if (Symbol40 != "") Gsa_1412[40] = Symbol40;
      if (Symbol41 != "") Gsa_1412[41] = Symbol41;
      if (Symbol42 != "") Gsa_1412[42] = Symbol42;
      if (Symbol43 != "") Gsa_1412[43] = Symbol43;
      if (Symbol44 != "") Gsa_1412[44] = Symbol44;
      if (Symbol45 != "") Gsa_1412[45] = Symbol45;
      if (Symbol46 != "") Gsa_1412[46] = Symbol46;
      if (Symbol47 != "") Gsa_1412[47] = Symbol47;
      if (Symbol48 != "") Gsa_1412[48] = Symbol48;
      if (Symbol49 != "") Gsa_1412[49] = Symbol49;
      if (Symbol50 != "") Gsa_1412[50] = Symbol50;
      if (Symbol51 != "") Gsa_1412[51] = Symbol51;
      if (Symbol52 != "") Gsa_1412[52] = Symbol52;
      if (Symbol53 != "") Gsa_1412[53] = Symbol53;
      if (Symbol54 != "") Gsa_1412[54] = Symbol54;
      if (Symbol55 != "") Gsa_1412[55] = Symbol55;
      if (Symbol56 != "") Gsa_1412[56] = Symbol56;
      if (Symbol57 != "") Gsa_1412[57] = Symbol57;
      if (Symbol58 != "") Gsa_1412[58] = Symbol58;
      if (Symbol59 != "") Gsa_1412[59] = Symbol59;
      if (Symbol60 != "") Gsa_1412[60] = Symbol60;
      Gsa_1416[1] = TimeFrame01;
      Gsa_1416[2] = TimeFrame02;
      Gsa_1416[3] = TimeFrame03;
      Gsa_1416[4] = TimeFrame04;
      Gsa_1416[5] = TimeFrame05;
      Gsa_1416[6] = TimeFrame06;
      Gsa_1416[7] = TimeFrame07;
      Gsa_1416[8] = TimeFrame08;
      Gsa_1416[9] = TimeFrame09;
      Gsa_1416[10] = TimeFrame10;
      Gsa_1416[11] = TimeFrame11;
      Gsa_1416[12] = TimeFrame12;
      Gsa_1416[13] = TimeFrame13;
      Gsa_1416[14] = TimeFrame14;
      Gsa_1416[15] = TimeFrame15;
      Gsa_1416[16] = TimeFrame16;
      Gsa_1416[17] = TimeFrame17;
      Gsa_1416[18] = TimeFrame18;
      Gsa_1416[19] = TimeFrame19;
      Gsa_1416[20] = TimeFrame20;
      Gsa_1416[21] = TimeFrame21;
      Gsa_1416[22] = TimeFrame22;
      Gsa_1416[23] = TimeFrame23;
      Gsa_1416[24] = TimeFrame24;
      Gsa_1416[25] = TimeFrame25;
      Gsa_1416[26] = TimeFrame26;
      Gsa_1416[27] = TimeFrame27;
      Gsa_1416[28] = TimeFrame28;
      Gsa_1416[29] = TimeFrame29;
      Gsa_1416[30] = TimeFrame30;
      Gsa_1416[31] = TimeFrame31;
      Gsa_1416[32] = TimeFrame32;
      Gsa_1416[33] = TimeFrame33;
      Gsa_1416[34] = TimeFrame34;
      Gsa_1416[35] = TimeFrame35;
      Gsa_1416[36] = TimeFrame36;
      Gsa_1416[37] = TimeFrame37;
      Gsa_1416[38] = TimeFrame38;
      Gsa_1416[39] = TimeFrame39;
      Gsa_1416[40] = TimeFrame40;
      Gsa_1416[41] = TimeFrame41;
      Gsa_1416[42] = TimeFrame42;
      Gsa_1416[43] = TimeFrame43;
      Gsa_1416[44] = TimeFrame44;
      Gsa_1416[45] = TimeFrame45;
      Gsa_1416[46] = TimeFrame46;
      Gsa_1416[47] = TimeFrame47;
      Gsa_1416[48] = TimeFrame48;
      Gsa_1416[49] = TimeFrame49;
      Gsa_1416[50] = TimeFrame50;
      Gsa_1416[51] = TimeFrame51;
      Gsa_1416[52] = TimeFrame52;
      Gsa_1416[53] = TimeFrame53;
      Gsa_1416[54] = TimeFrame54;
      Gsa_1416[55] = TimeFrame55;
      Gsa_1416[56] = TimeFrame56;
      Gsa_1416[57] = TimeFrame57;
      Gsa_1416[58] = TimeFrame58;
      Gsa_1416[59] = TimeFrame59;
      Gsa_1416[60] = TimeFrame60;
      for (Li_0 = 1; Li_0 <= 60; Li_0++) {
         if (Gsa_1416[Li_0] != "") {
            Gia_1424[Li_0] = ChartX(Li_0);
            Gia_1428[Li_0] = ChartY(Li_0);
            Reset(Li_0);
         }
      }
   }
   return (0);
}

int deinit() {
   ObjectDeleteByPrefix(Gs_1252, WindowNumber);
   return (0);
}

int start() {
   if (!MultiMode) {
      if (Gia_1380[0] != iTime(Gsa_1412[0], Gia_1384[0], 0)) Reset(0);
      Update(0);
   } else {
      for (int Li_0 = 1; Li_0 <= 60; Li_0++) {
         if (Gsa_1416[Li_0] != "") {
            if (Gia_1380[Li_0] != iTime(Gsa_1412[Li_0], Gia_1384[Li_0], 0)) Reset(Li_0);
            Update(Li_0);
         }
      }
   }
   return (0);
}

int ChartX(int Ai_0) {
   int Li_ret_4;
   if (Ai_0 == 0) Li_ret_4 = CornerX;
   else Li_ret_4 = CornerX + (Ai_0 - 1) % Columns * (SpacingColumns + Width);
   return (Li_ret_4);
}

int ChartY(int Ai_0) {
   int Li_ret_4;
   if (Ai_0 == 0) Li_ret_4 = CornerY;
   else Li_ret_4 = CornerY + (Ai_0 - 1) / Columns * (SpacingRows + Height);
   return (Li_ret_4);
}

void ObjectDeleteByPrefix(string As_0, int Ai_8) {
   string Lsa_12[];
   string name_20;
   int Li_28;
   ArrayResize(Lsa_12, ObjectsTotal());
   int str_len_32 = StringLen(As_0);
   for (int Li_16 = 0; Li_16 < ObjectsTotal(); Li_16++) {
      name_20 = ObjectName(Li_16);
      if (StringLen(name_20) > str_len_32 && StringSubstr(name_20, 0, str_len_32) == As_0 && ObjectFind(name_20) == Ai_8) {
         Lsa_12[Li_28] = name_20;
         Li_28++;
      }
   }
   for (Li_16 = 0; Li_16 < Li_28; Li_16++) ObjectDelete(Lsa_12[Li_16]);
}

void ObjectMakeBarVerticalLine(int Ai_0, string As_4, int Ai_12, int Ai_16, int Ai_20, int Ai_24) {
   int Li_32;
   int Li_36;
   int count_28 = 0;
   if (Ai_16 > Ai_20) {
      Li_32 = Ai_20;
      Li_36 = Ai_16;
   } else {
      Li_32 = Ai_16;
      Li_36 = Ai_20;
   }
   for (int Li_40 = Li_32; Li_40 <= Li_36; Li_40 += Gi_1368) {
      ObjectMakeLabel(Ai_0, As_4 + "Bar" + DoubleToStr(count_28, 0), Gs_1344, Ai_12 + Gia_1372[Corner], Li_40 + Gia_1376[Corner], Gs_arial_1352, Gi_1360, Ai_24);
      count_28++;
   }
}

void ObjectMakeBarTags(int Ai_0, string As_4, int Ai_12, int Ai_16, int Ai_20, int Ai_24) {
   ObjectMakeLabel(Ai_0, As_4 + "Open", Gs_1308, Ai_12 + Gia_1336[Corner] - Gi_1328, Ai_16 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_24);
   ObjectMakeLabel(Ai_0, As_4 + "Close", Gs_1308, Ai_12 + Gia_1336[Corner] + Gi_1364, Ai_20 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_24);
}

void ObjectMakeBody(int Ai_0, string As_4, int Ai_12, int Ai_16, int Ai_20, int Ai_24) {
   int Li_32;
   int Li_36;
   int count_28 = 0;
   if (Ai_16 > Ai_20) {
      Li_36 = Ai_20;
      Li_32 = Ai_16;
   } else {
      Li_36 = Ai_16;
      Li_32 = Ai_20;
   }
   for (int Li_40 = Li_36; Li_40 <= Li_32; Li_40 += Gi_1332) {
      ObjectMakeLabel(Ai_0, As_4 + "BodyL" + DoubleToStr(count_28, 0), Gs_1308, Ai_12 + Gia_1336[Corner] - Gi_1328, Li_40 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_24);
      ObjectMakeLabel(Ai_0, As_4 + "BodyC" + DoubleToStr(count_28, 0), Gs_1308, Ai_12 + Gia_1336[Corner], Li_40 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_24);
      ObjectMakeLabel(Ai_0, As_4 + "BodyR" + DoubleToStr(count_28, 0), Gs_1308, Ai_12 + Gia_1336[Corner] + Gi_1364, Li_40 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_24);
      count_28++;
   }
}

void ObjectMakeLabel(int Ai_0, string A_name_4, string A_text_12, int Ai_20, int Ai_24, string A_fontname_28, int A_fontsize_36, color A_color_40) {
   ObjectCreate(A_name_4, OBJ_LABEL, WindowNumber, 0, 0);
   ObjectSetText(A_name_4, A_text_12, A_fontsize_36, A_fontname_28, A_color_40);
   ObjectSet(A_name_4, OBJPROP_CORNER, Corner);
   ObjectSet(A_name_4, OBJPROP_XDISTANCE, PixelX(Ai_0, Ai_20));
   ObjectSet(A_name_4, OBJPROP_YDISTANCE, PixelY(Ai_0, Ai_24));
}

void ObjectMakeWicks(int Ai_0, string As_4, int Ai_12, int Ai_16, int Ai_20, int Ai_24, int Ai_28, int Ai_32) {
   int Li_40;
   int Li_44;
   int Li_48;
   int Li_52;
   int count_36 = 0;
   if (Ai_16 > Ai_20) {
      Li_40 = Ai_20;
      Li_44 = Ai_16;
   } else {
      Li_40 = Ai_16;
      Li_44 = Ai_20;
   }
   if (Ai_24 > Ai_28) {
      Li_52 = Ai_28;
      Li_48 = Ai_24;
   } else {
      Li_52 = Ai_24;
      Li_48 = Ai_28;
   }
   for (int Li_56 = Li_40; Li_56 <= Li_44; Li_56 += Gi_1368) {
      if (Li_56 < Li_48 || Li_56 > Li_52) ObjectMakeLabel(Ai_0, As_4 + "Bar" + DoubleToStr(count_36, 0), Gs_1344, Ai_12 + Gia_1372[Corner], Li_56 + Gia_1376[Corner], Gs_arial_1352, Gi_1360, Ai_32);
      count_36++;
   }
}

void ObjectMakeDojiBody(int Ai_0, string As_4, int Ai_12, int Ai_16, int Ai_20) {
   ObjectMakeLabel(Ai_0, As_4 + "DojiL", Gs_1308, Ai_12 + Gia_1336[Corner] - Gi_1328, Ai_16 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_20);
   ObjectMakeLabel(Ai_0, As_4 + "DojiC", Gs_1308, Ai_12 + Gia_1336[Corner], Ai_16 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_20);
   ObjectMakeLabel(Ai_0, As_4 + "DojiR", Gs_1308, Ai_12 + Gia_1336[Corner] + Gi_1364, Ai_16 + Gia_1340[Corner], Gs_system_1316, Gi_1324, Ai_20);
}

int PixelX(int Ai_0, int Ai_4) {
   int Li_ret_8 = 0;
   switch (Corner) {
   case 0:
      Li_ret_8 = Gia_1424[Ai_0] + Ai_4;
      break;
   case 1:
      Li_ret_8 = Gia_1424[Ai_0] + Width - Ai_4;
      break;
   case 2:
      Li_ret_8 = Gia_1424[Ai_0] + Ai_4;
      break;
   case 3:
      Li_ret_8 = Gia_1424[Ai_0] + Width - Ai_4;
   }
   return (Li_ret_8);
}

int PixelY(int Ai_0, int Ai_4) {
   int Li_ret_8 = 0;
   switch (Corner) {
   case 0:
      Li_ret_8 = Gia_1428[Ai_0] + Ai_4;
      break;
   case 1:
      Li_ret_8 = Gia_1428[Ai_0] + Ai_4;
      break;
   case 2:
      Li_ret_8 = Gia_1428[Ai_0] + Height - Ai_4;
      break;
   case 3:
      Li_ret_8 = Gia_1428[Ai_0] + Height - Ai_4;
   }
   return (Li_ret_8);
}

void Reset(int Ai_0) {
   int Li_4;
   int Li_16;
   double iopen_44;
   double ihigh_52;
   double iclose_60;
   double ilow_68;
   int Li_76;
   int Li_80;
   int Li_84;
   int Li_88;
   int color_92;
   int Li_120;
   double Ld_140;
   Gda_1408[Ai_0] = MarketInfo(Gsa_1412[Ai_0], MODE_POINT);
   Gsa_1420[Ai_0] = Gs_1252 + Gsa_1412[Ai_0] + Gsa_1416[Ai_0] + "_";
   Gia_1384[Ai_0] = TimePeriodFromString(Gsa_1416[Ai_0]);
   Gia_1380[Ai_0] = iTime(Gsa_1412[Ai_0], Gia_1384[Ai_0], 0);
   Gda_1388[Ai_0] = iATR(Gsa_1412[Ai_0], Gia_1384[Ai_0], ATRBars, 1);
   if (Gda_1388[Ai_0] == 0.0) {
      Print("Error: iATR function returned 0 ... exiting");
      return;
   }
   int color_96 = WickColor;
   ObjectDeleteByPrefix(Gsa_1420[Ai_0], WindowNumber);
   string Ls_100 = Gsa_1420[Ai_0] + "Heading";
   string Ls_108 = Gsa_1412[Ai_0] + " " + Gsa_1416[Ai_0];
   ObjectMakeLabel(Ai_0, Ls_100, Ls_108, HeadingX, HeadingY, HeadingFontName, HeadingFontSize, HeadingFontColor);
   int Li_12 = Width / 2 + BarSpacingX;
   Gia_1400[Ai_0] = ScaleStartY + (Height - ScaleStartY) / 2;
   double ihigh_20 = iHigh(Gsa_1412[Ai_0], Gia_1384[Ai_0], iHighest(Gsa_1412[Ai_0], Gia_1384[Ai_0], MODE_HIGH, BarsToDisplay + 1, 0));
   double ilow_28 = iLow(Gsa_1412[Ai_0], Gia_1384[Ai_0], iLowest(Gsa_1412[Ai_0], Gia_1384[Ai_0], MODE_LOW, BarsToDisplay + 1, 0));
   double Ld_36 = ihigh_20 - ilow_28;
   Gda_1392[Ai_0] = ilow_28 + Ld_36 / 2.0;
   bool Li_116 = BarsToDisplay % 2;
   if (Li_116) Li_120 = MathFloor(BarsToDisplay / 2.0) - 1.0;
   else {
      Li_120 = BarsToDisplay / 2 + 1;
      Li_12 += MathFloor(BarSpacingX / 2);
   }
   Gia_1396[Ai_0] = Li_12 + Li_120 * BarSpacingX;
   double Ld_124 = Gda_1388[Ai_0] / Gda_1408[Ai_0];
   double Ld_132 = Ld_124 / 10.0;
   if (AutoScale) Ld_140 = (Height - ScaleStartY) / (Ld_36 / Gda_1408[Ai_0] / 10.0);
   else Ld_140 = ATRPixelsY / Ld_132;
   Gda_1404[Ai_0] = Ld_140 / 10.0;
   if (Ld_140 > 3.0) {
      for (int Li_8 = ScaleStartY; Li_8 < Height; Li_8 += MathRound(Ld_140)) {
         Ls_100 = Gsa_1420[Ai_0] + "ScalePip" + DoubleToStr(Li_16, 0);
         if (Li_16 % 10 == 0) ObjectMakeLabel(Ai_0, Ls_100, Gs_1288, Gia_1300[Corner], Li_8 + Gia_1304[Corner], Gs_verdana_1268, Gi_1296, ScaleColor);
         else ObjectMakeLabel(Ai_0, Ls_100, Gs_1260, Gia_1280[Corner], Li_8 + Gia_1284[Corner], Gs_verdana_1268, Gi_1276, ScaleColor);
         Li_16++;
      }
   } else {
      if (10.0 * Ld_140 > 1.0) {
         for (Li_8 = ScaleStartY; Li_8 < Height; Li_8 += MathRound(10.0 * Ld_140)) {
            Ls_100 = Gsa_1420[Ai_0] + "ScalePip" + DoubleToStr(Li_16, 0);
            ObjectMakeLabel(Ai_0, Ls_100, Gs_1288, Gia_1300[Corner], Li_8 + Gia_1304[Corner], Gs_verdana_1268, Gi_1296, ScaleColor);
            Li_16++;
         }
      }
   }
   for (int Li_148 = BarsToDisplay; Li_148 >= 1; Li_148--) {
      Li_4 = Li_12 + (Li_120 - Li_148) * BarSpacingX;
      iopen_44 = iOpen(Gsa_1412[Ai_0], Gia_1384[Ai_0], Li_148);
      ihigh_52 = iHigh(Gsa_1412[Ai_0], Gia_1384[Ai_0], Li_148);
      ilow_68 = iLow(Gsa_1412[Ai_0], Gia_1384[Ai_0], Li_148);
      iclose_60 = iClose(Gsa_1412[Ai_0], Gia_1384[Ai_0], Li_148);
      Li_76 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (iopen_44 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
      Li_80 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (ihigh_52 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
      Li_88 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (ilow_68 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
      Li_84 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (iclose_60 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
      if (iclose_60 > iopen_44) color_92 = BullBarColor;
      else color_92 = BearBarColor;
      if (WickColor == CLR_NONE) color_96 = color_92;
      Ls_100 = Gsa_1420[Ai_0] + "Bar_" + DoubleToStr(Li_148, 0) + "_";
      if (CandleMode) {
         if (Li_76 == Li_84) ObjectMakeDojiBody(Ai_0, Ls_100, Li_4, Li_76, color_96);
         else ObjectMakeBody(Ai_0, Ls_100, Li_4, Li_76, Li_84, color_92);
         ObjectMakeWicks(Ai_0, Ls_100, Li_4, Li_88, Li_80, Li_76, Li_84, color_96);
      } else {
         ObjectMakeBarVerticalLine(Ai_0, Ls_100, Li_4, Li_88, Li_80, color_92);
         ObjectMakeBarTags(Ai_0, Ls_100, Li_4, Li_76, Li_84, color_92);
      }
   }
}

int TimePeriodFromString(string As_0) {
   int Li_ret_8 = 0;
   if (As_0 == "M1") Li_ret_8 = 1;
   if (As_0 == "M5") Li_ret_8 = 5;
   if (As_0 == "M15") Li_ret_8 = 15;
   if (As_0 == "M30") Li_ret_8 = 30;
   if (As_0 == "H1") Li_ret_8 = 60;
   if (As_0 == "H4") Li_ret_8 = 240;
   if (As_0 == "D1") Li_ret_8 = 1440;
   if (As_0 == "W1") Li_ret_8 = 10080;
   if (As_0 == "MN1") Li_ret_8 = 43200;
   return (Li_ret_8);
}

void Update(int Ai_0) {
   int color_60;
   string Ls_4 = Gsa_1420[Ai_0] + "Bar_0_";
   int color_64 = WickColor;
   ObjectDeleteByPrefix(Ls_4, WindowNumber);
   double iopen_12 = iOpen(Gsa_1412[Ai_0], Gia_1384[Ai_0], 0);
   double ihigh_20 = iHigh(Gsa_1412[Ai_0], Gia_1384[Ai_0], 0);
   double ilow_36 = iLow(Gsa_1412[Ai_0], Gia_1384[Ai_0], 0);
   double iclose_28 = iClose(Gsa_1412[Ai_0], Gia_1384[Ai_0], 0);
   int Li_44 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (iopen_12 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
   int Li_48 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (ihigh_20 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
   int Li_56 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (ilow_36 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
   int Li_52 = Gia_1400[Ai_0] - MathRound(Gda_1404[Ai_0] * (iclose_28 - Gda_1392[Ai_0]) / Gda_1408[Ai_0]);
   if (iclose_28 > iopen_12) color_60 = BullBarColor;
   else color_60 = BearBarColor;
   if (WickColor == CLR_NONE) color_64 = color_60;
   if (CandleMode) {
      if (Li_44 == Li_52) ObjectMakeDojiBody(Ai_0, Ls_4, Gia_1396[Ai_0], Li_44, color_64);
      else ObjectMakeBody(Ai_0, Ls_4, Gia_1396[Ai_0], Li_44, Li_52, color_60);
      ObjectMakeWicks(Ai_0, Ls_4, Gia_1396[Ai_0], Li_56, Li_48, Li_44, Li_52, color_64);
      return;
   }
   ObjectMakeBarVerticalLine(Ai_0, Ls_4, Gia_1396[Ai_0], Li_56, Li_48, color_60);
   ObjectMakeBarTags(Ai_0, Ls_4, Gia_1396[Ai_0], Li_44, Li_52, color_60);
}
