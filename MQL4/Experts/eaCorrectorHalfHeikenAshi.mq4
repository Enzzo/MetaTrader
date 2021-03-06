//+------------------------------------------------------------------+
//|                                    eaCorrectorHalfHeikenAshi.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "DESCRIPTION!!!"
#property link      "http://vk.com/id29520847"
#property version   "1.00"

#property strict
#include <Trade.mqh>

CTrade trade;

enum slType{
   mnl,        //0. manual (tral - disabled)
   ha,         //1. heiken ashi
   fxd,        //2. fixed pips   
   mxd         //3. not less than...
};

input int    magic      = 11126748;
input double volume     = 0.01;
input ushort dpc        = 60;       //Dest. prev order
input slType slt        = 1;        //SL type
input int    fsl        = 50;       //2. SL (p)
input int    minsl      = 30;       //3. Not less than (p)
input bool   useMarkers  = true;     //Use Markers
input color  clBuy       = clrBlue;
input color  clSell      = clrRed;

int mtp = 1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   trade.SetExpertComment("Heiken Ashi + TMS");
   if(Digits() == 5 || Digits() == 3)mtp = 10;
   ObjectDelete(ChartID(), "LimBTN");
   ObjectDelete(ChartID(), "ClrBTN");
   ObjectDelete(ChartID(), "MktBTN");
   ButtonCreate(ChartID(), "MktBTN", 0, 52, 60, 50, 18, CORNER_RIGHT_LOWER, "MKT", "Arial", 10, clrBlack, clrYellowGreen, clrYellow);
   ButtonCreate(ChartID(), "LimBTN", 0, 52, 40, 50, 18, CORNER_RIGHT_LOWER, "LMT", "Arial", 10, clrBlack, clrGreen, clrYellow);
   ButtonCreate(ChartID(), "ClrBTN", 0, 52, 20, 50, 18, CORNER_RIGHT_LOWER, "Close", "Arial", 10, clrBlack, clrRed, clrYellow);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(ChartID(), "LimBTN");
   ObjectDelete(ChartID(), "ClrBTN");
   ObjectDelete(ChartID(), "MktBTN");
   
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Arrow")!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   double h0 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 0, 0), Digits());
   double h1 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 1, 0), Digits());
   double h2 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 2, 0), Digits());  //open
   double h3 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 3, 0), Digits());  //close
   double sl = 0.0;//NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 0, 1), Digits());
   
   double avprc = 0.0;
   if(h0 < h1){
      avprc = NormalizeDouble(h1 - (h1 - h0)/2, Digits());
   }
   else if(h0 > h1){
      avprc = NormalizeDouble(h0 - (h0 - h1)/2, Digits());      
   }
   if(ObjectGetInteger(ChartID(), "LimBTN", OBJPROP_STATE)){
      if(h0 < h1){
         if(Bid > avprc){
            sl = NormalizeDouble(SL(0, avprc), Digits());
            trade.BuyLimit(Symbol(), volume, NormalizeDouble(avprc, Digits()), sl, sl == 0.0?0.0:NormalizeDouble(avprc + (avprc - sl)*3, Digits()));
         }
         else {
            sl = NormalizeDouble(SL(0, Ask), Digits());
            trade.Buy(Symbol(), volume, sl,sl == 0.0?0.0:NormalizeDouble(avprc + (avprc - sl)*3, Digits()));
         }
      }
      else if(h0 > h1){
         if(Ask < avprc){
            sl = NormalizeDouble(SL(1, avprc), Digits());
            trade.SellLimit(Symbol(), volume, NormalizeDouble(avprc, Digits()), sl, sl == 0.0?0.0:NormalizeDouble(avprc - (sl - avprc)*3, Digits()));
         }
         else {
            sl = NormalizeDouble(SL(1, Bid), Digits());
            trade.Sell(Symbol(), volume, sl, sl == 0.0?0.0:NormalizeDouble(avprc - (sl - avprc)*3, Digits()));
         }
      }
      ObjectSetInteger(ChartID(), "LimBTN", OBJPROP_STATE, false);
   }
   
   if(ObjectGetInteger(ChartID(), "MktBTN", OBJPROP_STATE)){
      if(h0 < h1){
         sl = NormalizeDouble(SL(0, Ask), Digits());
         trade.Buy(Symbol(), volume, sl, sl == 0.0?0.0:NormalizeDouble(Ask + (Ask - sl)*3, Digits()));
      }
      else if(h0 > h1){
         sl = NormalizeDouble(SL(1, Bid), Digits());
         trade.Sell(Symbol(), volume, sl, sl == 0.0?0.0:NormalizeDouble(Bid - (sl - Bid)*3, Digits()));
      }
      ObjectSetInteger(ChartID(), "MktBTN", OBJPROP_STATE, false);
   }
   
   if(ObjectGetInteger(ChartID(), "ClrBTN", OBJPROP_STATE)){
      trade.DeletePendings();
      trade.CloseTrades();
      ObjectSetInteger(ChartID(), "ClrBTN", OBJPROP_STATE, false);
   }
   
   if(OrdersTotal() > 0){
      
      int type = -1;
      int ticket = 0;
      double op = 0.0;
      double stl = 0.0;
      double tkp = 0.0;
      
      for(int i = OrdersTotal() - 1; i>= 0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && avprc != 0.0){
            
            type   = OrderType();
            ticket = OrderTicket();
            op     = NormalizeDouble(OrderOpenPrice(), Digits());
            stl    = NormalizeDouble(OrderStopLoss(), Digits());
            tkp    = NormalizeDouble(OrderTakeProfit(), Digits());
            
            sl     = NormalizeDouble(SL(0, avprc), Digits());
            if(type == OP_BUYLIMIT && avprc > op && Bid > avprc)
               x   = OrderModify(ticket, NormalizeDouble(avprc, Digits()), sl==0.0?OrderStopLoss():sl, sl == 0.0?OrderTakeProfit():NormalizeDouble(avprc + (avprc - sl)*2, Digits()), 0);
            sl     = NormalizeDouble(SL(1, avprc), Digits());
            if(type == OP_SELLLIMIT && avprc < op && Ask < avprc)
               x   = OrderModify(ticket, NormalizeDouble(avprc, Digits()), sl==0.0?OrderStopLoss():sl, sl == 0.0?OrderTakeProfit():NormalizeDouble(avprc - (sl - avprc)*2, Digits()), 0);
            sl     = NormalizeDouble(SL(0, Ask), Digits());
            if(type == OP_BUY && stl < sl && Bid > sl)               
               x   = OrderModify(ticket, op, sl==0.0?OrderStopLoss():sl, sl==0.0?OrderTakeProfit():tkp, 0);
            sl     = NormalizeDouble(SL(1, Bid), Digits());
            if(type == OP_SELL && stl > sl && Ask < sl)               
               x = OrderModify(ticket, op, sl==0.0?OrderStopLoss():sl, sl==0.0?OrderTakeProfit():tkp, 0);
         }
         if(useMarkers == true && OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)){
            MqlRates rates[];
            CopyRates(Symbol(), PERIOD_CURRENT, OrderOpenTime(), 1, rates);
            
            if(!FindObject(OrderTicket())){
               
               ArrowCreate(ChartID(), "Arrow_"+(string)OrderTicket(), 0, OrderOpenTime(),OrderType() == OP_BUY?rates[0].low:rates[0].high,OrderType() == OP_BUY?OBJ_ARROW_UP:OBJ_ARROW_DOWN, OrderType()==OP_BUY?ANCHOR_TOP:ANCHOR_BOTTOM, OrderType() == OP_BUY?clBuy:clSell);
            }
         }
      }
   }
   if(OrdersHistoryTotal()>0 && useMarkers == true){
      for(int i = OrdersHistoryTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)){
            MqlRates rates[];
            CopyRates(Symbol(), PERIOD_CURRENT, OrderOpenTime(), 1, rates);
            if(!FindObject(OrderTicket())){
               ArrowCreate(ChartID(), "Arrow_"+(string)OrderTicket(), 0, OrderOpenTime(),OrderType() == OP_BUY?rates[0].low:rates[0].high,OrderType() == OP_BUY?OBJ_ARROW_UP:OBJ_ARROW_DOWN, OrderType() == OP_BUY?ANCHOR_TOP:ANCHOR_BOTTOM, OrderType() == OP_BUY?clBuy:clSell);
            }
         }
      }
   }
}
//+------------------------------------------------------------------+

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=0,                      // координата по оси X 
                  const int               y=0,                      // координата по оси Y 
                  const int               width=50,                 // ширина кнопки 
                  const int               height=18,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
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

bool ArrowCreate(const long              chart_ID=0,           // ID графика 
                   const string            name="ArrowUp",       // имя знака 
                   const int               sub_window=0,         // номер подокна 
                   datetime                time=0,               // время точки привязки 
                   double                  price=0,              // цена точки привязки 
                   const ENUM_OBJECT       arrowDir=OBJ_ARROW_UP,// направление стрелки
                   const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // способ привязки 
                   const color             clr=clrRed,           // цвет знака 
                   const ENUM_LINE_STYLE   style=STYLE_SOLID,    // стиль окаймляющей линии 
                   const int               width=2,              // размер знака 
                   const bool              back=false,           // на заднем плане 
                   const bool              selection=false,      // выделить для перемещений 
                   const bool              hidden=true,          // скрыт в списке объектов 
                   const long              z_order=0)            // приоритет на нажатие мышью 
  { 
//--- установим координаты точки привязки, если они не заданы 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим знак 
   if(!ObjectCreate(chart_ID,name,arrowDir,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать знак \"Стрелка вверх\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим способ привязки 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- установим цвет знака 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
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
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 


bool FindObject(int tkt){
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>= 0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Arrow_"+(string)tkt)!=-1)return true;
      }
   }
   return false;
}

double SL(ushort i, double prc){
   double _sl = 0.0;
   double _h0 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 0, 1), Digits());
   double _h1 = NormalizeDouble(iCustom(Symbol(), PERIOD_CURRENT, "Synergy_APB", 1, 1), Digits());
   
   switch(slt){
      
      case 0: _sl = 0.0; break;
      
      case 1:
         _sl = _h0;
         if(i == 0 && _sl > _h1)
            _sl = _h1;
         if(i == 1 && _sl < _h1)
            _sl = _h1;
      break;
      
      case 2:
         if(i == 0)
            _sl = NormalizeDouble(prc - fsl*Point()*mtp, Digits());
         else if(i == 1)
            _sl = NormalizeDouble(prc + fsl*Point()*mtp, Digits());
      break;
            
      case 3:
         if(i == 0){
            _sl = NormalizeDouble(prc - minsl*Point()*mtp, Digits());
            if(_h0 < _sl)
               _sl = _h0;
            if(_h1 < _sl)
               _sl = _h1;
         }
         else if(i == 1){
            _sl = NormalizeDouble(prc + minsl*Point()*mtp, Digits());
            if(_h0 > _sl)
               _sl = _h0;
            if(_h1 > _sl)
               _sl = _h1;
         }
      break;
   }
   return _sl;
}