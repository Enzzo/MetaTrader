//+------------------------------------------------------------------+
//|                                                    Grid_v6.0.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>
#include <GridAdvisor.mqh>

CTrade trade;
GridAdvisor *GA;

enum gaMode{
   manual,
   rsi,
   macd,
   stoch
};

input int      magic    = 87654;
input gaMode   gm       = manual;
input int      offset   = 10;
input int      maxCount = 10;

      int mtp = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   switch(gm){
      case 0:  GA = new Manual();  break;
      case 1:  GA = new RSI();     break;
      case 2:  GA = new MACD();    break;
      case 3:  GA = new Stoch();   break;
      default:return(INIT_FAILED); 
   }
   
   trade.SetExpertMagic(magic);
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
   //IF TOTAL == 0 GUISTART()
   //ELSE IF TOTAL > 0 GUIGRID()
   
   //IF (BUTTON_SELECT == ISPRESSED) THEN GUISELECT()
}
//+------------------------------------------------------------------+

int Total(){
   int count = 0;
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            count++;
         }
      }
   }
   return count;
}