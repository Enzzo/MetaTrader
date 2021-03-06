//+------------------------------------------------------------------+
//|                                                        table.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\include\\trade.mqh"

#import "stdlib.ex4"
string ErrorDescription(int);
#import

CTrade trade;

struct Request{
   string symbol;
   double price;
   double sl;
   double tp;
   double risk;
};

Request r[];

int SLIPPAGE = 5;

void SkipTitle(const int);
void ShowRequest(const Request& []);
string DTS(const double, const int);
double FileStringToDouble(const int);

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
//---
   const string path = "table.csv";
   
   ResetLastError();
   int fileHandle = FileOpen(path, FILE_READ|FILE_CSV);

   if (fileHandle == INVALID_HANDLE){
      Print(ErrorDescription(GetLastError()));
      return;
   }
   
   Skip(fileHandle, 5);
   
      
   while(!FileIsEnding(fileHandle)){
      static int i = 0;
      ArrayResize(r, i+1);
      const string symbol = FileReadString(fileHandle);
      
      if(!SymbolSelect(symbol, true)) {
         Wrong("Symbol ["+symbol + "] doesn't exist");
         Skip(fileHandle, 4);
         continue;
      }
      
      r[i].symbol = symbol;
      r[i].price  = FileStringToDouble(fileHandle);
      r[i].sl     = FileStringToDouble(fileHandle);
      r[i].tp     = FileStringToDouble(fileHandle);
      r[i].risk   = FileStringToDouble(fileHandle);     
      
      i++;
   }
   
   FileClose(fileHandle);
   
   for(int i = 0; i < ArraySize(r); ++i){
      Trade(r[i].symbol, r[i].price, r[i].sl, r[i].tp, r[i].risk);
   }
   
}
//+------------------------------------------------------------------+

void Skip(const int fHandle, const int t){
   for(int i = 0; i < t; i++)
      FileReadString(fHandle);
}

void ShowRequest(const Request& req[]){
   for(int i = 0; i < ArraySize(req); ++i){
      int digits = (int)SymbolInfoInteger(req[i].symbol, SYMBOL_DIGITS);
      Print("Symbol: "+req[i].symbol+"    Price: "+DTS(req[i].price, digits)+"    TP: "+DTS(req[i].tp, digits)+"    SL: "+DTS(req[i].sl, digits)+"    Risk: "+DTS(req[i].risk));
   }
}

string DTS(const double d, int digits = 2){
   return DoubleToString(d, digits);
}

double FileStringToDouble(const int handle){
   string level = FileReadString(handle);
   StringReplace(level, ",",".");
   return StringToDouble(level);
}

bool Trade(const string symbol, const double pr, const double sl, const double tp, double risk){
   
   if(sl == 0.0) risk = 0.0;
   int pts = 1;
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   //Рассчитаем количество пунктов до стоплосса
   if(sl != 0.0){
      //Если цена не задана и ордер будет рыночным, то
      if(pr == 0.0){
         if(sl < Bid) pts = (int)((Ask-sl)/point);
         else if(sl > Ask) pts = (int)((sl-Bid)/point);
      }
      //Если цена задана и будет отложенный ордер, то
      else{
         if(sl < pr) pts = (int)((pr-sl)/point);
         else if(pr < sl)pts = (int)((sl- pr)/point);
      }
   }
   
   //1, 2)
   if(tp == 0.0 && sl == 0.0){
      return Wrong(symbol+ ": set a stop loss or take profit line");
   }
   
   //(3, 4, 7)
   if(pr == 0.0){
      
      //РИСКА НЕТ
      //3)
      if(sl == 0.0){
         if(tp > ask) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         if(tp < bid) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         return Wrong(symbol+ ": take profit can't be inside the spread");
      }
      
      //РИСК ЕСТЬ
      //4)
      if(tp == 0.0){
         if(sl < bid) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         if(sl > ask) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         return Wrong(symbol+ ": stop loss can't be inside the spread");
      }
      
      //7
      if(tp > ask && sl > ask){
         return Wrong(symbol+ ": take profit and stop loss above the opening price");
      }
      if(tp < bid && sl < bid){
         return Wrong(symbol+ ": take profit and stop loss below the opening price");
      }
      if(tp > ask && sl < bid) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      if(tp < bid && sl > ask) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      return Wrong(symbol+ ": 7 E");
   }
   //(5, 6, 8)
   else{
   
      //РИСКА НЕТ
      //5
      if(sl == 0.0){
         if(tp > pr){
            if(pr > ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr < ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            
            if(pr == ask)return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         if(tp < pr){
            if(pr < bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr > bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == bid)return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         //5 D
         return Wrong(symbol+ ": take profit cannot be equal to the opening price");         
      }
      
      //РИСК ЕСТЬ
      //6
      if(tp == 0.0){
         if(sl < pr){
            if(pr > ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr < ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == ask)return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         if(sl > pr){
            if(pr < bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr > bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == bid)return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         //6 D
         return Wrong(symbol+ ": stop loss cannot be equal to the opening price");
      }
      
      //8 ВСЕ ЛИНИИ НА ГРАФИКЕ
      if(tp == sl || tp == pr || sl == pr)return Wrong(symbol+ ": price levels cannot be equal");
      if(tp > pr && sl > pr)return Wrong(symbol+ ": take profit and stop loss above the opening price");
      if(tp < pr && sl < pr)return Wrong(symbol+ ": take profit and stop loss below the opening price");
      if(tp > pr){
         if(pr > ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
         if(pr < ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
                     return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      }
      if(tp < pr){
         if(pr > bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
         if(pr < bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
                     return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      }
   }
   return false;
}

//+------------------------------------------------------------------+
bool Wrong(const string msg){
   Alert(msg);
   return false;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//r - риск %, p - пункты до стоплосса
double AutoLot(const string& symbol, const double risk, const int p){
   double l = MarketInfo(symbol, MODE_MINLOT);
   
   l = NormalizeDouble((AccountBalance()/100*risk/(p*MarketInfo(symbol, MODE_TICKVALUE))), 2);
   
   if(l > MarketInfo(symbol, MODE_MAXLOT))l = MarketInfo(symbol, MODE_MAXLOT);
   if(l < MarketInfo(symbol, MODE_MINLOT))l = MarketInfo(symbol, MODE_MINLOT);
   return l;
}