//+------------------------------------------------------------------+
//|                                                 shfgsdfgsdfg.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <Trade.mqh>

CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int magic = 2319471;
input double vol = 0.01;
input int SL = 50;
input int TP = 25;
input int EMA1_period=10;
input int EMA2_period=50;
input int EMA3_period=200;
input int Stochastic_period=30;
input int CCI_period=50;
input int RSI_period=14;
input int MACD_period=20;

string botName = "asdffasfd";

int OnInit(){
//---
   trade.SetExpertMagic(magic);
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
   if(Total() == 0)
      SendOrders(Signal());      
}
//+------------------------------------------------------------------+

int Signal(){
   double ema1,ema2,sto, cci, rsi, macd, macds, ema3;
   ema1=iMA(Symbol(),NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema2=iMA(Symbol(),NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema3=iMA(Symbol(),NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   cci =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,0); 
   rsi =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,0); 
   macd=iMACD(Symbol(),NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
   macds=iMACD(Symbol(),NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
   int buy = 0;
   int sell = 0;
   
      if ( ema2>ema1 && ema1>ema3 ) buy++; 
      if ( ema2<ema1 && ema1<ema3 )sell++; 
  
      if ( sto>80 )buy++;     
      if ( sto<20 )sell++;

      if ( cci>100) buy++;
      if ( cci<-100)sell++;
      
      if ( rsi<35 )sell++;
      if ( rsi>65 )buy++;

      if ( macd<0 && macd<macds )sell++;
      if ( macd>0 && macd>macds )buy++;
      
      if(buy == 5)
         return 0;
      if(sell == 5)
         return 1;
      
   return -1;
}

int Total(){
   int count = 0;
   if(OrdersTotal() != 0){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__,"  ",GetLastError());
            return count;
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            count++;
         }
      }
   }
   //Print("count = ",count);
   return count;
};

void SendOrders(int s = -1){
   switch(s){
      case 0:
         trade.Buy(Symbol(), PERIOD_CURRENT, vol, SL, TP, botName);return;
      case 1:
         trade.Sell(Symbol(), PERIOD_CURRENT, vol, SL, TP, botName);return;
   }
}