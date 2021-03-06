//+------------------------------------------------------------------+
//|                                                       HOTBOS.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#property description "HOTBOS (Heads Or Tails Buy Or Sell)"

#include <Trade.mqh>

CTrade trade;

input int      magic    = 5611234;        //Магик
input string   row      = "11"; //Ряд сигналов
input int      SL       = 40;             //Стоплос
input int      TP       = 40;             //Тейкпрофит
input double   volume   = 0.01;           //Лот
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
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
   Sleep(300000);
   int s = Signal();
   switch(s){
      case 0:
            trade.Buy(Symbol(), volume, SL, TP, "HOTBOS");
         break;
      case 1:
            trade.Sell(Symbol(), volume, SL, TP, "HOTBOS");
         break;
   }
}
//+------------------------------------------------------------------+


int Signal(){
   if(Total() > 0)return -1;
   static short s = -1;
   if(s >= StringLen(row)-1)s = -1;
   s++;
   
   if(row[s] == 48)return 0;
   if(row[s] == 49)return 1;
   
   return -1;
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

double MartinLot(){
   if(OrdersHistoryTotal() == 0)return volume;
   bool x = false;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderProfit() < 0.0){
            Sleep(3000000);
            return OrderLots()*2.0;
         }
         else return volume;
      }
   }
   return volume;
}