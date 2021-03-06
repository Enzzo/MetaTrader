//+------------------------------------------------------------------+
//|                                       20210531_InfoBySymbols.mq4 |
//|                                                   Sergey Vasilev |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

input datetime FROM = D'28.05.2021';

const string pref = "20210531";
int mtp = 1;

struct Info{
   const string sm_;
   const double pr_;
   const int y;
};

Info inf[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
ChartRedraw();
   
   if(ObjectsTotal() > 0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(), i), pref)!= -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
   if(Digits() == 5 || Digits() == 3)mtp = 1;
   
   
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
   
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

void OnDeinit(const int reason){
//---
  int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, pref)!= -1) ObjectDelete(ChartID(), on);
      }
   }
}

void DrawInfo(){
   LabelCreate(ChartID(), pref + "LB_Title",0, 10, 10, 0, "INFO",  "Arial", 14);
   LabelCreate(ChartID(), pref + "LB_from", 0, 10, 30, 0, "From: ","Arial", 12);
   LabelCreate(ChartID(), pref + "LB_date", 0, 60, 30, 0, TimeToString(FROM), "Arial", 12);
   
   int pos_y = 60;
   
   for(int i = OrdersHistoryTotal()-1; i >= 0; --i){
      bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);{
         const string sm = OrderSymbol();
         
         //если массив пустой, то добавляем элемент
         if(ArraySize(inf) == 0){
            ArrayResize(inf, 1);
            inf[0].sm_ = sm;
            inf[0].y = pos_y++;
         }
         //если массив не пустой, то ищем символ в его первом поле
         else{
            for(int i = 0; i < ArraySize(inf); ++i){
               
            }
         }
      }
   }
}
//+------------------------------------------------------------------+

bool LabelCreate(const long              chart_ID=0,               // ID графика 
                 const string            name="Label",             // имя метки 
                 const int               sub_window=0,             // номер подокна 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                 const string            text="Label",             // текст 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrBlack,               // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
   if(ObjectFind(chart_ID, name)) return true;
//--- создадим текстовую метку 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)){ 
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

bool LabelTextChange(const long   chart_ID=0,   // ID графика 
                     const string name="Label", // имя объекта 
                     const string text="Text")  // текст 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- изменим текст объекта 
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось изменить текст! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- успешное выполнение 
   return(true); 
  } 