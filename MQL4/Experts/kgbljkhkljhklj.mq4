//+------------------------------------------------------------------+
//|                                               kgbljkhkljhklj.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <Trade.mqh>

CTrade trade;

string botName = ";alkj";

input int magic = 1234541235;
input double vol = 0.01;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(Total() == 0)
      SendOrder();
}
//+------------------------------------------------------------------+

int Total(){
   int count = 0;
   if(OrdersTotal() != 0){
      for(int i = 0; i < OrdersTotal(); i++){
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

void SendOrder(){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)MarketInfo(Symbol(), MODE_SPREAD);
   double price = 0.0;
   int total = 0;
   bool t = false;
   if(OrdersHistoryTotal() == 0){
      trade.Buy(Symbol(), PERIOD_CURRENT, vol, 0, 40, botName);
      return;
   }
   else{      
      total = OrdersHistoryTotal();
      for(int i = total - 1; i >= 0; i--){
         t = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderProfit() < 0.0){
               if(OrderType() == OP_BUY){
                  trade.Sell(Symbol(), PERIOD_CURRENT, vol, 0, 40, botName);
                  return;
               }
               else if(OrderType() == OP_SELL){
                  trade.Buy(Symbol(), PERIOD_CURRENT, vol, 0, 40, botName);
                  return;
               }
            }
            else{
               if(OrderType() == OP_BUY){
                  trade.Buy(Symbol(), PERIOD_CURRENT, vol, 0, 40, botName);
                  return;
               }
               else if(OrderType() == OP_SELL){
                  trade.Sell(Symbol(), PERIOD_CURRENT, vol, 0, 40, botName);
                  return;
               }
            }
         }
      }
   }
}