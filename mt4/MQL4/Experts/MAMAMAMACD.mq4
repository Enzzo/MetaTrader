//+------------------------------------------------------------------+
//|                                                   MAMAMAMACD.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <Trade.mqh>

CTrade trade;

input int               magic    = 13411134;
input int               SL       = 40;
input int               TP       = 80;
input double            volume   = 0.01;
input ENUM_TIMEFRAMES   tf       = PERIOD_CURRENT;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
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
   double ma5     = iMA(Symbol(),   tf, 5,  0, MODE_EMA, PRICE_CLOSE, 1);
   double ma75    = iMA(Symbol(),   tf, 75, 0, MODE_LWMA, PRICE_LOW, 1);
   double ma85    = iMA(Symbol(),   tf, 85, 0, MODE_LWMA, PRICE_LOW, 1);
   double macd    = iMACD(Symbol(), tf, 15, 26, 1, PRICE_CLOSE, MODE_MAIN, 1);
   double ma5_2   = iMA(Symbol(),   tf, 5,  0, MODE_EMA, PRICE_CLOSE, 3);
   double ma75_2  = iMA(Symbol(),   tf, 75, 0, MODE_LWMA, PRICE_LOW, 3);
   double ma85_2  = iMA(Symbol(),   tf, 85, 0, MODE_LWMA, PRICE_LOW, 3);
   double macd_2  = iMACD(Symbol(), tf, 15, 26, 1, PRICE_CLOSE, MODE_MAIN, 3);
   
   static short maCross = -1;
   static short macdCross = -1;
   
   if(ma5 > ma75 && ma5 > ma85 && ma5_2 < ma75_2 && ma5_2 < ma85_2)  maCross     = 0; 
   if(macd > 0.0 && macd_2 < 0.0)                                    macdCross   = 0;
   if(ma5 < ma75 && ma5 < ma85 && ma5_2 > ma75_2 && ma5_2 > ma85_2)  maCross     = 1; 
   if(macd < 0.0 && macd_2 > 0.0)                                    macdCross   = 1;
   
   if(maCross == 0 && macdCross == 0){
      maCross = -1;
      macdCross = -1;
      if(!Consist(OP_BUY))trade.Buy(Symbol(), volume, SL, TP);
   }
   if(maCross == 1 && macdCross == 1){
      maCross = -1;
      macdCross = -1;
      if(!Consist(OP_SELL))trade.Sell(Symbol(), volume, SL, TP);
   }
}
//+------------------------------------------------------------------+
bool Consist(int dir){
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == dir)return true;
      }
   }
   return false;
}