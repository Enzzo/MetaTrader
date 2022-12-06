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

int TestFunction(){
   Alert("TEST SUCCESS");
   return 0;
}

int TestFunction2(){
   Alert("TEST2 SUCCESS");
   return 0;
}

Expert ea;

string ind_name = "signal_indicator\\Signal indicator.ex4";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   ea.SetSignal(TestFunction);
   ea.SetSignal(TestFunction2);
   ea.GetSignals();
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
}
//+------------------------------------------------------------------+

void TestBuffers(int bc){
   Print("----------------------------------------------------------------");
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
}



string DTS(double v, int d = 5){
   return DoubleToString(v, d);
}

string ITS(int v){
   return IntegerToString(v);
}