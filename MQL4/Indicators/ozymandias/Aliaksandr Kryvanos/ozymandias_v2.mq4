//+------------------------------------------------------------------+
//|                                                Ozymandias v2.mq4 |
//|                                      Copyright 2014, GoldnMoney  |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, GoldnMoney"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrChartreuse
#property indicator_width1 2
#property indicator_color2 clrOrange
#property indicator_width2 2
#property indicator_color3 clrChartreuse
#property indicator_width3 0
#property indicator_color4 clrOrange
#property indicator_width4 0

extern int Length=2;

double up[],down[],zoneup[],zonedown[],map[];
double bandup[],banddown[];
double minhi=0,maxlo=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(5);
   SetIndexBuffer(0,up);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(1,down);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(2,zoneup);
   SetIndexStyle(2,DRAW_LINE,STYLE_DASHDOT);
   SetIndexBuffer(3,zonedown);
   SetIndexStyle(3,DRAW_LINE,STYLE_DASHDOT);
   SetIndexBuffer(4,map,INDICATOR_CALCULATIONS);

   SetIndexLabel(0,"Up");
   SetIndexLabel(1,"Down");
   SetIndexLabel(2,"ZoneUp");
   SetIndexLabel(3,"ZoneDown");

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
   double lowprice,highprice,lowma,highma,zone;

   if(prev_calculated==0)
      int limit=rates_total-Length-1;
   if(prev_calculated>0)
      limit=rates_total-prev_calculated;

   for(int i=limit; i>=0; i--)
     {
      lowprice=iLow(NULL,0,iLowest(NULL,0,MODE_LOW,Length,i));
      highprice=iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,Length,i));

      lowma=iMA(NULL,0,Length,0,MODE_SMA,PRICE_LOW,i);
      highma=iMA(NULL,0,Length,0,MODE_SMA,PRICE_HIGH,i);

      zone=iATR(NULL,0,100,i)/2;

      maxlo=MathMax(lowprice,maxlo);
      minhi=MathMin(highprice,minhi);

      map[i]=map[i+1];

      if(highma<maxlo && close[i]<low[i+1])
        {
         map[i]=-1;
         maxlo=lowprice;
        }
      if(lowma>minhi && close[i]>high[i+1])
        {
         map[i]=1;
         minhi=highprice;
        }

      if(map[i]>0 && map[i+1]<0)
        {
         up[i]=down[i+1];
         up[i+1]=up[i];
         zoneup[i]=zonedown[i+1];
        }

      if(map[i]>0 && map[i+1]>0)
        {
         up[i]=MathMax(maxlo,up[i+1]);
         zoneup[i]=up[i]-zone;    
        }

      if(map[i]<0 && map[i+1]>0)
        {
         down[i]=up[i+1];
         down[i+1]=down[i];
         zonedown[i]=zoneup[i+1];
        }

      if(map[i]<0 && map[i+1]<0)
        {
         down[i]=MathMin(minhi,down[i+1]);
         zonedown[i]=down[i]+zone;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
