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
/*input timeframes  */ENUM_TIMEFRAMES timeframe   = PERIOD_CURRENT;    //���������
input bool        auto        = false; //�������������� ����������� ������� (��� �������)
input int         SL          = 10;    //�� �� 233(�)
input int         TP          = 20;    //��(�)
input double      volume      = 0.01;  //�����
input double      volume233   = 0.02;  //����� ��� 233
int         offset      = 0;     //������ �� ��
int         spread      = 0;     //����� ��� ������ �������� (0 - ����� �� �����������)
int         MAperiod    = 233;    //������ ��
int         MAshift     = 0;     //�����  ��

ENUM_TIMEFRAMES period;
int mtp;
string botName = "VSA-RISK";
bool j = false; //���� true, �� ������� ��� ������ �� ������ �����, ���� false, �� �������� ������ � ������������� ������������

int OnInit(){
//---
   trade.SetExpertMagic(magic);
   
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   /*switch(timeframe){
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
         
   }*/
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
   Comment("Profit: ",Profit());
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
   TralStops();
   /*CatchProfit();
   if(j){
      TakeProfit();
   }*/
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
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), period, 0, 2, rates);
   if(ArraySize(rates) < 2)
      return;
   
   double price21  = iMA(Symbol(), period, 21,  0, MODE_EMA, PRICE_CLOSE, 1);
   double price55  = iMA(Symbol(), period, 55,  0, MODE_EMA, PRICE_CLOSE, 1);
   double price233 = iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1);
   
   if(price21 > price55 && price55 > price233 && rates[1].low > price21 && (Total(0) == 0 || Last() == 1)){
      trade.BuyLimit(Symbol(), period, volume, NormalizeDouble(price21  + offset*Point()*mtp, Digits()), NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price21  + TP*Point()*mtp, Digits()), botName+"_MA_21");
      trade.BuyLimit(Symbol(), period, volume, NormalizeDouble(price55  + offset*Point()*mtp, Digits()), NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price55  + TP*Point()*mtp, Digits()), botName+"_MA_55");
      trade.BuyLimit(Symbol(), period, volume233, NormalizeDouble(price233 + offset*Point()*mtp, Digits()), NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price233 + TP*Point()*mtp, Digits()), botName+"_MA_233");
      return;
   }
   if(price21 < price55 && price55 < price233 && rates[1].high < price21 && (Total(1) == 0 || Last() == 0)){
      trade.SellLimit(Symbol(), period, volume, NormalizeDouble(price21  - offset*Point()*mtp, Digits()), NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price21 - TP*Point()*mtp, Digits()), botName+"_MA_21");
      trade.SellLimit(Symbol(), period, volume, NormalizeDouble(price55  - offset*Point()*mtp, Digits()), NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price21 - TP*Point()*mtp, Digits()), botName+"_MA_55");
      trade.SellLimit(Symbol(), period, volume233, NormalizeDouble(price233 - offset*Point()*mtp, Digits()), NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price21 - TP*Point()*mtp, Digits()), botName+"_MA_233");
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
   int total = OrdersTotal();
   bool t = false;
   double price21  = 0.0;
   double price55  = 0.0;
   double price233 = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYLIMIT){
            price21  = NormalizeDouble(iMA(Symbol(), period, 21, 0,  MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            price55  = NormalizeDouble(iMA(Symbol(), period, 55, 0,  MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            price233 = NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() < price21)
               t = OrderModify(OrderTicket(), price21, NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price21 + TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "55", 0) > -1 && OrderOpenPrice() < price55)
               t = OrderModify(OrderTicket(), price55, NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price55 + TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "233", 0) > -1 && OrderOpenPrice() < price233)
               t = OrderModify(OrderTicket(), price233, NormalizeDouble(price233 - SL*Point()*mtp, Digits()), NormalizeDouble(price233 + TP*Point()*mtp, Digits()), OrderExpiration());
         //Print("Buy sl: ",OrderStopLoss(),"   Buy tp: ",OrderTakeProfit());
         }
         if(OrderType() == OP_SELLLIMIT){
            price21  = NormalizeDouble(iMA(Symbol(), period, 21, 0,  MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            price55  = NormalizeDouble(iMA(Symbol(), period, 55, 0,  MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            price233 = NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() > price21)
               t = OrderModify(OrderTicket(), price21, NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price21 - TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "55", 0) > -1 && OrderOpenPrice() > price55)
               t = OrderModify(OrderTicket(), price55, NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price55 - TP*Point()*mtp, Digits()), OrderExpiration());
            if(StringFind(OrderComment(), "233", 0) > -1 && OrderOpenPrice() > price233)
               t = OrderModify(OrderTicket(), price233, NormalizeDouble(price233 + SL*Point()*mtp, Digits()), NormalizeDouble(price233 - TP*Point()*mtp, Digits()), OrderExpiration());
               
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }   
}

void TralStops(){
   if(Total() == 0)
      return;
   int total = OrdersTotal();
   bool t = false;
   double price233 = NormalizeDouble(iMA(Symbol(), period, 233, 0, MODE_EMA, PRICE_CLOSE, 1), Digits());
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            double sl = NormalizeDouble(price233 - SL*Point()*mtp, Digits());
            if(OrderStopLoss() < sl && OrderStopLoss() != 0.0)
               t = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
         //Print("Buy sl: ",OrderStopLoss(),"   Buy tp: ",OrderTakeProfit());
         }
         if(OrderType() == OP_SELL){
            double sl = NormalizeDouble(price233 + SL*Point()*mtp, Digits());
            if(OrderStopLoss() > sl && OrderStopLoss() != 0.0)
               t = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
               
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }   
}

int Total(int dir = -1){
   if(OrdersTotal() == 0)
      return 0;
   int count = 0;
   int total = OrdersTotal();
   bool t = false;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         if((OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) && (dir == -1 || dir == 0 || dir == 2))
            count++;
         else if((OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) && (dir == -1 || dir == 1 || dir == 3))
            count++;

   }
   return count;
}

int Last(){
   if(OrdersTotal() == 0)
      return -1;
   int total = OrdersTotal();
   bool t = false;
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP)
            return 0;
         else if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP)
            return 1;
      }
   }
   return -1;
}

double Profit(){
   if(OrdersTotal() == 0)
      return 0.0;
   int total = OrdersTotal();
   bool t = false;
   double profit = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         profit += OrderProfit() + OrderSwap() + OrderCommission();
   }
   return profit;
}

void CatchProfit(){
   if(OrdersTotal() == 0)
      return;
   int count = 0;
   
   bool t = false;
   int total = OrdersTotal();
   
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(count > 0 && (OrderProfit() + OrderSwap() + OrderCommission()) < 0.0){
            ClearTP();
            j = true;
            return;
         }
         j = false;
         count++;         
      }
   }
}

void ClearTP(){
   if(OrdersTotal() == 0)
      return;
   bool t = false;
   int total = OrdersTotal();
   
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderTakeProfit() != 0.0){
            t = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), 0.0, OrderExpiration());
         }        
      }
   }
}

void TakeProfit(){
   if(OrdersTotal() == 0)
      return;
   if(Profit() > 0.0){
      trade.DeletePendings();
      trade.CloseTrades();
      j = false;
   }
}

double MartinLot(){
   if(OrdersTotal() == 0)
      return volume;
   int total = OrdersTotal();
   bool t = false;
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         return OrderLots()*2;
   }
   return volume;
}