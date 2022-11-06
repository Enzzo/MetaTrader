//+------------------------------------------------------------------+
//|                                                 PRICECHANNEL.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 0987123476;//Магик

string botName = "PRICECHANNEL";

int OnInit(){
   trade.SetExpertMagic(magic);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){

   
}

void OnTick(){
   
   s = Signal();
   switch(s){
      case 0:
         if(Total(OP_BUY) == 0){
            trade.Buy(Symbol(), volume, 
         }
      break;
      case 1:
   }
   
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