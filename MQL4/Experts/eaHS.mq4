//+------------------------------------------------------------------+
//|                                                         eaHS.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int    magic = 123411111;
input double volume = 0.01;

string botName = WindowExpertName();
int mtp = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertComment(botName);
   trade.SetExpertMagic(magic);
   
   if(Digits() == 5 || Digits() == 3)mtp = 10;
   
   BorderCreate(0, "RECT", 0, 80, 95, 80, 100, clrSilver, 2, CORNER_RIGHT_LOWER, clrBlue);
   ButtonCreate(0, "BUY",  0, 75, 90, 70,  40,  CORNER_RIGHT_LOWER, "BUY",  "Arial", 10, clrYellow, clrGreen, clrBlack, false, false, false, true, 0);
   ButtonCreate(0, "SELL", 0, 75, 45, 70,  40,  CORNER_RIGHT_LOWER, "SELL", "Arial", 10, clrYellow, clrRed,   clrBlack, false, false, false, true, 0);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "RECT");
   ObjectDelete(0, "BUY");
   ObjectDelete(0, "SELL");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   ushort t = Total();
   static short n = 0;
   
   if(t == 0){
      if(ObjectGetInteger(ChartID(), "BUY", OBJPROP_STATE) == true){
         trade.Buy(Symbol(), AutoLot(), 0, 20);
         n = 1;
         ObjectSetInteger(ChartID(), "BUY", OBJPROP_STATE, false);
      }
      else if(ObjectGetInteger(ChartID(), "SELL", OBJPROP_STATE) == true){
         trade.Sell(Symbol(), AutoLot(), 0, 20);
         n = 1;
         ObjectSetInteger(ChartID(), "SELL", OBJPROP_STATE, false);
      }
   }
   else{
      double lmtp = 0.0;
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == OP_BUY){
               switch(n){
                  case 1:lmtp = 0.75;  break;
                  case 2:lmtp = 1;     break;
                  case 3:lmtp = 1.25;  break;
                  case 4:lmtp = 1.5;   break;
                  default: return;
               }
               if(Ask < NormalizeDouble(OrderOpenPrice()-50*mtp*Point(), Digits())){
                  if(trade.Buy(Symbol(), AutoLot(lmtp), 0, 40))n++;
               }
               return;
            }
            else if(OrderType() == OP_SELL){
               switch(n){
                  case 1:lmtp = 0.5;  break;
                  case 2:lmtp = 0.5;  break;
                  case 3:lmtp = 0.5;  break;
                  case 4:lmtp = 0.75; break;
                  case 5:lmtp = 1.0;  break;
                  case 6:lmtp = 1.25; break;
                  default: return;
               }
               if(Bid > NormalizeDouble(OrderOpenPrice()+45*mtp*Point(), Digits())){
                  if(trade.Sell(Symbol(), AutoLot(lmtp), 0, 40))n++;
               }
               return;
            }
         }
      }
   }   
}
//+------------------------------------------------------------------+

double AutoLot(double i = 1.0){
   double lot = MathAbs(volume*i);
   
   if(lot > MarketInfo(Symbol(), MODE_MAXLOT))
      lot = MarketInfo(Symbol(), MODE_MAXLOT);
   if(lot < MarketInfo(Symbol(), MODE_MINLOT))
      lot = MarketInfo(Symbol(), MODE_MINLOT);
   
   return lot;
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

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=5,                      // координата по оси X 
                  const int               y=80,                     // координата по оси Y 
                  const int               width=80,                 // ширина кнопки 
                  const int               height=25,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                  const string            text="Старт",             // текст 
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

bool BorderCreate(const long             chart_ID=0,               // ID графика 
                  const string           name="RectLabel",         // имя метки 
                  const int              sub_window=0,             // номер подокна 
                  const int              x=0,                      // координата по оси X 
                  const int              y=0,                      // координата по оси Y 
                  const int              width=50,                 // ширина 
                  const int              height=18,                // высота 
                  const color            back_clr=C'236,233,216',  // цвет фона 
                  const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы 
                  const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // угол графика для привязки 
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