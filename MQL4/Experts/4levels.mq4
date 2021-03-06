//+------------------------------------------------------------------+
//|                                                      4levels.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 902833;
input double volume = 0.01;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   Comment("");
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
   ButtonCreate(0, "Trade", 0, 90, 60, 80, 25, CORNER_RIGHT_LOWER, "Trade", "Arial", 10, clrBlack, C'236,233,216', clrGreen, false, false, false, true, 0);
   ButtonCreate(0, "Close", 0, 90, 30, 80, 25, CORNER_RIGHT_LOWER, "Закрыть все", "Arial", 10, clrBlack, C'236,233,216', clrOrange, false, false, false, true, 0);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "Trade");ObjectDelete(0, "Close");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(ObjectGetInteger(0, "Trade", OBJPROP_STATE, true)){
      fCastOrders();
      ObjectSetInteger(0, "Trade", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(0, "Close", OBJPROP_STATE, true)){
      trade.CloseTrades();
      trade.DeletePendings();
      ObjectSetInteger(0, "Close", OBJPROP_STATE, false);
   }
}
//+------------------------------------------------------------------+

void fCastOrders(){

   if(ObjectsTotal(OBJ_HLINE) < 4){
      Comment("ГОРИЗОНТАЛЬНЫХ ЛИНИЙ ДОЛЖНО БЫТЬ ЧЕТЫРЕ");
      Sleep(3000);
      Comment("");
      return;
   }
   
   double lvl[];
   ushort j = 0;
   ArrayResize(lvl,ObjectsTotal(OBJ_HLINE));
   for(int i = ObjectsTotal()-1; i>=0; i--){
      string name = ObjectName(ChartID(), i);
      if(StringFind(name, "Horizontal") != -1){         
         lvl[j] = NormalizeDouble(ObjectGetDouble(ChartID(), name, OBJPROP_PRICE), Digits());
         j++;
      }
   }
   if(ArraySize(lvl)>4){
      Comment("ГОРИЗОНТАЛЬНЫХ ЛИНИЙ ДОЛЖНО БЫТЬ ЧЕТЫРЕ");
      Sleep(7000);
      Comment("");
      return;
   }
   ArraySort(lvl);
   
   if(lvl[3] <= Bid || lvl[2] <= Ask || lvl[1] >= Bid || lvl[0] >= Ask){
      Comment("НЕ ПРАВИЛЬНОЕ РАСПОЛОЖЕНИЕ ГОРИЗОНТАЛЬНЫХ ЛИНИЙ\nДве линии должны быть выше цены закрытия, а две - ниже цены закрытия");
      Sleep(10000);
      Comment("");
      return;
   }
   trade.BuyStop  (Symbol(), volume, lvl[3], 0.0, 0.0, 0, "");
   trade.SellLimit(Symbol(), volume, lvl[2], 0.0, lvl[1], 0, "");
   trade.BuyLimit (Symbol(), volume, lvl[1], 0.0, lvl[2], 0, "");
   trade.SellStop (Symbol(), volume, lvl[0], 0.0, 0.0, 0, "");
   
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