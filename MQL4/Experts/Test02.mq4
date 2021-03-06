//+------------------------------------------------------------------+
//|                                                       Test02.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

input int magic = 1218818;
input int MNPeriod = 24;
input int H1Period = 24;
input int M1Period1= 24;
input int M1Period2= 5;
input int sl       = 0;
input int tp       = 0;
input double lot = 0.01;

      int M1S;
      int M1F;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   if(M1Period1 < M1Period2){
      M1F = M1Period1;
      M1S = M1Period2;
   }
   else{
      M1F = M1Period2;
      M1S = M1Period1;
   }
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
   Comment("");
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   Comment("");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(M1F == M1S){
      Comment("Периоды М1 не должны быть равны");
      return;
   }
   Trade(OP_BUY);
   Trade(OP_SELL);
}
//+------------------------------------------------------------------+

bool Trading(int d = -1){
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == d)return true;
      }
   }
   return false;
}

//МА на месячном, часовом и минутном
//Пересечение на часовом

void Trade(int d = -1){
   if(Trading(d))return;
   MqlRates MNRates[];
   MqlRates H1Rates[];
   //MqlRates M1Rates[];
   
   RefreshRates();
   
   CopyRates(Symbol(), PERIOD_D1,0, 2, MNRates);
   CopyRates(Symbol(), PERIOD_H1, 0, 3, H1Rates);
   //CopyRates(Symbol(), PERIOD_M1, 0, 2, M1Rates);
   
   if(ArraySize(MNRates) < 2 || ArraySize(H1Rates) < 2/* || ArraySize(M1Rates) < 3*/)return;
   
   double MAMN[2];
   double MAH1[2];
   double MAM1[4];

   ArraySetAsSeries(MNRates, true);
   ArraySetAsSeries(H1Rates, true);
   //ArraySetAsSeries(M1Rates, true);
   
   if(d == 1){
      
      
      MAMN[0] = NormalizeDouble(iMA(Symbol(), PERIOD_D1, MNPeriod, 0, MODE_EMA, PRICE_HIGH, 0), Digits());
      MAMN[1] = NormalizeDouble(iMA(Symbol(), PERIOD_D1, MNPeriod, 0, MODE_EMA, PRICE_HIGH, 1), Digits());
      MAH1[0] = NormalizeDouble(iMA(Symbol(), PERIOD_H1, H1Period, 0, MODE_EMA, PRICE_HIGH, 0), Digits());
      MAH1[1] = NormalizeDouble(iMA(Symbol(), PERIOD_H1, H1Period, 0, MODE_EMA, PRICE_HIGH, 1), Digits());
      MAM1[0] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1F,      0, MODE_EMA, PRICE_HIGH, 0), Digits());
      MAM1[1] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1F,      0, MODE_EMA, PRICE_HIGH, 2), Digits());
      MAM1[2] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1S,      0, MODE_EMA, PRICE_HIGH, 0), Digits());
      MAM1[3] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1S,      0, MODE_EMA, PRICE_HIGH, 2), Digits());
      
      if(MNRates[0].low > MAMN[0] && //MNRates[1].low > MAMN[1] &&
         H1Rates[0].low > MAH1[0] && //H1Rates[1].low > MAH1[1] &&
         MAM1[0] > MAM1[2]/* && MAM1[3] > MAM1[1]*/){
            trade.Sell(Symbol(), lot, sl, tp);
            if(Trading(OP_BUY))trade.CloseBuy();
            return;
         }
         
   }
   else if(d == 0){
      
      MAMN[0] = NormalizeDouble(iMA(Symbol(), PERIOD_D1, MNPeriod, 0, MODE_EMA, PRICE_LOW, 0), Digits());
      MAMN[1] = NormalizeDouble(iMA(Symbol(), PERIOD_D1, MNPeriod, 0, MODE_EMA, PRICE_LOW, 1), Digits());
      MAH1[0] = NormalizeDouble(iMA(Symbol(), PERIOD_H1, H1Period, 0, MODE_EMA, PRICE_LOW, 0), Digits());
      MAH1[1] = NormalizeDouble(iMA(Symbol(), PERIOD_H1, H1Period, 0, MODE_EMA, PRICE_LOW, 1), Digits());
      MAM1[0] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1F,      0, MODE_EMA, PRICE_LOW, 0), Digits());
      MAM1[1] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1F,      0, MODE_EMA, PRICE_LOW, 2), Digits());
      MAM1[2] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1S,      0, MODE_EMA, PRICE_LOW, 0), Digits());
      MAM1[3] = NormalizeDouble(iMA(Symbol(), PERIOD_M1, M1S,      0, MODE_EMA, PRICE_LOW, 2), Digits());
      
      if(MNRates[0].high < MAMN[0] && //MNRates[1].high < MAMN[1] &&
         H1Rates[0].high < MAH1[0] && //H1Rates[1].high < MAH1[1] &&
         MAM1[0] < MAM1[2] /*&& MAM1[3] < MAM1[1]*/){
            trade.Buy(Symbol(), lot, sl, tp);
            if(Trading(OP_SELL))trade.CloseSell();
            return;
         }
   }
   else return;   
}