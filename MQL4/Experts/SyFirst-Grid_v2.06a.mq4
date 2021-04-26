//+------------------------------------------------------------------+
//|                                          SyFrist_Grid v2.06a.mq4 |
//|                                                       Symphoenix |
//+------------------------------------------------------------------+

#property copyright "Symphoenix"

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

//--------------------------------------------------------------------  Extern Parameters Definition

extern string TimeFrames="Define TF Considered";
extern int TimeFrame_1 = 1;
extern int TimeFrame_2 = 5;
extern int TimeFrame_3 = 30;
extern string ADX_Mode_Parameter="Define ADX Mode";
extern int ADX_Mode = 2;
extern string Lot_Size_Info_1="Define Lot Size By User";
extern double Lot_Size = 0.1;
extern string Lot_Size_Info_2="Define Lot Size By MM";
extern int Money_Management = 1;
extern int FxPro_Money_Management = 0;
extern double Margin_Percent = 2.5;
extern string Capitalizing_Info="Increase Positions";
extern int Capitalizing = 0;
extern string Timing_Info="Define Timing Infos";
extern int Action_Window_Min = 15;
extern int SleepTime_Min = 0;
extern int Always_On = 1;
extern int StartHour = 1;
extern int EndHour = 23;
extern string Email="Send an Email When Opening/Closing";
extern int Send_Email = 0;
extern string Owner_Name = "John Doe";
extern string Log_Info="Write a CSV File With Today's Results";
extern int Logging = 0;
extern string Alert_Info="Verbose";
extern int Alert_Popping = 0;
extern string Test_Oriented="Testing";
extern int Testing = 0;
extern string Magic_Numbers="Define Magic Numbers";
extern int MN_Sell_Primary_1 = 16400;
extern int MN_Buy_Primary_1 = 16401;
extern int MN_Sell_Protection = 16412;
extern int MN_Buy_Protection = 16413;
extern int MN_Sell_Intermediary_Protection = 16422;
extern int MN_Buy_Intermediary_Protection = 16423;
extern int MN_Sell_Capitalizing = 16432;
extern int MN_Buy_Capitalizing = 16433;
extern int MN_Sell_Ultimate_Protection = 16442;
extern int MN_Buy_Ultimate_Protection = 16443;

//----------------------------------------------------------------------  Init

int init()
{

return(0);

}

//----------------------------------------------------------------------  Deinit

int deinit()                                  
{

if(ObjectFind("Framework")>=0)
  ObjectDelete("Framework");
if(ObjectFind("Target_for_Protection_High")>=0)
  ObjectDelete("Target_for_Protection_High");
if(ObjectFind("Target_for_Protection_Low")>=0)
  ObjectDelete("Target_for_Protection_Low");
if(ObjectFind("Target_for_BreakEven")>=0)
  ObjectDelete("Target_for_BreakEven");

return(0);                               

}

//----------------------------------------------------------------------  Start

int start()
{

//------------------------ Mask

string label_name="Framework";

if(Testing==0)
{
   if(ObjectFind(label_name)<0) 
     { 
      //--- create Label object 
      ObjectCreate(0,label_name,OBJ_RECTANGLE_LABEL,0,0,0);            
      //--- set X coordinate 
      ObjectSetInteger(0,label_name,OBJPROP_XDISTANCE,1); 
      //--- set Y coordinate 
      ObjectSetInteger(0,label_name,OBJPROP_YDISTANCE,30);
      //--- set X size 
      ObjectSetInteger(0,label_name,OBJPROP_XSIZE,225); 
      //--- set Y size 
      ObjectSetInteger(0,label_name,OBJPROP_YSIZE,535);
      //--- define background color 
      ObjectSetInteger(0,label_name,OBJPROP_BGCOLOR,clrDarkBlue); 
      //--- define text for object Label 
      ObjectSetString(0,label_name,OBJPROP_TEXT,"Cache");    
      //--- disable for mouse selecting 
      ObjectSetInteger(0,label_name,OBJPROP_SELECTABLE,0);
      //--- set the style of rectangle lines 
      ObjectSetInteger(0,label_name,OBJPROP_STYLE,STYLE_SOLID);
      //--- define border type 
      ObjectSetInteger(0,label_name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      //--- define border width 
      ObjectSetInteger(0,label_name,OBJPROP_WIDTH,1); 
      //--- draw it on the chart 
      ChartRedraw(0);
     }
}
//----------------------------------------------------------------------  Balance Check

static int Balance_OK;

if(AccountBalance()>100)
  Balance_OK=1;

if(AccountBalance()<100 && Balance_OK==1)
  {
  if(Send_Email==1)
    SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", unfortunately, your account at " + TerminalCompany() + "'s has been blown away." + "\r\n" + "It's been emotionnal !");
  Balance_OK=0;
  }

if(AccountBalance()<100 && Balance_OK==0)
  return(0);
  
//----------------------------------------------------------------------  Negative Account Protection

double Equity, Equity_Limit;
int h;
bool OrderSell_Closing=False;
bool OrderBuy_Closing=False;
int Order_Number = 0;
static int Status, Strategy_Used, Defcon=5;
static double Lot_Size_Adjusted;
static double Price_Opened_Initial, Price_Opened_Secondary;
static int Protective_Mode;
static int Protective_Mode_Activated;
static int Order_Ticket_1 = -1, Order_Ticket_2 = -1;
bool Hline_High, Hline_Low;
static int RealTime_Drawing = 0;
int FileHandle;
string Subfolder;

Equity=NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2);
Equity_Limit=NormalizeDouble((AccountBalance()/100*3), 2);

if(Equity<Equity_Limit)
{
  for(h=OrdersTotal()-1;h>=0;h--)
  {

   if(OrderSelect(h,SELECT_BY_POS, MODE_TRADES)==true)
    {
        
    if(OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderSell_Closing!=True)
        {  
        RefreshRates();
        OrderSell_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        Status=0;
        Lot_Size_Adjusted=0;
        Price_Opened_Initial=0;
        Price_Opened_Secondary=0;
        Protective_Mode=0;
        Protective_Mode_Activated=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_Protection_High")>=0)
          ObjectDelete("Target_for_Protection_High");
        if(ObjectFind("Target_for_Protection_Low")>=0)
          ObjectDelete("Target_for_Protection_Low");
        }
      if(OrderSell_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      }
    
    if(OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderBuy_Closing!=True)
        {  
        RefreshRates();
        OrderBuy_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        Status=0;
        Lot_Size_Adjusted=0;
        Price_Opened_Initial=0;
        Price_Opened_Secondary=0;
        Protective_Mode=0;
        Protective_Mode_Activated=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_Protection_High")>=0)
          ObjectDelete("Target_for_Protection_High");
        if(ObjectFind("Target_for_Protection_Low")>=0)
          ObjectDelete("Target_for_Protection_Low");
        }
      if(OrderBuy_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      }    
    }

  }

  if(OrderSell_Closing==True || OrderBuy_Closing==True)
    {
    Balance_OK=0;
    Defcon=0;
    if(Send_Email==1)
      SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", unfortunately, your account at " + TerminalCompany() + "'s has been blown away." + "\r\n" + "It's been emotionnal !");
    }

}

//----------------------------------------------------------------------  Variables Definition

double M5_Gravity_1_Positif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 2.0, 500, 1, 0);
double M5_Gravity_1_Negatif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 2.0, 500, 2, 0);
double M5_Gravity_2_Positif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 1, 0);
double M5_Gravity_2_Negatif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 2, 0);
double M5_Gravity_3_Positif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 4.0, 500, 1, 0);
double M5_Gravity_3_Negatif = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 4.0, 500, 2, 0);
double M5_Gravity_0 = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 0);
double M5_Gravity_0_T1 = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 1);
double M5_Gravity_0_T2 = iCustom(Symbol(), TimeFrame_1, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 4);
double M30_Gravity_1_Positif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 1.2, 500, 1, 0);
double M30_Gravity_1_Negatif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 1.2, 500, 2, 0);
double M30_Gravity_2_Positif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 2.2, 500, 1, 0);
double M30_Gravity_2_Negatif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 2.2, 500, 2, 0);
double M30_Gravity_3_Positif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 3.4, 500, 1, 0);
double M30_Gravity_3_Negatif = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 3.4, 500, 2, 0);
double M30_Gravity_0 = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 3.0, 500, 0, 0);
double M30_Gravity_0_T1 = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 3.0, 500, 0, 1);
double M30_Gravity_0_T2 = iCustom(Symbol(), TimeFrame_2, "Center_of_Gravity_2", 500, 4, 0, 3.0, 500, 0, 4);
double M30Y_Gravity_1_Positif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 1.0, 500, 1, 0);
double M30Y_Gravity_1_Negatif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 1.0, 500, 2, 0);
double M30Y_Gravity_2_Positif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 2.2, 500, 1, 0);
double M30Y_Gravity_2_Negatif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 2.2, 500, 2, 0);
double M30Y_Gravity_3_Positif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 3.4, 500, 1, 0);
double M30Y_Gravity_3_Negatif = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 3.4, 500, 2, 0);
double M30Y_Gravity_0 = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 0);
double M30Y_Gravity_0_T1 = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 1);
double M30Y_Gravity_0_T2 = iCustom(Symbol(), TimeFrame_3, "Center_of_Gravity_2", 200, 4, 0, 3.0, 500, 0, 4);

double BBflat_sw_M5_T1;
double BBflat_Signal_Plus_M5_T1;
double BBflat_Signal_Minus_M5_T1;
double BBflat_sw_M30_T1;
double BBflat_Signal_Plus_M30_T1;
double BBflat_Signal_Minus_M30_T1;
double BBflat_sw_M30Y_T1;
double BBflat_Signal_Plus_M30Y_T1;
double BBflat_Signal_Minus_M30Y_T1;
double BBflat_sw_M5_T2;
double BBflat_Signal_Plus_M5_T2;
double BBflat_Signal_Minus_M5_T2;
double BBflat_sw_M30_T2;
double BBflat_Signal_Plus_M30_T2;
double BBflat_Signal_Minus_M30_T2;
double BBflat_sw_M30Y_T2;
double BBflat_Signal_Plus_M30Y_T2;
double BBflat_Signal_Minus_M30Y_T2;

double Stochastic_Line_M5, Stochastic_Line_M30Y;

BBflat_sw_M5_T1=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,3,1);
BBflat_Signal_Plus_M5_T1=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,1,1);
BBflat_Signal_Minus_M5_T1=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,2,1);

BBflat_sw_M30_T1=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,3,1);
BBflat_Signal_Plus_M30_T1=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,1,1);
BBflat_Signal_Minus_M30_T1=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,2,1);

BBflat_sw_M30Y_T1=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,3,1);
BBflat_Signal_Plus_M30Y_T1=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,1,1);
BBflat_Signal_Minus_M30Y_T1=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,2,1);

BBflat_sw_M5_T2=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,3,2);
BBflat_Signal_Plus_M5_T2=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,1,2);
BBflat_Signal_Minus_M5_T2=iCustom(Symbol(),TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,2,2);

BBflat_sw_M30_T2=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,3,2);
BBflat_Signal_Plus_M30_T2=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,1,2);
BBflat_Signal_Minus_M30_T2=iCustom(Symbol(),TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,2,2);

BBflat_sw_M30Y_T2=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,3,2);
BBflat_Signal_Plus_M30Y_T2=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,1,2);
BBflat_Signal_Minus_M30Y_T2=iCustom(Symbol(),TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,2,2);

Stochastic_Line_M5=iStochastic(Symbol(),TimeFrame_1,12,6,6,2,0,0,1);
Stochastic_Line_M30Y=iStochastic(Symbol(),TimeFrame_3,12,6,6,2,0,0,1);

double Profit = 0;
double SL_SELL = 0;
double SL_BUY = 0;

//---------------------------------------------------------------------  ATR

double ATR_M30, ATR_Alternate;

ATR_M30 = iCustom(Symbol(),TimeFrame_2,"ATR",20,0,0);

ATR_Alternate = iCustom(Symbol(),TimeFrame_2,"ATR",6,0,0);

//---------------------------------------------------------------------  

double Price = 0;
int Trend_M5, Trend_M30, Trend_M30Y;
int Trend_Global = 0;
bool TS_1=False;
bool TS_2=False;
bool Hline=False;
datetime ActualTime;
string Power;
string Order_Type = "NONE";
string Comments;
string Strategy_Used_Alternate;
int M5, M30, M30Y, BBflat_Verdict_M1, BBflat_Verdict_M30, BBflat_Verdict_M30Y, BBflat_Verdict_M5_T2, BBflat_Verdict_M30_T2, BBflat_Verdict_M30Y_T2, Countdown_Minutes, Countdown_Seconds;
int OCHP = 0;
static int UpdatedOrderTime;
static double ATR_M30_Static;

//---------------------------------------------------------------------  Reading-parameters Definition

//--------  Spotting Activity Zones

if(Bid>M5_Gravity_0 && Bid<M5_Gravity_1_Positif)
  M5=1;
if(Bid>M30_Gravity_0 && Bid<M30_Gravity_1_Positif)
  M30=1;
if(Bid>M30Y_Gravity_0 && Bid<M30Y_Gravity_1_Positif)
  M30Y=1;  
if(Bid>M5_Gravity_1_Positif && Bid<M5_Gravity_2_Positif)
  M5=2;
if(Bid>M30_Gravity_1_Positif && Bid<M30_Gravity_2_Positif)
  M30=2;
if(Bid>M30Y_Gravity_1_Positif && Bid<M30Y_Gravity_2_Positif)
  M30Y=2;
if(Bid>M5_Gravity_2_Positif && Bid<M5_Gravity_3_Positif)
  M5=3;
if(Bid>M30_Gravity_2_Positif && Bid<M30_Gravity_3_Positif)
  M30=3;
if(Bid>M30Y_Gravity_2_Positif && Bid<M30Y_Gravity_3_Positif)
  M30Y=3;
if(Bid>M5_Gravity_3_Positif)
  M5=4;
if(Bid>M30_Gravity_3_Positif)
  M30=4;
if(Bid>M30Y_Gravity_3_Positif)
  M30Y=4;
if(Bid<M5_Gravity_0 && Bid>M5_Gravity_1_Negatif)
  M5=-1;
if(Bid<M30_Gravity_0 && Bid>M30_Gravity_1_Negatif)
  M30=-1;
if(Bid<M30Y_Gravity_0 && Bid>M30Y_Gravity_1_Negatif)
  M30Y=-1;
if(Bid<M5_Gravity_1_Negatif && Bid>M5_Gravity_2_Negatif)
  M5=-2;
if(Bid<M30_Gravity_1_Negatif && Bid>M30_Gravity_2_Negatif)
  M30=-2;
if(Bid<M30Y_Gravity_1_Negatif && Bid>M30Y_Gravity_2_Negatif)
  M30Y=-2;
if(Bid<M5_Gravity_2_Negatif && Bid>M5_Gravity_3_Negatif)
  M5=-3;
if(Bid<M30_Gravity_2_Negatif && Bid>M30_Gravity_3_Negatif)
  M30=-3;
if(Bid<M30Y_Gravity_2_Negatif && Bid>M30Y_Gravity_3_Negatif)
  M30Y=-3;
if(Bid<M5_Gravity_3_Negatif)
  M5=-4;
if(Bid<M30_Gravity_3_Negatif)
  M30=-4;
if(Bid<M30Y_Gravity_3_Negatif)
  M30Y=-4;

//----------  Volatility Analysis

if(BBflat_sw_M5_T1<=BBflat_Signal_Plus_M5_T1 && BBflat_sw_M5_T1>=BBflat_Signal_Minus_M5_T1)
  BBflat_Verdict_M1=0;
if(BBflat_sw_M5_T1>BBflat_Signal_Plus_M5_T1)
  BBflat_Verdict_M1=1;
if(BBflat_sw_M5_T1<BBflat_Signal_Minus_M5_T1)
  BBflat_Verdict_M1=-1;
  
if(BBflat_sw_M30_T1<=BBflat_Signal_Plus_M30_T1 && BBflat_sw_M30_T1>=BBflat_Signal_Minus_M30_T1)
  BBflat_Verdict_M30=0;
if(BBflat_sw_M30_T1>BBflat_Signal_Plus_M30_T1)
  BBflat_Verdict_M30=1;
if(BBflat_sw_M30_T1<BBflat_Signal_Minus_M30_T1)
  BBflat_Verdict_M30=-1;
  
if(BBflat_sw_M30Y_T1<=BBflat_Signal_Plus_M30Y_T1 && BBflat_sw_M30Y_T1>=BBflat_Signal_Minus_M30Y_T1)
  BBflat_Verdict_M30Y=0;
if(BBflat_sw_M30Y_T1>BBflat_Signal_Plus_M30Y_T1)
  BBflat_Verdict_M30Y=1;
if(BBflat_sw_M30Y_T1<BBflat_Signal_Minus_M30Y_T1)
  BBflat_Verdict_M30Y=-1;
  
if(BBflat_sw_M5_T2<=BBflat_Signal_Plus_M5_T2 && BBflat_sw_M5_T2>=BBflat_Signal_Minus_M5_T2)
  BBflat_Verdict_M5_T2=0;
if(BBflat_sw_M5_T2>BBflat_Signal_Plus_M5_T2)
  BBflat_Verdict_M5_T2=1;
if(BBflat_sw_M5_T2<BBflat_Signal_Minus_M5_T2)
  BBflat_Verdict_M5_T2=-1;
  
if(BBflat_sw_M30_T2<=BBflat_Signal_Plus_M30_T2 && BBflat_sw_M30_T2>=BBflat_Signal_Minus_M30_T2)
  BBflat_Verdict_M30_T2=0;
if(BBflat_sw_M30_T2>BBflat_Signal_Plus_M30_T2)
  BBflat_Verdict_M30_T2=1;
if(BBflat_sw_M30_T2<BBflat_Signal_Minus_M30_T2)
  BBflat_Verdict_M30_T2=-1;
  
if(BBflat_sw_M30Y_T2<=BBflat_Signal_Plus_M30Y_T2 && BBflat_sw_M30Y_T2>=BBflat_Signal_Minus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=0;
if(BBflat_sw_M30Y_T2>BBflat_Signal_Plus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=1;
if(BBflat_sw_M30Y_T2<BBflat_Signal_Minus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=-1;

//-----------  MTF Trend Analysis

if(M5_Gravity_0_T1>M5_Gravity_0_T2)
  Trend_M5=1;
if(M5_Gravity_0_T1<M5_Gravity_0_T2)
  Trend_M5=-1;
if(M5_Gravity_0_T1==M5_Gravity_0_T2)
  Trend_M5=0;
if(M30_Gravity_0_T1>M30_Gravity_0_T2)
  Trend_M30=1;
if(M30_Gravity_0_T1<M30_Gravity_0_T2)
  Trend_M30=-1;
if(M30_Gravity_0_T1==M30_Gravity_0_T2)
  Trend_M30=0;
if(M30Y_Gravity_0_T1>M30Y_Gravity_0_T2)
  Trend_M30Y=1;
if(M30Y_Gravity_0_T1<M30Y_Gravity_0_T2)
  Trend_M30Y=-1;
if(M30Y_Gravity_0_T1==M30Y_Gravity_0_T2)
  Trend_M30Y=0;
if(Trend_M5==1 && Trend_M30==1 && Trend_M30Y==1)
  Trend_Global=2;
if(Trend_M5==-1 && Trend_M30==-1 && Trend_M30Y==-1)
  Trend_Global=-2;
if(Trend_M5==-1 && Trend_M30==1)
  Trend_Global=1;
if(Trend_M5==1 && Trend_M30==-1)
  Trend_Global=-1;

//----------------------------------------------------------------------  Trend Analysis according to M30Y

int Trend_M30Y_Verdict;

if(BBflat_sw_M30Y_T1>0)
Trend_M30Y_Verdict=1;
if(BBflat_sw_M30Y_T1<0)
Trend_M30Y_Verdict=-1;

//--------------------------------------------------------------------  ADX

double ADX_Norm_TF1=iCustom(Symbol(),TimeFrame_1,"ADX",18,0,0);
double DI_Plus_TF1=iCustom(Symbol(),TimeFrame_1,"ADX",18,1,0);
double DI_Minus_TF1=iCustom(Symbol(),TimeFrame_1,"ADX",18,2,0);

double ADX_Norm_TF2=iCustom(Symbol(),TimeFrame_1,"ADX",10,0,0);
double DI_Plus_TF2=iCustom(Symbol(),TimeFrame_1,"ADX",10,1,0);
double DI_Minus_TF2=iCustom(Symbol(),TimeFrame_1,"ADX",10,2,0);

int ADX_Level;

if(ADX_Mode==1)
  {
  if(DI_Plus_TF1<ADX_Norm_TF1 && DI_Minus_TF1>ADX_Norm_TF1 && (DI_Minus_TF1-DI_Plus_TF1)>10)
  ADX_Level=-1; //Buy

  if(DI_Plus_TF1>ADX_Norm_TF1 && DI_Minus_TF1<ADX_Norm_TF1 && (DI_Plus_TF1-DI_Minus_TF1)>10)
  ADX_Level=1; //Sell
  }

if(ADX_Mode==2)
  {
  if(DI_Plus_TF1>DI_Minus_TF2)
  ADX_Level=-1; //Buy

  if(DI_Plus_TF1<DI_Minus_TF2)
  ADX_Level=1; //Sell
  }

//--------------------------------------------------------------------  OCLH Analysis

double Close_M5_T1 = iClose(Symbol(), PERIOD_M5, 1);
double Close_M5_T2 = iClose(Symbol(), PERIOD_M5, 2);
double Close_M5_T3 = iClose(Symbol(), PERIOD_M5, 3);
double Close_M30_T1 = iClose(Symbol(), PERIOD_M30, 1);
double Close_M30_T2 = iClose(Symbol(), PERIOD_M30, 2);
double Close_M30_T3 = iClose(Symbol(), PERIOD_M30, 3);
double Close_H4_T1 = iClose(Symbol(), PERIOD_H4, 1);
double Close_H4_T2 = iClose(Symbol(), PERIOD_H4, 2);
double Close_H4_T3 = iClose(Symbol(), PERIOD_H4, 3);
double Open_M5_T1 = iOpen(Symbol(), PERIOD_M5, 1);
double Open_M5_T2 = iOpen(Symbol(), PERIOD_M5, 2);
double Open_M5_T3 = iOpen(Symbol(), PERIOD_M5, 3);
double Open_M30_T1 = iOpen(Symbol(), PERIOD_M30, 1);
double Open_M30_T2 = iOpen(Symbol(), PERIOD_M30, 2);
double Open_M30_T3 = iOpen(Symbol(), PERIOD_M30, 3);
double Open_H4_T1 = iOpen(Symbol(), PERIOD_H4, 1);
double Open_H4_T2 = iOpen(Symbol(), PERIOD_H4, 2);
double Open_H4_T3 = iOpen(Symbol(), PERIOD_H4, 3);
double High_M5_T1 = iHigh(Symbol(), PERIOD_M5, 1);
double High_M5_T2 = iHigh(Symbol(), PERIOD_M5, 2);
double High_M5_T3 = iHigh(Symbol(), PERIOD_M5, 3);
double High_M30_T1 = iHigh(Symbol(), PERIOD_M30, 1);
double High_M30_T2 = iHigh(Symbol(), PERIOD_M30, 2);
double High_M30_T3 = iHigh(Symbol(), PERIOD_M30, 3);
double High_H4_T1 = iHigh(Symbol(), PERIOD_H4, 1);
double High_H4_T2 = iHigh(Symbol(), PERIOD_H4, 2);
double High_H4_T3 = iHigh(Symbol(), PERIOD_H4, 3);
double Low_M5_T1 = iLow(Symbol(), PERIOD_M5, 1);
double Low_M5_T2 = iLow(Symbol(), PERIOD_M5, 2);
double Low_M5_T3 = iLow(Symbol(), PERIOD_M5, 3);
double Low_M30_T1 = iLow(Symbol(), PERIOD_M30, 1);
double Low_M30_T2 = iLow(Symbol(), PERIOD_M30, 2);
double Low_M30_T3 = iLow(Symbol(), PERIOD_M30, 3);
double Low_H4_T1 = iLow(Symbol(), PERIOD_H4, 1);
double Low_H4_T2 = iLow(Symbol(), PERIOD_H4, 2);
double Low_H4_T3 = iLow(Symbol(), PERIOD_H4, 3);

double Index_Iris_1_M5_T1 = (-1+((1+(High_M5_T1-Close_M5_T1))/(1+(Low_M5_T1-Open_M5_T1))))*1000;
double Index_Iris_1_M5_T2 = (-1+((1+(High_M5_T2-Close_M5_T2))/(1+(Low_M5_T2-Open_M5_T2))))*1000;
double Index_Iris_1_M5_T3 = (-1+((1+(High_M5_T3-Close_M5_T3))/(1+(Low_M5_T3-Open_M5_T3))))*1000;

double Index_Iris_2_M5_T1 = (-1+((1+(Close_M5_T1-Low_M5_T1))/(1+(Open_M5_T1-High_M5_T1))))*1000;
double Index_Iris_2_M5_T2 = (-1+((1+(Close_M5_T2-Low_M5_T2))/(1+(Open_M5_T2-High_M5_T2))))*1000;
double Index_Iris_2_M5_T3 = (-1+((1+(Close_M5_T3-Low_M5_T3))/(1+(Open_M5_T3-High_M5_T3))))*1000;

double Index_Iris_M5  = ((Index_Iris_2_M5_T1+Index_Iris_2_M5_T2+Index_Iris_2_M5_T3)/3)    - ((Index_Iris_1_M5_T1+Index_Iris_1_M5_T2+Index_Iris_1_M5_T3)/3);

Index_Iris_M5 = NormalizeDouble(Index_Iris_M5, 2);

//----------------------------------------------------------------------  Caching Time

ActualTime=TimeCurrent();

//----------------------------------------------------------------------  Activity Window Check

if(Always_On==0 && Balance_OK==1)
{
if(StartHour<EndHour)
{
if(TimeHour(ActualTime)>=StartHour && TimeHour(ActualTime)<EndHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)<StartHour || TimeHour(ActualTime)>=EndHour)
  Power="INACTIVE";
}

if(StartHour>EndHour)
{
if(TimeHour(ActualTime)<=23 && TimeHour(ActualTime)>=12 && TimeHour(ActualTime)>=StartHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)<=23 && TimeHour(ActualTime)>=12 && TimeHour(ActualTime)<StartHour)
  Power="INACTIVE";
if(TimeHour(ActualTime)>=00 && TimeHour(ActualTime)<12 && TimeHour(ActualTime)<EndHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)>=00 && TimeHour(ActualTime)<12 && TimeHour(ActualTime)>=EndHour)
  Power="INACTIVE";
}
}

if(Always_On==1 && Balance_OK==1)
  Power="ACTIVE";

//---------------------------------------------------------------------  Opened Order(s) Spotting and Analysis

int total=OrdersTotal();
int pos; 

if(OrdersTotal()!=0)
{
if(Protective_Mode==0)
  {
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(OrderMagicNumber()==MN_Sell_Primary_1)
        {
        Status=15;
        Price_Opened_Initial=OrderOpenPrice();
        Order_Ticket_1=OrderTicket();
        Defcon=4;
        }
      if(OrderMagicNumber()==MN_Buy_Primary_1)
        {
        Status=16;
        Price_Opened_Initial=OrderOpenPrice();
        Order_Ticket_1=OrderTicket();
        Defcon=4;
        }
      }
    }
  }
}

//--------------------  Stop Loss Management

bool OrderBuy_Modify, OrderSell_Modify, Order_Closing_Stop;
static int StopLoss_Activation;
int Position_Active;

if(OrdersTotal()!=0)
{
if(Protective_Mode==0 && StopLoss_Activation==0)
{
for(pos=0; pos<total; pos++)
{
  if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES)==true)
  {
    if(OrderMagicNumber()==MN_Sell_Primary_1 && Ask<Price_Opened_Initial-ATR_M30_Static)
      {
      StopLoss_Activation=-1;
      if(ObjectFind("Target_for_BreakEven")>=0)
        ObjectDelete("Target_for_BreakEven");
      while(OrderSell_Modify!=True)
        {
        RefreshRates();
        OrderSell_Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),0,0,Red);
        }
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I put the Stop Loss at Breakeven level.");
      }

    if(OrderMagicNumber()==MN_Buy_Primary_1 && Ask>Price_Opened_Initial+ATR_M30_Static)
      {
      StopLoss_Activation=1;
      if(ObjectFind("Target_for_BreakEven")>=0)
        ObjectDelete("Target_for_BreakEven");
      while(OrderBuy_Modify!=True)
        {
        RefreshRates();
        OrderBuy_Modify=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),0,0,Red);
        }
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I put the Stop Loss at Breakeven level.");
      }
  }
}
}
}

if((StopLoss_Activation==-1 || StopLoss_Activation==1) && (Defcon==4 || Defcon==5))
{

for(pos=0; pos<total; pos++)
{
  if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES)==true)
  {
    if(OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1)
      Position_Active++;
  }
}

for(pos=0; pos<total; pos++)
{
  if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES)==true)
    {
    if(OrderMagicNumber()==MN_Buy_Protection && StopLoss_Activation==-1 && Position_Active==0)
      {
      if(Logging==1)
        {
        Subfolder="SyFirst_Grid-EA";
        FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
        if(FileHandle!=INVALID_HANDLE)
          {
          FileSeek(FileHandle, 0, SEEK_END);
          FileWrite(FileHandle, Symbol(), "SELL", Defcon, Strategy_Used, "0");
          FileClose(FileHandle);
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Writing Parameters OK");
          }
        if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
          Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
        }
      StopLoss_Activation=0;
      Status=0;
      Lot_Size_Adjusted=0;
      Strategy_Used=0;
      Defcon=5;
      Order_Number=OrderTicket();
      while(Order_Closing_Stop!=True)
        Order_Closing_Stop=OrderDelete(Order_Number,Red);
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I closed the SELL order at Breakeven level.");
      if(Alert_Popping==1 && SleepTime_Min>0)
        Alert("Idling ", SleepTime_Min, " min");
      if(Alert_Popping==1 && SleepTime_Min==0)
        Alert("No Idling");
      if(SleepTime_Min>0)
        Sleep(SleepTime_Min*60000);
      }
    if(OrderMagicNumber()==MN_Sell_Protection && StopLoss_Activation==1 && Position_Active==0)
      {
      if(Logging==1)
        {
        Subfolder="SyFirst_Grid-EA";
        FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
        if(FileHandle!=INVALID_HANDLE)
          {
          FileSeek(FileHandle, 0, SEEK_END);
          FileWrite(FileHandle, Symbol(), "BUY", Defcon, Strategy_Used, "0");
          FileClose(FileHandle);
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Writing Parameters OK");
          }
        if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
          Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
        }
      StopLoss_Activation=0;
      Status=0;
      Lot_Size_Adjusted=0;
      Strategy_Used=0;
      Defcon=5;
      Order_Number=OrderTicket();
      while(Order_Closing_Stop!=True)
        Order_Closing_Stop=OrderDelete(Order_Number,Red);
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I closed the BUY order at Breakeven level.");
      if(Alert_Popping==1 && SleepTime_Min>0)
        Alert("Idling ", SleepTime_Min, " min");
      if(Alert_Popping==1 && SleepTime_Min==0)
        Alert("No Idling");
      if(SleepTime_Min>0)
        Sleep(SleepTime_Min*60000);
      }
    }
}
}

//--------------------

if(OrdersTotal()!=0)
{
if(Protective_Mode==0)
  {  
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(Status==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY))
        {
        Order_Ticket_2=OrderTicket();
        Protective_Mode=1;
        Defcon=3;
        RealTime_Drawing=1;
        }
      if(Status==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL))
        {
        Order_Ticket_2=OrderTicket();
        Protective_Mode=1;
        Defcon=3;
        RealTime_Drawing=1;
        }
      if(Protective_Mode==1 && Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I'm in DEFCON 3 mode.");
      }
    }    
  }
}

//----------------------------------------------------------------------  Protective Mode

int Protective_Order = -2; 
static int Protection_Step_One; 
double Protective_Lots;
static int First_Launch;

if(Protective_Mode==1 && Protective_Mode_Activated>=0)
  {  
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(Status==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY))
        {
        Price_Opened_Secondary=OrderOpenPrice();
        }
      if(Status==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL))
        {
        Price_Opened_Secondary=OrderOpenPrice();
        }
      }
    }    
  }

if(Protective_Mode==1 && Protective_Mode_Activated==0)
  {
  RefreshRates();
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY) && Ask<Price_Opened_Initial-ATR_Alternate*2.85)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Primary_1)
          {
          while(OrderSell_Closing!=True)
            {
            RefreshRates();
            Profit=OrderProfit();
            OrderSell_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderSell_Closing==True)
            {
            if(Logging==1)
              {
              Subfolder="SyFirst_Grid-EA";
              FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
              if(FileHandle!=INVALID_HANDLE)
                {
                FileSeek(FileHandle, 0, SEEK_END);
                FileWrite(FileHandle, Symbol(), "SELL Primary", Defcon, Strategy_Used, Profit);
                FileClose(FileHandle);
                if(Alert_Popping==1)
                  Alert("SyFirst_Grid : Writing Parameters OK");
                }
              if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
                Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
              }
            Protection_Step_One=1;
            }
          }
        }
      if(Protection_Step_One==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_SELL,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Intermediary",MN_Sell_Intermediary_Protection,0,Cyan);
          }
        if(Protective_Order!=-1)
          {  
          Protection_Step_One=0;
          RealTime_Drawing=2;
          Protective_Mode_Activated=1;
          Protective_Order=-2;
          Defcon=2;
          if(ObjectFind("Target_for_Protection_Low")>=0)
            ObjectDelete("Target_for_Protection_Low");
          if(OrderSelect(Order_Ticket_2, SELECT_BY_TICKET)==True)
            {
            Price=Price_Opened_Secondary+(ATR_M30*2);
            }
          Hline_High=ObjectCreate("Target_for_Protection_High", OBJ_HLINE, 0, 0, Price);
          if(Hline_High==true)
            {
            ObjectSet("Target_for_Protection_High",OBJPROP_COLOR,Gold);
            ObjectSet("Target_for_Protection_High",OBJPROP_STYLE,STYLE_DOT);
            }
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I'm in DEFCON 2 mode.");
          }
        }
      }
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL) && Ask>Price_Opened_Initial+ATR_Alternate*3.75)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Primary_1)
          {
          while(OrderBuy_Closing!=True)
            {
            RefreshRates();
            Profit=OrderProfit();
            OrderBuy_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderBuy_Closing==True)  
            {
            if(Logging==1)
              {
              Subfolder="SyFirst_Grid-EA";
              FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
              if(FileHandle!=INVALID_HANDLE)
                {
                FileSeek(FileHandle, 0, SEEK_END);
                FileWrite(FileHandle, Symbol(), "BUY Primary", Defcon, Strategy_Used, Profit);
                FileClose(FileHandle);
                if(Alert_Popping==1)
                  Alert("SyFirst_Grid : Writing Parameters OK");
                }
              if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
                Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
              }
            Protection_Step_One=1;
            }
          }
        }
      if(Protection_Step_One==1)
        {
        while(Protective_Order<0)
          { 
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_BUY,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Intermediary",MN_Buy_Intermediary_Protection,0,Cyan);
          }
        if(Protective_Order!=-1)
          {  
          Protection_Step_One=0;
          RealTime_Drawing=2;
          Protective_Mode_Activated=1;
          Protective_Order=-2;
          Defcon=2;
          if(ObjectFind("Target_for_Protection_High")>=0)
            ObjectDelete("Target_for_Protection_High");
          if(OrderSelect(Order_Ticket_2, SELECT_BY_TICKET)==True)
            {
            Price=Price_Opened_Secondary-(ATR_M30*2);
            }
          Hline_Low=ObjectCreate("Target_for_Protection_Low", OBJ_HLINE, 0, 0, Price);
          if(Hline_Low==true)
            {
            ObjectSet("Target_for_Protection_Low",OBJPROP_COLOR,Gold);
            ObjectSet("Target_for_Protection_Low",OBJPROP_STYLE,STYLE_DOT);
            }
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I'm in DEFCON 2 mode.");
          }
        }
      }
    }
  }

static int Protection_Step_Two, Sell_Ultimate, Buy_Ultimate;

total=OrdersTotal();

if(Protective_Mode==1 && Protective_Mode_Activated==1)
  {
  RefreshRates();
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Intermediary_Protection && Ask<Price_Opened_Secondary-ATR_Alternate*2.30)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Protection)
          {
          while(OrderSell_Closing!=True)
            {
            RefreshRates();
            Profit=OrderProfit();
            OrderSell_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderSell_Closing==True)  
            {
            if(Logging==1)
              {
              Subfolder="SyFirst_Grid-EA";
              FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
              if(FileHandle!=INVALID_HANDLE)
                {
                FileSeek(FileHandle, 0, SEEK_END);
                FileWrite(FileHandle, Symbol(), "SELL Secondary", Defcon, Strategy_Used, Profit);
                FileClose(FileHandle);
                if(Alert_Popping==1)
                  Alert("SyFirst_Grid : Writing Parameters OK");
                }
              if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
                Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
              }
            Protection_Step_Two=1;
            }
          }
        }
      if(Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {  
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_SELL,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Sell_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          RealTime_Drawing=0;
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Sell_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_Low")>=0)
            ObjectDelete("Target_for_Protection_Low");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I'm in DEFCON 1 mode.");
          }
        }
      }
    
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Intermediary_Protection && Ask>Price_Opened_Secondary+ATR_Alternate*2.80)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Protection)
          {
          while(OrderBuy_Closing!=True)
            {
            RefreshRates();
            Profit=OrderProfit();
            OrderBuy_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderBuy_Closing==True)  
            {
            if(Logging==1)
              {
              Subfolder="SyFirst_Grid-EA";
              FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
              if(FileHandle!=INVALID_HANDLE)
                {
                FileSeek(FileHandle, 0, SEEK_END);
                FileWrite(FileHandle, Symbol(), "BUY Secondary", Defcon, Strategy_Used, Profit);
                FileClose(FileHandle);
                if(Alert_Popping==1)
                  Alert("SyFirst_Grid : Writing Parameters OK");
                }
              if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
                Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
              }
            Protection_Step_Two=1;
            }
          }
        }
      if(Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_BUY,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Buy_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          RealTime_Drawing=0;
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Buy_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_High")>=0)
            ObjectDelete("Target_for_Protection_High");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, I'm in DEFCON 1 mode.");
          }
        }
      }
    }
  }

//----------------------------------------------------------------------  Closing when Profit is 0 in Recovery Mode

total=OrdersTotal();
int Position_Buy, Position_Sell, Position_Buy_Closed, Position_Sell_Closed;
double Profit_Buy, Profit_Sell, Profit_Cumulated;
bool OrderBuy_Closing_2, OrderSell_Closing_2;

if(OrdersTotal()!=0)
{
for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    {
    Position_Buy=1;
    Profit_Buy=Profit_Buy+OrderProfit()+OrderCommission()+OrderSwap();
    }
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection))
    {
    Position_Sell=1;
    Profit_Sell=Profit_Sell+OrderProfit()+OrderCommission()+OrderSwap();
    }
  }
}

if((Position_Buy!=0 && Position_Sell!=0 && Profit_Buy!=0 && Profit_Sell!=0) || Protective_Mode_Activated>=1)
  {
  Profit_Cumulated=Profit_Buy+Profit_Sell;
  if(Profit_Cumulated>=0)
    {
    for(h=OrdersTotal()-1;h>=0;h--)
    {
    if(OrderSelect(h,SELECT_BY_POS, MODE_TRADES)==true)
      {
    if(OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderSell_Closing_2!=True)
        {
        RefreshRates();
        OrderSell_Closing_2=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing_2==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        Status=0;
        Lot_Size_Adjusted=0;
        Position_Sell_Closed=1;
        }
      if(OrderSell_Closing_2==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      OrderSell_Closing_2=False;
      }
    if(OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderBuy_Closing_2!=True)
        {
        RefreshRates();  
        OrderBuy_Closing_2=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing_2==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        Status=0;
        Lot_Size_Adjusted=0;
        Position_Buy_Closed=1;
        }
      if(OrderBuy_Closing_2==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      OrderBuy_Closing_2=False;
      }
      }
    }
    }
    if(Position_Buy_Closed==1 || Position_Sell_Closed==1)
      {
      if(Logging==1)
        {
        Subfolder="SyFirst_Grid-EA";
        FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
        if(FileHandle!=INVALID_HANDLE)
          {
          FileSeek(FileHandle, 0, SEEK_END);
          FileWrite(FileHandle, Symbol(), "BUY & SELL", Defcon, Strategy_Used, Profit_Cumulated);
          FileClose(FileHandle);
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Writing Parameters OK");
          }
        if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
          Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
        }
      if(Alert_Popping==1 && SleepTime_Min>0)
        Alert("Breakeven. Idling for ", SleepTime_Min, " min");
      if(Alert_Popping==1 && SleepTime_Min==0)
        Alert("Breakeven. No Idling");
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", I reached equilibrium concerning the pair" + Symbol() + " at " + TerminalCompany() + "'s !" + "\r\n" + "Account balance #" + AccountNumber() + " is " + AccountBalance() + " units.");
      Protective_Mode=0;
      Protective_Mode_Activated=0;
      Buy_Ultimate=0;
      Sell_Ultimate=0;
      Position_Buy_Closed=0;
      Position_Sell_Closed=0;
      Strategy_Used=0;
      ATR_M30_Static=0;
      RealTime_Drawing=0;
      Order_Ticket_1=-1;
      Order_Ticket_2=-1;
      if(ObjectFind("Target_for_BreakEven")>=0)
        ObjectDelete("Target_for_BreakEven");
      if(ObjectFind("Target_for_Protection_High")>=0)
        ObjectDelete("Target_for_Protection_High");
      if(ObjectFind("Target_for_Protection_Low")>=0)
        ObjectDelete("Target_for_Protection_Low");
      Defcon=5;
      if(SleepTime_Min>0)
        Sleep(SleepTime_Min*60000);
      }
  }
  
//----------------------------------------------------------------------  RealTime Drawing

static double Price_T0=0, Price_T1=0;

if((RealTime_Drawing==1 || RealTime_Drawing==2) && Testing==0)
{
for(pos=0; pos<total; pos++)
{
if(RealTime_Drawing==1)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY))
    {
    Price_T0=Price_Opened_Initial-(ATR_Alternate*2.85);
    if(Price_T0!=Price_T1)
      {
      if(ObjectFind("Target_for_BreakEven")>=0)
        ObjectDelete("Target_for_BreakEven");
      if(ObjectFind("Target_for_Protection_Low")>=0)
        ObjectDelete("Target_for_Protection_Low");
      Hline_Low=ObjectCreate("Target_for_Protection_Low", OBJ_HLINE, 0, 0, Price_T0);
      if(Hline_Low==true)
        {
        ObjectSet("Target_for_Protection_Low",OBJPROP_COLOR,Cyan);
        ObjectSet("Target_for_Protection_Low",OBJPROP_STYLE,STYLE_DOT);
        }
      Price_T1=Price_T0;
      }
    }
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL))
    {
    Price_T0=Price_Opened_Initial+(ATR_Alternate*3.75);
    if(Price_T0!=Price_T1)
      {
      if(ObjectFind("Target_for_BreakEven")>=0)
        ObjectDelete("Target_for_BreakEven");
      if(ObjectFind("Target_for_Protection_High")>=0)
        ObjectDelete("Target_for_Protection_High");
      Hline_High=ObjectCreate("Target_for_Protection_High", OBJ_HLINE, 0, 0, Price_T0);
      if(Hline_High==true)
        {
        ObjectSet("Target_for_Protection_High",OBJPROP_COLOR,Cyan);
        ObjectSet("Target_for_Protection_High",OBJPROP_STYLE,STYLE_DOT);
        }
      Price_T1=Price_T0;
      }
    }
  Price_T1=Price;
  }
  
if(RealTime_Drawing==2)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==16 && (OrderMagicNumber()==MN_Buy_Intermediary_Protection && OrderType()==OP_BUY))
    {
    Price_T0=Price_Opened_Secondary-(ATR_Alternate*2.30);
    if(Price_T0!=Price_T1)
      {
      if(ObjectFind("Target_for_Protection_Low")>=0)
        ObjectDelete("Target_for_Protection_Low");
      Hline_Low=ObjectCreate("Target_for_Protection_Low", OBJ_HLINE, 0, 0, Price_T0);
      if(Hline_Low==true)
        {
        ObjectSet("Target_for_Protection_Low",OBJPROP_COLOR,Gold);
        ObjectSet("Target_for_Protection_Low",OBJPROP_STYLE,STYLE_DOT);
        }
      Price_T1=Price_T0;
      }
    }
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status==15 && (OrderMagicNumber()==MN_Sell_Intermediary_Protection && OrderType()==OP_SELL))
    {
    Price_T0=Price_Opened_Secondary+(ATR_Alternate*2.80);
    if(Price_T0!=Price_T1)
      {
      if(ObjectFind("Target_for_Protection_High")>=0)
        ObjectDelete("Target_for_Protection_High");
      Hline_High=ObjectCreate("Target_for_Protection_High", OBJ_HLINE, 0, 0, Price_T0);
      if(Hline_High==true)
        {
        ObjectSet("Target_for_Protection_High",OBJPROP_COLOR,Gold);
        ObjectSet("Target_for_Protection_High",OBJPROP_STYLE,STYLE_DOT);
        }
      Price_T1=Price_T0;
      }
    }
  }
}
}

//----------------------------------------------------------------------  Price Action Analysis

if(Status==0 && Power=="ACTIVE" && ADX_Level!=0 && Trend_M30Y_Verdict!=0 && (ATR_M30*4<(35*10*Point) && ATR_M30*4>(10*10*Point)))
{

if(M5==1 && M30==1 && M30Y>-1)
{
Status=1; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1) 
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(M5==2 && M30==2 && M30Y>-1)
{
Status=2; 
UpdatedOrderTime=TimeCurrent(); 
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(M5==3 && M30==3 && M30Y>-1)
{
Status=3; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if((M5==4 && M30==4) || M30Y==4)
{
Status=4; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(M5==-1 && M30==-1 && M30Y<-1)
{
Status=5; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1) 
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(M5==-2 && M30==-2 && M30Y<-1)
{
Status=6; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(M5==-3 && M30==-3 && M30Y<-1)
{
Status=7; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if((M5==-4 && M30==-4)  || M30Y==-4)
{
Status=8; 
UpdatedOrderTime=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : BBflat Screening. Status = ", Status, " and ADX = ", ADX_Level);
}

if(Bid==M5_Gravity_0 || Bid==M5_Gravity_1_Positif || Bid==M5_Gravity_2_Positif || Bid==M5_Gravity_3_Positif || Bid==M30_Gravity_0 || Bid==M30_Gravity_1_Positif || Bid==M30_Gravity_2_Positif || Bid==M30_Gravity_3_Positif)
Status=9;

if(Bid==M5_Gravity_0 || Bid==M5_Gravity_1_Negatif || Bid==M5_Gravity_2_Negatif || Bid==M5_Gravity_3_Negatif || Bid==M30_Gravity_0 || Bid==M30_Gravity_1_Negatif || Bid==M30_Gravity_2_Negatif || Bid==M30_Gravity_3_Negatif)
Status=10;

}

//--------------------------------------------------------------------  Filtration Preparation

if(Status==9 || Status==10)
  Status=0;

//--------------------------------------------------------------------  Timer 'Elapsed_Time' Computations

if(UpdatedOrderTime>0)
  {
  Countdown_Minutes=TimeMinute(ActualTime-UpdatedOrderTime);
  Countdown_Seconds=TimeSeconds(ActualTime-UpdatedOrderTime);
  }

//--------------------------------------------------------------------  Setting 'Open-Close Hit Prevention'

int Position=0;

total=OrdersTotal();

if(OrdersTotal()!=0)
{
for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    Position=1;
  }
}

if(Position==0)
{
  if(BBflat_Verdict_M30Y_T2==-1 && BBflat_Verdict_M30Y==0)
    OCHP=-1;
  if(BBflat_Verdict_M30Y_T2==1 && BBflat_Verdict_M30Y==0)
    OCHP=1;
}

//-------------------------------------------------------------------- Time Computations

int Today_Seconds=(Hour()*3600)+(Minute()*60)+Seconds();
int Yesterday_End=TimeCurrent()-Today_Seconds;
int Yesterday_Start=Yesterday_End-86400;

int Day_Of_Week=DayOfWeek();
int Weekly_Seconds=(Day_Of_Week-1)*86400+(Hour()*3600)+(Minute()*60)+Seconds();
int Week_Start=TimeCurrent()-Weekly_Seconds;
int Week_End=Week_Start+(86400*5)-(5*60);

//-------------------------------------------------------------------- Closed Orders Properties Analysis

double Profit_Today=0,Profit_Yesterday=0;
int Yesterday_Trades=0,Today_Trades=0;
 
int Friday_End=TimeCurrent()-Today_Seconds-(86400*2);
int Friday_Start=TimeCurrent()-Today_Seconds-(86400*3);
 
for(h=OrdersHistoryTotal()-1;h>=0;h--)
  {
    if(OrderSelect(h,SELECT_BY_POS,MODE_HISTORY)==true)
      {
        if(OrderCloseTime()>Friday_Start && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
         {      
           if(OrderCloseTime()>Yesterday_End)
           { 
           Profit_Today=Profit_Today+OrderProfit()+OrderCommission()+OrderSwap(); 
           Today_Trades++;
           } 
           
           if(DayOfWeek()!=1 && OrderCloseTime()<Yesterday_End && OrderCloseTime()>Yesterday_Start)
           {
           Profit_Yesterday=Profit_Yesterday+OrderProfit()+OrderCommission()+OrderSwap(); 
           Yesterday_Trades++;
           }
           
           if(DayOfWeek()==1 && OrderCloseTime()<Friday_End && OrderCloseTime()>Friday_Start)
           {
           Profit_Yesterday=Profit_Yesterday+OrderProfit()+OrderCommission()+OrderSwap(); 
           Yesterday_Trades++;
           }
         }
      }
  }

//--------------------------------------------------------------------  CSV File Writing

int Write_Results;
int Write_Results_WeekEnd;
int Week_End_Adjusted;
static int Day_Of_Week_Static;
static int Yesterday_Update_Operation;
static int Today_Update_Operation;

if(Day_Of_Week==5)
  Week_End_Adjusted=Week_Start+(86400*5)-(3*60);

if(Day_Of_Week!=5)
  Today_Update_Operation=0;

if(First_Launch==0)
  {
  Day_Of_Week_Static=DayOfWeek();
  First_Launch=1;
  if(Alert_Popping==1)  
    Alert("SyFirst_Grid : First Launch Detected");
  }

if(Day_Of_Week==2 || Day_Of_Week==3 || Day_Of_Week==4 || Day_Of_Week==5)
  {
  if(Day_Of_Week_Static!=DayOfWeek() && Yesterday_Update_Operation==0)
    {
    Day_Of_Week_Static=DayOfWeek();
    Yesterday_Update_Operation=1;
    Write_Results=1;
    }
  }

if(Day_Of_Week==5)
  {
  if(TimeCurrent()>Week_End_Adjusted && Today_Update_Operation==0)
    {
    Today_Update_Operation=1;
    Write_Results_WeekEnd=1;
    }
  }

if(Logging==1 && Write_Results==1)
  {
  Subfolder="SyFirst_Grid-EA";
  FileHandle=FileOpen(Subfolder+"\\Results_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
  if(FileHandle!=INVALID_HANDLE)
    {
    FileSeek(FileHandle, 0, SEEK_END);
    FileWrite(FileHandle, Symbol(), TimeToStr(ActualTime, TIME_DATE), TimeToStr(ActualTime, TIME_SECONDS), Profit_Yesterday, Yesterday_Trades);
    FileClose(FileHandle);
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Writing Results OK");
    }
  if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
    Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
  Yesterday_Update_Operation=0;
  Write_Results=0;
  }

if(Logging==1 && Write_Results_WeekEnd==1)
  {
  Subfolder="SyFirst_Grid-EA";
  FileHandle=FileOpen(Subfolder+"\\Results_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
  if(FileHandle!=INVALID_HANDLE)
    {
    FileSeek(FileHandle, 0, SEEK_END);
    FileWrite(FileHandle, Symbol(), TimeToStr(ActualTime, TIME_DATE), TimeToStr(ActualTime, TIME_SECONDS), Profit_Today, Today_Trades);
    FileClose(FileHandle);
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Writing Results OK - Have A Nice WeekEnd");
    }
  if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
    Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
  Write_Results_WeekEnd=0;
  }

//--------------------------------------------------------------------  Open Position(s) Analysis

total=OrdersTotal();

if(OrdersTotal()!=0)
{
for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    {
    Profit=Profit+OrderProfit()+OrderCommission()+OrderSwap();
    }
  }
}

//--------------------------------------------------------------------  Lots Sizing

int LotsDigit;
double MinLots, MaxLots, AcFrMar, Step, One_Lot;

if(Money_Management==0)
   Lot_Size_Adjusted=Lot_Size;

if(Money_Management==1 && FxPro_Money_Management==0)
   {
   if(MarketInfo(Symbol(),MODE_MINLOT) == 0.1)
     LotsDigit=1;
   else if(MarketInfo(Symbol(),MODE_MINLOT) == 0.01)
     LotsDigit=2;
     
   One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   
   Step=MarketInfo(Symbol(),MODE_LOTSTEP);
   
   MinLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MINLOT),LotsDigit);
   MaxLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MAXLOT),LotsDigit);
   
   AcFrMar=NormalizeDouble(AccountFreeMargin(),2);
   
   Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/One_Lot/Step)*Step;

   if(Lot_Size_Adjusted*19>MaxLots)
     Lot_Size_Adjusted=MaxLots/19;
   if(Lot_Size_Adjusted<MinLots)
     Lot_Size_Adjusted=MinLots; 
   }

if(FxPro_Money_Management==1)
   {
   if(MarketInfo(Symbol(),MODE_MINLOT) == 0.1)
     LotsDigit=1;
   else if(MarketInfo(Symbol(),MODE_MINLOT) == 0.01)
     LotsDigit=2;
     
   One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   
   Step=MarketInfo(Symbol(),MODE_LOTSTEP);
   
   MinLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MINLOT),LotsDigit);
   MaxLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MAXLOT),LotsDigit);
   
   AcFrMar=NormalizeDouble(AccountFreeMargin(),2);
   
   if(AccountBalance()<45000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/200/Step)*Step;
     if(Lot_Size_Adjusted<MinLots)
       Lot_Size_Adjusted=MinLots;
     if(Lot_Size_Adjusted>5.5)
       Lot_Size_Adjusted=5.5;
     }
     
   if(AccountBalance()>=45000 && AccountBalance()<225000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/500/Step)*Step;
     if(Lot_Size_Adjusted<5.5)
       Lot_Size_Adjusted=5.5;
     if(Lot_Size_Adjusted>11.1)
       Lot_Size_Adjusted=11.1;
     }
     
   if(AccountBalance()>=225000 && AccountBalance()<670000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/1000/Step)*Step;
     if(Lot_Size_Adjusted<11.1)
       Lot_Size_Adjusted=11.1;
     if(Lot_Size_Adjusted>16.6)
       Lot_Size_Adjusted=16.6;
     }
   
   if(AccountBalance()>=670000 && AccountBalance()<2250000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/2000/Step)*Step;
     if(Lot_Size_Adjusted<16.6)
       Lot_Size_Adjusted=16.6;
     if(Lot_Size_Adjusted>27.7)
       Lot_Size_Adjusted=27.7;
     }
     
   if(AccountBalance()>=2250000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/3030/Step)*Step;
     if(Lot_Size_Adjusted<27.7)
       Lot_Size_Adjusted=27.7;
     if(Lot_Size_Adjusted*19>MaxLots)
       Lot_Size_Adjusted=MaxLots/19;
     } 
   }

//--------------------------------------------------------------------  Activity Report

string sComment   = "";
string sp         = "------------------------------------------------\n";
string NL         = "\n";

if(Testing==0)
{

//----- Initialisation Timer

static int Timer_Tick_Counting;

Timer_Tick_Counting++;

if(Timer_Tick_Counting>10)
  Timer_Tick_Counting=1;

//----- Comments
  
   sComment = NL + NL;
   sComment = sComment + "SyFirst_Grid Version_2.06" + NL;
   sComment = sComment + sp;
   sComment = sComment + Symbol() + NL;
   if(Power=="INACTIVE")
     sComment = sComment + "POWER = INACTIVE" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==1)
     sComment = sComment + "POWER = |" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==2)
     sComment = sComment + "POWER = ||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==3)
     sComment = sComment + "POWER = |||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==4)
     sComment = sComment + "POWER = ||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==5)
     sComment = sComment + "POWER = |||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==6)
     sComment = sComment + "POWER = ||||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==7)
     sComment = sComment + "POWER = |||||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==8)
     sComment = sComment + "POWER = ||||||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==9)
     sComment = sComment + "POWER = |||||||||" + NL;
   if(Power=="ACTIVE" && Timer_Tick_Counting==10)
     sComment = sComment + "POWER = ||||||||||" + NL;
   sComment = sComment + sp;
   sComment = sComment + "Screening Zones :" + NL;
   sComment = sComment + "EU_M1  = " + M5 + NL;  
   sComment = sComment + "EU_M5  = " + M30 + NL;
   sComment = sComment + "EU_M30 = " + M30Y + NL;
   sComment = sComment + sp;
   sComment = sComment + "BBflat Verdict :" + NL;
   sComment = sComment + "EU M1  = " + BBflat_Verdict_M1 + NL;
   sComment = sComment + "EU M5  = " + BBflat_Verdict_M30 + NL;
   sComment = sComment + "EU M30 = " + BBflat_Verdict_M30Y + NL;
   sComment = sComment + "ADX    = " + ADX_Level + NL;
   sComment = sComment + "OCHP   = " + OCHP + NL;
   sComment = sComment + sp;
   sComment = sComment + "Index Iris M5   = " + Index_Iris_M5 + NL;
   sComment = sComment + sp;
   sComment = sComment + "Trend M1   = " + Trend_M5 + NL; 
   sComment = sComment + "Trend M5   = " + Trend_M30 + NL;
   sComment = sComment + "Trend M30  = " + Trend_M30Y_Verdict + NL;
   sComment = sComment + "Trend Global  = " + Trend_Global + NL;
   sComment = sComment + sp;
   sComment = sComment + "          --> ETAPE " + Status + " <--" + NL;
   sComment = sComment + sp;
   if(Balance_OK==1)
     sComment = sComment + "Account Balance : OK" + NL;
   if(Balance_OK<1)
     sComment = sComment + "Account Balance : NOT OK" + NL;
   sComment = sComment + "Opening Lot Size = " + Lot_Size_Adjusted + NL;
   sComment = sComment + "Equity = " + Equity + NL;
   sComment = sComment + "Equity Limit = " + Equity_Limit + NL;
   sComment = sComment + sp;
   sComment = sComment + "DEFCON " + Defcon + NL;
   sComment = sComment + sp;
   if(Day_Of_Week==1)
     sComment = sComment + "Actual Time = MONDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==2)
     sComment = sComment + "Actual Time = TUESDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==3)
     sComment = sComment + "Actual Time = WEDNESDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==4)
     sComment = sComment + "Actual Time = THURSDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==5)
     sComment = sComment + "Actual Time = FRIDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   sComment = sComment + "Window Starting Time = " + TimeToStr(UpdatedOrderTime, TIME_SECONDS) + NL;
   sComment = sComment + "Elapsed Time = " + Countdown_Minutes + ":" + Countdown_Seconds + NL;
   sComment = sComment + sp;
   sComment = sComment + "Gain = " + NormalizeDouble(Profit, 2) + NL;
   sComment = sComment + sp;
   sComment = sComment + "Profit Yesterday = " + NormalizeDouble(Profit_Yesterday, 2) + NL;
   sComment = sComment + "Profit Today = " + NormalizeDouble(Profit_Today, 2);
       
   Comment(sComment);

}

//--------------------------------------------------------------------  Activity Window Check + Filtration Preparation

if((ActualTime>(UpdatedOrderTime+(Action_Window_Min*60))) && UpdatedOrderTime>0)
  {
  Status=0;
  UpdatedOrderTime=0;
  if(Alert_Popping==1)
    Alert("SyFirst_Grid : Stopping Screening Data after ", Action_Window_Min, " min... Status & UpdatedOrderTime re-initialized.");
  }

//--------------------------------------------------------------------  Filtration

if(Status==0)
return(0);

//--------------------------------------------------------------------  Pivot Steam

//if(Pivot_Steam>0.3)
//int PS_Index=1;

//if(Pivot_Steam<0.3)
//PS_Index=-1;

//--------------------------------------------------------------------  Order Launching Room

if(Status>0 && Status<=14 && (Index_Iris_M5>=0.1 || Index_Iris_M5<=-0.1))
{

    if(Status==1 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---R
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==-1)
      {
      Status=11;
      Strategy_Used=101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status=12;
      Strategy_Used=102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==2 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status=12;
      Strategy_Used=201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)                           //---A
      {
      Status=12;
      Strategy_Used=202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==3 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status=12;
    Strategy_Used=3;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==4 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=-1 && ADX_Level==1)          //---RRR
    {
    Status=11;
    Strategy_Used=4;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
    }
    
    if(Status==5 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1 && Stochastic_Line_M5<18)
      {
      Status=12;
      Strategy_Used=501;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1 && Stochastic_Line_M5>25)
      {
      Status=12;
      Strategy_Used=503;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=-1 && (Stochastic_Line_M5>18 && Stochastic_Line_M5<25))
      {
      Status=11;
      Strategy_Used=504;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=502;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==6 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=601;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=602;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==7 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---RR
    {
    Status=11;
    Strategy_Used=7;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
    }
    
    if(Status==8 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1)          //---RRR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==1 && Trend_Global==-1 && BBflat_Verdict_M1==1 && OCHP!=-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=901;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status=12;
      Strategy_Used=902;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==2 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=1001;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<80 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=1002;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1 && Stochastic_Line_M5>80 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1003;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==3 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M1==1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && Stochastic_Line_M5<80 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && Stochastic_Line_M5>80 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=1103;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==-1 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=1102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<90 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1104;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5>90 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=1105;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==4 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=1201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=1202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==5 && Trend_Global==-1 && BBflat_Verdict_M1==1)           //---A
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==-1)
      {
      Status=11;
      Strategy_Used=1301;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && Stochastic_Line_M5>80 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1303;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1 && (Stochastic_Line_M5<80 && Stochastic_Line_M30Y>25))
      {
      Status=11;
      Strategy_Used=1302;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && (Stochastic_Line_M5<80 && Stochastic_Line_M30Y<25) && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1304;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==6 && Trend_Global==-1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)
    {
    Status=12;
    Strategy_Used=14;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==7 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---RR
    {
    Status=11;
    Strategy_Used=15;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
    }
    
    if(Status==8 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && OCHP!=-1)
     {
      Status=11;
      Strategy_Used=1601;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=1602;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
   }
    
    if(Status==1 && Trend_Global==2 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=1701;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=1702;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==2 && Trend_Global==2 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=1801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=1802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==3 && Trend_Global==1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RR
    {
    Status=12;
    Strategy_Used=19;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==4 && Trend_Global==1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RR
    {
    Status=12;
    Strategy_Used=20;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==5 && Trend_Global==1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=2101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=2102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==6 && Trend_Global==1 && BBflat_Verdict_M1==-1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && Stochastic_Line_M30Y>50 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=2201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1 && Stochastic_Line_M30Y<50)
      {
      Status=12;
      Strategy_Used=2204;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=2203;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=2202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==7 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status=12;
    Strategy_Used=23;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==8 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status=12;
    Strategy_Used=24;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
     
    if(Status==1 && Trend_Global==1 && BBflat_Verdict_M1==1)                  //----A
    {
      if(BBflat_sw_M30_T1<0.0005 && Stochastic_Line_M5>80 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=2501;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && Stochastic_Line_M5<20 && OCHP!=-1 && ADX_Level==-1)
      {
      Status=11;
      Strategy_Used=2508;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=2503;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1 && (Stochastic_Line_M5>35 && Stochastic_Line_M5<74) && Stochastic_Line_M30Y>50)
      {
      Status=11;
      Strategy_Used=2502;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && (Stochastic_Line_M5>35 && Stochastic_Line_M5<74) && Stochastic_Line_M30Y<50 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=2507;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<35 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=2505;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5>74 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=2506;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=2504;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==2 && Trend_Global==1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)
    {
    Status=12;
    Strategy_Used=26;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==3 && Trend_Global==1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)          //---R
    {
    Status=12;
    Strategy_Used=27;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==4 && Trend_Global==1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status=12;
      Strategy_Used=2801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=2802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==5 && Trend_Global==1 && BBflat_Verdict_M1==-1 && ADX_Level==1)          //---R
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1)
      {
      Status=12;
      Strategy_Used=2901;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1)
      {
      Status=11;
      Strategy_Used=2902;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
    }
    
    if(Status==6 && Trend_Global==1 && BBflat_Verdict_M1==-1 && OCHP!=1 && ADX_Level==1)          //---R
    {
    Status=12;
    Strategy_Used=30;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
    }
    
    if(Status==7 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=-1 && ADX_Level==1)          //---R
    {
    Status=11;
    Strategy_Used=31;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
    }
    
    if(Status==8 && Trend_Global==1 && BBflat_Verdict_M1==-1) //&& BBflat_Verdict_M30==-1)          //---R
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status=11;
      Strategy_Used=3201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing SELL order using Strategy #", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status=12;
      Strategy_Used=3202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance for Initializing BUY order using Strategy #", Strategy_Used);
      }
    }
    
    Comments=NormalizeDouble(Strategy_Used, 0);  //----------------------------  Comments
     
    long current_chart_id=ChartID();
    string Name_Hline="Target_for_BE";

//--------------------------------------------------------------------  Processing Order

int Order_Number_1 = -2;
int Order_Number_2 = -2;

    switch(Status)
    {
      case 11 : RefreshRates();
        while(Order_Number_1<0)
          {
          RefreshRates();
          Order_Number_1=OrderSend(Symbol(),OP_SELL,Lot_Size_Adjusted,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,Comments,MN_Sell_Primary_1,0,Green);
          }
        while(Order_Number_2<0)
          {
          RefreshRates();
          Order_Number_2=OrderSend(Symbol(),OP_BUYSTOP,Lot_Size_Adjusted*3,NormalizeDouble((MarketInfo(Symbol(),MODE_ASK)+(ATR_M30*4)),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Protection",MN_Buy_Protection,0,Blue);
          }
        if(Order_Number_1>=0 && Order_Number_2>=0)
          {
          Status=15;
          UpdatedOrderTime=0;
          Countdown_Minutes=0;
          Countdown_Seconds=0;
          ATR_M30_Static=ATR_M30*4;
          Price=NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS))-(ATR_M30_Static);
          Hline_Low=ObjectCreate("Target_for_BreakEven", OBJ_HLINE, 0, 0, Price);
          if(Hline_Low==true)
            {
            ObjectSet("Target_for_BreakEven",OBJPROP_COLOR,Red);
            ObjectSet("Target_for_BreakEven",OBJPROP_STYLE,STYLE_DOT);
            }
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Positions #", Order_Number_1, " SELL ", "and #", Order_Number_2, " BUYSTOP ", Symbol(), " confirmed. Re-initializing Countdown.");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, SELL order has been initialized using Stategy # " + Strategy_Used + ".");
          Defcon=4;
          }
        if((Order_Number_1==-1 || Order_Number_2==-1) && Alert_Popping==1)
          {
          Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
          }
        break;
     
      case 12 : RefreshRates();
        while(Order_Number_1<0)
          {
          RefreshRates();
          Order_Number_1=OrderSend(Symbol(),OP_BUY,Lot_Size_Adjusted,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,Comments,MN_Buy_Primary_1,0,Green);
          }
        while(Order_Number_2<0)
          {
          RefreshRates();
          Order_Number_2=OrderSend(Symbol(),OP_SELLSTOP,Lot_Size_Adjusted*3,NormalizeDouble((MarketInfo(Symbol(),MODE_BID)-(ATR_M30*4)),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Protection",MN_Sell_Protection,0,Blue);
          }
        if(Order_Number_1>=0 && Order_Number_2>=0)
          {
          Status=16;
          UpdatedOrderTime=0;
          Countdown_Minutes=0;
          Countdown_Seconds=0;
          ATR_M30_Static=ATR_M30*4;
          Price=NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS))+(ATR_M30_Static);
          Hline_High=ObjectCreate("Target_for_BreakEven", OBJ_HLINE, 0, 0, Price);
          if(Hline_High==true)
            {
            ObjectSet("Target_for_BreakEven",OBJPROP_COLOR,Red);
            ObjectSet("Target_for_BreakEven",OBJPROP_STYLE,STYLE_DOT);
            }        
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Positions #", Order_Number_1, " BUY ", "and #", Order_Number_2, " SELLSTOP ", Symbol(), " confirmed. Re-initializing Countdown.");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, BUY order has been initialized using Stategy # " + Strategy_Used + ".");
          Defcon=4;
          }
        if((Order_Number_1<0 || Order_Number_2<0) && Alert_Popping==1)
          {
          Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
          }
        break;
    
    default : break;
    
    }

return(0);
}

//-----------------------------------------------------------------------  Tracking Orders

bool Order_Closing=False;

if(Protective_Mode==0 && Profit>=0 && OrdersTotal()!=0)
{

for(pos=0; pos<total; pos++)
{
  
  if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES)==true)
  {
    if((OrderMagicNumber()==MN_Sell_Primary_1) && (BBflat_Verdict_M30Y_T2==-1 && BBflat_Verdict_M30Y==0))
      {
      RefreshRates();
      Profit=OrderProfit();
      Order_Number=OrderTicket();
      while(OrderSell_Closing!=True)
        {
        RefreshRates();
        OrderSell_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        if(Logging==1)
          {
          Subfolder="SyFirst_Grid-EA";
          FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
          if(FileHandle!=INVALID_HANDLE)
            {
            FileSeek(FileHandle, 0, SEEK_END);
            FileWrite(FileHandle, Symbol(), "SELL", Defcon, Strategy_Used, Profit);
            FileClose(FileHandle);
            if(Alert_Popping==1)
              Alert("SyFirst_Grid : Writing Parameters OK");
            }
          if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
            Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
          }
        Status=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_BreakEven")>=0)
          ObjectDelete("Target_for_BreakEven");
        for(pos=0; pos<total; pos++)
          {
          if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Protection)
            {
            Order_Number=OrderTicket();
            while(Order_Closing!=True)
              Order_Closing=OrderDelete(Order_Number,Red);
            }
          } 
        if(Profit>=0)
          {
          if(Alert_Popping==1 && SleepTime_Min>0)
            Alert("SyFirst_Grid : SELL Position closed. Gain = ", Profit, ", Idling for ", SleepTime_Min, " min");
          if(Alert_Popping==1 && SleepTime_Min==0)
            Alert("SyFirst_Grid : SELL Position closed. Gain = ", Profit, ", No Idling");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, you won " + Profit + " units." + "\r\n" + "Account balance #" + AccountNumber() + " is " + AccountBalance() + " units.");
          }
        if(Profit<0)
          {
          if(Alert_Popping==1 && SleepTime_Min>0)
            Alert("SyFirst_Grid : Position SELL cloturee. Perte = ", MathAbs(Profit), ", Idling for ", SleepTime_Min, " min");
          if(Alert_Popping==1 && SleepTime_Min==0)
            Alert("SyFirst_Grid : Position SELL cloturee. Perte = ", MathAbs(Profit), ", No Idling");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, you lost " + Profit + " units." + "\r\n" + "Account balance #" + AccountNumber() + " is " + AccountBalance() + " units.");
          }
        Defcon=5;
        StopLoss_Activation=0;
        if(SleepTime_Min>0)
          Sleep(SleepTime_Min*60000);
        }
      if(OrderSell_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
    
      return(0);
      }

    if(OrderMagicNumber()==MN_Buy_Primary_1 && (BBflat_Verdict_M30Y_T2==1 && BBflat_Verdict_M30Y==0))
      {
      RefreshRates();
      Profit=OrderProfit();
      Order_Number=OrderTicket();
      while(OrderBuy_Closing!=True)
        {
        RefreshRates();
        OrderBuy_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Closing #", Order_Number);
        if(Logging==1)
          {
          Subfolder="SyFirst_Grid-EA";
          FileHandle=FileOpen(Subfolder+"\\Parameters_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
          if(FileHandle!=INVALID_HANDLE)
            {
            FileSeek(FileHandle, 0, SEEK_END);
            FileWrite(FileHandle, Symbol(), "BUY", Defcon, Strategy_Used, Profit);
            FileClose(FileHandle);
            if(Alert_Popping==1)
              Alert("SyFirst_Grid : Writing Parameters OK");
            }
          if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
            Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
          }
        Status=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_BreakEven")>=0)
          ObjectDelete("Target_for_BreakEven");
        for(pos=0; pos<total; pos++)
          {
          if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Protection)
            {
            Order_Number=OrderTicket();
            while(Order_Closing!=True)  
              Order_Closing=OrderDelete(Order_Number,Red);
            }
          }
        if(Profit>=0)
          {
          if(Alert_Popping==1 && SleepTime_Min>0)
            Alert("SyFirst_Grid : BUY position closed. Gain = ", Profit, " Idling for ", SleepTime_Min, " min");
          if(Alert_Popping==1 && SleepTime_Min==0)
            Alert("SyFirst_Grid : BUY position closed. Gain = ", Profit, " No idling");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, you won " + Profit + " units." + "\r\n" + "Account balance #" + AccountNumber() + " is " + AccountBalance() + " units.");
          }
        if(Profit<0)
          {
          if(Alert_Popping==1 && SleepTime_Min>0)
            Alert("SyFirst_Grid : Position BUY cloturee. Perte = ", MathAbs(Profit), " Mise en veille de ", SleepTime_Min, " min");
          if(Alert_Popping==1 && SleepTime_Min==0)
            Alert("SyFirst_Grid : Position BUY cloturee. Perte = ", MathAbs(Profit), " Aucune mise en veille");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Activity Report", "Hi " + Owner_Name + ", concerning the pair " + Symbol() + " at " + TerminalCompany() + "'s, you lost " + Profit + " units." + "\r\n" + "Account balance #" + AccountNumber() + " is " + AccountBalance() + " units.");
          }
        Defcon=5;
        StopLoss_Activation=0;
        if(SleepTime_Min>0)
          Sleep(SleepTime_Min*60000);
        }
      if(OrderBuy_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
    
      return(0);
      }
      
  }

}

}

//---------------------------------------------------------------------  My only friend, The End...

return(0);
}