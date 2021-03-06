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

input int         magic       = 41134; //Магик
input bool        auto        = false; //Автоматическое выставление ордеров (для тестера)
input int         SL          = 10;    //СЛ(п)
input int         TP          = 20;    //ТП(п)
input double      volume      = 0.01;  //Объем
input int         MAperiod    = 233;   //Период МА

ENUM_TIMEFRAMES period = PERIOD_CURRENT;
int mtp = 1;
string botName = WindowExpertName();

int OnInit(){
//---
   trade.SetExpertMagic(magic);
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
   ButtonCreate(0, "Send", 0, 5, 80, 80, 25, CORNER_LEFT_LOWER, "Старт", "Arial", 10, clrBlack, C'236,233,216', clrNONE, false, false, false, true, 0);
   ButtonCreate(0, "Close", 0, 90, 80, 80, 25, CORNER_LEFT_LOWER, "Закрыть", "Arial", 10, clrBlack, C'236,233,216', clrNONE, false, false, false, true, 0);
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
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   if(auto)
      SendOrders();
   else if(!auto && ObjectGetInteger(0, "Send", OBJPROP_STATE, true)){
      SendOrders();
      //ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
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



void SendOrders(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), period, 1, 1, rates);
   if(ArraySize(rates) < 1)
      return;
   
   double ma0 = iMA(Symbol(), period, MAperiod,  0, MODE_EMA, PRICE_CLOSE, 0);
   double ma1 = iMA(Symbol(), period, MAperiod,  0, MODE_EMA, PRICE_CLOSE, 1);
   int t = Orders();
   if(rates[0].low > ma0 && Ask > ma1 && (t == -1 || t == 1)){
      trade.BuyLimit(Symbol(), volume, NormalizeDouble(ma1, Digits()), SL==0?0.0:NormalizeDouble(ma1 - SL*Point()*mtp, Digits()), TP==0?0.0:NormalizeDouble(ma1  + TP*Point()*mtp, Digits()), 0, botName+"_MA_21");
      ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
      //Print("Buy ",NormalizeDouble(ma1, Digits())," SL: ",NormalizeDouble(ma1 - SL*Point()*mtp, Digits()), " TP: ",NormalizeDouble(ma1  + TP*Point()*mtp, Digits()));
      return;
   }
   if(rates[0].high < ma0 && Bid < ma1 && (t == -1 || t == 0)){
      trade.SellLimit(Symbol(), volume, NormalizeDouble(ma1, Digits()), SL==0?0.0:NormalizeDouble(ma1 + SL*Point()*mtp, Digits()), TP==0?0.0:NormalizeDouble(ma1 - TP*Point()*mtp, Digits()), 0, botName+"_MA_21");
      ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
      //Print("Sell ",NormalizeDouble(ma1, Digits())," SL: ",NormalizeDouble(ma1 + SL*Point()*mtp, Digits()), " TP: ",NormalizeDouble(ma1  - TP*Point()*mtp, Digits()));
      return;
   }
}

void CloseOrders(){
   if(Orders() == -1)
      return;
   trade.CloseBuy();
   trade.CloseSell();
   trade.DeletePendings();
}

void TralOrders(){
   if(Orders() == -1)
      return;
   int total = OrdersTotal();
   bool t = false;
   double level  = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYLIMIT){
            level = NormalizeDouble(iMA(Symbol(), period, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1), Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() < level)
               t = OrderModify(OrderTicket(), level, NormalizeDouble(level - SL*Point()*mtp, Digits()), NormalizeDouble(level + TP*Point()*mtp, Digits()), OrderExpiration());
         }
         if(OrderType() == OP_SELLLIMIT){
            level = NormalizeDouble(iMA(Symbol(), period, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1), Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() > level)
               t = OrderModify(OrderTicket(), level, NormalizeDouble(level + SL*Point()*mtp, Digits()), NormalizeDouble(level - TP*Point()*mtp, Digits()), OrderExpiration());
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }   
}

void TralStops(){
   if(Orders() == -1)
      return;
   int total = OrdersTotal();
   bool t = false;
   double level = NormalizeDouble(iMA(Symbol(), period, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1), Digits());
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            double sl = NormalizeDouble(level - SL*Point()*mtp, Digits());
            if(OrderStopLoss() < sl && OrderStopLoss() != 0.0)
               t = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
         //Print("Buy sl: ",OrderStopLoss(),"   Buy tp: ",OrderTakeProfit());
         }
         if(OrderType() == OP_SELL){
            double sl = NormalizeDouble(level + SL*Point()*mtp, Digits());
            if(OrderStopLoss() > sl && OrderStopLoss() != 0.0)
               t = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
               
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }   
}
/*
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
*/

int Orders(){
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
/*
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
*/

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=5,                      // координата по оси X 
                  const int               y=80,                      // координата по оси Y 
                  const int               width=80,                 // ширина кнопки 
                  const int               height=25,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_LOWER, // угол графика для привязки 
                  const string            text="Старт",            // текст 
                  const string            font="Arial",             // шрифт 
                  const int               font_size=10,             // размер шрифта 
                  const color             clr=clrBlack,             // цвет текста 
                  const color             back_clr=C'236,233,216',  // цвет фона 
                  const color             border_clr=clrNONE,       // цвет границы 
                  const bool              state=false,              // нажата/отжата 
                  const bool              back=false,               // на заднем плане 
                  const bool              selection=false,          // выделить для перемещений 
                  const bool              hidden=true,              // скрыт в списке объектов 
                  const long              z_order=0)                // приоритет на нажатие мышью 
{ 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим кнопку 
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать кнопку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты кнопки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размер кнопки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим цвет текста 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим цвет границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- переведем кнопку в заданное состояние 
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state); 
//--- включим (true) или отключим (false) режим перемещения кнопки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
} 