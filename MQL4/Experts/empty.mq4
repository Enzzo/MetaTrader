//+------------------------------------------------------------------+
//|                                                        empty.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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
void OnTick()
  {
//---
   Print("0 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",0, 1));
   Print("1 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",1, 1));
   Print("2 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",2, 1));
   Print("3 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",3, 1));
   Print("4 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",4, 1));
   Print("5 ",iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",5, 1));
  }
//+------------------------------------------------------------------+
