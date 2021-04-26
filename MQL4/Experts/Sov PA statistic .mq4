#property copyright "Scritong"
#property link      "http://autograf.dp.ua"

//---- input parameters
extern string    A1 = "����� ������. ���� Lots = 0, �� ��������� � ���������";
extern double    Lots = 0.1;
extern double    PercentOfDepo = 5;
extern string    A2 = "������ � ������� �� ���� �������� �������";
extern int       defaultTP = 50;
extern string    A3 = "����-������ � ������� �� ������� ��������";
extern int       defaultSLOffset = 50;

extern string    A4_0 = "=== ��������������� ==============================";
extern string    A4_1 = "���/���� ���������������";
extern bool      useOptimization = true;
extern string    A4_2 = "�������� ����� � ������� �� ������ � ��.., ��.";
extern int       maxSLTP = 200;
extern string    A4_3 = "��� ��������� ����� � �������, ��";
extern int       stepSLTP = 2;
extern string    A4_4 = "��������� �����������, ��� ������� ����������� ������";
extern double    minExpectation = 5.0; 
extern string    A4_5 = "����������� ���������� ����. ������ ��� �������� �����";
extern double    minStatDeals = 10; 
extern string    A4_6 = "���������� �������������� �����";
extern int       optimizationBars = 500;
extern string    A4_7 = "==================================================";

extern string    A5_0 = "=== ������� ���������� ��� =======================";
extern string    A5_1 = "���������/���������� ������ ��������";
extern bool      useIBpattern = true;
extern string    A5_2 = "==================================================";
extern string    A6_0 = "=== �������� DBHLC � DBLHC =======================";
extern string    A6_1 = "���������/���������� ������ ��������";
extern bool      useDBpattern = true;
extern string    A6_2 = "������� � �������, ����������� �������";
extern int       equalPipsDB = 3;
extern string    A6_3 = "==================================================";
extern string    A7_0 = "=== �������� TBH � TBL ===========================";
extern string    A7_1 = "���������/���������� ������ ��������";
extern bool      useTBpattern = true;
extern string    A7_3 = "������� � �������, ����������� �������";
extern int       equalPipsTB = 3;
extern string    A7_4 = "==================================================";
extern string    A8_0 = "======= ������� ������ ==============";
extern string    A8_1 = "���������/���������� ������ ��������";
extern bool      useRAILSpattern = true;
extern string    A8_2 = "������������ ������������� ��� ����� �� ������, � %";
extern double    bodyGreatPercents = 10;
extern string    A8_3 = "����������� ���� ���� ����� � ����� ������ �����, � %";
extern double    bodyToHeightPercents = 20;
extern string    A8_4 = "=======================================================";
extern string    A9_0 = "======= �������� BUOVB � BEOVB ==============";
extern string    A9_1 = "���������/���������� ������ ��������";
extern bool      useOVBpattern = true;
extern string    A9_2 = "=======================================================";
extern string    A10_0 = "=== ������� PPR ======================================";
extern string    A10_1 = "���������/���������� ������ ��������";
extern bool      usePPRpattern = true;
extern string    A10_2 = "=======================================================";
extern string    A11_0 = "=== ������� HR ========================================";
extern string    A11_1 = "���������/���������� ������ ��������";
extern bool      useHRpattern = true;
extern string    A11_2 = "�������� ��� �������� � �������� � ��� � ����, � �������";
extern int       openCloseToHighLowPointsHR = 3;
extern string    A11_3 = "=======================================================";
extern string    A12_0 = "=== ������� CPR =======================================";
extern string    A12_1 = "���������/���������� ������ ��������";
extern bool      useCPRpattern = true;
extern string    A12_2 = "�������� ��� �������� � �������� � ��� � ����, � �������";
extern int       openCloseToHighLowPoints = 3;
extern string    A12_3 = "����������� �������� ����, � �������";
extern int       gapPoints = 2;
extern string    A12_4 = "=======================================================";
extern string    A13_0 = "=== ������� Pin Bar ===================================";
extern string    A13_1 = "���������/���������� ������ ��������";
extern bool      usePINBARpattern = true;
extern string    A13_2 = "�������� ���� �������� � ��� ��� ����, � �������";
extern int       closeToHighLowPoints = 3;
extern string    A13_3 = "����������� ��������� ���� (����) � ���� �����";
extern double    shadowToBodyKoef = 3.0;
extern string    A13_4 = "����������� ����� ����, ����������� �� ���������� ���, � %";
extern double    noseOutsidePercent = 75.0;
extern string    A13_5 = "=======================================================";
extern string    A14_0 = "=== ������� MCM =======================================";
extern string    A14_1 = "���������/���������� ������ ��������";
extern bool      useMCMpattern = true;
extern string    A14_2 = "�������� ��� �������� � �������� ������ ����� � ��� ��� ����, � �������";
extern int       openCloseToHighLowPointsMCM = 3;
extern string    A14_3 = "������������ ��������� ������ ���������� ����� � ������, � %";
extern double    signalToFirstPercents = 35.0;
extern string    A14_4 = "=======================================================";
extern string    A15_0 = "=== ������� Island Reversal ===========================";
extern string    A15_1 = "���������/���������� ������ ��������";
extern bool      useIRpattern = true;
extern string    A15_2 = "�������� ������� (����� �� �������) ���� � �������";
extern int       firstGap = 1;
extern string    A15_3 = "�������� ������� (������ �� �������) ���� � �������";
extern int       secondGap = 1;
extern string    A15_4 = "=======================================================";

extern string    Z1 = "=== ������ ��������� ===";
extern string    OpenOrderSound = "ok.wav";
extern int       MagicNumber = 4738293;

int g_ticket,                                      // ����� ������� �������
    g_type;                                        // ��� ������� ������� 

bool g_activate,                                   // ������� �������� �������������
     g_fatalError;                                 // ������� ������� ��������� ������
     
double g_tickSize,                                 // ������ ������������ ��������� ����
       g_spread,                                   // �������� ������
       g_stopLevel,                                // ������ ������������ ������ ������
                                                   // ..� ������� ��������
       g_freezeLevel,                              // ������ �������� ��������� �..
                                                   // ..������� ��������
       g_lotStep,
       g_minLot,                                   // ����������� ����� ������
       g_maxLot,                                   // ������������ ����� ������
       g_slBuyPrice,                               // ��������� ���� ����-������� ������
                                                   // ..Buy
       g_slSellPrice;                              // ��������� ���� ����-������� ������
                                                   // ..Sell
datetime g_lastBar;                                // ����� �������� ���������� ����, ��
                                                   // ..������� ���� ����������� ���..
                                                   // ..����������� ������� � ��������..
                                                   // ..��������
                                                   
// ��� ���������� �������� ��������
#define EXE_MODE_NO       0                        // �� ���������
#define EXE_MODE_MARKET   1                        // Market Execution
#define EXE_MODE_INSTANT  2                        // Instant Execution

#define BULL_BAR        1                          // ������������� ������ �����
#define BEAR_BAR        -1                         // ������������� ��������� �����

#define PATTERN_NO      0                          // ������������� ���������� ��������
#define PATTERN_BULL    1                          // ������������� ������� �������..
                                                   // ..��������
#define PATTERN_BEAR    -1                         // ������������� ������� ���������..
                                                   // ..��������


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


#include <stderror.mqh>
                                                   
//+-------------------------------------------------------------------------------------+
//| ������� ������������� ��������                                                      |
//+-------------------------------------------------------------------------------------+
int init()
{
   g_fatalError = False;

   GetMarketInfo();                                // ���� ���������� �� ��������..
                                                   // ..��������
    
   g_lastBar = 0;
   g_activate = True;                              // ��� �������� ������� ���������,..
                                                   // ..�������� ���� ��������� ��������
   
//----
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| ������� ��������������� ��������                                                    |
//+-------------------------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| ��������� �������� ����������                                                       |
//+-------------------------------------------------------------------------------------+
void GetMarketInfo()
{
   g_tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   g_spread = MarketInfo(Symbol(), MODE_SPREAD)*Point;
   g_stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL)*Point;
   g_freezeLevel = MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point;
   g_minLot = MarketInfo(Symbol(), MODE_MINLOT);   
   g_maxLot = MarketInfo(Symbol(), MODE_MAXLOT);   
   g_lotStep = MarketInfo(Symbol(), MODE_LOTSTEP); 
}
//+-------------------------------------------------------------------------------------+
//| ������ ������ ������, ������ �� ��������� �������.                                  |
//+-------------------------------------------------------------------------------------+
double GetLots()
{
// - 2 - == ���� ����������� ������� ������ =============================================
   if (Lots == 0)                                  // ���� �������� Lots ����� ����, ��
   {                                               // ..���������� ����� �� ���������..
                                                   // ..��������� ���������
      double lot = (PercentOfDepo/100)*AccountFreeMargin()/
                                MarketInfo(Symbol(), MODE_MARGINREQUIRED);
      return(LotRound(lot));
   }
   else                                            // ���� �������� �� ����� ����, ��..
      return(LotRound(Lots));                      // ..������ ������ ��� ��������
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| �������� ������ �� ������������ � ����������                                        |
//+-------------------------------------------------------------------------------------+
double LotRound(double L)
{
   return(MathRound(MathMin(MathMax(L, g_minLot), g_maxLot)/g_lotStep)*g_lotStep);
}
//+-------------------------------------------------------------------------------------+
//| �������� ��������� ������. ���� ����� ��������, �� ��������� True, ����� - False    |
//+-------------------------------------------------------------------------------------+  
bool WaitForTradeContext()
{
   int P = 0;
   while(IsTradeContextBusy() && P < 5)
   {
      P++;
      Sleep(1000);
   }
   if (P == 5)
     return(False);
   return(True);    
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� ������� � ������� ��������� �� ������               |
//+-------------------------------------------------------------------------------------+
bool IsEnoughMoney(double lot)
{
   static bool freeMarginAlert = false;            // ���� ���������� ���������. 
                                                   // ������������� ������ ���������..
                                                   // ..�� ������ �� ������ ����

   if (AccountFreeMarginCheck(Symbol(), OP_BUY, lot) > 0 && // ������� ����������
       GetLastError() != ERR_NOT_ENOUGH_MONEY) 
   {
      freeMarginAlert = false;                     // ����� ����� ���������� ���������
      return(true);                                // ��� ������
   }       
       
   if (!freeMarginAlert)                           // ��������� ��� �� ���� ������
   {
      Print("������������ ������� ��� �������� �������. Free Margin = ", 
            AccountFreeMargin());
      freeMarginAlert = true;                      // � ��������� ��� �� ����������..
                                                   // ..���������
   }  

   return(false);  
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������ ��� ��������, ������� � ����-������� ��������� ������         |
//+-------------------------------------------------------------------------------------+
bool IsMarketOrderParametersCorrect(int type, double& price, double& sl, double& tp, 
                                    bool redefinition)
{
   RefreshRates();

// - 1 - == �������� ���������� ������ Buy ==============================================
   if (type == OP_BUY)
   {
      price = NP(Ask);
      if (tp - Bid <= g_stopLevel && tp != 0)
         if (redefinition) 
            tp = NP(Bid + g_stopLevel + g_tickSize);
         else
            return(false);
      if (Bid - sl <= g_stopLevel)
         if (redefinition) 
            sl = NP(Bid - g_stopLevel - g_tickSize);
         else
            return(false);
      return(true);
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ���������� ������ Sell =============================================
   price = NP(Bid);
   if (Ask - tp <= g_stopLevel) 
      if (redefinition) 
         tp = NP(Ask - g_stopLevel - g_tickSize);
      else
         return(false);
   if (sl - Ask <= g_stopLevel && sl != 0)
      if (redefinition) 
         sl = NP(Ask + g_stopLevel + g_tickSize);
      else
         return(false);
   return(true);
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ����������� ���� ���������� �������� ��������                                       |
//+-------------------------------------------------------------------------------------+
int GetExecutionType()
{
   static int executionMode = EXE_MODE_NO;         // ��� ���������� �������� ��������
   
   if (executionMode != EXE_MODE_NO)               // ��� ���������� ��� ���������
      return(executionMode);
   
   if (IsTesting())                                // � ������� ����� ������������..
   {                                               // ..Instant Execution
      executionMode = EXE_MODE_INSTANT;         
      return(executionMode);
   }
      
   executionMode = EXE_MODE_INSTANT;               // �� ��������� �������, ��� Instant
   OrderSend(Symbol(), OP_BUY, 1, 0, 0, Point, 0); // ����������� ���� ����������
   if (GetLastError() == ERR_INVALID_STOPS)        // ������������ ����� - Market
      executionMode = EXE_MODE_MARKET;             // ������ ��� ����������
   return(executionMode);  
}
//+-------------------------------------------------------------------------------------+
//| ���������� ���� ������ � ���������� �����������                                     |
//+-------------------------------------------------------------------------------------+
string OrderTypeToString(int type)
{
   switch (type)
   {
      case OP_BUY: return("Buy");
      case OP_SELL: return("Sell");
      case OP_BUYLIMIT: return("Buy Limit");
      case OP_SELLLIMIT: return("Sell Limit");
      case OP_BUYSTOP: return("Buy Stop");
      case OP_SELLSTOP: return("Sell Stop");
   }
   return("Unknown order");
}
//+-------------------------------------------------------------------------------------+
//| �������� ������ ��� ���� ���������� Instant Execution, ���������� �����             |
//+-------------------------------------------------------------------------------------+
int OpenOrderWithInstantMode(int type, double lot, double price, double sl, double tp, 
                              int magicNumber)
{
   ///////////////////////////////////////////////////////////////////////////////
   double tp2 = 0;
   if(type == OP_BUY)
      tp2 = NormalizeDouble((High[1]+(High[1]-Low[1])*1.61), Digits());
   if(type == OP_SELL)
      tp2 = NormalizeDouble((Low[1]-(High[1]-Low[1])*1.61), Digits());
   ///////////////////////////////////////////////////////////////////////////////
   string orderType = OrderTypeToString(type);
   Comment("��������� ������ �� �������� ������ ", orderType, "...");  
   int ticket = OrderSend(Symbol(), type, lot,     // �������� �������
                          price, 3, sl, /*tp*/tp2, NULL, 
                          magicNumber, 0);
   
   if (ticket > 0)                                 // �������� �������� ������
   {                          
      Comment("����� ", orderType, " ������ �������!"); 
      PlaySound(OpenOrderSound); 
      return(ticket); 
   }
                          
   int error = GetLastError();                     // ��������� �������� ������
   Comment("������ �������� ������ ", orderType, ": ", error);
   return(ticket);
}
//+-------------------------------------------------------------------------------------+
//| ��������� ��� ����-������� � ������� � ������������ � �������� ��������� ���������  |
//+-------------------------------------------------------------------------------------+
void CorrectionOfStops(int type, double& sl, double& tp)
{
   RefreshRates();
   if (type == OP_BUY)
   {
      if (Bid - sl <= g_stopLevel)
         sl = NP(Bid - g_stopLevel - g_tickSize);
      if (tp - Bid <= g_stopLevel && tp != 0)
         tp = NP(Bid + g_stopLevel + g_tickSize);
      return;
   }
   if (sl - Ask <= g_stopLevel && sl != 0)
      sl = NP(Ask + g_stopLevel + g_tickSize);
   if (Ask - tp <= g_stopLevel)
      tp = NP(Ask - g_stopLevel - g_tickSize);
}
//+-------------------------------------------------------------------------------------+
//| �������� ������ ��� ���� ���������� Market Execution                                |
//+-------------------------------------------------------------------------------------+
bool OpenOrderWithMarketMode(int type, double lot, double price, double sl, double tp, 
                             int magicNumber)
{
   int ticket = OpenOrderWithInstantMode(type, lot, price, 0, 0, magicNumber);
   if (ticket <= 0)
      return(false);
    
   if (!OrderSelect(ticket, SELECT_BY_TICKET) || 
       OrderCloseTime() != 0)   
   {
      Alert("��������� ������ ��� ��������� ������ � �������� ������ ������!");
      return(false);
   }
   
   Comment("��������� ����-������� � ������� ������...");
   int cnt = 0;
   while (!IsStopped())
   {
      while (!WaitForTradeContext()) {}
      CorrectionOfStops(type, sl, tp);
      if (OrderModify(ticket, 0, sl, tp, OrderExpiration()))
      {
         Comment("����-������ � ������ ������� �����������!");
         return(true);
      }
      Sleep(1000);
   }
}
//+-------------------------------------------------------------------------------------+
//| �������� ��������� ������ � �������������� ������������ ���� ���������� ������      |
//+-------------------------------------------------------------------------------------+
bool OpenByMarket(int type, double lot, double sl, double tp, 
                  int magicNumber, bool redefinition = true)
// redefinition - ��� true ������������ ��������� �� ���������� ����������
//                ��� false - ���������� ������
{
// - 1 - == �������� ������������ ���� ������ � ������������� ��������� ������� =========
   if (type > OP_SELL)
      return(false);
   
   if (!IsEnoughMoney(lot))
      return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ����������� ��������� ������ � ������������ ���������� ������ ======
   if (!WaitForTradeContext())
   {
      Comment("����� �������� ������������ ��������� ������ �������!");
      return(false);
   }

   double price;                                   // ���� ���������� ������
   if (!IsMarketOrderParametersCorrect(type, price, sl, tp, redefinition))
      return(false);
// - 2 - == ��������� ����� =============================================================
 
// - 3 - == �������� ������ � �������� ��������� ������ =================================
   if (GetExecutionType() == EXE_MODE_INSTANT ||
       (sl == 0 && tp == 0))
      return(OpenOrderWithInstantMode(type, lot, price, sl, tp, magicNumber) > 0);
      
   return(OpenOrderWithMarketMode(type, lot, price, sl, tp, magicNumber));
}
//+-------------------------------------------------------------------------------------+
//| ���������� �������� � �������� ������ ����                                          |
//+-------------------------------------------------------------------------------------+
double NP(double A)
{
   return(MathRound(A/g_tickSize)*g_tickSize);
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
   patternStart = index;
   while(IsSimpleIB(patternStart) &&               // ����� ������������ ��������� ������
         patternStart < total)
      patternStart++;
      
   if (patternStart == index)                      // �� ���� ������� �� ������
      return(false);   
      
   return(true);                                   // ������� ������
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
//| �������� ������������� �������� IB �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
int IBPatternDir(int index, int total, int& patternStart)
{
   if (!IsIBPattern(index, total, patternStart))
      return (PATTERN_NO);
      
   if (Close[index] >= Open[index])
      return (PATTERN_BULL);
   return (PATTERN_BEAR);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� DB �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
int DBPatternDir(int index, int total, int& patternStart)
{
   if (IsDBLHCPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsDBHLCPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� TB �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
int TBPatternDir(int index, int total, int& patternStart)
{
   if (IsTBLPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsTBHPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� ������ �� ��������� ����                            |
//+-------------------------------------------------------------------------------------+
int RAILSPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsRailsPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsRailsPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� CPR �� ��������� ����                               |
//+-------------------------------------------------------------------------------------+
int CPRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsCPRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsCPRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� HR �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
int HRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsHRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsHRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� OVB �� ��������� ����                               |
//+-------------------------------------------------------------------------------------+
int OVBPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBUOVBPattern(index, total))
      return (PATTERN_BULL);
   if (IsBEOVBPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� PPR �� ��������� ����                               |
//+-------------------------------------------------------------------------------------+
int PPRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsPPRPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsPPRPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� Pin Bar �� ��������� ����                           |
//+-------------------------------------------------------------------------------------+
int PINBARPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsPINBARPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsPINBARPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� MCM �� ��������� ����                               |
//+-------------------------------------------------------------------------------------+
int MCMPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsMCMPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsMCMPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������������� �������� IR �� ��������� ����                                |
//+-------------------------------------------------------------------------------------+
int IRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 2;
   if (IsBullsIRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsIRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| �������� ������� ������ �� ����������� ��������� �� ��������� ����                  |
//+-------------------------------------------------------------------------------------+
int GetAnyPatternTypeAndDir(int index, int& patternDir, int& patternStart)
{
   int total = Bars - 2;
   if (useIRpattern)                               // ���� ��������� ������������..
   {                                               // ..������� IR, �� ��������� ���..
      patternDir = IRPatternDir(index, total, patternStart);// ..�������
      if (patternDir != PATTERN_NO)
         return (IR_INDEX);
   }
   
   if (useMCMpattern)                              // ���� ��������� ������������..
   {                                               // ..������� MCM, �� ��������� ���..
      patternDir = MCMPatternDir(index, total, patternStart); // ..�������
      if (patternDir != PATTERN_NO)
         return (MCM_INDEX);
   }
   
   if (usePINBARpattern)                           // ���� ��������� ������������..
   {                                               // ..������� Pin Bar, �� ���������..
      patternDir = PINBARPatternDir(index, total, patternStart); // ..��� �������
      if (patternDir != PATTERN_NO)
         return (PINBAR_INDEX);
   }

   if (useCPRpattern)                              // ���� ��������� ������������..
   {                                               // ..������� CPR, �� ��������� ���..
      patternDir = CPRPatternDir(index, total, patternStart); // ..��� �������
      if (patternDir != PATTERN_NO)
         return (CPR_INDEX);
   }
   
   if (useHRpattern)                               // ���� ��������� ������������..
   {                                               // ..������� HR, �� ��������� ���..
      patternDir = HRPatternDir(index, total, patternStart); // ..��� �������
      if (patternDir != PATTERN_NO)
         return (HR_INDEX);
   }
   
   if (usePPRpattern)                              // ���� ��������� ������������..
   {                                               // ..������� PPR, �� ��������� ���..
      patternDir = PPRPatternDir(index, total, patternStart); // ..�������
      if (patternDir != PATTERN_NO)
         return (PPR_INDEX);
   }
   
   if (useOVBpattern)                              // ���� ��������� ������������..
   {                                               // ..�������� BUOVB � BEOVB, ��..
      patternDir = OVBPatternDir(index, total, patternStart); // ..��������� ��� �������
      if (patternDir != PATTERN_NO)
         return (OVB_INDEX);
   }
   
   if (useRAILSpattern)                            // ���� ��������� ������������..
   {                                               // ..������� ������, �� ���������..
      patternDir = RAILSPatternDir(index, total, patternStart); // ..��� �������
      if (patternDir != PATTERN_NO)
         return (RAILS_INDEX);
   }
   
   if (useTBpattern)                               // ���� ��������� ������������..
   {                                               // ..������� TB, �� ��������� ���..
      patternDir = TBPatternDir(index, total, patternStart); // ..�������
      if (patternDir != PATTERN_NO)
         return (TB_INDEX);
   }

   if (useDBpattern)                               // ���� ��������� ������������..
   {                                               // ..������� DB, �� ��������� ���..
      patternDir = DBPatternDir(index, total, patternStart); // ..�������
      if (patternDir != PATTERN_NO)
         return (DB_INDEX);
   }

   if (useIBpattern)                               // ���� ��������� ������������..
   {                                               // ..������� IB, �� ��������� ���..
      patternDir = IBPatternDir(index, total, patternStart); // ..�������
      if (patternDir != PATTERN_NO)
         return (IB_INDEX);
   }
   
   return (-1);                                    // �� ���� �� ��������� �� ���������
}
//+-------------------------------------------------------------------------------------+
//| ���������� ������ ����-������� �� ����������� �������� � ��� ������                 |
//+-------------------------------------------------------------------------------------+
double GetPatternSL(int index, int patternStart, int patternDir, int offset)
{
   if (patternDir == PATTERN_BEAR)
      return (High[iHighest(NULL, 0, MODE_HIGH, patternStart - index + 1, index)] +
              offset*Point + g_spread);
              
   return (Low[iLowest(NULL, 0, MODE_LOW, patternStart - index + 1, index)] -
           offset*Point);
}
//+-------------------------------------------------------------------------------------+
//| ���������� ������ ������� �� ����������� �������� � ������� ����                    |
//+-------------------------------------------------------------------------------------+
double GetTP(int patternDir, int tpSize)
{
   RefreshRates();
   if (patternDir == PATTERN_BEAR)
      return (Bid - tpSize*Point);
              
   return (Ask + tpSize*Point);
}
//+-------------------------------------------------------------------------------------+
//| ���������� �������� � �������                                                       |
//+-------------------------------------------------------------------------------------+
int ToPoints(double value)
{
   return (MathRound(value/Point));
}
//+-------------------------------------------------------------------------------------+
//| ����������� ����� ������ (������� ��� ������)                                       |
//+-------------------------------------------------------------------------------------+
int GetPatternProfit(int start, int finish, double openPrice, int direction,
                     double slPrice, int useTP, int useSLOffset)
{
// - 1 - == ������ ��� ������� � ����-������� ===========================================
   if (direction == PATTERN_BULL)                  // ������� ��� �� Bid. ������� ���..
   {                                               // ..������� ������ ������� TP �������
      double tpPrice = openPrice + Point*useTP + g_spread;// .. �� �����
      slPrice -= useSLOffset*Point;                // ����-������ � ��� �� Bid
   }
   else                                            // ������� ��� �� Bid. ������� ���..
   {                                               // ..�������� ������ ������ ��������
      tpPrice = openPrice - Point*useTP - g_spread;// ..�� �����
      slPrice += useSLOffset*Point - g_spread;     // ����-������
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������ ��� ������� � ����-������� ===========================================
   for (int i = finish-1; i >= start; i--)         // ������� ������� ���������� �����..
   {                                               // ..�������
      if (direction == PATTERN_BULL)               // � ������� ������ ����-������..
      {                                            // ..��������� �����, � ������ -..
         if (Low[i] <= slPrice)                    // ..������
            return (-ToPoints(openPrice-slPrice+g_spread));
         if (High[i] >= tpPrice)
            return (useTP);
         continue;
      }

      if (High[i] >= slPrice)                      // � �������� ������ ����-������..
         return (-ToPoints(slPrice-openPrice+g_spread));// ..��������� ������, � ������ -
      if (Low[i] <= tpPrice)                       // ..�����
         return (useTP);
   }
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������ �� ������� �� �� �����, �� ������� ===================================
   double closePrice = Open[start-1];              // ���� �������� ���� - �������� ����
   if (direction == PATTERN_BULL)                  // ��� ������� ������ ���� ����,..
      return (ToPoints(closePrice - openPrice - g_spread));
   return (ToPoints(openPrice - closePrice - g_spread));// ..��� �������� - ������
// - 3 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ������ �������������� ������                                                        |
//+-------------------------------------------------------------------------------------+
void CalculateData(int patternCnt, int& patternIndex[], int& patternDir[], 
                   double& patternSL[], int& totalNetProfit,
                   int useTP, int useSLOffset)
{
   totalNetProfit = 0;
   
   for (int i = patternCnt-1; i >= 0; i--)         // �� ������� ���������
   {
      if (i > 0)                                   // ������ ������� (������ �� �������)
         int start = patternIndex[i-1];            // ..������� �� �������
      else
         start = 1;
      int finish = patternIndex[i];                // ����� ������� ������� �� �������
      double openPrice = Open[finish-1];           // ���� �������� ������
      
      int netProfit = GetPatternProfit(start, finish,// ���� ������
                                       openPrice, 
                                       patternDir[i], 
                                       patternSL[i], useTP, useSLOffset);

      totalNetProfit += netProfit;                 // ����� ���� ���� ������
   }
}    
//+-------------------------------------------------------------------------------------+
//| ������ �������� ����������� ���������� ��� ������� �������� � ������ ������         |
//+-------------------------------------------------------------------------------------+
void SelectParameters(int patternCnt, int& patternIndex[], int& patternDir[], 
                      double& patternSL[], int& totalNetProfit, int& bestSLOffset, 
                      int& bestTP)
{
   int bestNetProfit = -999999999;
   int twoSpreads = 2*MarketInfo(Symbol(), MODE_SPREAD);
   for (int slSize = 0; slSize <= maxSLTP; slSize += stepSLTP)
      for (int tpSize = twoSpreads; tpSize <= maxSLTP; tpSize += stepSLTP)
      {
         CalculateData(patternCnt, patternIndex,   // ������ ����. ������
                       patternDir, patternSL, 
                       totalNetProfit, 
                       tpSize, slSize);
         if (totalNetProfit <= bestNetProfit)      // ����� ��������� ���� �����������
            continue;                              // ���������� �����
   
         bestNetProfit = totalNetProfit;           // ����� ��������� �����. ����������..
         bestSLOffset = slSize;                    // ..������
         bestTP = tpSize;
      }
   totalNetProfit = bestNetProfit;                 // ���������� �������� ��������
}
//+-------------------------------------------------------------------------------------+
//| ����������� ������� ���������� �������� �� ��������� ����                           |
//+-------------------------------------------------------------------------------------+
int GetPatternDirection(int index, int total, int patternType, int& patternStart)
{
   patternStart = index;
   switch (patternType)
   {
      case IB_INDEX: return (IBPatternDir(index, total, patternStart));
      case DB_INDEX: return (DBPatternDir(index, total, patternStart));
      case TB_INDEX: return (TBPatternDir(index, total, patternStart));
      case RAILS_INDEX: return (RAILSPatternDir(index, total, patternStart));
      case CPR_INDEX: return (CPRPatternDir(index, total, patternStart));
      case HR_INDEX: return (HRPatternDir(index, total, patternStart));
      case OVB_INDEX: return (OVBPatternDir(index, total, patternStart));
      case PPR_INDEX: return (PPRPatternDir(index, total, patternStart));
      case PINBAR_INDEX: return (PINBARPatternDir(index, total, patternStart));
      case MCM_INDEX: return (MCMPatternDir(index, total, patternStart));
      case IR_INDEX: return (IRPatternDir(index, total, patternStart));
   }
}

//+-------------------------------------------------------------------------------------+
//| ����� ��������� ���������� ���� � �������                                           |
//+-------------------------------------------------------------------------------------+
void FindPatterns(int patternType, int total, int& patternCnt, 
                  int& patternIndex[], int& patternDir[], double& patternSL[])
{
   int patternStart;
   for (int i = 2; i < total; i++)                 // ���� ������ ������ �� �������,..
   {                                               // ..�������� ������� �������� ��..
      int direction = GetPatternDirection(i, total,// .. ������ ����
                                          patternType, patternStart);
      if (direction == PATTERN_NO)                 // �������� ��� - ���� ������
         continue;
      patternIndex[patternCnt] = i;                // ������� ���� - ������� ����� ����,
      patternDir[patternCnt] = direction;          // ..����������� ��������,..
      if (direction == PATTERN_BULL)               // ..� ���������� ������� ����-�������
         patternSL[patternCnt] = Low[iLowest(NULL, 0, 
                                             MODE_LOW,
                                             patternStart - i + 1, i)]; 
      else
         patternSL[patternCnt] = High[iHighest(NULL, 0, 
                                               MODE_HIGH,
                                               patternStart - i + 1, i)];

      patternCnt++;                                // ���������� ��������� �����������
   }
}

//+-------------------------------------------------------------------------------------+
//| ���������� ������� ����������� ���������� ��� �������� �������                      |
//+-------------------------------------------------------------------------------------+
bool IsOptimalParameters(int patternType, int patternDir, int& bestSLOffset, int& bestTP)
{
// - 1 - == ���������� ���� �������� ��������� �� ��������� ������� ������� =============
   int patternCnt = 0;
   int patternIndex[];                             // ������� �����, �� ������� �������..
                                                   // ..�������� ��������
   int patternDirN[];                              // ����������� ���������
   double patternSL[];                             // ���� ����-������� ��������
   ArrayResize(patternIndex, optimizationBars);    // ������������ ���-�� ��������� ��..
   ArrayResize(patternDirN, optimizationBars);     // ..���� ������� �������
   ArrayResize(patternSL, optimizationBars);
   FindPatterns(patternType, optimizationBars,  
                patternCnt, patternIndex, patternDirN, patternSL);
// - 1 - == ��������� ����� =============================================================

// - 2 - == ���������� ������� ���������� ===============================================
   int totalNetProfit;                             // ���� ����������� �������� �..
                                                   // ..�������������� �����������..
                                                   // ..����������, � ��.
   SelectParameters(patternCnt, patternIndex,      // ���������� ����������� ���������
                    patternDirN, patternSL, totalNetProfit, 
                    bestSLOffset, bestTP);
// - 2 - == ��������� ����� =============================================================

// - 3 - == �������� ������� � ���������� ������ ========================================
   double expectation = 0;                         // ���� ���� ����������� ������, ��..
   if (patternCnt != 0)                            // ..���������� ��������������..
      expectation = totalNetProfit/1.0/patternCnt; // ..��������
   if (patternCnt >= minStatDeals)                 // ����������� ��������� �������
      if (expectation >= minExpectation)            
         return (true);
// - 3 - == ��������� ����� =============================================================

   return (false);                                 // ����������� ��������� �� �������
}
//+-------------------------------------------------------------------------------------+
//| ��������� ������� ��������, ������� ��� �������                                     |
//+-------------------------------------------------------------------------------------+
int GetSignal(double& sl, double& tp)
{
// - 1 - == ����������� ������� �������� �� ��������� ���� ==============================
   int patternDir;                                 // ����� ��� �������� �������
   int patternStart;                               // ������ ���� ������ ��������
   int patternType = GetAnyPatternTypeAndDir(1, patternDir, patternStart);
   
   if (patternType < 0)                            // ������� �� ��������� - ������� ���
      return (PATTERN_NO);
// - 1 - == ��������� ����� =============================================================
      
// - 2 - == ������ ������������� �������� ����-������� � ������� ========================
   if (!useOptimization)                           // ���� ����������� �� ���������, ��..
   {                                               // ..��������� ������������� ������..
      sl = GetPatternSL(1, patternStart,           //  ������� � ������
                        patternDir, defaultSLOffset);
      tp = GetTP(patternDir, defaultTP);
      return (patternDir);                         
   }
// - 2 - == ��������� ����� =============================================================
   
// - 3 - == ���������� ������� ����������� ���������� ===================================
   int bestSLOffset, bestTP;                       // ������� SL � TP � �������
   if (!IsOptimalParameters(patternType, patternDir, bestSLOffset, bestTP))
      return (PATTERN_NO);                         // ��� ��������� �������
      
   sl = GetPatternSL(1, patternStart, patternDir, bestSLOffset);
   tp = GetTP(patternDir, bestTP);
   
   return (patternDir);                            // ������� ������            
// - 3 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| ������� ������ ����� �������.                                                       |
//+-------------------------------------------------------------------------------------+
void FindOrders()
{
// - 1 - == ������������� ���������� ����� ������� ======================================
   int total = OrdersTotal() - 1;
   g_type = -1;                                    // �� ������� ������ � ��� ��� �������
// - 1 - == ��������� ����� =============================================================
 
// - 2 - == ��������������� ����� =======================================================
   for (int i = total; i >= 0; i--)                // ������������ ���� ������ �������
      if (OrderSelect(i, SELECT_BY_POS))           // ��������, ��� ����� ������
         if (OrderMagicNumber() == MagicNumber &&  // ����� ������ ���������,
             OrderSymbol() == Symbol())            // ..������� ���������� � ������� ����
         {
            g_ticket = OrderTicket();// ������� ������ �������
            g_type = OrderType();
         } 
// - 2 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| �������� ��������� ��������� ������                                                 |
//+-------------------------------------------------------------------------------------+
bool CloseDeal(int ticket, double closeLots = 0) 
{                          
   if (OrderSelect(ticket, SELECT_BY_TICKET) &&    // ���������� ����� � ��������.. 
       OrderCloseTime() == 0)                      // ..������� � ����� �� ������
      if (WaitForTradeContext())                   // �������� �� �������� �����?
      {
         double Price = MarketInfo(Symbol(), MODE_BID);// ���� ������� ������� �������..
                                                   // ..������, �� ����������� ���� BID
         if (OrderType() == OP_SELL)               // ���� ������� ������� ��������.. 
            Price = MarketInfo(Symbol(), MODE_ASK);// ..������, �� ����������� ���� ASK
         if (closeLots == 0 ||                     // ���� ����� �� ������..
             closeLots > OrderLots())              // ..��� ������� ������� �����, ��..
            closeLots = OrderLots();               // ..��������� ���
         if (!OrderClose(OrderTicket(), closeLots, NP(Price), 3))// ���� ������ ��..
            return(False);                         // ..������� �������, �� ���������..
                                                   // ������� - False
      }    
      else
         return(false);
   return(True);                                   // ����� ��������� ��������� ������
}  
//+-------------------------------------------------------------------------------------+
//| ��������� ������� ������� � ����� ��������� �������                                 |
//+-------------------------------------------------------------------------------------+
bool ModifySLAndTP(int ticket, double sl, double tp)
{
   if (!(OrderSelect(ticket, SELECT_BY_TICKET) &&  // ������� ������� �� ������ �..
         OrderCloseTime() == 0))                   // ..�������������, ��� ��� �� �������
      return (true);                               // ������, ���� ��� �������
      
   if (MathAbs(sl - OrderStopLoss()) < g_tickSize &&// �������� ������� ����-�������..
       MathAbs(tp - OrderTakeProfit()) < g_tickSize)// ..� �������
      return (true);                               // ������, ���� ��� ������ �������..
                                                   // ..�� �����
                                                   
   if ((OrderType() == OP_BUY && Bid - sl <= g_stopLevel) ||// ���� ���� ������� ������..
       (OrderType() == OP_SELL && sl - Ask <= g_stopLevel))// ..� ������ ������..
       return(false);                              // ..����-������� - ������ ������
                                                      
   if ((OrderType() == OP_BUY && tp - Bid <= g_stopLevel) ||// ���� ���� ������� ������..
       (OrderType() == OP_SELL && Ask - tp <= g_stopLevel))// ..� ������ ������..
       return(false);                              // ..������� - ������ ������

   if (OrderModify(OrderTicket(), 0, sl, tp, 0))   // �������� ����-������
      return (true);                               // �������� �����������

   return(false);                                  // ��������� �����������
}
//+-------------------------------------------------------------------------------------+
//| �������� ������� �������                                                            |
//+-------------------------------------------------------------------------------------+
bool OpenBuy(double sl, double tp)
{
// - 1 - == �������� ��������������� ������� ============================================
   if (g_type == OP_SELL)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == ����������� ������������ ������� ============================================
   if (g_type == OP_BUY)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������� �� ����� ============================================================
   return (OpenByMarket(OP_BUY, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| �������� �������� �������                                                           |
//+-------------------------------------------------------------------------------------+
bool OpenSell(double sl, double tp)
{
// - 1 - == �������� ��������������� ������� ============================================
   if (g_type == OP_BUY)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == ����������� ������������ ������� ============================================
   if (g_type == OP_SELL)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������� �� ����� ============================================================
   return (OpenByMarket(OP_SELL, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == ��������� ����� =============================================================
}
//+-------------------------------------------------------------------------------------+
//| �������� �������                                                                    |
//+-------------------------------------------------------------------------------------+
bool Trade(int signal, double sl, double tp)
{
// - 1 - == �������� ������� ������� ====================================================
   if (signal == PATTERN_BULL)                     // ������� ������ �������
      if (!OpenBuy(sl, tp))                        // �������� �������
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� �������� ������� ===================================================
   if (signal == PATTERN_BEAR)                     // ������� ������ �������
      if (!OpenSell(sl, tp))                       // �������� �������
         return(false);
// - 2 - == ��������� ����� =============================================================

   return(true);    
}
//+-------------------------------------------------------------------------------------+
//| ������� start ��������                                                              |
//+-------------------------------------------------------------------------------------+
int start()
{
// - 1 - == ����� �� �������� ��������? =================================================
   if (!g_activate || g_fatalError) return(0);
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� �� ���������� ������ ���� � ������� ================================
   if (g_lastBar == Time[0])
      return (0);
// - 2 - == ��������� ����� =============================================================

// - 3 - == �������� �� ���������� ��������� ��������� ==================================
   if (!IsTesting())
      GetMarketInfo();
// - 3 - == ��������� ����� =============================================================

// - 4 - == ������ ������� ==============================================================
   double sl, tp;
   int signal = GetSignal(sl, tp);                 // ���������� ������
// - 4 - == ��������� ����� =============================================================
   
// - 5 - == ���������� �������� �������� ================================================
   FindOrders();                                   // ������ ���� �������
   if (!Trade(signal, sl, tp))                     // ��������/�������� �������
      return(0);                                   
// - 5 - == ��������� ����� =============================================================

   g_lastBar = Time[0];

   return(0);
}


