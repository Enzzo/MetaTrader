//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers   1
#property indicator_plots     1
// plot Label1
#property indicator_label1 "Label1"
#property indicator_type1  DRAW_LINE
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1
// indicator buffers
double   label1_buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   SetIndexBuffer(0, label1_buffer, INDICATOR_DATA);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double& price[]){
//---
   Print("begin = ", begin, " prev_calculated = ", prev_calculated, " rates_total = ", rates_total);
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
