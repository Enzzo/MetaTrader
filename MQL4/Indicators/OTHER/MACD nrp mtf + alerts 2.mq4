//------------------------------------------------------------------
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1  C'0,200,0'//LimeGreen
#property indicator_color2  Red//PaleVioletRed
#property indicator_color3  Red//PaleVioletRed
#property indicator_color4  Silver//Red
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_style4  STYLE_DOT
#property indicator_level1  0
//
#property  indicator_levelcolor Silver
#property  indicator_levelstyle 0
#property  indicator_levelwidth 1
//
//
//
//
//

extern ENUM_TIMEFRAMES TimeFrame = PERIOD_CURRENT;
extern int  FastEMA   = 12;
extern int  SlowEMA   = 26;
extern int  SignalEMA =  9;
extern ENUM_APPLIED_PRICE Price = PRICE_CLOSE;
extern bool ColorOnSignalCross = true;
extern bool   alertsOn         = false;
extern bool   alertsOnCurrent  = false;
extern bool   alertsMessage    = true;
extern bool   alertsSound      = false;
extern bool   alertsEmail      = false;
extern bool   Interpolate      = true;

double macd[];
double macdDa[];
double macdDb[];
double signal[];
double colors[];
string indicatorFileName;
bool   returnBars;

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//

int init()
{
   IndicatorBuffers(5);
   SetIndexBuffer(0,macd);
   SetIndexBuffer(1,macdDa);
   SetIndexBuffer(2,macdDb);
   SetIndexBuffer(3,signal);
   SetIndexBuffer(4,colors);
         indicatorFileName = WindowExpertName();
         returnBars        = (TimeFrame==-99);
         TimeFrame         = MathMax(TimeFrame,_Period);
      IndicatorShortName(timeFrameToString(TimeFrame)+" MACD nrp_csc ("+FastEMA+","+SlowEMA+","+SignalEMA+")");
   return(0);
}
int deinit()
{
   return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

double emas[][2];
int start()
{
   double alphaSign = 2.0/(1.0+SignalEMA);
   double alphaFast = 2.0/(1.0+FastEMA);
   double alphaSlow = 2.0/(1.0+SlowEMA);
   int i,r,counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
         if (returnBars) { macd[0] = limit+1; return(0); }
         if (TimeFrame!=Period())
         {
            limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,TimeFrame,indicatorFileName,-99,0,0)*TimeFrame/Period()));
            if (colors[limit]==-1) CleanPoint(limit,macdDa,macdDb);
            for (i=limit; i>=0; i--)
            {   
               int y = iBarShift(NULL,TimeFrame,Time[i]);
                  macd[i]   = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,FastEMA,SlowEMA,SignalEMA,Price,ColorOnSignalCross,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsEmail,0,y);
                  macdDa[i] = EMPTY_VALUE;
                  macdDb[i] = EMPTY_VALUE;
                  signal[i] = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,FastEMA,SlowEMA,SignalEMA,Price,ColorOnSignalCross,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsEmail,3,y);
                  colors[i] = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,FastEMA,SlowEMA,SignalEMA,Price,ColorOnSignalCross,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsEmail,4,y);

                  if (!Interpolate || y == iBarShift(NULL,TimeFrame,Time[i-1])) continue;

                  //
                  //
                  //
                  //
                  //

                  datetime time = iTime(NULL,TimeFrame,y);
                     for(int n = 1; i + n < Bars && Time[i+n] >= time; n++) continue;	
                     for(int x = 1; x < n; x++)
                     {
                        macd[i+x]   = macd[i]   + (macd[i+n]   - macd[i]  ) * x/n;
                        signal[i+x] = signal[i] + (signal[i+n] - signal[i]) * x/n;
                     }
            }
            for (i=limit; i>=0; i--) if (colors[i]==-1) PlotPoint(i,macdDa,macdDb,macd);
            return(0);
         }            

   //
   //
   //
   //
   //
   
   if (ArrayRange(emas,0) != Bars) ArrayResize(emas,Bars);
   if (colors[limit]==-1) CleanPoint(limit,macdDa,macdDb);
   for(i = limit, r=Bars-i-1; i >= 0 ; i--,r++)
   {
      double price = iMA(NULL,0,1,0,MODE_SMA,Price,i);
      if (i>Bars-2)
      {
         emas[r][0] = price;
         emas[r][1] = price;
         macd[i]    = 0;
         signal[i]  = 0;
         continue;
      }

      emas[r][0] = emas[r-1][0]+alphaFast*(price-emas[r-1][0]);
      emas[r][1] = emas[r-1][1]+alphaSlow*(price-emas[r-1][1]);
      macd[i]    = emas[r][0]-emas[r][1];
      macdDa[i]  = EMPTY_VALUE;
      macdDb[i]  = EMPTY_VALUE;
      signal[i]  = signal[i+1]+alphaSign*(macd[i]-signal[i+1]);
      colors[i]  = colors[i+1];
      if (ColorOnSignalCross)
      {
         if (macd[i]>signal[i]) colors[i] =  1;
         if (macd[i]<signal[i]) colors[i] = -1;
         }
         else
         {
         if (macd[i]>macd[i+1]) colors[i] =  1;
         if (macd[i]<macd[i+1]) colors[i] = -1;
         }
         if (colors[i]==-1) PlotPoint(i,macdDa,macdDb,macd);
   }         
   manageAlerts();
   return(0);
}


//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

void manageAlerts()
{
   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1; 
      if (colors[whichBar] != colors[whichBar+1])
      {
         if (colors[whichBar] ==  1) doAlert(whichBar,"up");
         if (colors[whichBar] == -1) doAlert(whichBar,"down");
      }
   }
}

//
//
//
//
//

void doAlert(int forBar, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];

       //
       //
       //
       //
       //

       message =  StringConcatenate(Symbol()," ",timeFrameToString(Period())," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," macd changed direction to ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(StringConcatenate(Symbol()," macd "),message);
          if (alertsSound)   PlaySound("alert2.wav");
   }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

//
//
//
//
//

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      {
         if (first[i+2] == EMPTY_VALUE) {
                first[i]   = from[i];
                first[i+1] = from[i+1];
                second[i]  = EMPTY_VALUE;
            }
         else {
                second[i]   =  from[i];
                second[i+1] =  from[i+1];
                first[i]    = EMPTY_VALUE;
            }
      }
   else
      {
         first[i]  = from[i];
         second[i] = EMPTY_VALUE;
      }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}