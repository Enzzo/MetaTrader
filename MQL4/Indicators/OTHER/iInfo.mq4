//+------------------------------------------------------------------+
//|                                                        iInfo.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window

int mtp = 1;

enum language{
   rus,     //Русский
   eng,     //English
};

input language lng         = 0;//Language
input int      sz          = 8;//Font size
input bool     dDeals      = true;//Draw deals on chart
input color    clDealLvl   = clrWhite;
input color    clBuyTrack  = clrBlue;
input color    clSellTrack = clrRed;

string pstns;
string vl;
string ls;
string prf;
string rsk;
string maxr;
string minr;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   
   
   switch (lng){
      case 0:   
         pstns = "Всего сделок";
         vl    = "Общий объем";
         ls    = "Потенциальный убыток";
         prf   = "Потенциальная прибыль";
         rsk   = "Риск";
         maxr  = "Макс. риск";
         minr  = "Мин. риск";
         break;
      case 1:
         pstns = "Positions";
         vl    = "Total volume";
         ls    = "Potential loss";
         prf   = "Potential profit";
         rsk   = "Risk";
         maxr  = "Max risk";
         minr  = "Min risk";
         break;
   }

   ChartRedraw();
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Info")!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
   if(Digits() == 5 || Digits() == 3)mtp = 1;
   DrawTable();
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
   UpdateTable();
   if(dDeals)if(OrdersHistoryTotal()>0){
               static int total = 0;
                 if(total != OrdersHistoryTotal()){
                    DrawDeals();      
                      total = OrdersHistoryTotal();
                 }
             }
   return(rates_total);
}
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
//---
   ChartRedraw();
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Info")!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
}

void DrawDeals(){
   for(int i = OrdersHistoryTotal()-1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)){
         if(!FindObject(OrderTicket())){
            static int n = 0;
            TrendCreate(ChartID(), "HDOrder_Info_"+(string)OrderTicket()+"_"+(string)n,  0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), OrderType() == 0?clBuyTrack:clSellTrack, 1, 2);//t == 0?clrBlue:clrRed);
            TrendCreate(ChartID(), "HDCenter_Info_"+(string)OrderTicket()+"_"+(string)n,  0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderOpenPrice(), clDealLvl, 1, 2);
            if(OrderTakeProfit() != 0){
               TrendCreate(ChartID(), "HDProfit_Info_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderTakeProfit(), OrderCloseTime(), OrderTakeProfit(), clrRed, 1, 2);
               TrendCreate(ChartID(), "HDSUPP_Info_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderOpenPrice(), OrderOpenTime(), OrderTakeProfit(), clrRed, 1, 1);
            }
            if(OrderStopLoss() != 0){
               TrendCreate(ChartID(), "HDLoss_Info_"+(string)OrderTicket()+"_"+(string)n,   0, OrderOpenTime(), OrderStopLoss(), OrderCloseTime(), OrderStopLoss(), clrRed, 1, 2);
               TrendCreate(ChartID(), "HDSUPL_Info_"+(string)OrderTicket()+"_"+(string)n,0, OrderOpenTime(), OrderOpenPrice(), OrderOpenTime(), OrderStopLoss(), clrRed, 1, 1);
            }
            MarkCreate(ChartID(),  "HDStart_Info_"+(string)OrderTicket()+"_"+(string)n, 0, OrderType() == 0?OBJ_ARROW_BUY:OBJ_ARROW_SELL, OrderOpenTime(), OrderOpenPrice(),OrderType() == 0?clrBlue:clrRed, 0, 3);
            MarkCreate(ChartID(),  "HDStop_Info_"+(string)OrderTicket()+"_"+(string)n,  0, OrderProfit() < 0.0?OBJ_ARROW_STOP:OBJ_ARROW_CHECK, OrderCloseTime(), OrderClosePrice(), OrderProfit() > 0.0?clrGreen:clrRed, 0, 3);
            n++;
         }
      }
   }         
}

bool FindObject(int tkt){
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>= 0; i--){
         if(StringFind(ObjectName(ChartID(), i), "Info_"+(string)tkt)!=-1)return true;
      }
   }
   return false;
}

void UpdateTable(){
   
   if(ObjectsTotal()>0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i),"InfoTXT2-")!= -1 || StringFind(ObjectName(ChartID(), i),"InfoRCT")!= -1 || StringFind(ObjectName(ChartID(), i),"InfoTXT3-")!= -1)
            ObjectDelete(ObjectName(ChartID(), i));
      }
   }
   
   ushort orders  = 0;
   double lots    = 0.0;
   double loss    = 0.0;
   double profit  = 0.0;
   string risk    = NULL;
   string max     = NULL;
   string min     = NULL;
   double maxlvl   = 0.0;
   double minlvl   = 0.0;
   
   Checking(orders, lots, loss, profit, max, min, maxlvl, minlvl);
   if(loss != 0.0 && AccountBalance() != 0.0)risk = (string)(int)(MathAbs(loss)/(AccountBalance()/100));
   if(loss == 0.0) risk = "0";
   
   LabelCreate(    ChartID(), "InfoTXT2-3", 0, 193, 138,CORNER_LEFT_LOWER, IntegerToString(orders),      "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT2-4", 0, 193, 119, CORNER_LEFT_LOWER, DoubleToString(lots,2),       "Arial",sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT2-5", 0, 193, 100, CORNER_LEFT_LOWER, DoubleToString(loss,2)+" $",  "Arial", sz, clrRed);
   LabelCreate(    ChartID(), "InfoTXT2-6", 0, 193, 81, CORNER_LEFT_LOWER, DoubleToString(profit,2)+" $","Arial", sz, clrGreen);
   LabelCreate(    ChartID(), "InfoTXT2-7", 0, 193, 62, CORNER_LEFT_LOWER, risk == NULL?"UNC":risk+" %", "Arial", sz, clrRed);
   LabelCreate(    ChartID(), "InfoTXT2-8", 0, 100, 43, CORNER_LEFT_LOWER, maxlvl >= 0.0?"NONE":max, "Arial", sz, maxlvl == NULL?clrGreen:clrRed);
   LabelCreate(    ChartID(), "InfoTXT3-8", 0, 193, 43, CORNER_LEFT_LOWER, maxlvl >= 0.0?"":DoubleToString(maxlvl, 2)+" $", "Arial", sz, clrRed);
   LabelCreate(    ChartID(), "InfoTXT2-9", 0, 100, 24, CORNER_LEFT_LOWER, min, "Arial", sz, clrGreen);
   LabelCreate(    ChartID(), "InfoTXT3-9", 0, 193, 24, CORNER_LEFT_LOWER, DoubleToString(minlvl, 2)+" $", "Arial", sz, clrGreen);
   
}
void Checking(ushort &ord, double &lts, double &lss, double &prft, string &_max, string &_min, double &_maxlvl, double &_minlvl){   
   
   if(OrdersTotal()>0){
      double p = 0.0;
      double l = 0.0;
      double tp = 0.0;
      double sl = 0.0;
      double op = 0.0;
      double ol = 0.0;
      int    type = -1;
      string smb = "";
   
      for(int i = OrdersTotal()-1; i>=0; i--){
         if(OrderSelect(i, SELECT_BY_POS)){
            //if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               ord++;
               lts+=OrderLots();
               tp  = OrderTakeProfit();
               sl  = OrderStopLoss();
               op  = OrderOpenPrice();
               ol  = OrderLots();
               smb = OrderSymbol();
               type = OrderType();
               
               p   = NormalizeDouble((tp-op)/MarketInfo(smb, MODE_POINT)*MarketInfo(smb, MODE_TICKVALUE)*ol, 2);
               l   = NormalizeDouble((op -sl)/MarketInfo(smb, MODE_POINT)*MarketInfo(smb, MODE_TICKVALUE)*ol, 2);
               
               if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){                  
                  if(tp != 0.0)prft += p;
                  if(sl != 0.0 && sl < op){
                     lss += l*(-1);        
                     if(_maxlvl == 0.0 || _maxlvl > (l*(-1))){
                        _maxlvl = (l*(-1));
                        _max = smb;
                     }
                     if(_minlvl == 0.0 || _minlvl < (l*(-1))){
                        _minlvl = (l*(-1));
                        _min = smb;
                     }
                  }
               }
               else if(type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT){
                  if (tp != 0.0)prft += p*(-1);
                  if(sl!= 0.0 && sl > op){
                     lss += l;  
                     if(_maxlvl == 0.0 || _maxlvl > l){
                        _maxlvl = l;
                        _max = smb;
                     }
                     if(_minlvl == 0.0 || _minlvl < l){
                        _minlvl = l;
                        _min = smb;
                     }
                  }
               }
            //}
         }         
      }
   }
}

void DrawTable(){
   RectLabelCreate(ChartID(), "InfoTBL0-7", 0, 5, 139, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-8", 0, 5, 120, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-9", 0, 5, 101, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-10",0, 5, 82, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-11",0, 5, 63, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-12",0, 5, 44, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL0-13",0, 5, 25, 31, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   
   LabelCreate(    ChartID(), "InfoTXT0-7", 0, 16, 138,CORNER_LEFT_LOWER, "1", "Arial", sz, clrBlack);   
   LabelCreate(    ChartID(), "InfoTXT0-8", 0, 16, 119,CORNER_LEFT_LOWER, "2", "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-9", 0, 16, 100,CORNER_LEFT_LOWER, "3", "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-10",0, 16, 81, CORNER_LEFT_LOWER, "4", "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-11",0, 16, 62, CORNER_LEFT_LOWER, "5", "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-12",0, 16, 43, CORNER_LEFT_LOWER, "6", "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT0-13",0, 16, 24, CORNER_LEFT_LOWER, "7", "Arial", sz, clrBlack);
   
   RectLabelCreate(ChartID(), "InfoTBL1-7", 0, 35, 139,154, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);   
   RectLabelCreate(ChartID(), "InfoTBL1-8", 0, 35, 120,154, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-9", 0, 35, 101,154, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-10",0, 35, 82, 154, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-11",0, 35, 63, 154, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-12",0, 35, 44, 60, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL1-13",0, 35, 25, 60, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
      
   LabelCreate(    ChartID(), "InfoTXT1-7", 0, 40, 138,CORNER_LEFT_LOWER, pstns,"Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-8", 0, 40, 119,CORNER_LEFT_LOWER, vl,   "Arial",sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-9", 0, 40, 100,CORNER_LEFT_LOWER, ls,   "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-10",0, 40, 81, CORNER_LEFT_LOWER, prf,  "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-11",0, 40, 62, CORNER_LEFT_LOWER, rsk,  "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-12",0, 40, 43, CORNER_LEFT_LOWER, maxr, "Arial", sz, clrBlack);
   LabelCreate(    ChartID(), "InfoTXT1-13",0, 40, 24, CORNER_LEFT_LOWER, minr, "Arial", sz, clrBlack);
   
   RectLabelCreate(ChartID(), "InfoTBL2-7", 0, 188, 139,80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-8", 0, 188, 120,80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-9", 0, 188, 101,80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-10",0, 188, 82, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-11",0, 188, 63, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-12",0, 94,  44, 95, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-12",0, 188, 44, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL2-13",0, 94,  25, 95, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
   RectLabelCreate(ChartID(), "InfoTBL3-13",0, 188, 25, 80, 20, clrLightGray, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1, false, false, true, 0);
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

bool LabelCreate(const long              chart_ID=0,               // ID графика 
                 const string            name="Label",             // имя метки 
                 const int               sub_window=0,             // номер подокна 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                 const string            text="Label",             // текст 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrRed,               // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим текстовую метку 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать текстовую метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим угол наклона текста 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- установим способ привязки 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- установим цвет 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
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
  
bool TrendCreate(const long            chart_ID=0,        // ID графика 
                 const string          name="TrendLine",  // имя линии 
                 const int             sub_window=0,      // номер подокна 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 const color           clr=clrRed,        // цвет линии 
                 const ENUM_LINE_STYLE style=STYLE_DASH, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,    // выделить для перемещений 
                 const bool            ray_right=false,   // продолжение линии вправо 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точек привязки, если они не заданы
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим трендовую линию по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать линию тренда! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль отображения линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим продолжения отображения линии вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 

bool MarkCreate(const long                chart_ID=0,        // ID графика 
                    const string          name="ArrowBuy",   // имя знака 
                    const int             sub_window=0,      // номер подокна
                    ENUM_OBJECT           obj = OBJ_ARROW_BUY, 
                    datetime              time=0,            // время точки привязки 
                    double                price=0,           // цена точки привязки 
                    const color           clr=C'3,95,172',   // цвет знака 
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии (при выделении) 
                    const int             width=1,           // размер линии (при выделении) 
                    const bool            back=false,        // на заднем плане 
                    const bool            selection=false,   // выделить для перемещений 
                    const bool            hidden=true,       // скрыт в списке объектов 
                    const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точки привязки, если они не заданы 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим знак 
   if(!ObjectCreate(chart_ID,name,obj,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать знак \"Buy\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет знака 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии (при выделении) 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим размер линии (при выделении) 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения знака мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установи приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  }

bool VLineCreate(const long            chart_ID=0,        // ID графика 
                 const string          name="VLine",      // имя линии 
                 const int             sub_window=0,      // номер подокна 
                 datetime              time=0,            // время линии 
                 const color           clr=clrRed,        // цвет линии 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=true,    // выделить для перемещений 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0)         // приоритет на нажатие мышью 
  { 
//--- если время линии не задано, то проводим ее через последний бар 
   if(!time) 
      time=TimeCurrent(); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим вертикальную линию 
   if(!ObjectCreate(chart_ID,name,OBJ_VLINE,sub_window,time,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать вертикальную линию! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль отображения линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
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
