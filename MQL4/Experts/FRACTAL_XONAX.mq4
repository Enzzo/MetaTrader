//+------------------------------------------------------------------+
//|                                                FRACTAL_XONAX.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property description "На пробитии сформированного фрактала"
#property description "выставляет ордер в направлении пробития"

#include <Trade.mqh>

CTrade trade;

input int               magic    = 23111981;       //Магик
input ENUM_TIMEFRAMES   tf       = PERIOD_CURRENT; //Таймфрейм
input double            volume   = 0.01;           //Лот
input int               TP       = 40;             //ТП
input int               SL       = 40;             //СЛ
input ushort            fractal  = 5;              //Бары для рассчета фрактала (нечетные, начиная с 3)
input int               offset   = 10;             //Прорыв фрактала (п)
input bool              tral     = true;           //Трал
input int               tralStep = 10;             //Трал шаг (п)
input int               tralStop = 50;             //Трал отступ (п)

int mtp;

int OnInit(){
//---
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   if(fractal < 3 || fractal%2 == 0){
      Alert("Неверное количество баров для рассчета фрактала.\nМинимальное количество баров = 3\nКоличество должно быть нечетным\nСоветник не работает!!! Заданное количество: "+IntegerToString(fractal));
      return -1;
   }
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
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
   if(fractal < 3 || fractal%2 == 0){
      return;
   }
   static bool stopBuy = false;
   static bool stopSell = false;
   
   static datetime pTime = 0;
   static datetime cTime[1];
   
   CopyTime(Symbol(), tf, 0, 1, cTime);
   if(ArraySize(cTime)<1)
      return;
   
   if(pTime != cTime[0]){
      pTime = cTime[0];
      stopBuy = false;
      stopSell = false;
   }
   
   short s = Signal();
   switch(s){
      case 0:
         if(!stopBuy){trade.Buy(Symbol(), volume, SL, TP);stopBuy = true;}break;
      case 1:
         if(!stopSell){trade.Sell(Symbol(), volume, SL, TP);stopSell = true;}break;
   }
   if(tral)trade.TralPointsGeneral(tralStep, tralStop);
}
//+------------------------------------------------------------------+

short Signal(){
   double upper = Fractal(1, fractal);
   double lower = Fractal(2, fractal);
   static double up = 0.0;
   static double dn = 0.0;
   if(upper != 0.0)up = upper;
   if(lower != 0.0)dn = lower;
   if(up > 0.0 && Ask > up+NormalizeDouble(offset*mtp*Point(), Digits())){up = 0.0;return 0;}
   if(dn > 0.0 && Bid < dn-NormalizeDouble(offset*mtp*Point(), Digits())){dn = 0.0;return 1;}
   
   return -1;
}

//md - режим (1 - UPPER, 2 - LOWER)
//cnt - количество свечей для рассчета
double Fractal(ushort md, ushort cnt){
   if(Bars < cnt+1)
      return 0.0;
      
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), tf, 1, cnt, rates);
   if(ArraySize(rates)<cnt)
      return 0.0;
   double frctl = 0.0;
   uint n = 0;
   double max = 0.0;
   double min = 0.0;
   switch(md){
      case 1:
         for(int i = 0; i < cnt-1; i++){
            if(max < rates[i].high){
               max = rates[i].high;
               n = i;
            }
         }
         if(n == (cnt-1)/2)frctl = max;         
      break;
      case 2:
         for(int i = 0; i < cnt-1; i++){
            if(min == 0.0 || min > rates[i].low){
               min = rates[i].low;
               n = i;
            }
         }
         if(n == (cnt-1)/2)frctl = min;
      break;
   }
   return frctl;
}