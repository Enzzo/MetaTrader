//+------------------------------------------------------------------+
//|                                          eaSupportResistance.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int      magic  = 5544876;
input int      fntsz  = 10; //Размер шрифта
input double   volume = 0.01;
      string   pref   = "S/R";
      double   lot;
      double   lvl[3];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(pref);
   Comment("");
   lot = volume;
   ClearChart();
   RectLabelCreate(ChartID(), pref+"Pannel",      0, 206, 48, 206, 46, clrGray);
   ButtonCreate   (ChartID(), pref+"BuyPButton",  0, 204, 46, 80, 20, CORNER_RIGHT_LOWER, "BUY ОТЛ", "Arial", fntsz, clrBlack, clrTeal);
   ButtonCreate   (ChartID(), pref+"SellPButton", 0, 204, 24, 80, 20, CORNER_RIGHT_LOWER, "SELL ОТЛ", "Arial", fntsz, clrBlack, clrCrimson);
   ButtonCreate   (ChartID(), pref+"BuyMButton",   0, 123, 46, 80, 20, CORNER_RIGHT_LOWER, "BUY РЫН", "Arial", fntsz, clrBlack, clrGreen);
   ButtonCreate   (ChartID(), pref+"SellMButton",  0, 123, 24, 80, 20, CORNER_RIGHT_LOWER, "SELL РЫН", "Arial", fntsz, clrBlack, clrRed);   
   ButtonCreate   (ChartID(), pref+"CloseButton", 0, 42, 24, 40, 20, CORNER_RIGHT_LOWER, "CLS", "Arial", fntsz, clrBlack, clrYellow);
   EditCreate     (ChartID(), pref+"EditLot",     0, 42, 46, 40, 20, DoubleToString(lot, 2), "Arial", fntsz);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ClearChart();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(ObjectGetInteger(ChartID(), pref+"BuyPButton", OBJPROP_STATE)){
      lot = (double)StringToDouble(ObjectGetString(ChartID(), pref+"EditLot", OBJPROP_TEXT));
      TrySend(0);
      ObjectSetInteger(ChartID(), pref+"BuyPButton", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(ChartID(), pref+"SellPButton", OBJPROP_STATE)){
      lot = (double)StringToDouble(ObjectGetString(ChartID(), pref+"EditLot", OBJPROP_TEXT));
      TrySend(1);
      ObjectSetInteger(ChartID(), pref+"SellPButton", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(ChartID(), pref+"BuyMButton", OBJPROP_STATE)){
      lot = (double)StringToDouble(ObjectGetString(ChartID(), pref+"EditLot", OBJPROP_TEXT));
      trade.Buy(Symbol(), lot, 0, 0);
      ObjectSetInteger(ChartID(), pref+"BuyMButton", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(ChartID(), pref+"SellMButton", OBJPROP_STATE)){
      lot = (double)StringToDouble(ObjectGetString(ChartID(), pref+"EditLot", OBJPROP_TEXT));
      trade.Sell(Symbol(), lot, 0, 0);
      ObjectSetInteger(ChartID(), pref+"SellMButton", OBJPROP_STATE, false);
   }
   if(ObjectGetInteger(ChartID(), pref+"CloseButton", OBJPROP_STATE)){
      trade.CloseTrades();
      trade.DeletePendings();
      ObjectSetInteger(ChartID(), pref+"CloseButton", OBJPROP_STATE, false);
   }
}
//+------------------------------------------------------------------+

void TrySend(int d){
   ZeroMemory(lvl);
   int x = 0;
   
   //Находим три горизонтальных линии и присваиваем их цены в массив из трех элементов
   for(int i = ObjectsTotal()-1; i>=0; i--){
      if(ObjectType(ObjectName(ChartID(), i)) == OBJ_HLINE){
         if(x < 3)lvl[x] = NormalizeDouble(ObjectGetDouble(ChartID(), ObjectName(ChartID(), i), OBJPROP_PRICE), Digits());
         x++;
      }
   }
   
   //Если горизонтальных линий меньше или больше трех, то не выставляемся и пишем комментарий
   if(x != 3){
      Comment("Горизонтальных линий должно быть три.");
      return;
   }  
   
   if(lvl[0] == lvl[1] || lvl[0] == lvl[2] || lvl[1] == lvl[2]){
      Comment("Уровни не должны быть равны между собой");
      return;
   }  
   
   Comment(""); 
   
   
   //Сортировка. Нулевой - цена выше, последний - цена ниже
   double temp = 0.0;
   
   if(lvl[0] < lvl[1]){
      temp = lvl[0];
      lvl[0] = lvl[1];
      lvl[1] = temp;
   }
   
   if(lvl[0] < lvl[2]){
      temp = lvl[0];
      lvl[0] = lvl[2];
      lvl[2] = temp;
   }
   
   if(lvl[1] < lvl[2]){
      temp = lvl[1];
      lvl[1] = lvl[2];
      lvl[2] = temp;
   }
   
   
   if(d == 0){//Покупаем
      if(Ask > lvl[1])trade.BuyLimit(Symbol(), lot, lvl[1], lvl[2], lvl[0], 0);
      else if(Ask < lvl[1])trade.BuyStop(Symbol(), lot, lvl[1], lvl[2], lvl[0], 0);
      else trade.Buy(Symbol(), lot, lvl[2], lvl[0]);
   }
   else if(d == 1){//Продаём
      if(Bid > lvl[1])trade.SellStop(Symbol(), lot, lvl[1], lvl[0], lvl[2], 0);
      else if(Bid < lvl[1])trade.SellLimit(Symbol(), lot, lvl[1], lvl[0], lvl[2], 0);
      else trade.Sell(Symbol(), lot, lvl[0], lvl[2]);
   }
   
}

bool RectLabelCreate(const long             chart_ID=0,               // ID графика 
                     const string           name="RectLabel",         // имя метки 
                     const int              sub_window=0,             // номер подокна 
                     const int              x=0,                      // координата по оси X 
                     const int              y=0,                      // координата по оси Y 
                     const int              width=50,                 // ширина 
                     const int              height=18,                // высота 
                     const color            back_clr=C'236,233,216',  // цвет фона 
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы 
                     const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                     const color            clr=clrRed,               // цвет плоской границы (Flat) 
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы 
                     const int              line_width=1,             // толщина плоской границы 
                     const bool             back=false,               // на заднем плане 
                     const bool             selection=false,          // выделить для перемещений 
                     const bool             hidden=true,              // скрыт в списке объектов 
                     const long             z_order=0)                // приоритет на нажатие мышью 
{ 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим прямоугольную метку 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольную метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размеры метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим тип границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим цвет плоской рамки (в режиме Flat) 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии плоской рамки 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину плоской границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
}  

bool EditCreate(const long             chart_ID=0,               // ID графика 
                const string           name="Edit",              // имя объекта 
                const int              sub_window=0,             // номер подокна 
                const int              x=0,                      // координата по оси X 
                const int              y=0,                      // координата по оси Y 
                const int              width=50,                 // ширина 
                const int              height=18,                // высота 
                const string           text="Text",              // текст 
                const string           font="Arial",             // шрифт 
                const int              font_size=10,             // размер шрифта 
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // способ выравнивания 
                const bool             read_only=false,          // возможность редактировать 
                const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                const color            clr=clrBlack,             // цвет текста 
                const color            back_clr=clrWhite,        // цвет фона 
                const color            border_clr=clrNONE,       // цвет границы 
                const bool             back=false,               // на заднем плане 
                const bool             selection=false,          // выделить для перемещений 
                const bool             hidden=true,              // скрыт в списке объектов 
                const long             z_order=0)                // приоритет на нажатие мышью 
{ 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим поле ввода 
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать объект \"Поле ввода\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты объекта 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размеры объекта 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим способ выравнивания текста в объекте 
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align); 
//--- установим (true) или отменим (false) режим только для чтения 
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only); 
//--- установим угол графика, относительно которого будут определяться координаты объекта 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим цвет текста 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим цвет границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
}

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=0,                      // координата по оси X 
                  const int               y=0,                      // координата по оси Y 
                  const int               width=50,                 // ширина кнопки 
                  const int               height=18,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                  const string            text="Button",            // текст 
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

void ClearChart(){
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), pref)!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
}