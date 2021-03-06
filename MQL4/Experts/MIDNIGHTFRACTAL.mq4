//+------------------------------------------------------------------+
//|                                              MIDNIGHTFRACTAL.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <trade.mqh>

CTrade trade;

input int               magic       = 98138;          //магик
input ENUM_TIMEFRAMES   period      = PERIOD_CURRENT; //Таймфрейм
//input int               offset      = 10;             //Сдвиг отложки от фрактала
input int               TP          = 100;            //Тейкпрофит
input int               SL          = 50;             //Стоплос
input double            volume      = 0.01;           //Лот
//input int               tral        = 20;             //Трал (п)
//input int               expiration  = 10;             //Экспирация (ч)

int mtp;
string botName;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   botName = "MIDNIGHT";
   trade.SetExpertMagic(magic);
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)mtp = 10;
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
   double upper = iFractals(Symbol(), period, MODE_UPPER, 2);
   double lower = iFractals(Symbol(), period, MODE_LOWER, 2);
   //if(Total(OP_BUYSTOP)  == 0 && upper > 0.0)trade.BuyStop( Symbol(), volume, NormalizeDouble(upper + offset*Point()*mtp + (Ask - Bid), Digits()), SL, TP, botName, TimeCurrent()+expiration*3600);
   //if(Total(OP_SELLSTOP) == 0 && lower > 0.0)trade.SellStop(Symbol(), volume, NormalizeDouble(lower - offset*Point()*mtp, Digits()),               SL, TP, botName, TimeCurrent()+expiration*3600);

      if(upper > 0.0)trade.Sell(Symbol(), volume, SL, TP, botName);
      else if(lower > 0.0)trade.Buy(Symbol(), volume, SL, TP, botName);
   //trade.TralPointsGeneral(tral);
}
//+------------------------------------------------------------------+

short Total(short t = -1){
   if(OrdersTotal() == 0)
      return 0;
   bool x = false;
   short count = 0;
   for(int i = OrdersTotal() - 1; i>= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(t == -1 || OrderType() == t)count++;
      }
   }
   return count;
}