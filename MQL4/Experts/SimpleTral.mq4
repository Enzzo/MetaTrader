//+------------------------------------------------------------------+
//|                                                   TralTester.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Tral.mqh>

enum tralType{
   points,  //По пунктам
   ma,      //По МА
   parab    //По параболику
};

input tralType tt = 0;     //Трал 
input int      points = 40;//Пункты для трала по пунктам
Tral tr;

void OnTick(){
   int total = OrdersTotal();
   if(total != 0){
      for(int i = 0; i < total; i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," error: ",GetLastError());
            return;
         }
         if(OrderSymbol() == Symbol() && OrderTakeProfit() == 0.0)
            StartTrail(OrderTicket());
      }
   }
}
//+------------------------------------------------------------------+

void StartTrail(int t){
   switch(tt){
      case 0:
         tr.TralPointAccurate(t, points); 
         break;
      case 1:
         tr.TralMAAccurate(t);
         break;
      case 2:
         tr.TralParabAccurate(t);
         break;
   }
}