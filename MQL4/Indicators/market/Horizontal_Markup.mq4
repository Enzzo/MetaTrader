//+------------------------------------------------------------------+
//|                                                      iLevels.mq4 |
//|                                                           Sergey |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "http://vk.com/id29520847"
#property version   "1.01"
#property strict
#property indicator_chart_window


input ENUM_LINE_STYLE   LINESTYLE = 1;          // Line style
input int               WIDTH = 1;              // Line width
input ENUM_LINE_STYLE   ARROWSTYLE = 1;         // Mark style
input int               RIGHTOFFSET = 200;      // Mark offset(pixels)
input color             CUSTOMCOLOR = clrRed;   // Line color
input bool              STF = false;            // Separate timeframe
input string            TOKEN = "Ctrl";         // Hotkey for markup

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
   
   long width = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS, 0) - RIGHTOFFSET;
   ChartXYToTimePrice(ChartID(), (int)width,  (int)dparam, window, dtRight, globalPrice);
   ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, window, dtLeft,  globalPrice);
   //При нажатии на Ctrl переходим в режим рисования
   if(id == CHARTEVENT_KEYDOWN && lparam == StringToToken(TOKEN) && !draw) draw = true;
   
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

bool ArrowRightPriceCreate(const long            chart_ID=0,        // ID графика 
                           const string          name="RightPrice", // имя ценовой метки 
                           const int             sub_window=0,      // номер подокна 
                           datetime              time=0,            // время точки привязки 
                           double                price=0,           // цена точки привязки 
                           // const color           clr=clrRed,        // цвет ценовой метки 
                           // const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль окаймляющей линии 
                           // const int             width=1,           // размер ценовой метки 
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
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,CUSTOMCOLOR); 
//--- установим стиль окаймляющей линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,ARROWSTYLE); 
//--- установим размер метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,WIDTH); 
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
   if(STF)ObjectSetInteger(chart_ID, name, OBJPROP_TIMEFRAMES, tf());
//--- успешное выполнение 
   return(true); 
}

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
bool TrendCreate(const long            chart_ID=0,        // ID графика 
                 const string          name="TrendLine",  // имя линии 
                 const int             sub_window=0,      // номер подокна 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 // const color           clr=clrRed,        // цвет линии 
                 // const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 // const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,    // выделить для перемещений 
                 const bool            selectable=true,
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
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,CUSTOMCOLOR); 
//--- установим стиль отображения линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,LINESTYLE); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,WIDTH); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selectable); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим продолжения отображения линии вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);    
   if(STF)ObjectSetInteger(chart_ID, name, OBJPROP_TIMEFRAMES, tf());
//--- успешное выполнение 
   return(true); 
}

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

int tf(){
   ENUM_TIMEFRAMES tf = PERIOD_CURRENT;
   switch(tf){
      case PERIOD_M1: return OBJ_PERIOD_M1;
      case PERIOD_M5: return OBJ_PERIOD_M5;
      case PERIOD_M15:return OBJ_PERIOD_M15;
      case PERIOD_M30:return OBJ_PERIOD_M30;
      case PERIOD_H1: return OBJ_PERIOD_H1;
      case PERIOD_H4: return OBJ_PERIOD_H4;
      case PERIOD_D1: return OBJ_PERIOD_D1;
      case PERIOD_W1: return OBJ_PERIOD_W1;
      case PERIOD_MN1:return OBJ_PERIOD_MN1;
   }
   return OBJ_ALL_PERIODS;
}

long StringToToken(const string& s){
   if(s == "ctrl" || s == "Ctrl") return 17;
   if(s[0] == '0') return 48;
   if(s[0] == '1') return 49;
   if(s[0] == '2') return 50;
   if(s[0] == '3') return 51;
   if(s[0] == '4') return 52;
   if(s[0] == '5') return 53;
   if(s[0] == '6') return 54;
   if(s[0] == '7') return 55;
   if(s[0] == '8') return 56;
   if(s[0] == '9') return 57;
   if(s[0] == 'A' || s[0] == 'a') return 65;
   if(s[0] == 'B' || s[0] == 'b') return 66;
   if(s[0] == 'C' || s[0] == 'c') return 67;
   if(s[0] == 'D' || s[0] == 'd') return 68;
   if(s[0] == 'E' || s[0] == 'e') return 69;
   if(s[0] == 'F' || s[0] == 'f') return 70;
   if(s[0] == 'G' || s[0] == 'g') return 71;
   if(s[0] == 'H' || s[0] == 'h') return 72;
   if(s[0] == 'I' || s[0] == 'i') return 73;
   if(s[0] == 'J' || s[0] == 'j') return 74;
   if(s[0] == 'K' || s[0] == 'k') return 75;
   if(s[0] == 'L' || s[0] == 'l') return 76;
   if(s[0] == 'M' || s[0] == 'm') return 77;
   if(s[0] == 'N' || s[0] == 'n') return 78;
   if(s[0] == 'O' || s[0] == 'o') return 79;
   if(s[0] == 'P' || s[0] == 'p') return 80;
   if(s[0] == 'Q' || s[0] == 'q') return 81;
   if(s[0] == 'R' || s[0] == 'r') return 82;
   if(s[0] == 'S' || s[0] == 's') return 83;
   if(s[0] == 'T' || s[0] == 't') return 84;
   if(s[0] == 'U' || s[0] == 'u') return 85;
   if(s[0] == 'V' || s[0] == 'v') return 86;
   if(s[0] == 'W' || s[0] == 'w') return 87;
   if(s[0] == 'X' || s[0] == 'x') return 88;
   if(s[0] == 'Y' || s[0] == 'y') return 89;
   if(s[0] == 'Z' || s[0] == 'z') return 90;   
   return -1;
}

// utilites
string ITS(long i){
   return IntegerToString(i);
}