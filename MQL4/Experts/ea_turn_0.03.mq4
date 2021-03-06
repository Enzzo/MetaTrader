//+------------------------------------------------------------------+
//|                                                     ea_turn_0.01 |
//|                                                           Sergey |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
//v 1.03 Отменил привязку к часовому таймфрейму. Теперь советник работает на том таймфрейме, 
//который открыт в данный момент.
//Отменил автоматический расчёт пунктов. Теперь считает в пипсах
//добавил MIN_BARS_FOR_RANGE
//добавил PREV_BARS

//совертник даёт сигнал, когда свеча закрывается над/под контрольным верхним/нижним уровнем
//контрольный уровень - может быть один: верхний или нижний. Условия для появления:
//1)существует инсайд-бар с валидным диапазоном
//2)учитываем предшествующий тренд

//CHECK_INSIDE - задаёт базовые уровни b_up и b_dn
#property copyright "Sergey"
#property link      "http://vk.com/id29520847"
#property version   "1.03"
#property strict

input int MAX_LENGTH = 1000;   //максимальная длина базовой свечи
input unsigned MAX_BARS_FOR_RANGE = 10;  //максимальное количество инсайд-баров 
input unsigned MIN_BARS_FOR_RANGE = 3;   //минимальное количество инсайд-баров
input unsigned PREV_BARS = 3;            //предшествующие бары для определения тренда

input color BASE_COLOR_UP = clrLightGreen; //Цвет базовой свечи паттерна на покупку
input color BASE_COLOR_DN = clrPink;   //Цвет базовой свечи паттерна на продажу
input color RANGE_COLOR = clrYellow;//Цвет диапазона
input color BREAK_COLOR = clrRed;//Цвет пробитого уровня
input string MESSAGE = "Пробит инсайд-уровень"; //сообщение в алерт и на смартфон
input bool ALERT = true;
input bool DRAW = true; //отрисовка паттернов

enum ENUM_DIRECTION{
   NONE,
   UP,
   DOWN
};

struct InsideBar{
   //базовые уровни
double   b_up;
double   b_dn;
datetime t;
unsigned range; //текущее количество свечей, насчитанных в инсайд-баре. инкрементируется на каждой свече. 
bool inside;
ENUM_DIRECTION dir;
}IB = {0.0, 0.0, 0, 0, false, NONE};

datetime prv, crn[];
string pref = "turn";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   DeleteObjects(pref);
   for(unsigned int i = Bars-PREV_BARS - 2; i > 1; i--)
      Trade(IB, false, i);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   DeleteObjects(pref);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   //НА КАЖДОЙ СВЕЧЕ
   CopyTime(Symbol(), PERIOD_CURRENT, 0, 1, crn);
   if(prv == crn[0])return;
   prv = crn[0];
   
   Trade(IB, ALERT);
}
void Trade(InsideBar& ib, const bool alert = false, const int bar = 1){ //НОМЕР БАРА (БОЛЬШЕ 0)
   if(bar < 1)return;
   //IF INSIDE
      //UPDATE_RATES
      //IF CHECK_MAX_RANGE
         //IF CHECK_OPPOSITE_LEVEL
            //IF CHECK_SIGNAL
               //IF CHECK_MIN_RANGE
                  //ALERT
            //ELSE RETURN
   //CHECK_INSIDE
   
   RefreshRates();
   if (ib.inside){
      if(++ib.range <= MAX_BARS_FOR_RANGE){
         double   c[];
         datetime t[];
         CopyClose(Symbol(), PERIOD_CURRENT, bar, 1, c);
         CopyTime (Symbol(), PERIOD_CURRENT, bar, 1, t);
         
         if(Check_opposite_level(ib, c[0], t[0])){
            if(Check_signal(ib, c[0], t[0])){
               if(ib.range >= MIN_BARS_FOR_RANGE){
                  if(DRAW)TrendCreate(pref+"_break_"+TTS(IB.t), IB.t, (IB.dir == UP)?IB.b_up:IB.b_dn, t[0], (IB.dir == UP)?IB.b_up:IB.b_dn, 3, BREAK_COLOR);
                  if(alert){
                     Alert(MESSAGE);
                     SendNotification(MESSAGE);
                  }
               }
            }
            else return;
         }
      }
   }
   Check_inside(ib, bar);
}

//Контролирует, чтобы цена закрытия не вывалилась за противоположный уровень базовой свечи
bool Check_opposite_level(const InsideBar& ib, const double p, const datetime t){
   if((ib.dir == UP && p < ib.b_dn) ||
      (ib.dir == DOWN && p > ib.b_up)){
      //if(DRAW)RectangleCreate(pref+"_rect_"+TTS(IB.t), IB.t, IB.b_up, t, IB.b_dn, clrLightGray);
      return false;
   }
   return true;
}

bool Check_signal(const InsideBar& ib, const double p, const datetime t){
   if((ib.dir == UP && p > ib.b_up) ||
      (ib.dir == DOWN && p < ib.b_dn)){
         if(DRAW)RectangleCreate(pref+"_rect_"+TTS(IB.t), IB.t, IB.b_up, t, IB.b_dn, RANGE_COLOR);
         return true;
      }
   return false;
}
// Ищет инсайд. Если найден, то задаёт контрольные уровни, направление и 
//устанавливает inside = true
void Check_inside(InsideBar& ib, const int pos){
   //Обнулим паттерн, если в нём что-то уже есть
   if(ib.inside)
      ZeroMemory(ib);
   
   double h[];
   double l[];
   double o[];
   double c[];
   datetime t[];
   
   unsigned cnt = 1 + PREV_BARS; //количество баров (1: базовая свеча, PREV_BARS - бары для определения предшествующего тренда
   
   CopyHigh (Symbol(), PERIOD_CURRENT, pos+1, cnt, h); //отступаем от первой свечи для поиска базовой (второй по счёту)
   CopyLow  (Symbol(), PERIOD_CURRENT, pos+1, cnt, l); //отступаем от первой свечи для поиска базовой (второй по счёту)
   CopyOpen (Symbol(), PERIOD_CURRENT, pos,   1,   o);
   CopyClose(Symbol(), PERIOD_CURRENT, pos,   1,   c);
   CopyTime (Symbol(), PERIOD_CURRENT, pos+1, 1,   t); //время открытия для отрисовки графических элементов
   
   ArraySetAsSeries(h, true);
   ArraySetAsSeries(l, true);
   ArraySetAsSeries(o, true);
   ArraySetAsSeries(c, true);
   ArraySetAsSeries(t, true);
   
   //Если найден инсайд-паттерн
   if(h[0] > o[0] && h[0] > c[0] &&
      l[0] < o[0] && l[0] < c[0] &&
      (h[0] - l[0]) <= NormalizeDouble(MAX_LENGTH * Point(), Digits())){
      //Определяем направление при помощи предшествующего тренда
      //Если low базовой свечи ниже, чем low предыдущих свечей, то контрольный уровень - верхний
      
      ushort u = 0, d = 0; //u - количество свечей ниже базового high, d - выше базового low
      for(unsigned i = cnt-1; i > 0; i--){
         if(h[0] > h[i])u++;
         if(l[0] < l[i])d++;
      }
      if(u != d){
         IB.b_up = h[0];
         IB.b_dn = l[0];
         IB.t = t[0];
         if(d == PREV_BARS){
            IB.dir = UP;
            IB.inside = true;
         }
         else if(u == PREV_BARS){
            IB.dir = DOWN;
            IB.inside = true;
         }         
         if(DRAW && IB.inside)TrendCreate(pref+"_base_"+TTS(IB.t), IB.t, IB.b_up, IB.t, IB.b_dn, 4, (IB.dir == UP)?BASE_COLOR_UP:BASE_COLOR_DN);
      }
   }
}

void DeleteObjects(const string& p){
   int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, p)!= -1) ObjectDelete(ChartID(), on);
      }
   }
}
bool RectangleCreate(const string          name="Rectangle",  // имя прямоугольника
                     datetime              time1=0,           // время первой точки 
                     double                price1=0,          // цена первой точки 
                     datetime              time2=0,           // время второй точки 
                     double                price2=0,          // цена второй точки 
                     const color           clr=clrRed,        // цвет прямоугольника 
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линий прямоугольника 
                     const int             width=1)         // приоритет на нажатие мышью 
  { 
   const long chart_ID = ChartID();
   const int sub_window = 0;
//--- сбросим значение ошибки 
   ResetLastError(); 
   if(ObjectFind(chart_ID, name) > -1)return true;
//--- создадим прямоугольник по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольник! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
   ObjectSetDouble(chart_ID,name,OBJPROP_SCALE,.5);
//--- установим цвет прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линий прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линий прямоугольника 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
    
//--- успешное выполнение 
   return(true); 
} 

bool TrendCreate(const string          name="TrendLine",  // имя линии 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 const int             width = 5,
                 const color           clr=clrBlue,        // цвет линии 
                 const ENUM_LINE_STYLE style=STYLE_SOLID)         // приоритет на нажатие мышью 
  { 
//--- установим координаты точек привязки, если они не заданы 
//--- сбросим значение ошибки 
   long chart_ID=0;        // ID графика 
   if(ObjectFind(chart_ID, name) > -1)return true;
   ResetLastError(); 
//--- создадим трендовую линию по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,0,time1,price1,time2,price2)) 
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
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false); 
//--- включим (true) или отключим (false) режим продолжения отображения линии вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,false); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
//--- успешное выполнение 
   return(true); 
  } 

string TTS(const datetime& tts){
   return TimeToString(tts);
}