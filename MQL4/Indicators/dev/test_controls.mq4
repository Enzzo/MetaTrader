//+------------------------------------------------------------------+
//|                                                test_controls.mq4 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include <Controls/Dialog.mqh>

CAppDialog AppWindow;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()  {
//--- indicator buffers mapping
   if(!AppWindow.Create(0, "Test Window", 0, 20, 20, 360, 324)){
      return (INIT_FAILED);
   }
   AppWindow.Run();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam){
   AppWindow.OnEvent(id, lparam, dparam, sparam);
}

void OnDeinit(const int reason){
   AppWindow.Destroy();
}