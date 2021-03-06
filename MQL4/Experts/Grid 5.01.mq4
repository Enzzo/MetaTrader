//+------------------------------------------------------------------+
//|                                                       Grid05.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

//buy
//вход:   1)отсутствуют рыночные ордера по магику
//        2)D1  MA(12) ниже цены;
//        3)H1  MA(8)  ниже цены;
//        4)М15 МА(20) ниже цены;
//        5)М5  RSI(8) выше 50;

//выход:  1)М15 МА(20)выше цены; 
//        2)М5 RSI(8) < 40; 
//        3)профит положительный

//sell
//вход:   1)отсутствуют рыночные ордера по магику
//        2)D1  MA(12) выше цены;
//        3)H1  MA(8)  выше цены;
//        4)М15 МА(20) выше цены;
//        5)М5  RSI(8) ниже 50;

//выход:  1)М15 МА(20)ниже цены; 
//        2)М5 RSI(8) > 60; 
//        3)профит положительный

#include <Trade.mqh>

CTrade trade;

input int magic = 8971;
//input int offset = 30;
input double volume = 0.01;
//input double profit = 2.0;
int mtp = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   if(Digits() == 5 || Digits() == 3)mtp = 10;
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
   //Comment("Highest: "+High[iHighest(Symbol(), PERIOD_M15, MODE_HIGH, 30, 0)]+"\n"+"Lowest: "+Low[iLowest(Symbol(), PERIOD_M15, MODE_LOW, 30, 0)]);
   MqlRates D1Rates[];
   MqlRates H1Rates[];
   MqlRates M15Rates[];
     
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1,  0, 3, D1Rates);
   CopyRates(Symbol(), PERIOD_H1,  0, 3, H1Rates);
   CopyRates(Symbol(), PERIOD_M15, 0, 3, M15Rates);
      
   ArraySetAsSeries(D1Rates,  true);
   ArraySetAsSeries(H1Rates,  true);
   ArraySetAsSeries(M15Rates, true);
      
   double ma200 = iMA(Symbol(), PERIOD_MN1, 200, 0, MODE_EMA, PRICE_CLOSE, 1);
   double ma50  = iMA(Symbol(), PERIOD_MN1,  50, 0, MODE_EMA, PRICE_CLOSE, 1);
 //double atr   = iATR(Symbol(), PERIOD_D1, 14, 1);
   if(Total() == 0){      
      if(ArraySize(D1Rates)!=3 || ArraySize(H1Rates)!=3 || ArraySize(M15Rates)!=3)return;
      
      if(      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<D1Rates[0].low  &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)<D1Rates[1].low  &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)<D1Rates[2].low  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<H1Rates[0].low  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)<H1Rates[1].low  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)<H1Rates[2].low  &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<M15Rates[0].low &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<M15Rates[1].low &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)<M15Rates[2].low &&
               iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)>50){
                  if(Ask > ma200 && Ask > ma50 && ma50 > ma200)//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
                     trade.Buy(Symbol(), volume, 0, 0);
               }
      
      else if( iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>D1Rates[0].high  &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)>D1Rates[1].high  &&
               iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)>D1Rates[2].high  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>H1Rates[0].high  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)>H1Rates[1].high  &&
               iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)>H1Rates[2].high  &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>M15Rates[0].high &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>M15Rates[1].high &&
               iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)>M15Rates[2].high &&
               iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)<50){
                  if(Bid < ma200 && Bid < ma50 && ma50 < ma200)//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
                  trade.Sell(Symbol(), volume, 0, 0);
               }
      
   }
   else {
      BuildGrid();
      TakeProfit();
   }
}
//+------------------------------------------------------------------+
void BuildGrid(){
   int type = -1;
   double price = 0.0;
   for(int i = OrdersTotal() - 1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         type = OrderType();
         price = OrderOpenPrice();
         
         if((Bid < OrderOpenPrice() && Bid > NormalizeDouble(OrderOpenPrice()-iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Bid > OrderOpenPrice() && Bid < NormalizeDouble(OrderOpenPrice()+iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Ask < OrderOpenPrice() && Ask > NormalizeDouble(OrderOpenPrice()-iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Ask > OrderOpenPrice() && Ask < NormalizeDouble(OrderOpenPrice()+iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())))
            return;
      }
   }
   MqlRates D1Rates[];
   MqlRates H1Rates[];
   MqlRates M15Rates[];
   MqlRates MN1Rates[];
   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1,  0, 3, D1Rates);
   CopyRates(Symbol(), PERIOD_H1,  0, 3, H1Rates);
   CopyRates(Symbol(), PERIOD_M15, 0, 3, M15Rates);
   CopyRates(Symbol(), PERIOD_MN1, 1, 1, MN1Rates);
   
   ArraySetAsSeries(D1Rates,  true);
   ArraySetAsSeries(H1Rates,  true);
   ArraySetAsSeries(M15Rates, true);
   ArraySetAsSeries(MN1Rates, true);
   
   if(ArraySize(D1Rates)<3 || ArraySize(H1Rates)<3 || ArraySize(M15Rates)<3 || ArraySize(MN1Rates)<1)return;
   if(type == 0 && 
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<D1Rates[0].low  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)<D1Rates[1].low  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)<D1Rates[2].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<H1Rates[0].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)<H1Rates[1].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)<H1Rates[2].low  &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<M15Rates[0].low &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<M15Rates[1].low &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)<M15Rates[2].low &&
      iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)>50){
      if(Ask > iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
         //if(price != 0.0 && Ask < price - iATR(Symbol(), PERIOD_D1, 14, 1))
            trade.Buy(Symbol(), volume, 0, 0);
      }
   else if(type == 1 && 
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>D1Rates[0].high  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)>D1Rates[1].high  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)>D1Rates[2].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>H1Rates[0].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)>H1Rates[1].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)>H1Rates[2].high  &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>M15Rates[0].high &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>M15Rates[1].high &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)>M15Rates[2].high &&
      iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)<50){
      if(Bid < iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
         //if(price != 0.0 && Bid > price + iATR(Symbol(), PERIOD_D1, 14, 1))
         trade.Sell(Symbol(), volume, 0, 0);
      }
   /*int buy = Total(0);
   int sell = Total(1);
   
   if(buy > 0 && MN1Rates[0].high < iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))trade.CloseBuy();
   if(sell > 0 && MN1Rates[0].low > iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))trade.CloseSell();*/
}

void TakeProfit(){
   double p = 0.0;
   int    type = -1;
   for(int i = OrdersTotal()-1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         p += OrderSwap()+OrderCommission()+OrderProfit();
         type = OrderType();
      }
   }
   if(p > 0.0){
      if((type == 0) && (iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1) < 40) && (iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<Low[1]) ||
         (type == 1) && (iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1) > 60) && (iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>High[1]))
         trade.CloseTrades();
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