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
   
   SkipTitle(fileHandle);
   
   int i = 0;   
   while(!FileIsEnding(fileHandle)){
      ArrayResize(r, i+1);
      r[i].symbol = FileReadString(fileHandle);      
      r[i].price  = FileStringToDouble(fileHandle);
      r[i].sl     = FileStringToDouble(fileHandle);
      r[i].tp     = FileStringToDouble(fileHandle);
      r[i].risk   = FileStringToDouble(fileHandle);
      
      i++;
   }
   
   FileClose(fileHandle);
   ShowRequest(r);
}
//+------------------------------------------------------------------+

void SkipTitle(const int fHandle){
   for(int i = 0; i < 5; i++)
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

//TODO:
bool Trade(const string symbol, const double pr, const double sl, const double tp, double risk){
   
   if(sl == 0.0) risk = 0.0;
   int pts = 1;
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double bid =
   double ask = 
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
      return Wrong("set a stop loss or take profit line");
   }
   
   //(3, 4, 7)
   if(pr == 0.0){
      
      //РИСКА НЕТ
      //3)
      if(sl == 0.0){
         if(tp > Ask) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         if(tp < Bid) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         return Wrong("take profit can't be inside the spread");
      }
      
      //РИСК ЕСТЬ
      //4)
      if(tp == 0.0){
         if(sl < Bid) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         if(sl > Ask) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         return Wrong("stop loss can't be inside the spread");
      }
      
      //7
      if(tp > Ask && sl > Ask){
         return Wrong("take profit and stop loss above the opening price");
      }
      if(tp < Bid && sl < Bid){
         return Wrong("take profit and stop loss below the opening price");
      }
      if(tp > Ask && sl < Bid) return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      if(tp < Bid && sl > Ask) return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      return Wrong("7 E");
   }
   //(5, 6, 8)
   else{
   
      //РИСКА НЕТ
      //5
      if(sl == 0.0){
         if(tp > pr){
            if(pr > Ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr < Ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            
            if(pr == Ask)return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         if(tp < pr){
            if(pr < Bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr > Bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == Bid)return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         //5 D
         return Wrong("take profit cannot be equal to the opening price");         
      }
      
      //РИСК ЕСТЬ
      //6
      if(tp == 0.0){
         if(sl < pr){
            if(pr > Ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr < Ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == Ask)return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         if(sl > pr){
            if(pr < Bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr > Bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
            if(pr == Bid)return trade.Sell(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
         }
         //6 D
         return Wrong("stop loss cannot be equal to the opening price");
      }
      
      //8 ВСЕ ЛИНИИ НА ГРАФИКЕ
      if(tp == sl || tp == pr || sl == pr)return Wrong("control levels cannot be equal");
      if(tp > pr && sl > pr)return Wrong("take profit and stop loss above the opening price");
      if(tp < pr && sl < pr)return Wrong("take profit and stop loss below the opening price");
      if(tp > pr){
         if(pr > Ask)return trade.BuyStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
         if(pr < Ask)return trade.BuyLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
                     return trade.Buy(symbol, AutoLot(symbol, risk, pts), sl, tp, SLIPPAGE);
      }
      if(tp < pr){
         if(pr > Bid)return trade.SellLimit(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
         if(pr < Bid)return trade.SellStop(symbol, AutoLot(symbol, risk, pts), pr, sl, tp, 0);
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
   
   if(l > MarketInfo(symbol, MODE_MAXLOT))l = MarketInfo(Symbol(), MODE_MAXLOT);
   if(l < MarketInfo(symbol, MODE_MINLOT))l = MarketInfo(symbol, MODE_MINLOT);
   return l;
}