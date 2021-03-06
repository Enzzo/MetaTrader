//+------------------------------------------------------------------+
//|                                                       MARTIN.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int               magic       = 3298284;        //Магик
input ENUM_TIMEFRAMES   period      = PERIOD_CURRENT; //Таймфрейм
input double            volume      = 0.01;           //Объем
input int               Channel     = 100;            //Канал (п)
input double            k           = 2.0;            //Коэффициент мартин
input string            comm1       = "MA1 (медленная)";
input int               MA1period   = 200;            //Период
input int               MA1shift    = 0;              //Сдвиг
input string            comm2       = "MA2 (быстрая)";
input int               MA2period   = 20;             //Период
input int               MA2shift    = 0;              //Сдвиг
input int               MAoffset    = 500;            //Расстояние между мувингами (п)


int mtp;
string botName;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   botName = "MARTIN";
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
      if(Total() == 0)Trade();
      trade.TralPointsGeneral(Channel);
}
//+------------------------------------------------------------------+

void Trade(){
   if(OrdersHistoryTotal() == 0){
      Start();
      return;
   }
   int total = OrdersHistoryTotal();
   bool x = false;
   for(int i = total - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(OrderProfit() > 0.0){
            Start();
            return;
         }
         else if(OrderProfit() < 0.0){
            double MA1 = iMA(Symbol(), period, MA1period, MA1shift, MODE_EMA, PRICE_CLOSE, 1);
            double MA2 = iMA(Symbol(), period, MA2period, MA2shift, MODE_EMA, PRICE_CLOSE, 1);
            if(/*OrderType() == OP_BUY*/MA1-MAoffset*Point()*mtp > MA2)trade.Sell(Symbol(), OrderLots()*k > MarketInfo(Symbol(), MODE_MAXLOT)?MarketInfo(Symbol(), MODE_MAXLOT):OrderLots()*k, Channel, Channel, botName);
            if(/*OrderType() == OP_SELL*/MA1+MAoffset*Point()*mtp < MA2)trade.Buy(Symbol(), OrderLots()*k > MarketInfo(Symbol(), MODE_MAXLOT)?MarketInfo(Symbol(), MODE_MAXLOT):OrderLots()*k, Channel, Channel, botName);
            return;
         }
      }         
   }
   Start();
}

void Start(){
   double MA1 = iMA(Symbol(), period, MA1period, MA1shift, MODE_EMA, PRICE_CLOSE, 1);
   double MA2 = iMA(Symbol(), period, MA2period, MA2shift, MODE_EMA, PRICE_CLOSE, 1);
   
   if(MA1+MAoffset*Point()*mtp < MA2)trade.Buy( Symbol(), volume, Channel, 0, botName);
   if(MA1-MAoffset*Point()*mtp > MA2)trade.Sell(Symbol(), volume, Channel, 0, botName);
}

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