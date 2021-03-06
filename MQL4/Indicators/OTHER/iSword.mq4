//+------------------------------------------------------------------+
//|                                                      iCloses.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window

input int   bars  = 50;       //С какого бара начинать
input int   wdth  = 2;        //Ширина
input color clr   = clrGreen; //Цвет

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
//---
   if(prev_calculated == 0 && bars <= rates_total){
      for(int i = bars-1; i > 0; i--)         
         ArrowCheckCreate(0, "AC", 0, time[i], high[i], 1, clr, 0, wdth);
      return (rates_total);
   }
   
   ArrowCheckCreate(0, "AC", 0, time[1], high[1], 1, clr, 0, wdth);
   
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
//---
   for(int i = ObjectsTotal()-1; i>=0; i--){
      if(StringFind(ObjectName(0, i), "AC")!= -1)
         ObjectDelete(0, ObjectName(0, i));
   }
}

bool ArrowCheckCreate(const long              chart_ID=0,           // ID графика 
                      const string            _name="AC",    // имя знака 
                      const int               sub_window=0,         // номер подокна 
                      datetime                time=0,               // время точки привязки 
                      double                  price=0,              // цена точки привязки 
                      const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // способ привязки 
                      const color             _clr=clrRed,          // цвет знака 
                      const ENUM_LINE_STYLE   style=STYLE_SOLID,    // стиль окаймляющей линии 
                      const int               width=3,              // размер знака 
                      const bool              back=false,           // на заднем плане 
                      const bool              selection=false,      // выделить для перемещений 
                      const bool              hidden=true,          // скрыт в списке объектов 
                      const long              z_order=0)            // приоритет на нажатие мышью 
  {
  if(ObjectsTotal() != 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(0, i), DoubleToString(NormalizeDouble(time, Digits())))!= -1)
         return false;
      }
   }
   static int n = 0;
   string name = _name + (n<10? "_0":"_") + IntegerToString(n)+"_"+DoubleToString(NormalizeDouble(time, Digits()));
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим знак 
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_CHECK,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать знак \"Галка\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим способ привязки 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- установим цвет знака 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,_clr); 
//--- установим стиль окаймляющей линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим размер знака 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения знака мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установи приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 
