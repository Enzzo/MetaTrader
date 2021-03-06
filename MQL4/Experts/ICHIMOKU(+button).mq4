//+------------------------------------------------------------------+
//|                                            ICHIMOKU(+button).mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 87741;      //Магик
input double volume = 0.01;   //Объем сделки
input int tenkan = 9;
input int kijun = 22;
input int senkouspanB = 52;
input bool useAlert = true;   //Использовать алерты

string botName = "ICHIMOKU";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   ButtonCreate(0, "Send0", 0, 90, 30, 80, 25, CORNER_RIGHT_LOWER, "TP = 0.0", "Arial", 10, clrBlack, C'236,233,216', clrGreen, false, false, false, true, 0);
   ButtonCreate(0, "Send1", 0, 90, 60, 80, 25, CORNER_RIGHT_LOWER, "TP = ATR", "Arial", 10, clrBlack, C'236,233,216', clrGreen, false, false, false, true, 0);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "Send0");ObjectDelete(0, "Send1");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(useAlert)CustomAlert();
   int total = Total();
   if(ObjectGetInteger(0, "Send0", OBJPROP_STATE, true)){
      SendOrder();
      ObjectSetInteger(0, "Send0", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(0, "Send1", OBJPROP_STATE, true)){
      SendOrder(1);
      ObjectSetInteger(0, "Send1", OBJPROP_STATE, false);
   }
   if(total > 0)Tral();
}
//+------------------------------------------------------------------+

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=5,                      // координата по оси X 
                  const int               y=80,                      // координата по оси Y 
                  const int               width=80,                 // ширина кнопки 
                  const int               height=25,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER, // угол графика для привязки 
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

void SendOrder(int x = 0){
   double chk0 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_CHIKOUSPAN, kijun);
   double chk1 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_CHIKOUSPAN, kijun+1);
   double tk0  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_TENKANSEN, 0);
   double tk1  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_TENKANSEN, 1);
   double kj0  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_KIJUNSEN, 0);
   double kj1  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_KIJUNSEN, 1);
   static short s = -1;
   double sl = 0.0;
   double tp = 0.0;
      
   if(chk0 > Close[kijun] && tk0 >= kj0){
      sl = Ask - iATR(Symbol(), PERIOD_CURRENT, 14, 0);
      tp = Ask + iATR(Symbol(), PERIOD_CURRENT, 14, 0);
      s = 0;
   }
   else if(chk0 < Close[kijun] && tk0 <= kj0){
      sl = Bid + iATR(Symbol(), PERIOD_CURRENT, 14, 0);
      tp = Ask - iATR(Symbol(), PERIOD_CURRENT, 14, 0);
      s = 1;
   }
   else
      s = -1;
      
   if(sl != 0.0)
   switch(s){
      case 0:
         trade.Buy(Symbol(), volume, sl-(Ask-Bid), x == 0?0.0:tp, botName);
      break;
      case 1:
         trade.Sell(Symbol(), volume, sl+(Ask-Bid), x == 0?0.0:tp, botName);
      break;
   }
}

void Tral(){
   double sl = NormalizeDouble(iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_KIJUNSEN, 0), Digits());
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY && OrderStopLoss() < sl && sl < Bid){
            x = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
            break;
         }
         if(OrderType() == OP_SELL && OrderStopLoss() != 0.0 && OrderStopLoss() > sl && sl > Ask){
            x = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration());
            break;
         }
      }
   }
}

short Total(short t = -1){
   if(OrdersTotal() == 0)
      return 0;
   bool x = false;
   short count = 0;
   for(int i = OrdersTotal() - 1; i>= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(t == -1 || OrderType() == t)count++;
      }
   }
   return count;
}

void CustomAlert(){
   static datetime pTime = 0;
   datetime cTime[1];
   CopyTime(Symbol(), PERIOD_CURRENT, 0, 1, cTime);
   if(pTime == cTime[0])
      return;
   pTime = cTime[0];
   double chk0 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_CHIKOUSPAN, kijun);
   double tk0  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_TENKANSEN, 0);
   double tk1  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_TENKANSEN, 1);
   double kj0  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_KIJUNSEN, 0);
   double kj1  = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_KIJUNSEN, 1);
   
   static bool upChk = false;
   static bool gdCrs = false;
   static bool dnChk = false;
   static bool ddCrs = false;
   
   if(chk0 > Close[kijun]){
      upChk = true;
      dnChk = false;
   }
   if(chk0 < Close[kijun]){
      dnChk = true;
      upChk = false;
   }
   if(tk0 >= kj0 && tk1 < kj1){
      gdCrs = true;
      ddCrs = false;
   }
   if(tk0 <= kj0 && tk1 > kj1){
      ddCrs = true;
      gdCrs = false;
   }
   
   if(upChk && gdCrs){
      Alert(Symbol()+" BUY");
      upChk = false;
      gdCrs = false;
   }
   if(dnChk && ddCrs){
      Alert(Symbol()+" SELL");   
      dnChk = false;
      ddCrs = false;
   }
}