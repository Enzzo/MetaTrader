//+------------------------------------------------------------------+
//|                                             Super-signals_v3.mq4 |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 clrRed
#property indicator_color2 clrLime
#property indicator_color3 clrRed
#property indicator_color4 clrLime
#property indicator_color5 clrRed
#property indicator_color6 clrLime
#property indicator_color7 clrRed
#property indicator_color8 clrLime
#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 6
#property indicator_width4 6
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 4
#property indicator_width8 4

extern int  PeriodWeakChannel = 24;
extern int  PeriodMainChannel = 96;
extern bool alertsOn        = true;
extern bool alertsMessage   = true;
extern bool alertsSound     = false;
extern bool alertsEmail     = false;
extern string soundFile     ="alert2.wav";

double b1[],b2[],b3[],b4[],b5[],b6[],b7[],b8[];
int    TimeFrame;
int    shift1=PeriodWeakChannel/2;
int    shift2=PeriodMainChannel/2;

//---------------------------

int init()
{
   TimeFrame = MathMax(TimeFrame,_Period);
   IndicatorBuffers(8);
   SetIndexBuffer(0,b1); SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,164);
   SetIndexBuffer(1,b2); SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,164);
   SetIndexBuffer(2,b3); SetIndexStyle(2,DRAW_ARROW); SetIndexArrow(2,164);
   SetIndexBuffer(3,b4); SetIndexStyle(3,DRAW_ARROW); SetIndexArrow(3,164);
   SetIndexBuffer(4,b5); SetIndexLabel(4,"Upper weak channel");
   SetIndexBuffer(5,b6); SetIndexLabel(5,"Lower weak channel");
   SetIndexBuffer(6,b7); SetIndexLabel(6,"Upper Main channel");
   SetIndexBuffer(7,b8); SetIndexLabel(7,"Lower Main channel");
   IndicatorShortName(timeFrameToString(TimeFrame)+" Super-signals ("+PeriodWeakChannel+","+PeriodMainChannel+")");
   return(0);
}

//----------------------------

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit,hhb1,llb1,hhb2,llb2;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=Bars-counted_bars;
           limit=MathMax(limit,PeriodMainChannel);

   for (i=limit;i>=0;i--)
      {
         hhb1 = Highest(NULL,0,MODE_HIGH,PeriodWeakChannel,i-shift1);
         llb1 = Lowest(NULL,0,MODE_LOW,PeriodWeakChannel,i-shift1);
         hhb2 = Highest(NULL,0,MODE_HIGH,PeriodMainChannel,i-shift2);
         llb2 = Lowest(NULL,0,MODE_LOW,PeriodMainChannel,i-shift2);

         b1[i] = EMPTY_VALUE;
         b2[i] = EMPTY_VALUE;
         b3[i] = EMPTY_VALUE;
         b4[i] = EMPTY_VALUE;
         b5[i] = High[hhb1];
         b6[i] = Low[llb1];
         b7[i] = High[hhb2];
         b8[i] = Low[llb2];
      
         if (i==hhb1) b1[i]=High[hhb1];
         if (i==llb1) b2[i]=Low[llb1];
         if (i==hhb2) b3[i]=High[hhb2];
         if (i==llb2) b4[i]=Low[llb2] ;
      }

//-------------------------------------------------------------
 
   if (alertsOn)
      {
         if (b1[1] != EMPTY_VALUE && b3[1] != EMPTY_VALUE) doAlert(" @ MAIN channel");
         if (b2[1] != EMPTY_VALUE && b4[1] != EMPTY_VALUE) doAlert(" @ MAIN channel");
         if (b1[1] != EMPTY_VALUE && b3[1] == EMPTY_VALUE) doAlert(" @ WEAK channel");
         if (b2[1] != EMPTY_VALUE && b4[1] == EMPTY_VALUE) doAlert(" @ WEAK channel");
      }
   return(0);
}

//-------------------------------------------------------------------------------------

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          message = timeFrameToString(TimeFrame)+" Super-signals "+Symbol()+doWhat;
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol(),"Super-signals "),message);
             if (alertsSound)   PlaySound(soundFile);
      }
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