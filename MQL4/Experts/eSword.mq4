//+------------------------------------------------------------------+
//|                                                       eSword.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

input int   magic  = 9876111;    //Магик
input bool  bSword = true;       //Шпага
input int   offset = 2;          //Расхождение (%)
input int   wdth   = 1;          //Ширина
input color sClr   = clrGreen;   //Цвет шпаги
input bool  bWeak  = true;       //Истощение

//MqlRates m1[];
MqlRates m5[];
MqlRates m15[];
MqlRates m30[];
MqlRates h1[];
MqlRates h4[];
MqlRates d1[];
MqlRates w1[];
MqlRates mn[];

datetime m1_time;
datetime m5_time;
datetime m15_time;
datetime m30_time;
datetime h1_time;
datetime h4_time;
datetime d1_time;
datetime w1_time;
datetime mn_time;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   RefreshRates();
   //CopyRates(Symbol(), PERIOD_M1,  1, 1, m1);
   CopyRates(Symbol(), PERIOD_M15, 1, 4, m5);   
   CopyRates(Symbol(), PERIOD_M15, 1, 4, m15);
   CopyRates(Symbol(), PERIOD_M30, 1, 4, m30);
   CopyRates(Symbol(), PERIOD_H1,  1, 4, h1);
   CopyRates(Symbol(), PERIOD_H4,  1, 4, h4);
   CopyRates(Symbol(), PERIOD_D1,  1, 4, d1);
   CopyRates(Symbol(), PERIOD_W1,  1, 4, w1);
   CopyRates(Symbol(), PERIOD_MN1, 1, 4, mn);
   
   ArraySetAsSeries(m5, true);
   ArraySetAsSeries(m15, true);
   ArraySetAsSeries(m30, true);
   ArraySetAsSeries(h1, true);
   ArraySetAsSeries(h4, true);
   ArraySetAsSeries(d1, true);
   ArraySetAsSeries(w1, true);
   ArraySetAsSeries(mn, true);
   
   //if(ArraySize(m1)<1 || ArraySize(m15)<1 || */ArraySize(m30)<4 || ArraySize(h1)<4 || ArraySize(h4)<4 || ArraySize(d1)<4 || ArraySize(w1)<4 || ArraySize(mn)<4) return;
   
   /*if(m1_time != m1[0].time){
      CheckSword(m1,"M1");
      m1_time = m1[0].time;
   }*/
   if(m5_time != m5[0].time && ArraySize(m5)==4){
      CheckWeak(m5,"M5");
      m5_time = m5[0].time;
   }
   if(m15_time != m15[0].time && ArraySize(m15)==4){
      CheckWeak(m15,"M15");
      m15_time = m15[0].time;
   }
   if(m30_time != m30[0].time && ArraySize(m30)==4){
      CheckSword(m30,"M30");
      CheckWeak (m30,"M30");
      m30_time = m30[0].time;
   }
   if(h1_time  != h1[0].time  && ArraySize(h1)==4){
      CheckSword(h1,"H1");
      CheckWeak (h1,"H1");
      h1_time = h1[0].time;
   }
   if(h4_time  != h4[0].time  && ArraySize(h4)==4){
      CheckSword(h4,"H4");
      CheckWeak (h4,"H4");
      h4_time = h4[0].time;
   }
   if(d1_time  != d1[0].time  && ArraySize(d1)==4){
      CheckSword(d1,"D1");
      CheckWeak (d1,"D1");
      d1_time = d1[0].time;
   }
   if(w1_time  != w1[0].time  && ArraySize(w1)==4){
      CheckSword(w1,"W1");
      CheckWeak (w1,"W1");
      w1_time = w1[0].time;
   }
   if(mn_time  != mn[0].time  && ArraySize(mn)==4){
      CheckSword(mn,"MN");
      CheckWeak (mn,"MN");
      mn_time = mn[0].time;
   }
}
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
//---
   for(int i = ObjectsTotal()-1; i>=0; i--){
      if(StringFind(ObjectName(0, i), "sword")!= -1 || StringFind(ObjectName(0, i), "rect")!= -1)
         ObjectDelete(0, ObjectName(0, i));
   }
}

void CheckSword(MqlRates &tf[], string period){   
   if(!bSword)return;
   double offs = NormalizeDouble((tf[0].high - tf[0].low)/100*offset, Digits());
   if(MathAbs(tf[0].open - tf[0].close) <= offs)
      ArrowCheckCreate(period, 0, "sword", 0, tf[0].time, tf[0].high, 1, sClr, 0, wdth);
}

void CheckWeak(MqlRates &tf[], string period){
   if(!bWeak)return;
   //bear
   if(tf[3].open < tf[3].close && 
      tf[2].open > tf[2].close &&
      tf[1].open < tf[1].close && 
      tf[0].open > tf[0].close &&
      tf[1].close > tf[2].high && tf[1].close > tf[3].high &&
      tf[0].open  > tf[2].high && tf[0].open  > tf[3].high &&
      tf[0].close < tf[2].close && tf[0].close < tf[3].open)
      RectangleCreate(period, "SELL", 0, "rect", 0, tf[3].time, tf[3].high, tf[0].time, tf[0].low, clrRed);
   
   //bull
   if(tf[3].open > tf[3].close && 
      tf[2].open < tf[2].close &&
      tf[1].open > tf[1].close && 
      tf[0].open < tf[0].close &&
      tf[1].close < tf[2].low && tf[1].close < tf[3].low &&
      tf[0].open  < tf[2].low && tf[0].open  < tf[3].low &&
      tf[0].close > tf[2].close && tf[0].close > tf[3].open)
      RectangleCreate(period, "BUY", 0, "rect", 0, tf[3].time, tf[3].high, tf[0].time, tf[0].low, clrGreen);
}

bool ArrowCheckCreate(string                  p = "",
                      const long              chart_ID=0,           // ID графика 
                      const string            _name="sword",        // имя знака 
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
         if(StringFind(ObjectName(0, i), DoubleToString(NormalizeDouble(time, Digits())))!= -1 &&
            StringFind(ObjectName(0, i), _name)!= -1)
            return false;
      }
   }
   
   Alert(Symbol()+": шпага на "+p);
   
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
  
bool RectangleCreate(string                p = "",
                     string                t = "",            // тип паттерна (бай/селл)
                     const long            chart_ID=0,        // ID графика 
                     const string          _name="Rectangle", // имя прямоугольника 
                     const int             sub_window=0,      // номер подокна  
                     datetime              time1=0,           // время первой точки 
                     double                price1=0,          // цена первой точки 
                     datetime              time2=0,           // время второй точки 
                     double                price2=0,          // цена второй точки 
                     const color           _clr=clrRed,       // цвет прямоугольника 
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линий прямоугольника 
                     const int             width=1,           // толщина линий прямоугольника 
                     const bool            fill=true,         // заливка прямоугольника цветом 
                     const bool            back=true,         // на заднем плане 
                     const bool            selection=false,   // выделить для перемещений 
                     const bool            hidden=true,       // скрыт в списке объектов 
                     const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точек привязки, если они не заданы 
//--- сбросим значение ошибки 
   if(ObjectsTotal() != 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(0, i), DoubleToString(NormalizeDouble(time1, Digits())))!= -1 &&
            StringFind(ObjectName(0, i), _name)!= -1)
            return false;
      }
   }
   Alert(Symbol()+": пробой истощения на "+p+" "+t);
   
   static int n = 0;
   string name = _name + (n<10? "_0":"_") + IntegerToString(n)+"_"+DoubleToString(NormalizeDouble(time1, Digits()));
   ResetLastError(); 
//--- создадим прямоугольник по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольник! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,_clr); 
//--- установим стиль линий прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линий прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим выделения прямоугольника для перемещений 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 
