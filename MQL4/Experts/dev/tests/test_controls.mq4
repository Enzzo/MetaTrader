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
   AppWindow.Create(ChartID(), "window", 0, 20, 20, 360, 324);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   AppWindow.Destroy();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
   AppWindow.ChartEvent(id, lparam, dparam,sparam);
}