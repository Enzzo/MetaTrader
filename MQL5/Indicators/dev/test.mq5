//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property indicator_chart_window

#property indicator_plots 1
#property indicator_buffers 1
#property indicator_label1 "l1"
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID
#property indicator_color1 clrRed
#property indicator_width1 1

input uint N = 5;

double line_buffer[];

color colors[] = {clrRed, clrGreen, clrYellow};

ENUM_LINE_STYLE styles[] = {STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT};

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   SetIndexBuffer(0, line_buffer, INDICATOR_DATA);

   MathSrand(GetTickCount());
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, 
                const int prev_calculated, 
                const datetime& time[], 
                const double& open[], 
                const double& high[], 
                const double& low[], 
                const double& close[], 
                const long& tick_volume[], 
                const long& volume[], 
                const int& spread[]){
//---

   static ushort tick_count = 0;
   ++tick_count;
   
   if(tick_count > N){
      ChangeLineAppearance();
      tick_count = 0;
   }

   for(int i = 0; i < rates_total; i++){
      line_buffer[i] = close[i];
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

void ChangeLineAppearance(){

}