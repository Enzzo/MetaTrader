//+------------------------------------------------------------------+
//|                                                test_controls.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Controls/Dialog.mqh>

CAppDialog AppWindow;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   if(!AppWindow.Create(0, "AppWindow", 0, 20, 20, 360, 324)){
      return (INIT_FAILED);
   }
   
   AppWindow.Run();
//---
   return(INIT_SUCCEEDED);
  }
  
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
   AppWindow.OnEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   AppWindow.Destroy();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
