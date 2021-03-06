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

input    color    iColor   = clrBlack;    //Цвет фибо
input    int      iWidth   = 2;           //Ширина фибо
input    string   c0    = "";    //----------++++++++++----------
input    double   l0    = 0.0;   //Уровень
input    string   d0    = "";    //Описание
input    string   c1    = "";    //----------++++++++++----------
input    double   l1    = 0.382;  //Уровень
input    string   d1    = "";    //Описание
input    string   c2    = "";    //----------++++++++++----------
input    double   l2    = 0.5;   //Уровень
input    string   d2    = "";    //Описание
input    string   c3    = "";    //----------++++++++++----------
input    double   l3    = 0.618;   //Уровень
input    string   d3    = "";    //Описание
input    string   c4    = "";    //----------++++++++++----------
input    double   l4    = 1.236;   //Уровень
input    string   d4    = "";    //Описание
input    string   c5    = "";    //----------++++++++++----------
input    double   l5    = 1.0;   //Уровень
input    string   d5    = "";    //Описание
input    string   c6    = "";    //----------++++++++++----------
input    double   l6    = 1.618;   //Уровень
input    string   d6    = "";    //Описание
input    string   c7    = "";    //----------++++++++++----------
input    double   l7    = 2.618;   //Уровень
input    string   d7    = "";    //Описание
input    string   c8    = "";    //----------++++++++++----------
input    double   l8    = 4.236;   //Уровень
input    string   d8    = "";    //Описание
input    string   c9    = "";    //----------++++++++++----------
input    double   l9    = 0.0;   //Уровень
input    string   d9    = "";    //Описание
input    string   c10    = "";    //----------++++++++++----------
input    double   l10   = 0.0;   //Уровень
input    string   d10   = "";    //Описание
input    string   c11   = "";    //----------++++++++++----------
input    double   l11   = 0.0;   //Уровень
input    string   d11   = "";    //Описание
input    string   c12   = "";    //----------++++++++++----------
input    double   l12   = 0.0;   //Уровень
input    string   d12   = "";    //Описание
input    string   c13   = "";    //----------++++++++++----------
input    double   l13   = 0.0;   //Уровень
input    string   d13   = "";    //Описание
input    string   c14   = "";    //----------++++++++++----------
input    double   l14   = 0.0;   //Уровень
input    string   d14   = "";    //Описание
input    string   c15   = "";    //----------++++++++++----------
input    double   l15   = 0.0;   //Уровень
input    string   d15   = "";    //Описание
input    string   c16   = "";    //----------++++++++++----------

         string   fiboName    = "FiboGrid";
         
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
   if(ObjectsTotal() > 0)for(int i = ObjectsTotal()-1; i>= 0; i--)
         if(StringFind(ObjectName(ChartID(), i),"FiboGrid") != -1)return(rates_total);
      
   double            lvls[];         
   string            dscrpt[];
      
   ArrayResize(lvls,  16);
   ArrayResize(dscrpt,16);
      
   for(int i = 0; i < 16; i++){
      switch (i){
         case 0:{
            lvls[i]  = l0;
            dscrpt[i]= d0==""?NormalizeDouble(l0*100,2)+" (%$)":d0;
            break;
         }
         case 1:{
            lvls[i]  = l1;
            dscrpt[i]= d1==""?NormalizeDouble(l1*100,2)+" (%$)":d1;
            break;
         }
         case 2:{
            lvls[i]  = l2;
            dscrpt[i]= d2==""?NormalizeDouble(l2*100,2)+" (%$)":d2;
            break;
         }
         case 3:{
            lvls[i]  = l3;
            dscrpt[i]= d3==""?NormalizeDouble(l3*100,2)+" (%$)":d3;
            break;
         }
         case 4:{
            lvls[i]  = l4;
            dscrpt[i]= d4==""?NormalizeDouble(l4*100,2)+" (%$)":d4;
            break;
         }
         case 5:{
            lvls[i]  = l5;
            dscrpt[i]= d5==""?NormalizeDouble(l5*100,2)+" (%$)":d5;
            break;
         }
         case 6:{
            lvls[i]  = l6;
            dscrpt[i]= d6==""?NormalizeDouble(l6*100,2)+" (%$)":d6;
            break;
         }
         case 7:{
            lvls[i]  = l7;
            dscrpt[i]= d7==""?NormalizeDouble(l7*100,2)+" (%$)":d7;
            break;
         }
         case 8:{
            lvls[i]  = l8;
            dscrpt[i]= d8==""?NormalizeDouble(l8*100,2)+" (%$)":d8;
            break;
         }
         case 9:{
            lvls[i]  = l9;
            dscrpt[i]= d9==""?NormalizeDouble(l9*100,2)+" (%$)":d9;
            break;
         }
         case 10:{
            lvls[i]  = l10;
            dscrpt[i]= d10==""?NormalizeDouble(l10*100,2)+" (%$)":d10;
            break;
         }
         case 11:{
            lvls[i]  = l11;
            dscrpt[i]= d11==""?NormalizeDouble(l11*100,2)+" (%$)":d11;
            break;
         }
         case 12:{
            lvls[i]  = l12;
            dscrpt[i]= d12==""?NormalizeDouble(l12*100,2)+" (%$)":d12;
            break;
         }
         case 13:{
            lvls[i]  = l13;
            dscrpt[i]= d13==""?NormalizeDouble(l13*100,2)+" (%$)":d13;
            break;
         }
         case 14:{
            lvls[i]  = l14;
            dscrpt[i]= d14==""?NormalizeDouble(l14*100,2)+" (%$)":d14;
            break;
         }
         case 15:{
            lvls[i]  = l15;
            dscrpt[i]= d15==""?NormalizeDouble(l15*100,2)+" (%$)":d15;
            break;
         }
      }
   }
   FiboLevelsCreate(0, fiboName);
   FiboLevelsSet(ArraySize(lvls), lvls, iColor, 1, iWidth, dscrpt, 0, fiboName);
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
                   color           clr,         // цвет линий уровня 
                   ENUM_LINE_STYLE stl,         // стиль линий уровня 
                   int             wdth,         // толщина линий уровня 
                   string          &descript[],       // описание уровня
                   const long      chart_ID=0,        // ID графика 
                   const string    name="FiboLevels") // имя объекта 
{ 
//--- проверим размеры массивов 
   if(levels!=ArraySize(values)) 
     { 
      Print(__FUNCTION__,": длина массива не соответствует количеству уровней, ошибка! ",ArraySize(values),"  ",levels); 
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
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,i,clr); 
      //--- стиль уровня 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELSTYLE,i,stl); 
      //--- толщина уровня 
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELWIDTH,i,wdth); 
      //--- описание уровня 
      ObjectSetString(chart_ID,name,OBJPROP_LEVELTEXT,i,descript[i]); 
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