//+------------------------------------------------------------------+
//|                                                      iLevels.mq4 |
//|                                                           Sergey |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window


input ENUM_LINE_STYLE lineStyle = 1;   //Стиль линии
input ENUM_LINE_STYLE arrowStyle = 1;  //Стиль метки
input int rightOffset = 200;           //сдвиг от правого края окна (пиксели)
input color customColor = clrRed;      //Цвет
input bool STF = false;                //Раздельный таймфрейм

bool draw = false;
bool move = false;
string pref = "DrawLevels";
long lineID = 0;
datetime dtRight = 0;
datetime dtLeft  = 0;
double globalPrice = 0.0;
int window = 0;
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
//+------------------------------------------------------------------+


void OnChartEvent(const int id,         // идентификатор события   
                  const long& lparam,   // параметр события типа long 
                  const double& dparam, // параметр события типа double 
                  const string& sparam){// параметр события типа string
   
   long width = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS, 0) - rightOffset;
   ChartXYToTimePrice(ChartID(), (int)width,  (int)dparam, window, dtRight, globalPrice);
   ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, window, dtLeft,  globalPrice);
   //При нажатии на Ctrl переходим в режим рисования
   if(id == CHARTEVENT_KEYDOWN && lparam == 17 && !draw) draw = true;
   
   //рисуем линию с меткой и двигаем
   if(id == CHARTEVENT_MOUSE_MOVE && draw){      
      static string arrowName = "";
      static string trendName = "";
      if(!move){
         lineID = TimeCurrent();
         arrowName = "Arrow"+pref+IntegerToString(lineID);
         trendName = "Trend"+pref+IntegerToString(lineID);
         
         ArrowRightPriceCreate(ChartID(), arrowName, 0, dtRight, globalPrice);
         TrendCreate(ChartID(), trendName, 0, dtLeft, globalPrice, dtRight, globalPrice);
      }
      else {
         ArrowRightPriceMove(ChartID(), arrowName, dtRight, globalPrice);
         TrendPointChange(ChartID(), trendName, 0, dtLeft, globalPrice);
         TrendPointChange(ChartID(), trendName, 1, dtRight, globalPrice);
      }
      move = true;
   }
   
   //закрепляем линию с меткой
   if(id == CHARTEVENT_CLICK && draw){
      
      draw = false;
      move = false;
   }
   
   int total = ObjectsTotal();
   
   if(total > 0){
      string objectName = "";
      string lineName = "";
      
      string sid = "";
      double prc = 0.0; //цена метки и линии
      for(int i = 0; i < total; i++){
         objectName = ObjectName(ChartID(), i);
         if(StringFind(objectName, pref) != -1){
            prc = ObjectGetDouble(ChartID(), objectName, OBJPROP_PRICE);
            if(StringFind(objectName, "Arrow") != -1){               
               ArrowRightPriceMove(ChartID(), objectName, dtRight, prc);
               
               //Если метка без линии, то удаляем метку
               //Для этого необходимо сравнить идентификаторы метки и линии
               
               //Получаем идентификатор метки
               sid = objectName;
               if(StringReplace(sid, "Arrow"+pref, "")!= -1){
                  bool   found = false;
                  //Ищем линию с этим идентификатором
                  //по всем объектам
                  for(int j = 0; j < total; j++){
                     if(i == j)continue;
                     lineName = ObjectName(ChartID(), j);
                     
                     //Если нашли линию, то заканчиваем поиск
                     if(StringFind(lineName, sid) != -1){
                        found = true;
                     }
                  }
                  //Если не нашли линию, соответствующую метке
                  //то удаляем эту метку
                  if(!found)ObjectDelete(ChartID(), objectName);
               }               
            }
            else if(StringFind(objectName, "Trend") != -1){
               TrendPointChange(ChartID(), objectName, 1, dtRight, prc);
               if(StringReplace(objectName, "Trend", "Arrow")!= 0)
                  ArrowRightPriceMove(ChartID(), objectName, dtRight, prc);
            }
         }
      }
   }
}


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   ChartSetInteger(ChartID(), CHART_EVENT_MOUSE_MOVE, 1);
   Comment("");
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

bool ArrowRightPriceCreate(const long            chart_ID=0,        // ID графика 
                           const string          name="RightPrice", // имя ценовой метки 
                           const int             sub_window=0,      // номер подокна 
                           datetime              time=0,            // время точки привязки 
                           double                price=0,           // цена точки привязки 
                           //const color           clr=clrRed,        // цвет ценовой метки 
                           //const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль окаймляющей линии 
                           const int             width=1,           // размер ценовой метки 
                           const bool            back=false,        // на заднем плане 
                           const bool            selection=false,   // выделить для перемещений 
                           const bool            hidden=false,       // скрыт в списке объектов 
                           const long            z_order=0)         // приоритет на нажатие мышью 
{ 
//--- установим координаты точки привязки, если они не заданы 
   //ChangeArrowEmptyPoint(time,price); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим ценовую метку 
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_RIGHT_PRICE,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать правую ценовую метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,customColor); 
//--- установим стиль окаймляющей линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,arrowStyle); 
//--- установим размер метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   if(STF)ObjectSetInteger(chart_ID, name, OBJPROP_TIMEFRAMES, Timeframe());
//--- успешное выполнение 
   return(true); 
}
//+------------------------------------------------------------------+
bool ArrowRightPriceMove(const long   chart_ID=0,        // ID графика 
                         const string name="RightPrice", // имя метки 
                         datetime     time=0,            // координата времени точки привязки 
                         double       price=0)           // координата цены точки привязки 
{ 
//--- если координаты точки не заданы, то перемещаем ее на текущий бар с ценой Bid 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- переместим точку привязки 
   if(!ObjectMove(chart_ID,name,0,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось переместить точку привязки! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- успешное выполнение 
   return(true); 
  } 
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,        // ID графика 
                 const string          name="TrendLine",  // имя линии 
                 const int             sub_window=0,      // номер подокна 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 //const color           clr=clrRed,        // цвет линии 
                 //const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=true,    // выделить для перемещений 
                 const bool            ray_right=false,   // продолжение линии вправо 
                 const bool            hidden=false,      // скрыт в списке объектов 
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
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,customColor); 
//--- установим стиль отображения линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,lineStyle); 
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
   if(STF)ObjectSetInteger(chart_ID, name, OBJPROP_TIMEFRAMES, Timeframe());
//--- успешное выполнение 
   return(true); 
}
//+------------------------------------------------------------------+
bool TrendPointChange(const long   chart_ID=0,       // ID графика 
                      const string name="TrendLine", // имя линии 
                      const int    point_index=0,    // номер точки привязки 
                      datetime     time=0,           // координата времени точки привязки 
                      double       price=0)          // координата цены точки привязки 
  { 
//--- если координаты точки не заданы, то перемещаем ее на текущий бар с ценой Bid 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- переместим точку привязки линии тренда 
   if(!ObjectMove(chart_ID,name,point_index,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось переместить точку привязки! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- успешное выполнение 
   return(true); 
}
//+------------------------------------------------------------------+
int Timeframe(){
   ENUM_TIMEFRAMES tf = Period();
   switch(tf){
      case 1:
      return 0x0001;
      case 5:
      return 0x0002;
      case 15:
      return 0x0004;
      case 30:
      return 0x0008;
      case 60:
      return 0x0010;
      case 240:
      return 0x0020;
      case 1440:
      return 0x0040;
      case 10080:
      return 0x0080;
      case 43200:
      return 0x0100;
   }
   return 0;
}