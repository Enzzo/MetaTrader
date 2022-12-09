//+------------------------------------------------------------------+
//|                                          ea_signal_indicator.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <custom/expert.mqh>

// Indicator buffers
// [0] центральная линия после стрелки вверх (сигнал на покупку)
// [1] центральная линия после стрелки вниз (сигнал на продажу)
// [2] верхняя линия
// [3] нижняя линия

string ind_name = "signal_indicator\\Signal indicator.ex4";

input int      SL       = 60;
input int      TP       = 60;
input double   VOLUME   = .01;

Expert ea;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   ea.SetStopLoss(SL).SetTakeProfit(TP).SetVolume(VOLUME).SetSignal(GetSignal);
   EventSetTimer(1);   
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   EventKillTimer();
}
void OnTimer(){
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   ea.Run();
}
//+------------------------------------------------------------------+

void TestBuffers(int bc = 1){
   Print("----------------------------------------------------------------");
   /*
   for(int i = 0; i < bc; ++i){
      double b = iCustom( Symbol(), 
                           PERIOD_CURRENT, 
                           ind_name,
                           PERIOD_CURRENT,
                           4, 6.0,
                           false, false, false, false, false, true, true, true, i, 0);
      if(b != EMPTY_VALUE && b != 0.0){
         Print("["+ITS(i)+"] "+ DTS(b));
      }
   }
   */
   double b = iCustom( Symbol(), 
                           PERIOD_CURRENT, 
                           ind_name,
                           PERIOD_CURRENT,
                           4, 6.0,
                           false, false, false, false, false, true, true, true, 0, 0);
   Print(DTS(b));
}

Signal GetSignal(){
   double s1,s2;
   Signal s;
   s.id = 0.0;
   s.type = -1;
   
   s1 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 0, 0);
   
   s2 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 1, 2);

   if(s1 != EMPTY_VALUE && s1 != 0.0 && 
      s2 != EMPTY_VALUE && s2 != 0.0){
      s.id = iOpen(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_BUY;
      return s;
   }
   
   
   s1 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 1, 0);
   
   s2 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 0, 2);
   
   if(s1 != EMPTY_VALUE && s1 != 0.0 && 
      s2 != EMPTY_VALUE && s2 != 0.0) {
      s.id = iOpen(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_SELL;
      return s;
   }   
   return s;                     
}

string DTS(double v, int d = 5){
   return DoubleToString(v, d);
}

string ITS(int v){
   return IntegerToString(v);
}