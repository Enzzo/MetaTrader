//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+

//VER 0.01 22/06/2020
//UPD: Проверка сигналов по периодам, а не по тикам
//UPD: Поиск направления (паттерна "Поглощение") при первой инициализации

#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>
CTrade trade;

struct Fractal{
   datetime time;
   double price;
   Fractal(){Init();};
   void Init(){time = 0; price = 0.0;};
   string Show()const {
      return "Time: "+ TTS(time)+ "   Price: "+ DTS(price);
   }
}fr;

input int MAGIC = 129813;
input string OTIME = "08:00";    //Открытие сессии
input string CTIME = "20:00";    //Закрытие сессии
input int LIFETIME = 5;          //закрытие сделки, если профит отрицательный (ч)
input int OFFSET = 1;            //допустимое минимальное расстояние между закрытием и экстремумом (пункты)
input bool DRAW_ABSORP = true;   //отрисовывать паттерн "Поглощение"
input bool DRAW_LEVELS = true;   //отрисовывать уровни пробоя фрактала
input bool NOTIFY = true;        //отправлять уведомления
input bool TRADE = false;        //разрешить торговать автоматически
input double VOLUME = 0.01;      //Лот
input int TP = 20;               //Тейкпрофит
input int SL = 120;              //Стоплосс
string shortName = "Tandem";

datetime oTime;
datetime cTime;

double offset;

ushort dir;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

   dir = 0;
   offset = NormalizeDouble(OFFSET  * Point(), Digits());

   trade.SetExpertMagic(MAGIC);
   ObjectsDelete(shortName);
   oTime = StringToTime(OTIME);
   cTime = StringToTime(CTIME);
   if(cTime < oTime)cTime += 86400;
   SetDirection(dir);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectsDelete(shortName);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
   SetDirection(dir);
   
   if(IsTradingTime()){
      SetBaseFractal(dir, fr);
      Trade(dir, fr);
   }
   
   CheckForExpiration();
   //
}
//+------------------------------------------------------------------+

bool IsTradingTime(){
   datetime tc = TimeCurrent();
   if(tc > cTime){
      oTime += 86400;
      cTime += 86400;
   }
   //string info = oTime+"  "+cTime+"  "+tc;
   if((oTime <= tc && tc < cTime)||
      (oTime == cTime)){
      //info += " открыто. ";
      Comment("СЕССИЯ ОТКРЫТА");
      return true;
   }
   //info += " закрыто.";
   Comment("СЕССИЯ ЗАКРЫТА");
   return false;
}

//Функция проверки экспирации отрицательных сделок.
//Закрывает позицию, если через заданное время она окажется отрицательной
void CheckForExpiration(){

   for(int i = OrdersTotal()-1; i >= 0; --i){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == MAGIC && OrderSymbol() == Symbol()){
         if(OrderProfit() < 0.0 && TimeCurrent() - OrderOpenTime() > (LIFETIME * 3600))
            x = OrderClose(OrderTicket(), OrderLots(), OrderType() == OP_BUY?Bid:Ask, 3); 
      }
   }
}

//d == 1 - MODE_UPPER
//d == 2 - MODE_LOWER
//Устанавливает контрольный фрактал, от которогобудем торговать
//Срабатывает каждый час
void SetBaseFractal(const unsigned short d, Fractal& f){
   
   static datetime pt = 0;
   datetime ct = iTime(Symbol(), PERIOD_H1, 1);
   if(pt == ct) return;
   pt = ct;

   if(0 < d && d < 3){
      double temp = iFractals(Symbol(), PERIOD_H1, d, 3);
      if(temp > 0.0){
         f.price = temp;
         f.time = iTime(Symbol(), PERIOD_H1, 3);
      }
   }
}
void Trade(const unsigned short d, Fractal& f){
   //Comment(ITS(d)+"  "+f.Show());
   static double prevAsk = EMPTY_VALUE;
   static double prevBid = EMPTY_VALUE;

   if(f.price <= 0.0)return;
   //Если цена - вверх и цена ниже целевого нижнего фрактала, то покупаем
   if(d == 2 && Ask <= f.price && prevAsk > f.price){
      //BUY
      if(DRAW_LEVELS){
         ArrowCreate("up", iTime(Symbol(), PERIOD_H1, 0), Ask, 233, ANCHOR_TOP, clrGreen);
         TrendCreate("up", f.time, f.price, iTime(Symbol(), PERIOD_H1, 0), Ask, clrGreen);
      }
      if(TRADE)trade.Buy(Symbol(), VOLUME, SL, TP);
      if(NOTIFY) SendNotification(Symbol()+" Сигнал BUY");
      f.Init();
   }
   else if(d == 1 && Bid >= f.price && prevBid < f.price){
      //SELL
      if(DRAW_LEVELS){
         ArrowCreate("dn", iTime(Symbol(), PERIOD_H1, 0), Bid, 234, ANCHOR_BOTTOM, clrRed);
         TrendCreate("dn", f.time, f.price, iTime(Symbol(), PERIOD_H1, 0), Bid, clrRed);
      }
      if(TRADE)trade.Sell(Symbol(), VOLUME, SL, TP);
      if(NOTIFY) SendNotification(Symbol()+" Сигнал SELL");
      f.Init();
   }
   prevAsk = Ask;
   prevBid = Bid;
}

//Функция срабатывает каждый день и ищет паттерн "Поглощение"
//d - direction - направление паттерна "Поглощение"
void SetDirection(ushort& d){
   /*
   static datetime pt = 0;
   datetime ct = iTime(Symbol(), PERIOD_D1, 1);
   if(pt == ct) return;
   pt = ct;
   */
   MqlRates d1[];
   ArraySetAsSeries(d1, true);

   if(!CopyRates(Symbol(), PERIOD_D1, 1, iBars(Symbol(), PERIOD_D1)-2, d1))return;
   
   for(int i = 0; i < ArraySize(d1); ++i){
      if(d1[i].close > (d1[i+1].high + offset)){
         if(DRAW_ABSORP){
            //ищем индекс наивысшего значения и сохраняем значение и время в переменные h и t
            int e = iHighest(Symbol(), PERIOD_H1, MODE_HIGH, 23, 23*i);
            double h = iHigh(Symbol(), PERIOD_H1, e);
            datetime t = iTime(Symbol(), PERIOD_H1, e);
            //обновляем индекс и ищем низший low
            e = iLowest(Symbol(), PERIOD_H1, MODE_LOW, 23, 23*i);
            double l = iLow(Symbol(), PERIOD_H1, e);

            RectangleCreate("up", d1[i].time, h, t, l, clrLightGreen);
         }
         //Переключаем d на MODE_LOWER и ориентируемся на нижние фракталы
         d = 2;
         return;
      }
      else if(d1[i].close < (d1[i+1].low - offset)){
         if(DRAW_ABSORP) {
            //ищем индекс низшего значения и сохраняем значение и время в переменные l и t
            int e = iLowest(Symbol(), PERIOD_H1, MODE_LOW, 23, 23*i);
            double l = iLow(Symbol(), PERIOD_H1, e);
            datetime t = iTime(Symbol(), PERIOD_H1, e);
            //обновляем индекс и ищем высший high
            e = iHighest(Symbol(), PERIOD_H1, MODE_HIGH, 23, 23*i);
            double h = iHigh(Symbol(), PERIOD_H1, e);

            RectangleCreate("dn", d1[i].time, h, t, l, clrPink);
         }
         //Переключаем d на MODE_UPPER и ориентируемся на верхние фракталы
         d = 1;
         return;
      }
   }
}

//Чистим график от объектов с именем, содержащим строку n в своём названии
void ObjectsDelete(const string& n){
   Comment("");
   string name; 
   for(int i = ObjectsTotal(ChartID())-1; i >= 0; --i){
      name = ObjectName(i);
      if(StringFind(name, n) > -1)   
         ObjectDelete(name);
   }
}

bool RectangleCreate(const string          n="Rectangle",     // имя прямоугольника 
                     datetime              time1=0,           // время первой точки 
                     double                price1=0,          // цена первой точки 
                     datetime              time2=0,           // время второй точки 
                     double                price2=0,          // цена второй точки 
                     const color           clr=clrRed         // цвет прямоугольника 
){
   const string name = shortName + n + ITS((int)time1)+"rect";
   const long chart_ID = ChartID();

   if(ObjectFind(chart_ID, name) == 0) return true;

   ResetLastError(); 

   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,0,time1,price1,time2,price2)){ 
      Print(__FUNCTION__, ": не удалось создать прямоугольник! Код ошибки = ",GetLastError()); 
      return(false); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0);
   return(true); 
}

string ITS(const int i){
   return IntegerToString(i);
}
string ITS(const ulong i){
   return ITS((int)i);
}

string TTS(const datetime t){
   return TimeToString(t);
}
string DTS(const double d){
   return DoubleToString(d);
}

bool ArrowCreate(const string            n="Arrow",            // имя стрелки 
                 datetime                time=0,               // время точки привязки 
                 double                  price=0,              // цена точки привязки 
                 const uchar             arrow_code=252,       // код стрелки 
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // положение точки привязки 
                 const color             clr=clrRed,           // цвет стрелки 
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // стиль окаймляющей линии 
                 const int               width=1               // размер стрелки 
                 ){
   const string name = shortName + n + ITS((int)time)+"arrow";
   const long chart_ID = ChartID();
   
   if(ObjectFind(chart_ID, name) == 0) return true;

   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,0,time,price)){ 
      Print(__FUNCTION__, 
            ": не удалось создать стрелку! Код ошибки = ",GetLastError()); 
      return(false); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
   return(true); 
}

bool TrendCreate(
                 const string          n="TrendLine",  // имя линии 
                 datetime              time1=0,           // время первой точки 
                 double                price1=0,          // цена первой точки 
                 datetime              time2=0,           // время второй точки 
                 double                price2=0,          // цена второй точки 
                 const color           clr=clrRed,        // цвет линии 
                 const int             width=1,           // толщина линии 
                 const long            z_order=0)         // приоритет на нажатие мышью 
                 {
//--- сбросим значение ошибки 
const string name = shortName + n + ITS((int)time1)+ITS((int)time2)+"trend";
const long chart_ID = ChartID();
if(ObjectFind(chart_ID, name) == 0) return true;
ResetLastError(); 
//--- создадим трендовую линию по заданным координатам 
if(!ObjectCreate(chart_ID,name,OBJ_TREND,0,time1,price1,time2,price2)){ 
   Print(__FUNCTION__, 
         ": не удалось создать линию тренда! Код ошибки = ",GetLastError()); 
   return(false); 
}
//--- установим цвет линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0);
   return(true);
}