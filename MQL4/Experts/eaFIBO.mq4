//+------------------------------------------------------------------+
//|                                                       eaFIBO.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <trade.mqh>

CTrade trade;

struct prices{
   datetime time;
   double   price;
};

input int               magic    = 098767;         //магик
input double            volume   = 0.01;           //объем
input ENUM_TIMEFRAMES   period   = PERIOD_CURRENT; //таймфрейм (от H1 до D1)
input double            level    = 0.38;           //уровень ордера по фибо 
input double            TP       = 1.23;           //уровень тейка по фибо 
input double            SL       = 0.0;            //уровень лося по фибо 

double   zeroLevel = 0.0;
bool     isAlert = true;
ENUM_TIMEFRAMES gPeriod;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertComment(WindowExpertName());
   trade.SetExpertMagic(magic);
   if(period == PERIOD_H1)gPeriod = PERIOD_D1;
   if(period == PERIOD_H4)gPeriod = PERIOD_W1;
   if(period == PERIOD_D1)gPeriod = PERIOD_MN1;
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
   if(period < PERIOD_H1 || period > PERIOD_D1){
      if(isAlert){
         Print("Период должен быть не ниже H1 и не выше D1");
         isAlert = false;
      }
      return;
   }
   static datetime t = 0;
   if(t == Time[0])return;
   t = Time[0];
   
   MqlRates rates[];
   datetime day[];
   prices   high[] = {};
   prices   low[] = {};
   
   RefreshRates();
   CopyRates(Symbol(), period, 0, 300, rates);
   CopyTime(Symbol(),  gPeriod, 1, 12, day);
   
   if(ArraySize(rates)<300 || ArraySize(day)<12)return;
   
   ArraySetAsSeries(rates,true);
   ArraySetAsSeries(day,  true);
   ArrayResize(high, ArraySize(day));
   ArrayResize(low,  ArraySize(day));
   
   int j = 0; //подсчет дней

   for(int i = 0; i < ArraySize(rates); i++){      
         
      if(high[j].price < rates[i].high){
         high[j].price = rates[i].high;
         high[j].time  = rates[i].time;
      }
      if(low[j].price > rates[i].low || low[j].price == 0.0){
         low[j].price = rates[i].low;
         low[j].time  = rates[i].time;
      }    
      if(rates[i].time < day[j])     
         j++;         
      if(j>ArraySize(day)-1)
         break;      
   } 
   
   prices min = {0};
   prices max = {0};
   
   for(int i = 1; i < ArraySize(day); i++){
      if(i == 1){
         min = low[0];
         max = high[0];
      }
      if(high[0].time > low[0].time){ //коррекция вверх. ищем импульс вниз
         if(high[i].time < low[i].time){
            if(min.price == 0.0 || min.price > low[i].price)   min = low[i];
            if(max.price < high[i].price)                      max = high[i];         
            continue;
         }
         else if(high[i].time > low[i].time){
            if(i < 2)   return;  
            else        break;          
         }
      }
      else if(high[0].time < low[0].time){ //коррекция вниз. ищем импульс вверх
         if(high[i].time > low[i].time){
            if(min.price == 0.0 || min.price > low[i].price)   min = low[i];
            if(max.price < high[i].price)                      max = high[i];            
            continue;
         }
         else if(high[i].time < low[i].time){
            if(i < 2)   return;
            else        break;              
         }
      }
   }
   static int n = 0;
   string name = "FL"+IntegerToString(n);
   Delete("FL");
   n++;
   FiboLevelsCreate(ChartID(), name, 0, max.time > min.time?max.time:min.time, max.time > min.time?max.price:min.price, max.time > min.time?min.time:max.time, max.time > min.time?min.price:max.price);  
   //Print("Min:  ",min, "   Max:  ",max);
   
   if(max.time > min.time && zeroLevel != min.price){ //1
      double price = NormalizeDouble(min.price + (max.price - min.price)*level, Digits());
      double sl    = NormalizeDouble(min.price + (max.price - min.price)*SL, Digits());
      double tp    = NormalizeDouble(min.price + (max.price - min.price)*TP, Digits());
         
         zeroLevel = min.price;
         
         trade.DeletePendings();

         if(price < Ask) trade.BuyLimit(Symbol(), volume, price, sl, tp);
         
         else if(sl < Ask && tp > Ask)
            //Print("BUY  SL: ",sl,"   TP: ",tp);
            trade.Buy(Symbol(), volume, sl, tp);


   }
   
   else if(max.time < min.time && zeroLevel != max.price){//2
      double price = NormalizeDouble(max.price - (max.price - min.price)*level, Digits());
      double sl    = NormalizeDouble(max.price - (max.price - min.price)*SL, Digits());
      double tp    = NormalizeDouble(max.price - (max.price - min.price)*TP, Digits());

         zeroLevel = max.price;
         trade.DeletePendings();

         if(price > Bid)trade.SellLimit(Symbol(), volume, price, sl, tp);
         else if(sl > Bid && tp < Ask)
            //Print("SELL  SL: ",sl,"   TP: ",tp);
            trade.Sell(Symbol(), volume, sl, tp);
         
   }   
}
//+------------------------------------------------------------------+
bool FiboLevelsCreate(const long            chart_ID=0,        // ID графика 
                      const string          name="FiboLevels", // имя объекта 
                      const int             sub_window=0,      // номер подокна  
                      datetime              time1=0,           // время первой точки 
                      double                price1=0,          // цена первой точки 
                      datetime              time2=0,           // время второй точки 
                      double                price2=0,          // цена второй точки 
                      const color           clr=clrRed,        // цвет объекта 
                      const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии объекта 
                      const int             width=1,           // толщина линии объекта 
                      const bool            back=false,        // на заднем плане 
                      const bool            selection=true,    // выделить для перемещений 
                      const bool            ray_right=false,   // продолжение объекта вправо 
                      const bool            hidden=true,       // скрыт в списке объектов 
                      const long            z_order=0)         // приоритет на нажатие мышью 
{ 
//--- установим координаты точек привязки, если они не заданы 
   
  
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим "Уровни Фибоначчи" по заданным координатам 
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time1,price1,time2,price2)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать \"Уровни Фибоначчи\"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим цвет 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину линии 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим выделения объекта для перемещений 
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект 
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection 
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- включим (true) или отключим (false) режим продолжения отображения объекта вправо 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установи приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,0, clrBlack); 
//--- успешное выполнение 
   return(true); 
} 

void Delete(string n){
   if(ObjectsTotal()>0){
      for(int i = ObjectsTotal()-1; i>=0; i--){
         if(StringFind(ObjectName(ChartID(),i),n)>-1) ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
   }
}