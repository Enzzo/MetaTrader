//+------------------------------------------------------------------+
//|                                                         FIBO.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

input    color    fiboColor   = clrBlack;
input    string   sLevels     = "0;1;2;3;4;5";
         string   fiboName    = "FiboLevel";
         ushort   n           = 0;
         
int OnInit(){
//---
   return(INIT_SUCCEEDED);
}
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
   if(n == 0){
      string   str[];
      int      l     = 0;
      StringSplit(sLevels,';',str);
      
      double            lvls[];
      color             clrs[];
      ENUM_LINE_STYLE   stls[];
      int               wdths[];         
      
      ArrayResize(lvls,  ArraySize(str));
      ArrayResize(clrs,  ArraySize(str));
      ArrayResize(stls,  ArraySize(str));
      ArrayResize(wdths, ArraySize(str));
      
      for(int i = 0; i < ArraySize(str); i++){
         clrs[i]  = clrBlack;
         stls[i]  = 0;
         wdths[i] = 3;
         lvls[i]  = StringToDouble(str[i]);
      }
      
      FiboLevelsCreate(0, fiboName);
      FiboLevelsSet(ArraySize(lvls), lvls, clrs, stls, wdths, 0, fiboName);
      n++;
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}

/*oid OnDeinit(const int reason){
   for(int i = ObjectsTotal()-1; i>=0; i--){
      if(StringFind(ObjectName(0, i),fiboName) > -1)ObjectDelete(0, ObjectName(0, i));
   }
}*/

//+------------------------------------------------------------------+

bool FiboLevelsCreate(const long            chart_ID=0,        // ID графика 
                      const string          name="FiboLevels", // имя объекта 
                      const int             sub_window=0,      // номер подокна  
                      datetime              time1=0,           // время первой точки 
                      double                price1=0,          // цена первой точки 
                      datetime              time2=0,           // время второй точки 
                      double                price2=0,          // цена второй точки 
                      const color           clr=clrRed,        // цвет объекта 
                      const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии объекта 
                      const int             width=1,           // толщина линии объекта 
                      const bool            back=false,        // на заднем плане 
                      const bool            selection=true,    // выделить для перемещений 
                      const bool            ray_right=false,   // продолжение объекта вправо 
                      const bool            hidden=true,       // скрыт в списке объектов 
                      const long            z_order=0)         // приоритет на нажатие мышью 
{ 
//--- установим координаты точек привязки, если они не заданы 
   ChangeFiboLevelsEmptyPoints(time1,price1,time2,price2); 
  
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим "Уровни Фибоначчи" по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать \"Уровни Фибоначчи\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим выделения объекта для перемещений 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим продолжения отображения объекта вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установи приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
} 

void ChangeFiboLevelsEmptyPoints(datetime &time1,double &price1, 
                                 datetime &time2,double &price2) 
{ 
//--- если время второй точки не задано, то она будет на текущем баре 
   if(!time2) 
      time2=TimeCurrent(); 
//--- если цена второй точки не задана, то она будет иметь значение Bid 
   if(!price2) 
      price2 = fLow();//fHigh();
//--- если время первой точки не задано, то она лежит на 9 баров левее второй 
   if(!time1) 
     { 
      //--- массив для приема времени открытия 10 последних баров 
      datetime temp[10]; 
      CopyTime(Symbol(),Period(),time2,10,temp); 
      //--- установим первую точку на 9 баров левее второй 
      time1=temp[0]; 
     } 
//--- если цена первой точки не задана, то сдвинем ее на 200 пунктов ниже второй 
   if(!price1) 
      price1=fHigh();//fLow();
}
  
bool FiboLevelsSet(int             levels,            // количество линий уровня 
                   double          &values[],         // значения линий уровня 
                   color           &colors[],         // цвет линий уровня 
                   ENUM_LINE_STYLE &styles[],         // стиль линий уровня 
                   int             &widths[],         // толщина линий уровня 
                   const long      chart_ID=0,        // ID графика 
                   const string    name="FiboLevels") // имя объекта 
{ 
//--- проверим размеры массивов 
   if(levels!=ArraySize(colors) || levels!=ArraySize(styles) || 
      levels!=ArraySize(values) || levels!=ArraySize(widths)) 
     { 
      Print(__FUNCTION__,": длина массива не соответствует количеству уровней, ошибка! ",ArraySize(colors),"  ",levels); 
      return(false); 
     } 
//--- установим количество уровней 
   ObjectSetInteger(chart_ID,name,OBJPROP_LEVELS,levels); 
//--- установим свойства уровней в цикле 
   for(int i=0;i<levels;i++) 
     { 
      //--- значение уровня 
      ObjectSetDouble(chart_ID,name,OBJPROP_LEVELVALUE,i,values[i]); 
      //--- цвет уровня 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,i,colors[i]); 
      //--- стиль уровня 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELSTYLE,i,styles[i]); 
      //--- толщина уровня 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELWIDTH,i,widths[i]); 
      //--- описание уровня 
      ObjectSetString(chart_ID,name,OBJPROP_LEVELTEXT,i,DoubleToString(100*values[i],1)); 
     } 
//--- успешное выполнение 
   return(true); 
}

double fHigh(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 10, rates);
   
      
   double price = High[1];
   
   if(ArraySize(rates)<10)return price;
   
   for(int i = 0; i < 10; i++){
      if(price < rates[i].high)price = rates[i].high;
   }
   
   return NormalizeDouble(price, Digits());
}

double fLow(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 10, rates);
   
      
   double price = Low[1];
   
   if(ArraySize(rates)<10)return price;
   
   for(int i = 0; i < 10; i++){
      if(price > rates[i].low)price = rates[i].low;
   }
   
   return NormalizeDouble(price, Digits());
}