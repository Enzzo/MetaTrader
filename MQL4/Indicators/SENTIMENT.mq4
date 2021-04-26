//+------------------------------------------------------------------+
//|                                                    SENTIMENT.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 clrOrange
#property indicator_color2 clrBlue

input int inpBarsPeriod = 100;

double bullSentiment[];
double bearSentiment[];
double temp[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
   string short_name;
//--- 1 additional buffer used for counting.
   IndicatorBuffers(3);
   IndicatorDigits(Digits);
//--- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(0,bullSentiment);
   SetIndexStyle(1,DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(1,bearSentiment);
//--- name for DataWindow and indicator subwindow label
   short_name="Sentiment";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,short_name);
   SetIndexBuffer(2,temp);
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
                const int &spread[]){
//---

   int limit=rates_total-prev_calculated;
   if(rates_total < inpBarsPeriod)
      return 0;
   double t;
   double s;
   if(prev_calculated == 0){
      for(int i=0; i<limit-inpBarsPeriod; i++){
         t = 0.0;
         s = 0.0;
         for(int j = 0 + i; j < inpBarsPeriod + i -1; j++){
            s = (((close[j]-low[j])+(high[j]-open[j]))-((high[j]-close[j])+(open[j]-low[j])))*tick_volume[j]/inpBarsPeriod;
            t += s;
         }
         if(t < 0.0){
            bearSentiment[i] = t*(-1)/Digits();
            bullSentiment[i] = 0.0;
         }
         else{
            bullSentiment[i] = t/Digits();
            bearSentiment[i] = 0.0;
         }
      }
   }
   else if(prev_calculated > 0){
      limit++;
      for(int i=0; i<limit+inpBarsPeriod; i++){
         t = 0.0;
         s = 0.0;
         for(int j = 0 + i; j < inpBarsPeriod + i; j++){
            //Print("j: ",j,"  limit: ",limit,"  ArraySize: ",ArraySize(close));
            s = (((close[j]-low[j])+(high[j]-open[j]))-((high[j]-close[j])+(open[j]-low[j])))*tick_volume[j]/inpBarsPeriod;
            t += s;
         }
         if(t < 0.0){
            bearSentiment[i] = t*(-1)/Digits();
            bullSentiment[i] = 0.0;
         }
         else{
            bullSentiment[i] = t/Digits();
            bearSentiment[i] = 0.0;
         }
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
