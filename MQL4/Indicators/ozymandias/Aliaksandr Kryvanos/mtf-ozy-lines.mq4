//+------------------------------------------------------------------+
//|                                                      mtf-ozy.mq4 |
//|                       Copyright 2014, GoldenMoney Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, GoldenMoney Software Corp."
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 MediumSeaGreen
#property indicator_color2 IndianRed
#property indicator_color3 MediumSeaGreen
#property indicator_color4 IndianRed


extern int TimeFrame=0;
extern string IndicatorName="ozymandias_v2";

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
string TimeFrameStr;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);

   SetIndexStyle(2,DRAW_LINE,STYLE_DASHDOT);
   SetIndexBuffer(2,ExtMapBuffer3);

   SetIndexStyle(3,DRAW_LINE,STYLE_DASHDOT);
   SetIndexBuffer(3,ExtMapBuffer4);

   switch(TimeFrame)
     {
      case 0 : TimeFrameStr="PERIOD_CURRENT"; break;
      case 1 : TimeFrameStr="PERIOD_M1"; break;
      case 5 : TimeFrameStr="PERIOD_M5"; break;
      case 15 : TimeFrameStr="PERIOD_M15"; break;
      case 30 : TimeFrameStr="PERIOD_M30"; break;
      case 60 : TimeFrameStr="PERIOD_H1"; break;
      case 240 : TimeFrameStr="PERIOD_H4"; break;
      case 1440 : TimeFrameStr="PERIOD_D1"; break;
      case 10080 : TimeFrameStr="PERIOD_W1"; break;
      case 43200 : TimeFrameStr="PERIOD_MN1"; break;
     }
   IndicatorShortName("MTF_Ozymandias ("+TimeFrameStr+")");

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

   datetime TimeArray[];
   int    i,limit,y=0,counted_bars=prev_calculated;
   ArrayCopySeries(TimeArray,MODE_TIME,NULL,TimeFrame);

   limit=Bars-prev_calculated;
   for(i=0,y=0;i<limit;i++)
     {
      if(Time[i]<TimeArray[y]) y++;

      ExtMapBuffer1[i]=iCustom(NULL,TimeFrame,IndicatorName,0,y);
      ExtMapBuffer2[i]=iCustom(NULL,TimeFrame,IndicatorName,1,y);
      ExtMapBuffer3[i]=iCustom(NULL,TimeFrame,IndicatorName,2,y);
      ExtMapBuffer4[i]=iCustom(NULL,TimeFrame,IndicatorName,3,y);
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+