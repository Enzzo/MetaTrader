#property copyright "Scriptong"
#property link "http://autograf.dp.ua"

#property indicator_chart_window                   // ����������� � ���� ������� ���
#property indicator_buffers 1                      // ������� �� ����� �������
#property indicator_color1 Black                   // ���� 1-�� ������

extern string A1 = "======= ����� ��������� ��� ������� ��������� =========";
extern string A1_1 = "���������� �� ��������� �������";
extern bool   showPatternDescription = false;
extern string A2 = "������ ������ �������";
extern int    textSize = 7;
extern string A3 = "���� ������ �������";
extern color  textColor = White;
extern string A4 = "��� ������ �������";
extern string fontName = "Tahoma";
extern string A5 = "=======================================================";
extern string A6 = "======= ������� ���������� ��� =========";
extern string A7 = "���������/���������� ������ ��������";
extern bool   showIBpattern = false;
extern string A8 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertIBpattern = false;
extern string soundIBpattern = "AG_SoundLevel_1.wav";
extern string A9 = "���� �������� IB";
extern color  colorIB = DarkOrchid;
extern string A10 = "=======================================================";
extern string A11 = "======= �������� DBHLC � DBLHC =========";
extern string A12 = "���������/���������� ������ ��������";
extern bool   showDBpattern = false;
extern string A13 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertDBpattern = false;
extern string soundDBpattern = "AG_SoundLevel_2.wav";
extern string A14 = "������� � �������, ����������� �������";
extern int    equalPipsDB = 3;
extern string A15 = "����� ������� � ���������� ��������� DB";
extern color  colorDBLHC = Blue;
extern color  colorDBHLC = Red;
extern string A16 = "=======================================================";
extern string A17 = "======= �������� TBH � TBL =========";
extern string A18 = "���������/���������� ������ ��������";
extern bool   showTBpattern = false;
extern string A19 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertTBpattern = false;
extern string soundTBpattern = "AG_SoundLevel_3.wav";
extern string A20 = "������� � �������, ����������� �������";
extern int    equalPipsTB = 3;
extern string A21 = "����� ������� � ���������� ��������� TB";
extern color  colorTBL = Goldenrod;
extern color  colorTBH = Goldenrod;
extern string A22 = "=======================================================";
extern string A23 = "======= ������� ������ ==============";
extern string A24 = "���������/���������� ������ ��������";
extern bool   showRAILSpattern = false;
extern string A25 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertRAILSpattern = false;
extern string soundRAILSpattern = "AG_SoundLevel_4.wav";
extern string A26 = "������������ ������������� ��� ����� �� ������, � %";
extern double bodyGreatPercents = 10;
extern string A27 = "����������� ���� ���� ����� � ����� ������ �����, � %";
extern double bodyToHeightPercents = 20;
extern string A28 = "����� ������� � ���������� ��������� ������";
extern color  colorBullsRails = DodgerBlue;
extern color  colorBearsRails = FireBrick;
extern string A29 = "=======================================================";
extern string A30 = "======= �������� BUOVB � BEOVB ==============";
extern string A31 = "���������/���������� ������ ��������";
extern bool   showOVBpattern = false;
extern string A32 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertOVBpattern = false;
extern string soundOVBpattern = "AG_SoundLevel_5.wav";
extern string A33 = "����� ��������� BUOVB � BEOVB";
extern color  colorBUOVB = RoyalBlue;
extern color  colorBEOVB = Crimson;
extern string A34 = "=======================================================";
extern string A35 = "======= ������� PPR ==============";
extern string A36 = "���������/���������� ������ ��������";
extern bool   showPPRpattern = false;
extern string A37 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertPPRpattern = false;
extern string soundPPRpattern = "AG_SoundLevel_6.wav";
extern string A38 = "����� ������� � ���������� ��������� PPR";
extern color  colorBullsPPR = DeepSkyBlue;
extern color  colorBearsPPR = MediumVioletRed;
extern string A39 = "=======================================================";
extern string A40 = "======= ������� HR ==============";
extern string A41 = "���������/���������� ������ ��������";
extern bool   showHRpattern = false;
extern string A42 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertHRpattern = false;
extern string soundHRpattern = "AG_SoundLevel_7.wav";
extern string A43 = "�������� ��� �������� � �������� � ��� � ����, � �������";
extern int    openCloseToHighLowPointsHR = 3;
extern string A44 = "����� ������� � ���������� ��������� HR";
extern color  colorBullsHR = MediumTurquoise;
extern color  colorBearsHR = Maroon;
extern string A45 = "=======================================================";
extern string A46 = "======= ������� CPR ==============";
extern string A47 = "���������/���������� ������ ��������";
extern bool   showCPRpattern = false;
extern string A48 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertCPRpattern = false;
extern string soundCPRpattern = "AG_TimeNews.wav";
extern string A49 = "�������� ��� �������� � �������� � ��� � ����, � �������";
extern int    openCloseToHighLowPoints = 3;
extern string A50 = "����������� �������� ����, � �������";
extern int    gapPoints = 2;
extern string A51 = "����� ������� � ���������� ��������� CPR";
extern color  colorBullsCPR = SkyBlue;
extern color  colorBearsCPR = IndianRed;
extern string A52 = "=======================================================";
extern string A53 = "======= ������� Pin Bar ==============";
extern string A54 = "���������/���������� ������ ��������";
extern bool   showPINBARpattern = false;
extern string A55 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertPINBARpattern = false;
extern string soundPINBARpattern = "AG_Sound.wav";
extern string A56 = "�������� ���� �������� � ��� ��� ����, � �������";
extern int    closeToHighLowPoints = 3;
extern string A57 = "����������� ��������� ���� (����) � ���� �����";
extern double shadowToBodyKoef = 3.0;
extern string A58 = "����������� ����� ����, ����������� �� ���������� ���, � %";
extern double noseOutsidePercent = 75.0;
extern string A59 = "����� ������� � ���������� ��������� Pin Bar";
extern color  colorBullsPINBAR = CadetBlue;
extern color  colorBearsPINBAR = Tomato;
extern string A60 = "=======================================================";
extern string A61 = "======= ������� MCM ==============";
extern string A62 = "���������/���������� ������ ��������";
extern bool   showMCMpattern = false;
extern string A63 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertMCMpattern = false;
extern string soundMCMpattern = "AG_Transform.wav";
extern string A64 = "�������� ��� �������� � �������� ������ ����� � ��� ��� ����, � �������";
extern int    openCloseToHighLowPointsMCM = 3;
extern string A65 = "������������ ��������� ������ ���������� ����� � ������, � %";
extern double signalToFirstPercents = 35.0;
extern string A66 = "����� ������� � ���������� ��������� MCM";
extern color  colorBullsMCM = PaleTurquoise;
extern color  colorBearsMCM = Plum;
extern string A68 = "=======================================================";
extern string A69 = "======= ������� Island Reversal ==============";
extern string A70 = "���������/���������� ������ ��������";
extern bool   showIRpattern = false;
extern string A71 = "���������/���������� ��������� ������� ��� ���������� ��������";
extern bool   alertIRpattern = false;
extern string soundIRpattern = "AG_Tuning.wav";
extern string A72 = "�������� ������� (����� �� �������) ���� � �������";
extern int    firstGap = 1;
extern string A73 = "�������� ������� (������ �� �������) ���� � �������";
extern int    secondGap = 1;
extern string A74 = "����� ������� � ���������� ��������� Island Reversal";
extern color  colorBullsIR = LightSeaGreen;
extern color  colorBearsIR = PaleVioletRed;
extern string A75 = "=======================================================";
extern string Z1 = "���������� ����� ����������� ����������. ��� - 0";
extern int    indBarsCount = 500;


string typesOfPatterns[] = {"DB_PATTERN_",         // �������� ����� ���������
                            "TB_PATTERN_",
                            "RAILS_PATTERN",
                            "CPR_PATTERN",
                            "IB_PATTERN",
                            "HR_PATTERN",
                            "OVB_PATTERN",
                            "PPR_PATTERN",
                            "PINBAR_PATTERN",
                            "MCM_PATTERN",
                            "IR_PATTERN"};                      

#define PREFIX          "PRIACT_"                  // ������� ���� ����������� ��������

#define DB_INDEX        0                          // ������ ���������� �������������..
                                                   // ..���� �������� DB � �������..
                                                   // ..typesOfPatterns
#define TB_INDEX        1                          // ������ ���������� �������������..
                                                   // ..���� �������� TB � �������..
                                                   // ..typesOfPatterns

#define RAILS_INDEX     2                          // ������ ���������� �������������..
                                                   // ..���� �������� ������ � �������..
                                                   // ..typesOfPatterns

#define CPR_INDEX       3                          // ������ ���������� �������������..
                                                   // ..���� �������� CPR � �������..
                                                   // ..typesOfPatterns

#define IB_INDEX        4                          // ������ ���������� �������������..
                                                   // ..���� �������� IB � �������..
                                                   // ..typesOfPatterns

#define HR_INDEX        5                          // ������ ���������� �������������..
                                                   // ..���� �������� HR � �������..
                                                   // ..typesOfPatterns

#define OVB_INDEX       6                          // ������ ���������� �������������..
                                                   // ..���� �������� OVB � �������..
                                                   // ..typesOfPatterns

#define PPR_INDEX       7                          // ������ ���������� �������������..
                                                   // ..���� �������� PPR � �������..
                                                   // ..typesOfPatterns

#define PINBAR_INDEX    8                          // ������ ���������� �������������..
                                                   // ..���� �������� Pin Bar � �������..
                                                   // ..typesOfPatterns

#define MCM_INDEX       9                          // ������ ���������� �������������..
                                                   // ..���� �������� MCM � �������..
                                                   // ..typesOfPatterns

#define IR_INDEX        10                         // ������ ���������� �������������..
                                                   // ..���� �������� IR � �������..
                                                   // ..typesOfPatterns

#define BULL_BAR        1                          // ������������� ������ �����
#define BEAR_BAR        -1                         // ������������� ��������� �����

#define FIRST_PART      "_1_"                      // ����� ���� �������� ���..
#define SECOND_PART     "_2_"                      // ..������������ �������� ��������,..
#define THIRD_PART      "_3_"                      // ..����������� � ������ ��������

#define DBHLC_DESCRIPTION "DBHLC"                  // ��������� �������� �������� DBHLC
#define DBLHC_DESCRIPTION "DBLHC"                  // ��������� �������� �������� DBLHC

#define TBH_DESCRIPTION "TBH"                      // ��������� �������� �������� TBH
#define TBL_DESCRIPTION "TBL"                      // ��������� �������� �������� TBL

#define RAILS_DESCRIPTION "Rails"                  // ��������� �������� �������� ������

#define CPR_DESCRIPTION "CPR"                      // ��������� �������� �������� CPR

#define HR_DESCRIPTION "HR"                        // ��������� �������� �������� HR

#define BUOVB_DESCRIPTION "BUOVB"                  // ��������� �������� �������� BUOVB
#define BEOVB_DESCRIPTION "BEOVB"                  // ��������� �������� �������� BEOVB

#define PPR_DESCRIPTION "PPR"                      // ��������� �������� �������� PPR

#define PINBAR_DESCRIPTION "Pin Bar"               // ��������� �������� �������� Pin Bar

#define MCM_DESCRIPTION "MCM"                      // ��������� �������� �������� MCM

#define IR_DESCRIPTION "IR"                        // ��������� �������� �������� IR

//+-------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                            |
//+-------------------------------------------------------------------------------------+
int init()
{
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                          |
//+-------------------------------------------------------------------------------------+
int deinit()
{
   DeleteAllObjects();
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| �������� ���� ��������, ��������� �����������                                       |
//+-------------------------------------------------------------------------------------+
void DeleteAllObjects()
{
   for (int i = ObjectsTotal()-1; i >= 0; i--)     
      if (StringSubstr(ObjectName(i), 0, StringLen(PREFIX)) == PREFIX)
         ObjectDelete(ObjectName(i));
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ����, � �������� ���������� ����������� ����������              |
//+-------------------------------------------------------------------------------------+
int GetRecalcIndex(int& total)
{
   int counted_bars = IndicatorCounted();          // ������� ����� ��� ���������
   total = Bars - 1;                               // ����������� ������� ���� �������
   if (indBarsCount > 0 && indBarsCount < total)   // ���� �� ����� ������������ ���..
      total = indBarsCount;                        // ..�������, �� ������ � ����������..
                                                   // ..���� - indBarsCount
   if (counted_bars == 0)                          // ���-�� ����������� ����� - 0. 
   {
      DeleteAllObjects();                          // �� ������� ������� ��� ���������..
                                                   // ..�������
      return(total);                               // ����� ����������� ��� �������
   }
   return(Bars - counted_bars - 1);                // �������� � ������� ��������������..
                                                   // ..����
}
//+-------------------------------------------------------------------------------------+
//| ������ ��������� ������� �� ����������� ��������                                    |
//+-------------------------------------------------------------------------------------+
void PatternAlert(bool doAlert, int index, datetime& lastAlert, string soundFileName)
{
   if (!doAlert)                                   // �������� ���������� �� ���������
      return;
   if (index != 1)                                 // ���������� ������ ��� ��������..
      return;                                      // ..������� �� ������� ��������
   if (lastAlert >= Time[0])                       // �� ������� ���� ���������� ���..
      return;                                      // ..�������������
      
   PlaySound(soundFileName);                       // ��������������� �����
   lastAlert = Time[0];                            // ��������, ��� ����������..
                                                   // ..�����������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������������ ������� - ��������������                                   |
//+-------------------------------------------------------------------------------------+
void ShowRectangle(string name, datetime time1, double price1, datetime time2, 
                   double price2, string description, color clr)
{
   if (ObjectFind(name) < 0)                       // ���� ������ �� ����������
   {
      ObjectCreate(name, OBJ_RECTANGLE,            // �������� ���
                   0, time1, price1, time2, price2); 
      ObjectSet(name, OBJPROP_COLOR, clr);         // ��������� ����,..
      ObjectSet(name, OBJPROP_BACK, true);         // ..��������� ������������ ������..
                                                   // ..�������..
      ObjectSetText(name, "Pattern " + description, 0);// ..� ��������
      return;
   }
   
   ObjectMove(name, 0, time1, price1);             // ����������� ������������� �������
   ObjectMove(name, 1, time2, price2);             // ����������� ������������� �������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������������ ������� - ��������� �������                                |
//+-------------------------------------------------------------------------------------+
void ShowText(string name, datetime time1, double price1, string description)
{
   if (ObjectFind(name) < 0)                       // ���� ������ �� ����������
   {
      ObjectCreate(name, OBJ_TEXT, 0, time1, price1);// �������� ��� �..
      ObjectSetText(name, description, textSize,   // ..������� �������
                    fontName, textColor);
      return;                            
   }
   
   ObjectMove(name, 0, time1, price1);             // ����������� ������������� �������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ��������, ���������� �� �������������� � ��������� �������              |
//+-------------------------------------------------------------------------------------+
void ShowTypicalPattern(int startIndex, int endIndex, color clr, string patternType, 
                        string description)
{
// - 1 - == ����� ������� � ������ ������ �������� ======================================
   double lowPrice = Low[iLowest(NULL, 0, MODE_LOW,// ������ ������� ��������
                         startIndex - endIndex + 1, endIndex)];
   double highPrice = High[iHighest(NULL, 0,       // ������� ������� ��������
                           MODE_HIGH, startIndex - endIndex + 1, endIndex)];
// - 1 - == ��������� ����� =============================================================

// - 2 - == ����������� �������������� ==================================================
   datetime leftTime = Time[startIndex];           // ��������� ����� ��������
   datetime rightTime  = Time[endIndex];           // �������� ����� ��������
   string name = PREFIX + patternType +            // ��� ������� ��������
                 FIRST_PART + rightTime;           
   ShowRectangle(name, leftTime, lowPrice,         // ����������� �������
                 rightTime, highPrice, description, clr);
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������� �������� ============================================================
   if (!showPatternDescription)                    // ���� ��������� ������� ����������..
      return;                                      // ..�� �������, �� ������
   name = PREFIX + patternType + SECOND_PART +     // ��� ������� ��������
          rightTime;
   ShowText(name, Time[(startIndex + endIndex)/2], // ����������� �������
            lowPrice, description);
// - 3 - == ��������� ����� =============================================================
}           
//+-------------------------------------------------------------------------------------+
//| �������� �������                                                                    |
//+-------------------------------------------------------------------------------------+
void DeleteObject(string name)
{
   if (ObjectFind(name) == 0)
      ObjectDelete(name);
}
//+-------------------------------------------------------------------------------------+
//| ����������� ���� ��������, ���������� �� ��������� ����                             |
//+-------------------------------------------------------------------------------------+
string GetTypeOfExistsPattern(datetime time)
{
   int total = ArraySize(typesOfPatterns);         // ���������� ����� ���������
   for (int i = 0; i < total; i++)                 // �������� ���� ����� ���������
   {
      string name = PREFIX + typesOfPatterns[i] +  // ���������� ����� ���� �� ������..
                    FIRST_PART + time;             // ..����� �������� - �������������
      if (ObjectFind(name) == 0)                   // ������� (������ �����), ������..
         return(typesOfPatterns[i]);               // ..�����, ���� ����������
   }
   return("");                                     // �� ���� �� ��������� �� ������
}
//+-------------------------------------------------------------------------------------+
//| �������� ������ ��������, ������������� �����������, � ��������� ���������          |
//+-------------------------------------------------------------------------------------+
void DeleteAnyPattern(int index, int patternStart)
{
   for (int i = index; i < patternStart; i++)
   {
      datetime time = Time[i];
      string type = GetTypeOfExistsPattern(time);     
      if (type == "")                              // �� ���� �������� �� ������
         continue;
      DeleteObject(PREFIX + type + FIRST_PART + time);// �������� �������������� ��������
      DeleteObject(PREFIX + type + SECOND_PART + time);// �������� ������� ��������
      i--;                                         // ��������� ����� ��������� �� ����..
                                                   // ..���� - ����� �� ������ ������
   }
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������������� �������� ���������� ���                           |
//+-------------------------------------------------------------------------------------+
bool IsSimpleIB(int index)
{
   if (Low[index] <= Low[index+1])                 // ������� ���� ���� ��������..
      return(false);                               // ..����������� ���� - ��� ��������
      
   if (High[index] >= High[index+1])               // �������� ���� ���� ���������..
      return(false);                               // ..����������� ���� - ��� ��������

   double typeLast = Close[index] - Open[index];   // ��� ���� index:
                                                   // ..>0 - �����, <0 - ��������
   double typePreLast = Close[index+1] - Open[index+1];// ��� ����������� ����
   
   if ((typeLast >= 0 && typePreLast >= 0) ||      // ���� ���� ����������� ����, ��..
       (typeLast <= 0 && typePreLast <= 0))        // ..������� �� ������
      return(false);

   return(true);                                   // ������� ������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� ���������� ���                                         |
//+-------------------------------------------------------------------------------------+
bool IsIBPattern(int index, int total, int& patternStart)
{
   while(IsSimpleIB(patternStart) &&               // ����� ������������ ��������� ������
         patternStart < total)
      patternStart++;
      
   if (patternStart == index)                      // �� ���� ������� �� ������
      return(false);   
      
   return(true);                                   // ������� ������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� ��������� ���������� ���                                        |
//+-------------------------------------------------------------------------------------+
void FindAndShowIB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;

   if (!IsIBPattern(index, total, patternStart))   // ����������� � ����������� ��������
      return;

   DeleteAnyPattern(index, patternStart);          // �������� ���������� ���������
   string description = "I" + 
                        DoubleToStr(patternStart - index + 1, 0) +
                        "B";
   ShowTypicalPattern(patternStart, index,         // ����������� ��������
                      colorIB, typesOfPatterns[IB_INDEX], description);
   PatternAlert(alertIBpattern, index,             // �������� ���������� � ����������..
                lastAlert, soundIBpattern);        // ..��������
}
//+-------------------------------------------------------------------------------------+
//| ������� ���������� ����� � ����������� �����������                                  |
//+-------------------------------------------------------------------------------------+
bool IsTwoEqualMax(int startIndex, int total, int equalPips, int& patternStart)
{
   for (int i = startIndex+1; i < total; i++)      //����� �� ����������� ������� �������
      if (MathAbs(High[i] - High[i-1]) >           // �������� ���������� ������..
          equalPips*Point)                         // ..����������� �������� - ���������
         break;                                    // ..�����
   if (i - startIndex < 2)                         // ��� ����� � ����������� �����������
      return(false);      
   
   patternStart = i - 1;                           // ������ ������� ���� ��������
   return(true);                         
}
//+-------------------------------------------------------------------------------------+
//| ������� ���������� ����� � ����������� ����������                                   |
//+-------------------------------------------------------------------------------------+
bool IsTwoEqualMin(int startIndex, int total, int equalPips, int& patternStart)
{
   for (int i = startIndex+1; i < total; i++)      //����� �� ����������� ������� �������
      if (MathAbs(Low[i] - Low[i-1]) >             // �������� ��������� ������..
          equalPips*Point)                         // ..����������� �������� - ���������
         break;                                    // ..�����
   if (i - startIndex < 2)                         // ��� ����� � ����������� �����������
      return(false);      
   
   patternStart = i - 1;                           // ������ ������� ���� ��������
   return(true);                         
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� DBHLC �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
bool IsDBHLCPattern(int index, int total, int& patternStart)
{
   if (Close[index] >= Low[index+1])               // ����� ��� �������� ���� ��������..
      return(false);                               // ..����������� ���� - ��� ��������

   if (!IsTwoEqualMax(index, total, equalPipsDB,   // ����� �� ��������� ���� �� � ����..
                      patternStart))               // ..����� ������?
      return(false);                               // ���� ��� ���� ����� - ��� ��������

   return(true);
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� DBLHC �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
bool IsDBLHCPattern(int index, int total, int& patternStart)
{
   if (Close[index] <= High[index+1])              // ����� ��� �������� ���� ���������..
      return(false);                               // ..����������� ���� - ��� ��������

   if (!IsTwoEqualMin(index, total, equalPipsDB,   // ����� �� �������� ���� �� � ����..
                      patternStart))               // ..����� ������?
      return(false);                               // ���� ��� ���� ����� - ��� ��������

   return(true);
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� ��������� DBHLC � DBLHC                                         |
//+-------------------------------------------------------------------------------------+
void FindAndShowDB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;
// - 1 - == ������� DBHLC ===============================================================
   if (IsDBHLCPattern(index, total, patternStart)) // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ��������
                         colorDBHLC, 
                         typesOfPatterns[DB_INDEX], DBHLC_DESCRIPTION);
      PatternAlert(alertDBpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundDBpattern);     // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������� DBLHC ===============================================================
   if (IsDBLHCPattern(index, total, patternStart)) // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ��������
                         colorDBLHC, 
                         typesOfPatterns[DB_INDEX], DBLHC_DESCRIPTION);
      PatternAlert(alertDBpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundDBpattern);     // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� TBH �� ��������� ����                                  |
//+-------------------------------------------------------------------------------------+
bool IsTBHPattern(int index, int total, int& patternStart)
{
   if (Low[index] < Open[index+1])                 // ����� ��� �� ��� ��������..
       return(false);                              // ..���������� ����� - ��� ��������
   
   if (Close[index+1] <= Open[index+1])            // ���������� ��� �� ��� ������
      return(false);                               // ��� ��������

   if (!IsTwoEqualMax(index, total, equalPipsTB,   // ����� �� ��������� ���� �� � ����..
                      patternStart))               // ..����� ������?
      return(false);                               // ���� ��� ���� ����� - ��� ��������
   
   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� TBL �� ��������� ����                                  |
//+-------------------------------------------------------------------------------------+
bool IsTBLPattern(int index, int total, int& patternStart)
{
   if (High[index] > Open[index+1])                // ����� ��� �� ��� ��������..
       return(false);                              // ..���������� ����� - ��� ��������
   
   if (Close[index+1] >= Open[index+1])            // ���������� ��� �� ��� ���������
      return(false);                               // ��� ��������

   if (!IsTwoEqualMin(index, total, equalPipsTB,   // ����� �� �������� ���� �� � ����..
                      patternStart))               // ..����� ������?
      return(false);                               // ���� ��� ���� ����� - ��� ��������

   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� ��������� TBH � TBL                                             |
//+-------------------------------------------------------------------------------------+
void FindAndShowTB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;
// - 1 - == ������� TBH =================================================================
   if (IsTBHPattern(index, total, patternStart))   // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� �������� TBH
                         colorTBH,
                         typesOfPatterns[TB_INDEX], TBH_DESCRIPTION);
      PatternAlert(alertTBpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundTBpattern);     // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������� DBLHC ===============================================================
   if (IsTBLPattern(index, total, patternStart))   // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� �������� TBL
                         colorTBL,
                         typesOfPatterns[TB_INDEX], TBL_DESCRIPTION);
      PatternAlert(alertTBpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundTBpattern);     // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ����� ��� ������ � �� ������ � ����������� ���� ��� ������              |
//+-------------------------------------------------------------------------------------+
bool IsRails(int index, double body1, double body2)
{
   if (body1 <= 0)                                 // ��������� ��� �� �����/�������� - 
      return(false);                               // ..�����

   if (body2 <= 0)                                 // ������������� ��� �� ��������/�����
      return(false);                               // .. - �����

   double height1 = High[index] - Low[index];      // ����� ������ ��������� �����
   if (body1/height1 < bodyToHeightPercents/100)   // ���� ����� ������������ �� ������..
      return(false);                               // ..������� ���� - �����

   double height2 = High[index+1] - Low[index+1];  // ����� ������ ������������� �����
   if (body2/height2 < bodyToHeightPercents/100)   // ���� ����� ������������ �� ������..
      return(false);                               // ..������� ���� - �����

   double ratio = 100*                             // ��������� ����� ���� ����� ����� �
                  (1 - MathMin(body1, body2)/MathMax(body1, body2));// ..� ������ � %
   if (ratio > bodyGreatPercents)                  // ��������� ���� ��� ������ ������..
       return(false);                              // ..��������� - �����

   return(true);                                   // ������� ������ ������������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� ������ �� ��������� ����                       |
//+-------------------------------------------------------------------------------------+
bool IsBullsRailsPattern(int index, int total)
{
   double body1 = Close[index] - Open[index];      // ���� ��������� �����
   double body2 = Open[index+1] - Close[index+1];  // ���� ������������� �����
   
   return (IsRails(index, body1, body2));          // ������������ �� ������� ������?
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� ������ �� ��������� ����                    |
//+-------------------------------------------------------------------------------------+
bool IsBearsRailsPattern(int index, int total)
{
   double body1 = Open[index] - Close[index];      // ���� ��������� �����
   double body2 = Close[index+1] - Open[index+1];  // ���� ������������� �����
   
   return (IsRails(index, body1, body2));          // ������������ �� ������� ������?
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� ������                                                 |
//+-------------------------------------------------------------------------------------+
void FindAndShowRAILS(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == ����� ������� ������ ========================================================
   if (IsBullsRailsPattern(index, total))          // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ������� ��������..
                         colorBullsRails,          // ..������
                         typesOfPatterns[RAILS_INDEX], RAILS_DESCRIPTION);
      PatternAlert(alertRAILSpattern, index,       // �������� ���������� � ����������..
                   lastAlert, soundRAILSpattern);  // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� ������ =====================================================
   if (IsBearsRailsPattern(index, total))          // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ���������� ��������..
                         colorBearsRails,          // ..������
                         typesOfPatterns[RAILS_INDEX], RAILS_DESCRIPTION);
      PatternAlert(alertRAILSpattern, index,       // �������� ���������� � ����������..
                   lastAlert, soundRAILSpattern);  // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� OVB �� ��������� ����                                  |
//+-------------------------------------------------------------------------------------+
bool IsOVBPattern(int index, int type)
{
   if (High[index] <= High[index+1])               // �������� ������������� ����� ��..
      return(false);                               // ..�������� ��������� ������ - �����

   if (Low[index] >= Low[index+1])                 // ������� ������������� ����� ��..
      return(false);                               // ..�������� ��������� ������ - �����

   double body1 = Close[index] - Open[index];      // ���� ��������� �����
   double body2 = Close[index+1] - Open[index+1];  // ���� ������������� �����
   
   if ((body1 >= 0 && body2 >= 0) ||               // ��������� ��� ����� �����������..
       (body1 <= 0 && body2 <= 0))                 // ..������� � ���� �� ���� �����.
      return(false);                               // ������� �� ���������
      
   return ((body1 > 0 && type == BULL_BAR) ||      // ������� �����������, ���� ���������
           (body1 < 0 && type == BEAR_BAR));       // ..��� ��������� � ���������� ����
   
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� BUOVB �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
bool IsBUOVBPattern(int index, int total)
{
   if (Close[index] <= High[index+1])              // �������� ���������� ����� �� ������
      return(false);                               // ������� �� �����������

   return (IsOVBPattern(index, BULL_BAR));         // ������� �������� OVB
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� �������� BEOVB �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
bool IsBEOVBPattern(int index, int total)
{
   if (Close[index] >= Low[index+1])               // ������� ���������� ����� �� ������
      return(false);                               // ������� �� �����������

   return (IsOVBPattern(index, BEAR_BAR));         // ������� �������� OVB
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� ��������� BUOVB � BEOVB                                         |
//+-------------------------------------------------------------------------------------+
void FindAndShowOVB(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == ������� BUOVB ===============================================================
   if (IsBUOVBPattern(index, total))               // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� �������� BUOVB
                         colorBUOVB,               
                         typesOfPatterns[OVB_INDEX], BUOVB_DESCRIPTION);
      PatternAlert(alertOVBpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundOVBpattern);    // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������� BEOVB ===============================================================
   if (IsBEOVBPattern(index, total))               // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� �������� BEOVB
                         colorBEOVB,               
                         typesOfPatterns[OVB_INDEX], BEOVB_DESCRIPTION);
      PatternAlert(alertOVBpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundOVBpattern);    // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� PPR �� ��������� ����                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsPPRPattern(int index, int total)
{
   if (Close[index] <= High[index+1])              // �������� ���������� ����� �� ������
      return(false);                               // ������� �� �����������
      
   if (Low[index+1] >= Low[index+2] ||             // ������� ����������� ���� ��..
       Low[index+1] >= Low[index])                 // ..�������� ��������� ��������
      return(false);                               // ������� �� �����������
      
   if (Close[index+2] >= Open[index+2])            // ��������� ��� �������� �� ��������
      return(false);                               // ..��������� - �����

   return (true);                                  // ������� �����������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� PPR �� ��������� ����                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsPPRPattern(int index, int total)
{
   if (Close[index] >= Low[index+1])               // ������� ���������� ����� �� ������
      return(false);                               // ������� �� �����������
      
   if (High[index+1] <= High[index+2] ||           // �������� ����������� ���� ��..
       High[index+1] <= High[index])               // ..�������� ���������� ��������
      return(false);                               // ������� �� �����������

   if (Close[index+2] <= Open[index+2])            // ��������� ��� �������� �� ��������
      return(false);                               // ..������ - �����

   return (true);                                  // ������� �����������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� PPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowPPR(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == ����� ������� PPR ===========================================================
   if (IsBullsPPRPattern(index, total))            // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+2);            // �������� ���������� ���������
      ShowTypicalPattern(index + 2, index,         // ����������� ������� �������� PPR
                         colorBullsPPR,               
                         typesOfPatterns[PPR_INDEX], PPR_DESCRIPTION);
      PatternAlert(alertPPRpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundPPRpattern);    // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� PPR ========================================================
   if (IsBearsPPRPattern(index, total))            // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+2);            // �������� ���������� ���������
      ShowTypicalPattern(index + 2, index,         // ����������� ���������� �������� PPR
                         colorBearsPPR,               
                         typesOfPatterns[PPR_INDEX], PPR_DESCRIPTION);
      PatternAlert(alertPPRpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundPPRpattern);    // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ���������� �������� ���� ������� � ������ �������� (� �������)                      |
//+-------------------------------------------------------------------------------------+
int PD(double greater, double less)
{
   return(MathRound((greater - less)/Point));
}
//+-------------------------------------------------------------------------------------+
//| ��������� �� ����� � ������������� ���� � ����� �� ���� � ���?                      |
//+-------------------------------------------------------------------------------------+
bool IsCandleTypeAndSmallShadows(int index, int openCloseToHL, double smaller, 
                                 double greater)
{
   if (greater <= smaller)                         // ����� �� ��������� ���� - �����
      return(false);
   
   if (PD(High[index], greater) > openCloseToHL)   // ������� ���� ���� ����� �� �����..
      return(false);                               // ..��������� - �����

   if (PD(smaller, Low[index]) > openCloseToHL)    // ������� ���� ���� ����� �� �����..
      return(false);                               // ..�������� - �����
      
   return(true);
}
//+-------------------------------------------------------------------------------------+
//| ����� ������ ����������� ������                                                     |
//+-------------------------------------------------------------------------------------+
bool IsUpTrend(int index, int total, int& patternStart)
{
   while(High[patternStart+1] < High[patternStart] &&// ����� ������ ����������� ������
         patternStart < total)
      patternStart++;
      
   if (patternStart < index+2)                     // ���������� ����� ������� �����, ���
      return(false);                               // ..�� ���� ����� - �����
      
   return(true);                                   // ���� ���������� �����
}
//+-------------------------------------------------------------------------------------+
//| ����� ������ ����������� ������                                                     |
//+-------------------------------------------------------------------------------------+
bool IsDownTrend(int index, int total, int& patternStart)
{
   while(Low[patternStart+1] > Low[patternStart] &&// ����� ������ ����������� ������
         patternStart < total)
      patternStart++;
      
   if (patternStart < index+2)                     // ���������� ����� ������� �����, ���
      return(false);                               // ..�� ���� ����� - �����
      
   return(true);                                   // ���� ���������� �����
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� HR �� ��������� ����                        |
//+-------------------------------------------------------------------------------------+
bool IsBearsHRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // �������� �� �����
                                    openCloseToHighLowPointsHR,
                                    Close[index],  // ..��������� � ������ ������?
                                    Open[index]))
      return(false);                               

   if (!IsSimpleIB(index))                         // ��� ��������� ���� ������ ������..
      return(false);                               // ..����� ���������� �������..
                                                   // ..���������� ���

   if (!IsUpTrend(index, total, patternStart))     // ���� �� ������������ ����������..
      return(false);                               // ..�����, �� ������� �� ���������
   
   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� HR �� ��������� ����                           |
//+-------------------------------------------------------------------------------------+
bool IsBullsHRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // �������� �� �����
                                    openCloseToHighLowPointsHR,
                                    Open[index],  // ..������ � ������ ������?
                                    Close[index]))
      return(false);                               

   if (!IsSimpleIB(index))                         // ��� ��������� ���� ������ ������..
      return(false);                               // ..����� ���������� �������..
                                                   // ..���������� ���

   if (!IsDownTrend(index, total, patternStart))   // ���� �� ������������ ����������..
      return(false);                               // ..�����, �� ������� �� ���������
   
   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� HR                                                     |
//+-------------------------------------------------------------------------------------+
void FindAndShowHR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index+1;
// - 1 - == ����� ������� HR ============================================================
   if (IsBullsHRPattern(index, total, patternStart))//����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ������� ��������..
                         colorBullsHR,             // ..HR
                         typesOfPatterns[HR_INDEX], HR_DESCRIPTION);
      PatternAlert(alertHRpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundHRpattern);    // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� HR =========================================================
   if (IsBearsHRPattern(index, total, patternStart))//����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ���������� ��������..
                         colorBearsHR,             // ..HR
                         typesOfPatterns[HR_INDEX], HR_DESCRIPTION);
      PatternAlert(alertHRpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundHRpattern);     // ..��������
      return;
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� CPR �� ��������� ����                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsCPRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // �������� �� �����
                                    openCloseToHighLowPoints,
                                    Open[index],   // ..������ � ������ ������?
                                    Close[index]))
      return(false);                               

   if (PD(Close[index+1], Open[index]) < gapPoints)// ��� �� ��������� ����� ������..
      return(false);                               // ..��������� - �����

   if (Close[index+1] >= Close[index])             // �������� ��������� ����� �� �������
      return(false);                               // ..�������� ���������� ����� - �����

   if (Open[index+1] <= Close[index+1])            // ��������� ����� �� �������� - �����
      return(false);

   if (!IsDownTrend(index, total, patternStart))   // ���� �� ������������ ����������..
      return(false);                               // ..�����, �� ������� �� ���������
   
   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� CPR �� ��������� ����                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsCPRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // �������� �� �����
                                    openCloseToHighLowPoints,
                                    Close[index],  // ..��������� � ������ ������?
                                    Open[index]))
      return(false);                               

   if (PD(Open[index], Close[index+1]) < gapPoints)// ��� �� ��������� ����� ������..
      return(false);                               // ..��������� - �����

   if (Close[index+1] <= Close[index])             // �������� ��������� ����� �� �������
      return(false);                               // ..�������� ���������� ����� - �����

   if (Open[index+1] >= Close[index+1])            // ��������� ����� �� ����� - �����
      return(false);

   if (!IsUpTrend(index, total, patternStart))     // ���� �� ������������ ����������..
      return(false);                               // ..�����, �� ������� �� ���������
   
   return(true);                                   // ���� �������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� CPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowCPR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index+1;
// - 1 - == ����� ������� CPR ===========================================================
   if (IsBullsCPRPattern(index, total, patternStart))//����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ������� ��������..
                         colorBullsCPR,            // ..CPR
                         typesOfPatterns[CPR_INDEX], CPR_DESCRIPTION);
      PatternAlert(alertCPRpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundCPRpattern);    // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� CPR ========================================================
   if (IsBearsCPRPattern(index, total, patternStart))//����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ���������� ��������..
                         colorBearsCPR,            // ..CPR
                         typesOfPatterns[CPR_INDEX], CPR_DESCRIPTION);
      PatternAlert(alertCPRpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundCPRpattern);    // ..��������
      return;
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� Pin Bar �� ��������� ����                   |
//+-------------------------------------------------------------------------------------+
bool IsBullsPINBARPattern(int index, int total)
{
   if (Open[index] < Low[index+1])                 // ���� ��� �������� ���� ��������..
      return(false);                               // ..�����������, �� ��� �� ������

   if (Close[index] < Low[index+1])                // ���� ��� �������� ���� ��������..
      return(false);                               // ..�����������, �� ��� �� ������

   if (Low[index] >= Low[index+1])                 // ���� ���� ���� �� ������� �������
      return(false);                               // ..�����������, �� ��� �� ������

   if (PD(High[index], Close[index]) > closeToHighLowPoints)// �������� ����� ������ ����
      return(false);                               // ..����� max ����. ����� - �� ������
    
   double shadow = MathMin(Open[index], Close[index]) - Low[index];// ������ ���� �����
   double body = MathAbs(Open[index] - Close[index]);// ���� �����
   if (body == 0)
      body = Point;
   if (shadow/body < shadowToBodyKoef)             // ��������� ������� ���� � ���� �����
       return(false);                              // ..������ ��������� - ��� ��������

   double noseOutside = Low[index+1] - Low[index]; // ����������� ����� ���� �������
   if (noseOutside/shadow < noseOutsidePercent/100)// ����������� ��� ���� ������������..
      return(false);                               // ..������� - �� ������

   return (true);                                  // ������� �����������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� Pin Bar �� ��������� ����                   |
//+-------------------------------------------------------------------------------------+
bool IsBearsPINBARPattern(int index, int total)
{
   if (Open[index] > High[index+1])                // ���� ��� �������� ���� ���������..
      return(false);                               // ..�����������, �� ��� �� ������

   if (Close[index] > High[index+1])               // ���� ��� �������� ���� ���������..
      return(false);                               // ..�����������, �� ��� �� ������

   if (High[index] <= High[index+1])               // ���� ���� ���� �� ������� ��������
      return(false);                               // ..�����������, �� ��� �� ������

   if (PD(Close[index], Low[index]) > closeToHighLowPoints)// �������� ����� ������ ����
      return(false);                               // ..����� min ����. ����� - �� ������
    
   double shadow = High[index] - MathMax(Open[index], Close[index]);// ������� ���� �����
   double body = MathAbs(Open[index] - Close[index]);// ���� �����
   if (body == 0)
      body = Point;
   if (shadow/body < shadowToBodyKoef)             // ��������� ������� ���� � ���� �����
       return(false);                              // ..������ ��������� - ��� ��������
       
   double noseOutside = High[index] - High[index+1];// ����������� ����� ���� �������
   if (noseOutside/shadow < noseOutsidePercent/100)// ����������� ��� ���� ������������..
      return(false);                               // ..������� - �� ������

   return (true);                                  // ������� �����������
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� PPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowPINBAR(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == ����� ������� Pin Bar =======================================================
   if (IsBullsPINBARPattern(index, total))         // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ������� ��������..
                         colorBullsPPR,            // ..Pin Bar
                         typesOfPatterns[PINBAR_INDEX], PINBAR_DESCRIPTION);
      PatternAlert(alertPINBARpattern, index,      // �������� ���������� � ����������..
                   lastAlert, soundPINBARpattern); // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� Pin Bar ====================================================
   if (IsBearsPINBARPattern(index, total))         // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ������� ��������..
                         colorBearsPPR,            // ..Pin Bar
                         typesOfPatterns[PINBAR_INDEX], PINBAR_DESCRIPTION);
      PatternAlert(alertPINBARpattern, index,      // �������� ���������� � ����������..
                   lastAlert, soundPINBARpattern); // ..��������
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ��������� ����� ���� ������� ����� ������                                           |
//+-------------------------------------------------------------------------------------+
bool IsSignalCandleIsSmall(int signalIndex, double maxPercents)
{
   double heightFirst = High[signalIndex+1] - Low[signalIndex+1];// ������ ������ �����
   if (heightFirst == 0)                           // ����� �� ������ ���� ������� ������
      return(false);                               // ������ � �������� ������� �� 0

   double heightSignal = High[signalIndex] - Low[signalIndex]; // ������ ���������� �����
   if (heightSignal/heightFirst > maxPercents/100) // ��������� ������ ���������� �����..
       return(false);                              // ..� ������ ������ ����� �� ������..
                                                   // ..���� ������ ������������ ��������
   return(true);
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� MCM �� ��������� ����                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsMCMPattern(int index, int total)
{
   if (High[index] <= High[index+1])               // ���� ���������� ��� �� ������ �����
      return(false);                               // ..���������� ���, �� ��� �� MCM

   if (Close[index] >= Open[index])                // ���� ���������� ��� �� ��������, ��
      return(false);                               // ..��� �� ���

   if (!IsCandleTypeAndSmallShadows(index+1,       // ���� ������ ����� �� ��������..
                                    openCloseToHighLowPointsMCM,// ..������ ��� ��..
                                    Open[index+1], // ..����� ����� ����, �� ��� �� ��� 
                                    Close[index+1]))
      return(false);                               
     
   return (IsSignalCandleIsSmall(index, signalToFirstPercents));
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� MCM �� ��������� ����                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsMCMPattern(int index, int total)
{
   if (Low[index] >= Low[index+1])                 // ���� ���������� ��� �� ������ ����
      return(false);                               // ..���������� ���, �� ��� �� MCM

   if (Close[index] <= Open[index])                // ���� ���������� ��� �� �����, ��..
      return(false);                               // ..��� �� ���

   if (!IsCandleTypeAndSmallShadows(index+1,       // ���� ������ ����� �� ��������..
                                    openCloseToHighLowPointsMCM,// .. ��������� ��� ��..
                                    Close[index+1],// ..����� ����� ����, �� ��� �� ��� 
                                    Open[index+1]))
      return(false);                               
      
   return (IsSignalCandleIsSmall(index, signalToFirstPercents));
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� MCM                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowMCM(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == ����� ������� MCM ===========================================================
   if (IsBullsMCMPattern(index, total))            // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ������� ��������..
                         colorBullsMCM,            // ..MCM
                         typesOfPatterns[MCM_INDEX], MCM_DESCRIPTION);
      PatternAlert(alertMCMpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundMCMpattern);    // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� MCM ========================================================
   if (IsBearsMCMPattern(index, total))            // ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, index+1);            // �������� ���������� ���������
      ShowTypicalPattern(index + 1, index,         // ����������� ���������� ��������..
                         colorBearsMCM,            // ..MCM
                         typesOfPatterns[MCM_INDEX], MCM_DESCRIPTION);
      PatternAlert(alertMCMpattern, index,         // �������� ���������� � ����������..
                   lastAlert, soundMCMpattern);    // ..��������
      return;
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ������� �������� IR �� ��������� ����                           |
//+-------------------------------------------------------------------------------------+
bool IsBullsIRPattern(int index, int total, int& patternStart)
{
   if (PD(Low[index], High[index+1]) < secondGap)  // �������� ������� ������� ����
      return(false);

   if (PD(Low[index+2], High[index+1]) < firstGap) // �������� ������� ������� ����
      return(false);

   return (IsDownTrend(index+1, total, patternStart));
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� IR �� ��������� ����                        |
//+-------------------------------------------------------------------------------------+
bool IsBearsIRPattern(int index, int total, int& patternStart)
{
   if (PD(Low[index+1], High[index]) < secondGap)  // �������� ������� ������� ����
      return(false);

   if (PD(Low[index+1], High[index+2]) < firstGap) // �������� ������� ������� ����
      return(false);

   return (IsUpTrend(index+1, total, patternStart));
}
//+-------------------------------------------------------------------------------------+
//| ����� � ����������� �������� Island Reversal                                        |
//+-------------------------------------------------------------------------------------+
void FindAndShowIR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index + 2;
// - 1 - == ����� ������� Island Reversal ===============================================
   if (IsBullsIRPattern(index, total, patternStart))// ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ������� ��������..
                         colorBullsIR,             // ..Island Reversal
                         typesOfPatterns[IR_INDEX], IR_DESCRIPTION);
      PatternAlert(alertIRpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundIRpattern);     // ..��������
      return;
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ������� Island Reversal ============================================
   if (IsBearsIRPattern(index, total, patternStart))// ����������� � ����������� ��������
   {
      DeleteAnyPattern(index, patternStart);       // �������� ���������� ���������
      ShowTypicalPattern(patternStart, index,      // ����������� ������� ��������..
                         colorBearsIR,             // ..Island Reversal
                         typesOfPatterns[IR_INDEX], IR_DESCRIPTION);
      PatternAlert(alertIRpattern, index,          // �������� ���������� � ����������..
                   lastAlert, soundIRpattern);     // ..��������
      return;
   }
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                 |
//+-------------------------------------------------------------------------------------+
int start()
{
// - 1 - == ��������������� �������� ====================================================
   int total;                                      // ������ �������� ������� � �������..
                                                   // ..����
   int limit = GetRecalcIndex(total);              // ��������� ������ ��������� ���
// - 1 - == ��������� ����� =============================================================
  
// - 2 - == ������ �������� ������� � ����������� ��������� =============================
   for (int i = limit; i > 0; i--)                 // ���������� ��� ����� ����
   {
      if (showIBpattern)                           // ���� ��������� ������������..
         FindAndShowIB(i, total);                  // ..������� DB, �� ��������� ���

      if (showDBpattern)                           // ���� ��������� ������������..
         FindAndShowDB(i, total);                  // ..������� DB, �� ��������� ���

      if (showTBpattern)                           // ���� ��������� ������������..
         FindAndShowTB(i, total);                  // ..������� TB, �� ��������� ���

      if (showRAILSpattern)                        // ���� ��������� ������������..
         FindAndShowRAILS(i, total);               // ..������� ������, �� ��������� ���

      if (showOVBpattern)                          // ���� ��������� ������������..
         FindAndShowOVB(i, total);                 // ..�������� BUOVB � BEOVB, ��..
                                                   // ..��������� ��

      if (showPPRpattern)                          // ���� ��������� ������������..
         FindAndShowPPR(i, total);                 // ..������� PPR, �� ��������� ���

      if (showHRpattern)                           // ���� ��������� ������������..
         FindAndShowHR(i, total);                  // ..������� HR, �� ��������� ���

      if (showCPRpattern)                          // ���� ��������� ������������..
         FindAndShowCPR(i, total);                 // ..������� CPR, �� ��������� ���

      if (showPINBARpattern)                       // ���� ��������� ������������..
         FindAndShowPINBAR(i, total);              // ..������� Pin Bar, �� ��������� ���

      if (showMCMpattern)                          // ���� ��������� ������������..
         FindAndShowMCM(i, total);                 // ..������� MCM, �� ��������� ���

      if (showIRpattern)                           // ���� ��������� ������������..
         FindAndShowIR(i, total);                  // ..������� IR, �� ��������� ���
   }
// - 2 - == ��������� ����� =============================================================
      
   WindowRedraw();
   
   return(0);
}

