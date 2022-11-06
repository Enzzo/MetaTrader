//+------------------------------------------------------------------+
//|                                                     VSA-RISK.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <trade.mqh>
#include <SpreadController.mqh>

CTrade trade;
SpreadController sc;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

enum timeframes{
   M1,   //M1
   M5,   //M5
   M15,  //M15
   M30,  //M30
   H1,   //H1
   H4    //H4
};

input int         magic       = 41134; //�����
input timeframes  timeframe   = H1;    //���������
bool        auto        = true; //�������������� ����������� ������� (��� �������)
int         SL          = 0;    //��(�)
int         TP          = 0;    //��(�)
input double      volume      = 20.00;  //�����
input double      volume233   = 20.00;  //����� ��� 233
input int         offset      = -100;     //������ �� ��
input int         spread      = 0;    //����� ��� ������ �������� (0 - ����� �� �����������)

ENUM_TIMEFRAMES period;
int mtp;
string botName = "VSA-RISK";

int OnInit(){
//---
   trade.SetExpertMagic(magic);
   
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   switch(timeframe){
      case 0:
         period = PERIOD_M1;
         break;
      case 1:
         period = PERIOD_M5;
         break;
      case 2:
         period = PERIOD_M15;
         break;
      case 3:
         period = PERIOD_M30;
         break;
      case 4:
         period = PERIOD_H1;
         break;
      default:
         period = PERIOD_H4;
         
   }
   ButtonCreate(0, "Send", 0, 5, 80, 80, 25, CORNER_LEFT_LOWER, "�����", "Arial", 10, clrBlack, C'236,233,216', clrNONE, false, false, false, true, 0);
   ButtonCreate(0, "Close", 0, 90, 80, 80, 25, CORNER_LEFT_LOWER, "�������", "Arial", 10, clrBlack, C'236,233,216', clrNONE, false, false, false, true, 0);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "Send");
   ObjectDelete(0, "Close");
   sc.DestroyInfo();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   sc.ShowSpread(1, 10, 15, spread);
   if(!sc.CompareSpread(spread))
      return;
   
   if(auto)
      SendOrders();
   else if(!auto && ObjectGetInteger(0, "Send", OBJPROP_STATE, true)){
      SendOrders();
      ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(0, "Close", OBJPROP_STATE, true)){
      CloseOrders();
      ObjectSetInteger(0, "Close", OBJPROP_STATE, false);      
   }
   TralOrders();
   TakeProfit();
}
//+------------------------------------------------------------------+

bool ButtonCreate(const long              chart_ID=0,               // ID ������� 
                  const string            name="Button",            // ��� ������ 
                  const int               sub_window=0,             // ����� ������� 
                  const int               x=5,                      // ���������� �� ��� X 
                  const int               y=80,                      // ���������� �� ��� Y 
                  const int               width=80,                 // ������ ������ 
                  const int               height=25,                // ������ ������ 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_LOWER, // ���� ������� ��� �������� 
                  const string            text="�����",            // ����� 
                  const string            font="Arial",             // ����� 
                  const int               font_size=10,             // ������ ������ 
                  const color             clr=clrBlack,             // ���� ������ 
                  const color             back_clr=C'236,233,216',  // ���� ���� 
                  const color             border_clr=clrNONE,       // ���� ������� 
                  const bool              state=false,              // ������/������ 
                  const bool              back=false,               // �� ������ ����� 
                  const bool              selection=false,          // �������� ��� ����������� 
                  const bool              hidden=true,              // ����� � ������ �������� 
                  const long              z_order=0)                // ��������� �� ������� ����� 
{ 
//--- ������� �������� ������ 
   ResetLastError(); 
//--- �������� ������ 
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": �� ������� ������� ������! ��� ������ = ",GetLastError()); 
      return(false); 
     } 
//--- ��������� ���������� ������ 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- ��������� ������ ������ 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- ��������� ���� �������, ������������ �������� ����� ������������ ���������� ����� 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- ��������� ����� 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- ��������� ����� ������ 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- ��������� ������ ������ 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- ��������� ���� ������ 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- ��������� ���� ���� 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- ��������� ���� ������� 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
//--- ��������� �� �������� (false) ��� ������ (true) ����� 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- ��������� ������ � �������� ��������� 
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state); 
//--- ������� (true) ��� �������� (false) ����� ����������� ������ ����� 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- ������ (true) ��� ��������� (false) ��� ������������ ������� � ������ �������� 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- ��������� ��������� �� ��������� ������� ������� ���� �� ������� 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- �������� ���������� 
   return(true); 
} 


void SendOrders(){
   //if(Total() > 0)
   //   return;
   
   bool buy21   = false;
   bool buy55   = false;
   bool buy233  = false;
   bool sell21  = false;
   bool sell55  = false;
   bool sell233 = false;
   double spr;
   RefreshRates();
   spr = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD)*Point()*mtp, Digits());
   int total = OrdersTotal();
   bool t = false;
   if(total > 0){
      for(int i = 0; i < total; i++){
         t = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && Period() == period){
            if(OrderType() == OP_BUYSTOP){
               if(StringFind(OrderComment(), "21",0) > -1)
                  buy21 = true;
               else if(StringFind(OrderComment(), "55", 0) > -1)
                  buy55 = true;
               else if(StringFind(OrderComment(), "233", 0) > -1)
                  buy233 = true;
            }
            else if(OrderType() == OP_SELLSTOP){
               if(StringFind(OrderComment(), "21",0) > -1)
                  sell21 = true;
               else if(StringFind(OrderComment(), "55", 0) > -1)
                  sell55 = true;
               else if(StringFind(OrderComment(), "233", 0) > -1)
                  sell233 = true;
            }
         }
      }
   }
   
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), period, 0, 2, rates);
   if(ArraySize(rates) < 2)
      return;
   
   if(iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 1) > iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1)  &&
      iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1) > iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) &&
      rates[0].close > iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 0)){
      if(!sell21)trade.SellStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_21");
      if(!sell55)trade.SellStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp , Digits()), SL, TP, botName+"_MA_55");
      if(!sell233)trade.SellStop(Symbol(), volume233, NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_233");
      return;
   }
   if(iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 1) < iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1)  &&
      iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1) < iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) &&
      rates[0].close < iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 0)){
      if(!buy21)trade.BuyStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), period, 21, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_21");
      if(!buy55)trade.BuyStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), period, 55, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_55");
      if(!buy233)trade.BuyStop(Symbol(), volume233, NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_233");
      return;
   }
}

void CloseOrders(){
   if(Total() == 0)
      return;
   trade.CloseBuy();
   trade.CloseSell();
   trade.DeletePendings();
}

void TralOrders(){
   if(Total() == 0)
      return;
   double spr;
   RefreshRates();
   spr = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD)*Point()*mtp, Digits());
   int total = OrdersTotal();
   bool t = false;
   double price21  = 0.0;
   double price55  = 0.0;
   double price233 = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && Period() == period){
         if(OrderType() == OP_BUYSTOP){
            price21  = NormalizeDouble(iMA(Symbol(), period, 21, 0,  MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            price55  = NormalizeDouble(iMA(Symbol(), period, 55, 0,  MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            price233 = NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() > price21)
               t = OrderModify(OrderTicket(), price21, SL == 0 ? 0.0 : NormalizeDouble(price21 - SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price21 + TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "55", 0) > -1 && OrderOpenPrice() > price55)
               t = OrderModify(OrderTicket(), price55, SL == 0 ? 0.0 : NormalizeDouble(price55 - SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price55 + TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "233", 0) > -1 && OrderOpenPrice() > price233)
               t = OrderModify(OrderTicket(), price233, SL == 0 ? 0.0 : NormalizeDouble(price233 - SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price233 + TP*Point()*mtp, Digits()), OrderExpiration());
         //Print("Buy sl: ",OrderStopLoss(),"   Buy tp: ",OrderTakeProfit());
         }
         if(OrderType() == OP_SELLSTOP){
            price21  = NormalizeDouble(iMA(Symbol(), period, 21, 0,  MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            price55  = NormalizeDouble(iMA(Symbol(), period, 55, 0,  MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            price233 = NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() < price21)
               t = OrderModify(OrderTicket(), price21, SL == 0 ? 0.0 : NormalizeDouble(price21 + SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price21 - TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "55", 0) > -1 && OrderOpenPrice() < price55)
               t = OrderModify(OrderTicket(), price55, SL == 0 ? 0.0 : NormalizeDouble(price55 + SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price55 - TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "233", 0) > -1 && OrderOpenPrice() < price55)
               t = OrderModify(OrderTicket(), price233, SL == 0 ? 0.0 : NormalizeDouble(price233 + SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price233 - TP*Point()*mtp, Digits()), OrderExpiration());
               
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }
   
}

int Total(){
   if(OrdersTotal() == 0)
      return 0;
   int count = 0;
   int total = OrdersTotal();
   bool t = false;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && Period() == period)
         count++;
   }
   return count;
}

void TakeProfit(){
   if(Total() == 0)
      return;
   bool t = false;
   int total = OrdersTotal();
   double profit = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && Period() == period)
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
   }
   Comment("Profit: ",profit);
   if(profit > 10.0)
      trade.CloseTrades();
}

