//+------------------------------------------------------------------+
//|                                                     eaFF2013.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

enum modes{
   rsi,  //RSI
   ema,  //EMA
   cci,  //CCI
   pt    //Price Target
};
enum dirs{
   buy,  //LONG
   sell, //SHORT
   both  //BOTH
};

input    string   c00      = "";
input    modes    mode     = 3;     //mode

input    string   c01      = "";
input    int      RSI      = 14;    //RSI period
input    int      EMA      = 14;    //EMA period
input    int      CCI      = 14;    //CCI period
input    double   target   = 0.0;   //Price Target
input    dirs     dir      = 2;     //dir(s)(USELESS FOR A WHILE!!!)
input    string   c02      = "";    
input    double   lot01    = 0.01;  //lot 01
input    double   lot02    = 0.01;  //lot 02
input    double   lot03    = 0.02;  //lot 03
input    double   lot04    = 0.02;  //lot 04
input    double   lot05    = 0.03;  //lot 05
input    double   lot06    = 0.03;  //lot 06
input    double   lot07    = 0.04;  //lot 07
input    double   lot08    = 0.05;  //lot 08
input    double   lot09    = 0.06;  //lot 09
input    double   lot10    = 0.07;  //lot 10
input    double   lot11    = 0.08;  //lot 11
input    double   lot12    = 0.09;  //lot 12
input    double   lot13    = 0.10;  //lot 13
input    string   c03      = "";
input    int      tp       = 20;    //TakeProfit
input    int      sl       = 10;    //StopLoss
input    string   c04      = "";
input    int      magic    = 111;   //Magic number
input    string   comment  = "";    //Comment

int mtp = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertComment(WindowExpertName()+comment);
   trade.SetExpertMagic(magic);
   /*
   BorderCreate(0, "RECT",  0, 165, 60, 165, 100, clrSilver, 2, CORNER_RIGHT_LOWER, clrBlue);
   ButtonCreate(0, "RSI",   0, 160, 50, 35,  20,  CORNER_RIGHT_LOWER, "RSI", "Arial", 10, mode == rsi?clrYellow:clrBlack, mode == rsi?clrGreen:clrWhite, mode == rsi?clrGreen:clrBlack, mode == rsi?false:true, false, false, true, 0);
   ButtonCreate(0, "EMA",   0, 120, 50, 35,  20,  CORNER_RIGHT_LOWER, "EMA", "Arial", 10, mode == ema?clrYellow:clrBlack, mode == ema?clrGreen:clrWhite, mode == ema?clrGreen:clrBlack, mode == ema?false:true, false, false, true, 0);
   ButtonCreate(0, "CCI",   0, 80,  50, 35,  20,  CORNER_RIGHT_LOWER, "CCI", "Arial", 10, mode == cci?clrYellow:clrBlack, mode == cci?clrGreen:clrWhite, mode == cci?clrGreen:clrBlack, mode == cci?false:true, false, false, true, 0);
   ButtonCreate(0, "PT",    0, 40,  50, 35,  20,  CORNER_RIGHT_LOWER, "PT",  "Arial", 10, mode == pt?clrYellow:clrBlack,  mode == pt?clrGreen:clrWhite,  mode == pt?clrGreen:clrBlack, mode == pt?false:true, false, false, true, 0);
   ButtonCreate(0, "TRADE", 0, 160, 25, 155, 20,  CORNER_RIGHT_LOWER, "TRADE",  "Arial", 10, clrBlack, clrWhite, clrBlack, true, false, false, true, 0);
   */
   BorderCreate(0, "RECT",  0, 165, 60, 165, 100, clrSilver, 2, CORNER_RIGHT_LOWER, clrBlue);
   ButtonCreate(0, "RSI",   0, 160, 50, 35,  20,  CORNER_RIGHT_LOWER, "RSI", "Arial", 10, mode == rsi?clrYellow:clrBlack, mode == rsi?clrGreen:clrWhite, mode == rsi?clrGreen:clrBlack, mode == rsi?true:false, false, false, true, 0);
   ButtonCreate(0, "EMA",   0, 120, 50, 35,  20,  CORNER_RIGHT_LOWER, "EMA", "Arial", 10, mode == ema?clrYellow:clrBlack, mode == ema?clrGreen:clrWhite, mode == ema?clrGreen:clrBlack, mode == ema?true:false, false, false, true, 0);
   ButtonCreate(0, "CCI",   0, 80,  50, 35,  20,  CORNER_RIGHT_LOWER, "CCI", "Arial", 10, mode == cci?clrYellow:clrBlack, mode == cci?clrGreen:clrWhite, mode == cci?clrGreen:clrBlack, mode == cci?true:false, false, false, true, 0);
   ButtonCreate(0, "PT",    0, 40,  50, 35,  20,  CORNER_RIGHT_LOWER, "PT",  "Arial", 10, mode == pt?clrYellow:clrBlack,  mode == pt?clrGreen:clrWhite,  mode == pt?clrGreen:clrBlack,  mode == pt?true:false, false, false, true, 0);
   ButtonCreate(0, "TRADE", 0, 160, 25, 155, 20,  CORNER_RIGHT_LOWER, "DISABLED",  "Arial", 10, clrYellow, clrRed, clrBlack, false, false, false, true, 0);
   if(Digits() == 5 || Digits() == 3)mtp = 10;
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "RSI");
   ObjectDelete(0, "EMA");
   ObjectDelete(0, "CCI");
   ObjectDelete(0, "PT");
   ObjectDelete(0, "RECT");
   ObjectDelete(0, "TRADE");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   CheckStateButtons();
   static ushort l = 0;
   ushort t = Total();
   
   switch (t){
   case 0:  
            if(ObjectGetInteger(ChartID(), "TRADE", OBJPROP_STATE) || (!IsVisualMode() && IsTesting())){
               Start();
               l = 2;
            }
            break;
   case 1:
            //if (l > 13)return;
            for(int i = OrdersTotal()-1; i>=0; i--){
               bool x = OrderSelect(i, SELECT_BY_POS);
               if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
                  if(OrderType() == OP_BUY){
                     if(OrderStopLoss() == 0.0 || OrderTakeProfit() == 0.0)x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()-sl*mtp*Point(), Digits()), NormalizeDouble(OrderOpenPrice()+tp*mtp*Point(), Digits()), 0);               
                     if(l<=13){
                        trade.SellStop(Symbol(), Lot(l), NormalizeDouble(OrderOpenPrice()-sl*mtp*Point(), Digits()),0);
                        l++;
                     }
                     return;
                  }
                  if(OrderType() == OP_SELL){
                     if(OrderStopLoss() == 0.0 || OrderTakeProfit() == 0.0)x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()+sl*mtp*Point(), Digits()), NormalizeDouble(OrderOpenPrice()-tp*mtp*Point(), Digits()), 0);               
                     if(l<=13)
                        {trade.BuyStop(Symbol(), Lot(l), NormalizeDouble(OrderOpenPrice()+sl*mtp*Point(), Digits()), 0);
                        l++;
                     }
                     return;
                  }
                  if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
                     if(OrdersHistoryTotal() > 0){
                        for(int j = OrdersHistoryTotal()-1; j>=0; j--){
                           x = OrderSelect(j, SELECT_BY_POS, MODE_HISTORY);
                           if((OrderType() == OP_BUY || OrderType() == OP_SELL) && OrderProfit()>0.0 && l > 2){
                              trade.DeletePendings();
                              ObjectSetInteger(ChartID(), "TRADE", OBJPROP_STATE, false);
                              return;
                           }
                        }
                     }
                     return;
                  }
                  return;
               }         
            }
   }
   if(t != 0){ //Corrector
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderStopLoss() == 0.0 || OrderTakeProfit() == 0.0){
               if(OrderType() == OP_BUY){
                  x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()-sl*mtp*Point(), Digits()), NormalizeDouble(OrderOpenPrice()+tp*mtp*Point(), Digits()), 0);  
                  return;
               }
               if(OrderType() == OP_SELL){
                  x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()+sl*mtp*Point(), Digits()), NormalizeDouble(OrderOpenPrice()-tp*mtp*Point(), Digits()), 0); 
                  return;
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+

void Start(){
   int i = -1;
   if(ObjectGetInteger(ChartID(), "RSI",OBJPROP_STATE)) i = 0;
   else if(ObjectGetInteger(ChartID(), "EMA",OBJPROP_STATE)) i = 1;
   else if(ObjectGetInteger(ChartID(), "CCI",OBJPROP_STATE)) i = 2;
   else if(ObjectGetInteger(ChartID(), "PT",OBJPROP_STATE))  i = 3;
   switch (i){
      case 0:  //RSI
               
               if(iRSI(Symbol(), PERIOD_CURRENT, RSI, PRICE_CLOSE, 1)>70)trade.Buy(Symbol(), lot01, sl, tp);
               else if(iRSI(Symbol(), PERIOD_CURRENT, RSI, PRICE_CLOSE, 1)<30)trade.Sell(Symbol(), lot01, sl, tp);
               break;
      case 1:  //EMA
               
               if(iMA(Symbol(), PERIOD_CURRENT, EMA, 0, MODE_EMA, PRICE_CLOSE, 1)<Low[1])trade.Buy(Symbol(), lot01, sl, tp);
               else if(iMA(Symbol(), PERIOD_CURRENT, EMA, 0, MODE_EMA, PRICE_CLOSE, 1)>High[1])trade.Sell(Symbol(), lot01, sl, tp);
               break;
      case 2:  //CCI
               
               if(iCCI(Symbol(), PERIOD_CURRENT, CCI, PRICE_CLOSE, 1)>100)trade.Buy(Symbol(), lot01, sl, tp);
               else if(iCCI(Symbol(), PERIOD_CURRENT, CCI, PRICE_CLOSE, 1)<-100)trade.Sell(Symbol(), lot01, sl, tp);
               break;
      case 3:  //PT);
               
               if(target > Ask){
                  trade.BuyStop(Symbol(), lot01, NormalizeDouble(target, Digits()), 0, 0);
               }
               else if(target < Bid && target != 0.0){
                  trade.SellStop(Symbol(), lot01, NormalizeDouble(target, Digits()), 0, 0);
               }
               else Comment("PriceTarget-based trading\nPlease enter correct price target parameter.\nCurrent parameter is "+DoubleToString(NormalizeDouble(target, Digits())));
               break;
   }
  
}

void CheckStateButtons(){
   
   if(ObjectGetInteger(ChartID(), "TRADE",OBJPROP_STATE)){
      ObjectSetString(ChartID(),  "TRADE", OBJPROP_TEXT, "ENABLED");
      ObjectSetInteger(ChartID(), "TRADE", OBJPROP_BGCOLOR, clrGreen);
   }
   else{
      ObjectSetString(ChartID(), "TRADE", OBJPROP_TEXT, "DISABLED");
      ObjectSetInteger(ChartID(), "TRADE", OBJPROP_BGCOLOR, clrRed);
   }
   
   if(ObjectGetInteger(ChartID(), "RSI",OBJPROP_STATE)){
      Comment("RSI-based trading");
      ObjectSetInteger(ChartID(), "RSI", OBJPROP_BGCOLOR, clrGreen);
      ObjectSetInteger(ChartID(), "RSI", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(ChartID(), "EMA", OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "EMA", OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "EMA", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "CCI", OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "CCI", OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "CCI", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "PT",  OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "PT",  OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "PT",  OBJPROP_COLOR, clrBlack);
   }
   if(ObjectGetInteger(ChartID(), "EMA",OBJPROP_STATE)){
      Comment("EMA-based trading");
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_BGCOLOR, clrGreen);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_COLOR, clrBlack);
   }
   if(ObjectGetInteger(ChartID(), "CCI",OBJPROP_STATE)){
      Comment("CCI-based trading");
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_BGCOLOR, clrGreen);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_COLOR, clrBlack);
   }
   if(ObjectGetInteger(ChartID(), "PT", OBJPROP_STATE)){
      Comment("PriceTarget-based trading\nCurrent target is "+DoubleToString(NormalizeDouble(target, Digits())));
      ObjectSetInteger(ChartID(), "PT", OBJPROP_BGCOLOR, clrGreen);
      ObjectSetInteger(ChartID(), "PT", OBJPROP_COLOR, clrYellow);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "EMA",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "CCI",OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_STATE, false);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_BGCOLOR, clrWhite);
      ObjectSetInteger(ChartID(), "RSI",OBJPROP_COLOR, clrBlack);
   }
}

double Lot(ushort i = 0){
   switch (i){
      case 2:  return lot02;
      case 3:  return lot03;
      case 4:  return lot04;
      case 5:  return lot05;
      case 6:  return lot06;
      case 7:  return lot07;
      case 8:  return lot08;
      case 9:  return lot09;
      case 10: return lot10;
      case 11: return lot11;
      case 12: return lot12;
      case 13: return lot13;
      default: return lot13;
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