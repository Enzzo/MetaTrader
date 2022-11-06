//+------------------------------------------------------------------+
//|                                                        diver.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 9889987;
input double volume = 0.01;
input int   TP  = 0;
input int   SL = 60;
input int   tral = 30;
string botName = "Diver";
datetime pTime;
datetime cTime[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   pTime = 0;
   trade.SetExpertMagic(magic);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   CopyTime(Symbol(), NULL, 0, 1, cTime);
   if(pTime == cTime[0])
      return;
   pTime = cTime[0];
   int s = (int)iCustom(Symbol(), PERIOD_CURRENT, "diver", 4, 2); 
   switch (s){
      case 0: trade.Buy( Symbol(), MartinLot(volume), SL, TP, botName); break;
      case 1: trade.Sell(Symbol(), MartinLot(volume), SL, TP, botName); break;
   }
   trade.TralPointsGeneral(tral);
}
//+------------------------------------------------------------------+

double MartinLot(double v = 0.01){
   /*if(OrdersHistoryTotal() > 0){
      for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderProfit() < 0.0){
            v = OrderLots()*2;
            break;
         }
      }
   }*/
   if(v < MarketInfo(Symbol(), MODE_MINLOT))
      v = MarketInfo(Symbol(), MODE_MINLOT);
   if(v > MarketInfo(Symbol(), MODE_MAXLOT))
      v = MarketInfo(Symbol(), MODE_MAXLOT);
   return v;
}