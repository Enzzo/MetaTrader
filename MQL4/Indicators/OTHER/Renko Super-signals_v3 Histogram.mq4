//+------------------------------------------------------------------+
//|                                      Super-signals histogram.mq4 |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 2
#property indicator_color1 clrRed
#property indicator_color2 clrBlue
#property indicator_width1 4
#property indicator_width2 4

extern int  SuperSignalsPeriod = 96; 

double b1[],b2[];
bool UpTrend = false;
bool DnTrend = false;
int  TimeFrame;
int  shift=SuperSignalsPeriod/2;

//---------------------------

int init()
{
   IndicatorBuffers(2);
   SetIndexBuffer(0,b1); SetIndexStyle(0,DRAW_HISTOGRAM); 
   SetIndexBuffer(1,b2); SetIndexStyle(1,DRAW_HISTOGRAM);
   TimeFrame  = MathMax(TimeFrame,_Period);
   IndicatorShortName(timeFrameToString(TimeFrame)+" Super-signals histogram ("+SuperSignalsPeriod+")"); 
   return(0);
}

//----------------------------

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit,hhb,llb;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   limit=MathMax(limit,SuperSignalsPeriod);

   for (i=limit;i>=0;i--)
      {
         hhb = Highest(NULL,0,MODE_HIGH,SuperSignalsPeriod,i-shift);
         llb = Lowest(NULL,0,MODE_LOW,SuperSignalsPeriod,i-shift);
      
         if (i==hhb) {b1[i]=1; DnTrend=true; UpTrend=false;} 
         else if (i==llb) {b2[i]=1; UpTrend=true; DnTrend=false;}
         else if (DnTrend==true) b1[i]=b1[i+1];
         else if (UpTrend==true) b2[i]=b2[i+1];
      }
 
  return(0);
}

//-------------------------------------------------------------------------------------

string sTfTable[] = {"M1","M2","M3","M5","M10","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,2,3,5,10,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//-------------------------------------------------------------------------------------