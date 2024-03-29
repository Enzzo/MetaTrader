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

input int            MAGIC    = 33311;

input string         ind_name = "Signal indicator.ex4";

input bool           FIXED    = true;  // SL TP фиксированные 
input bool           BUFFERS  = true;  // SL TP по индикатору

input int            SL       = 20;
input int            TP       = 60;
input double         VOLUME   = .01;
input ENUM_STRATEGY  STRATEGY = EVERY_CROSS_CLOSE; // Выставлять ордера

Expert ea(MAGIC, Symbol(), "");

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---   
   ea.SetStrategy(EVERY_CROSS_CLOSE).SetVolume(VOLUME).SetSignal(GetSignal);
   
   if(FIXED)  ea.SetStopLoss(SL).SetTakeProfit(TP);
   if(BUFFERS)ea.SetStopLoss(Buffer1).SetStopLoss(Buffer2).SetTakeProfit(Buffer1).SetTakeProfit(Buffer2);
   
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

double Buffer1(){
   return iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 2, 0);
}

double Buffer2(){
   return iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 3, 0);
}

//------------------------------------------------------------
// GetSimpleSignalByMA
//
// Выполняет один из видов выставления ордеров
//------------------------------------------------------------
Signal GetSimpleSignalByMA(){
   double s1 = iMA(Symbol(), PERIOD_CURRENT, 14,0, MODE_EMA, PRICE_CLOSE, 1);
   double f1 = iMA(Symbol(), PERIOD_CURRENT, 4, 0, MODE_EMA, PRICE_CLOSE, 1);
   double s2 = iMA(Symbol(), PERIOD_CURRENT, 14,0, MODE_EMA, PRICE_CLOSE, 2);
   double f2 = iMA(Symbol(), PERIOD_CURRENT, 4, 0, MODE_EMA, PRICE_CLOSE, 2);
   
   Signal s;
   s.id = 0.0;
   s.type = -1;
   
   if(s1 < f1 && f2 <= s2){
      s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_BUY;
   }
   else if(f1 < s1 && s2 <= f2){
      s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_SELL;
   }
   
   return s;
}

Signal GetSimpleSignalByMAFast(){
   double s1 = iMA(Symbol(), PERIOD_CURRENT, 14,0, MODE_EMA, PRICE_CLOSE, 1);
   double f1 = iMA(Symbol(), PERIOD_CURRENT, 4, 0, MODE_EMA, PRICE_CLOSE, 1);
   
   Signal s;
   s.id = 0.0;
   s.type = -1;
   
   if(s1 < f1){
      s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_BUY;
   }
   else if(f1 < s1){
      s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
      s.type = OP_SELL;
   }
   // Print("ID: "+ITS(s.id));
   return s;
}

//------------------------------------------------------------
// GetSignal
//
// Выполняет один из видов выставления ордеров
//------------------------------------------------------------
Signal GetSignal(){
   double s1,s2;
   Signal s;
   s.id = 0.0;
   s.type = -1;
   
   s1 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 0, 2);
   
   s2 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 1, 2);

   if(s1 != EMPTY_VALUE && s1 != 0.0 && 
      s2 != EMPTY_VALUE && s2 != 0.0){
      
      double s3 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 0, 3);

      if(s3 != EMPTY_VALUE && s3 != 0.0){
         s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
         s.type = OP_SELL;
         return s;
      }
      
      s3 = iCustom( Symbol(),PERIOD_CURRENT, 
                     ind_name,
                     PERIOD_CURRENT,
                     4, 6.0,
                     false, false, false, false, false, true, true, true, 1, 3);
                     
      if(s3 != EMPTY_VALUE && s3 != 0.0){
         s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
         s.type = OP_BUY;
         return s;
      }

   }
   
   
//   s1 = iCustom( Symbol(),PERIOD_CURRENT, 
//                     ind_name,
//                     PERIOD_CURRENT,
//                     4, 6.0,
//                     false, false, false, false, false, true, true, true, 1, 2);
//   
//   s2 = iCustom( Symbol(),PERIOD_CURRENT, 
//                     ind_name,
//                     PERIOD_CURRENT,
//                     4, 6.0,
//                     false, false, false, false, false, true, true, true, 0, 2);
//   
//   if(s1 != EMPTY_VALUE && s1 != 0.0 && 
//      s2 != EMPTY_VALUE && s2 != 0.0) {
//      s.id = (int)iTime(Symbol(), PERIOD_CURRENT, 0);
//      s.type = OP_SELL;
//      return s;
//   }   
   return s;                     
}

string DTS(double v, int d = 5){
   return DoubleToString(v, d);
}

string ITS(int v){
   return IntegerToString(v);
}