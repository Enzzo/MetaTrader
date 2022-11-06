//+------------------------------------------------------------------+
//|                                                       expert.mqh |
//|                                                   Sergey_Vasilev |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey_Vasilev"
#property link      "https://www.mql5.com"
#property strict

class Expert{
   struct Order{
      string symbol;
      int ticket;
   };
   
   Order orders_[];
   
   string GetSymbol(const int t){
      return IntegerToString(EMPTY_VALUE);
   }
   int GetTicket(const string& s){
      return EMPTY_VALUE;
   }
public:
   Expert(){}
};