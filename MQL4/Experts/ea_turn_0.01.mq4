//+------------------------------------------------------------------+
//|                                                     ea_turn_0.01 |
//|                                                           Sergey |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

input int MAX_LENGTH = 100;   //максимальная длина базовой свечи
input int MAX_BARS_FOR_RANGE = 10;  //максимальное количество инсайд-баров 
input color BASE_COLOR = clrLightBlue; //Цвет базовой свечи
input color RANGE_COLOR = clrYellow;//Цвет диапазона
input color BREAK_COLOR = clrRed;//Цвет пробитого уровня
input string MESSAGE = "Пробит инсайд-уровень"; //сообщение в алерт и на смартфон

struct InsideBar{
   //базовые уровни
double   b_up;
double   b_dn;
datetime b_tm;

//контрольные уровни
double   d_op;
double   d_cs;

datetime time;
bool is_valid;

}IB = {0.0, 0.0, 0, 0.0, 0.0, 0, false};

datetime prv, crn[];
int mtp = 1;
string pref = "turn";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   if(Digits() == 3 || Digits() == 5)mtp = 10;
   DeleteObjects(pref);
   for(unsigned int i = Bars-1; i > 1; i--)
      Trade(IB, i);
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
   CopyTime(Symbol(), PERIOD_H1, 0, 1, crn);
   if(prv == crn[0])return;
   prv = crn[0];
   
   Trade(IB);
}
void Trade(InsideBar& ib, const int bar = 2){ //НОМЕР БАРА (БОЛЬШЕ 1)
   if(bar < 2)return;
   //если базовая свеча не найдена, то задаём вторую сформированную для проверки
   if(!ib.is_valid){
      double h[],l[];
      datetime t[];
      
      CopyHigh(Symbol(), PERIOD_H1, bar, 1, h);
      CopyLow( Symbol(), PERIOD_H1, bar, 1, l);
      CopyTime(Symbol(), PERIOD_H1, bar, 1, t);
      
      ArraySetAsSeries(h, true);
      ArraySetAsSeries(l, true);
      ArraySetAsSeries(t, true);
      
      ib.b_up = h[0];
      ib.b_dn = l[0];
      ib.b_tm = t[0];
   }
   
   //Контроль максимального количества свечей в диапазоне
   //не должен превышать MAX_BARS_FOR_RANGE
   static int bars_for_range = 0;
   bars_for_range++;
   if(bars_for_range >= MAX_BARS_FOR_RANGE){
      bars_for_range = 0;
      ib.is_valid = false;
      return;
   }
   
   double o[], c[];
   //чисто косметическая переменная. для отрисовки прямоугольника
   datetime t[];
   //задаём проверочные контрольные уровни
   CopyOpen( Symbol(), PERIOD_H1, bar-1, 1, o);
   CopyClose(Symbol(), PERIOD_H1, bar-1, 1, c);
   CopyTime( Symbol(), PERIOD_H1, bar-1, 1, t);
   
   ArraySetAsSeries(o, true);
   ArraySetAsSeries(c, true);
   ArraySetAsSeries(t, true);
   
   ib.d_op = o[0];
   ib.d_cs = c[0];
   
   //СВЕРЯЕМ БАЗОВЫЕ И ПРОВЕРОЧНЫЕ КОНТРОЛЬНЫЕ УРОВНИ:
   bool pattern = is_pattern(ib);
   if(pattern){
      if(!ib.is_valid)TrendCreate(pref+"_base_"+TTS(ib.b_tm), ib.b_tm, ib.b_up, ib.b_tm, ib.b_dn, 5, BASE_COLOR);
      ib.is_valid = true;
   }
   else{
      if (ib.is_valid){//(ТО ЕСТЬ ПАТТЕРН БЫЛ, НО СЛОМАЛСЯ)
         //РИСУЕМ ПРЯМОУГОЛЬНИК
         RectangleCreate(pref+"_range_"+TTS(ib.b_tm), ib.b_tm, ib.b_up, t[0], ib.b_dn, RANGE_COLOR);
         
         //РИСУЕМ ЛИНИЮ, КОТОРУЮ ПРОБИЛО ЗАКРЫТИЕМ
         double break_price = (ib.d_cs > ib.b_up)?ib.b_up:ib.b_dn;
         TrendCreate(pref+"_break_"+TTS(ib.b_tm), ib.b_tm, break_price , t[0], break_price, 2, BREAK_COLOR);
         
         //ПРОВЕРЯЕМ ТРЕНД И ЗАКРЫТИЕ ЛОМАЮЩЕЙ СВЕЧИ
            //ЕСЛИ ВСЁ ПО ЗАДАЧЕ, ТО ШЛЁМ АЛЕРТ
         Alert(MESSAGE);
         ib.is_valid = false;
      }
   }
}

//Определяет правильность базовой свечи и дочерних
//функция готова
bool is_pattern(const InsideBar& ib){
   double length = ib.b_up - ib.b_dn;
   if(ib.b_up > ib.d_op && ib.b_up > ib.d_cs &&
      ib.b_dn < ib.d_op && ib.b_dn < ib.d_cs &&
      length < NormalizeDouble(MAX_LENGTH * Point() * mtp, Digits()))
      return true;
   return false;
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

string TTS(const datetime& t){
   return TimeToString(t);
}