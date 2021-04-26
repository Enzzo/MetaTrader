//+------------------------------------------------------------------+
//|                                                       JUNIOR.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 23987;
input double volume = 0.01;
input ushort bars = 5;  //Количество свечей для рассчета
input int TP = 40;
input int SL = 40;
input int offset = 5; //отступ ордеров
input ushort num = 2;  //свеча для трала
input ushort ofs = 5;  //отступ трала от high/low

int mtp;
double high;
double low;
string botName = "JUNIOR";

datetime pTime = 0;
datetime cTime[1];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   trade.SetExpertMagic(magic);
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
   
   CopyTime(Symbol(), PERIOD_CURRENT, 0, 1, cTime);
   
      
   if(Total(OP_BUY) > 0)trade.DeleteType(OP_SELLSTOP);
   if(Total(OP_SELL) > 0)trade.DeleteType(OP_BUYSTOP);
   trade.TralCandles(num, ofs);
   if(pTime == cTime[0])
      return;
   pTime = cTime[0];

   
   if(Junior()){
      /*trade.DeleteType(OP_SELLSTOP);
      trade.DeleteType(OP_BUYSTOP); */
      if(Total(OP_BUYSTOP)  == 0 && Total(OP_BUY) == 0)trade.BuyStop(Symbol(), volume, NormalizeDouble(high + offset*mtp*Point(), Digits()), SL, TP, botName);
      if(Total(OP_SELLSTOP) == 0 && Total(OP_SELL) == 0)trade.SellStop(Symbol(), volume, NormalizeDouble(low - offset*mtp*Point(), Digits()),SL, TP, botName);
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

bool Junior(){
   if(bars <= 1){
      Comment("Баров должно быть не менее двух.");
      return false;
   }
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, bars, rates);
   if(ArraySize(rates)<bars)
      return false;
   ArraySetAsSeries(rates, true);
   
   high = 0;
   low  = 0;
   
   for(int i = 1; i < bars; i++){
      if(rates[0].high - rates[0].low > rates[i].high - rates[i].low)
         return false;
   }
   
   high = rates[0].high;
   low  = rates[0].low;
   
   return true;
}
