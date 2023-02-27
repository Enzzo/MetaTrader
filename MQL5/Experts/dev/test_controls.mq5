//+------------------------------------------------------------------+
//|                                                test_controls.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"

#include <Controls/Dialog.mqh>

CAppDialog AppWindow;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(!AppWindow.Create(0, "AppWindow", 0, 20, 20, 360, 324)){
      return (INIT_FAILED);
   }
   
   AppWindow.Run();
//---
   return(INIT_SUCCEEDED);
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
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
   AppWindow.ChartEvent(id,lparam,dparam,sparam);
}