//+------------------------------------------------------------------+
//|                                                       SPRING.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int      magic = 897679;   //Магик
input int      size  = 200;      //Размер недельной свечи (п)
input double   volume = 0.01;    //Объем
input int      TP = 50;          //Тейкпрофит   
      int      SL = 0;           //Стоплос

      ushort   mtp;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   mtp = 1;if(Digits() == 5 || Digits() == 3)mtp = 10;
      
   trade.SetExpertComment(WindowExpertName());
   trade.SetExpertMagic(magic);
   
   ButtonCreate(0, "TRADE", 0, 90, 60, 80, 25, CORNER_RIGHT_LOWER, "TRADE", "Arial", 10, clrBlack, C'236,233,216', clrBlack, false, false, false, true, 0);
   ButtonCreate(0, "CLOSE", 0, 90, 30, 80, 25, CORNER_RIGHT_LOWER, "CLOSE", "Arial", 10, clrBlack, C'236,233,216', clrOrange, false, false, false, true, 0);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---

   ObjectDelete(0, "TRADE");ObjectDelete(0, "CLOSE");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(fCheckSize() && fTrades())ObjectSetInteger(0, "TRADE", OBJPROP_BGCOLOR, clrMediumSeaGreen);
   else ObjectSetInteger(ChartID(), "TRADE", OBJPROP_BGCOLOR, clrRed);
   
   if(IsOptimization() || IsTesting())if(ObjectGetInteger(0, "TRADE", OBJPROP_BGCOLOR) == clrMediumSeaGreen)fSendOrders();  
   
   else if(ObjectGetInteger(0, "TRADE", OBJPROP_STATE) == true){
      
      if(ObjectGetInteger(0, "TRADE", OBJPROP_BGCOLOR) == clrMediumSeaGreen)fSendOrders();     
      
      ObjectSetInteger(0, "TRADE", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(0, "CLOSE", OBJPROP_STATE, true)){
      trade.CloseTrades();
      trade.DeletePendings();
      ObjectSetInteger(0, "CLOSE", OBJPROP_STATE, false);
   }
}
//+------------------------------------------------------------------+

void fSendOrders(){
   Print("Send");
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_W1, 1, 1, rates);
   
   if(rates[0].close > rates[0].open)trade.Sell(Symbol(), volume, SL, TP);
   else trade.Buy(Symbol(), volume, SL, TP);
}

bool fCheckSize(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_W1, 1, 1, rates);
   if(ArraySize(rates)<1)return false;
      
   if(MathAbs((int)NormalizeDouble((rates[0].close - rates[0].open)/Point()/mtp, Digits()))>size)return true; //можно торговать
   return false;   //нельзя торговать
};

bool fTrades(){
   if(OrdersTotal() == 0)return true;
   for(int i = OrdersTotal()-1; i>= 0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         Trade(OrderTicket());
         return false;
      }
   }
   return true;
}

void Trade(int t = 0){
   if(OrderSelect(t, SELECT_BY_TICKET)){
      int d = OrderType();
      double tp = 0.0;
      switch(d){
         case 0:            
            if(Ask < NormalizeDouble(OrderOpenPrice()-TP*2*Point()*mtp, Digits())){
               tp = NormalizeDouble(OrderTakeProfit()-TP*Point()*mtp, Digits());
               trade.Buy(Symbol(), volume, (double)SL, tp);
               Averaging(tp);
            }
         break;
            
         case 1:
            if(Bid > NormalizeDouble(OrderOpenPrice()+TP*2*Point()*mtp, Digits())){
               tp = NormalizeDouble(OrderTakeProfit()+TP*Point()*mtp, Digits());
               trade.Sell(Symbol(), volume, (double)SL, tp);
               Averaging(tp);
            }
         break;
      }
   }
}

void Averaging(double tp){
   for(int i = OrdersTotal()-1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())x = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), tp, 0);
   }
}

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