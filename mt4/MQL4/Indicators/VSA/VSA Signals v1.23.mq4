//+---------------------------------------------------------------------+
//|                                               VSA Signals v1.23.mq4 |
//|                                   Copyright (C) Simon Kaufmann 2010 |
//|                                                                     |
//|                                                                     |
//|  08.05.2010  original version                                       |
//|  01.07.2010  bug fixes and updates                                  |
//|  15.07.2010  include session average volume, new vsa bars           |
//|  26.07.2010  minor definition tweaks                                |
//+---------------------------------------------------------------------+

#property copyright "Simon Kaufmann  (C) Copyright 2010"
#property link      ""

/*
-------------------------------------------------------------------------
Version v1.23, Date: 26/07/2010

changed the display signal function to place symbols better.

signals: weakness marked in red, strength marked in blue. signals with 
relevant background marked in gray

Currently this has not been optimised for CPU usage, or to prevent 
signals appearing without appropriate background 
(i.e. looking for polar bears in haiwaii), though they should be marked 
in gray rather than red or blue. 

VSA bar determination is sensitive to spread and volume look back factors
vollbf and spdlbf - I have optimised these by time period and "feel".  
I don't recommend changing them but you can if you wish.
-------------------------------------------------------------------------
*/

/*
//// WEAKNESS ////

SIGNAL NAME 	 			                BAR	CLOSE		VOLUME	SPREAD	CONFIRMED BY

UP-THRUST - Basic				      	    up	low		(v)high	vwide		N/A
UP-THRUST - Basic					          up	low		high		avg		N/A
UP-THRUST - Basic					          up	low		low		avg		N/A
UP-THRUST - Trap up move 	 			    down low 		avg 		(v)wide 	N/A
UP-THRUST - Trap up move				    down	low		(v)high	(v)wide	N/A

2-BAR REVERSAL (UPTHRUST)

NO DEMAND						             up	low/mid  (v)low	narrow	next bar closes down
NO DEMAND						             up	low/mid  v0<v1&v2	narrow	next bar closes down
NO DEMAND						             up	low/mid  (v)low	average	next bar closes down

EFFORT TO RISE						          up	high		high		(v)wide	N/A
BUYING CLIMAX						          up	high	   vhigh		vwide		N/A
END OF A RISING MARKET			          up	mid/high	high		narrow	N/A (previous spread wide or vwide)
HIDDEN POTENTIAL SELLING 		          up	mid/low	vhigh		avg/wide	N/A (previous spread wide or vwide)
SQUAT (UP)                              up	high     (v)high	narrow	N/A

//// STRENGTH ////

STOPPING VOLUME					          down	high		high		narrow	N/A
STOPPING VOLUME					          down	high		vhigh	   (v)wide  N/A
STOPPING VOLUME					          down	mid		vhigh		vwide  	N/A
(ABSORPTION VOLUME					       down	high		uhigh		uwide		N/A)

2-BAR REVERSAL (STOPPING VOLUME)

SHAKE OUT						             up	high		high		wide		N/A
(REVERSE UP-THRUST					       up	high		high		wide		N/A)

NO SUPPLY						             down	mid/high (v)low	narrow	next bar closes up
NO SUPPLY						             down high		low		average	next bar closes up

TEST OF SUPPLY						          down	mid/high	v0<v1&v2	narrow	next bar closes up

(FALLING PRESSURE					          down	low		low		wide		N/A)

EFFORT TO FALL						          down	low		high		(v)wide	N/A
SELLING CLIMAX						          down low	   vhigh	   vwide	   N/A
BAG HOLDING						             down	low		(v)high	narrow	N/A
SQUAT (DOWN)                            down	high  	(v)high	narrow	N/A

// rework all the definitions ala Hidden Gap's posts.
// rework 2-bar reversals to avoid some of the issues there

the other way to determine weakness or stength is to use a meter based on wether the high average volume is occuring on down bars, or up bars, with factoring for spread

*/

#property copyright "Simon Kaufmann (c) 2010"
#property link      ""

#property indicator_chart_window

extern string  settings          = "Lookback Factors"; // these determine what period to use for measuring average volume and spread
extern double  vollbf            = 1.0; 
extern double  spdlbf            = 1.0;
extern int     lookbackbars      = 500;
extern string  colors            = "Symbol Colors";
extern color   strength_color    = CornflowerBlue;
extern color   weakness_color    = IndianRed;
extern color   wrong_background;

extern bool    UseSessionAverage = false;
extern int     AsiaBegin         = 17;   // Start time of Asian session in brokers time 
extern int     AsiaEnd           = 5;   // End time of Asian session in brokers time
extern int     EurBegin          = 3;   // Start time of European session in brokers time
extern int     EurEnd            = 12;   // End time of European session in brokers time
extern int     USABegin          = 8;   // Start time of New York session in brokers time
extern int     USAEnd            = 17;   // Endtime of New York session in brokers time

// weakness
int UPTHRUST                  = 0;
int TWO_BAR_REV_UT            = 1;
int NO_DEMAND                 = 2;
int EFFORT_TO_RISE            = 3;
int BUYING_CLIMAX             = 4;
int FAILED_FALL               = 5;
int HIDDEN_POTENTIAL_SELLING  = 6;
int END_OF_RISING_MARKET      = 7;
int SQUAT_UP                  = 8;

//strength
int STOPPING_VOLUME           = 9; 
int SHAKEOUT                  = 10; 
int TWO_BAR_REV_SV            = 11; 
int NO_SUPPLY                 = 12; 
int TEST_OF_SUPPLY            = 13; 
int EFFORT_TO_FALL            = 14; 
int SELLING_CLIMAX            = 15; 
int BAG_HOLDING               = 16;
int HIDDEN_POTENTIAL_BUYING   = 17;
int SQUAT_DOWN                = 18; 
int FAILED_RISE               = 19; 
int HIDDEN_TEST               = 20; 

//CHART
int m = 0;
string pref = "chart_";
string name = "";
int chart = ChartID();
datetime time1;
datetime time2;
datetime cTime = 0;
double price1;
double price2;
color clr;

// bar type
bool upbar, downbar, upclose, midclose, downclose;
// spread
bool narrowsp, avgsp, widesp,vwidesp, uwidesp;
// volume
bool vlowv, lowv, avgv, highv, vhighv; 
// previous bar up and down flags
bool pbarup, pbardown;

int signal, prevsignal = EMPTY_VALUE;

// signal codes  0   1   2   3   4   5   6   7   8  /  9  10  11  12  13  14  15 16  17  18  19  20
int code[20] = {167,167,250,159,108,111,108,108,159,  178,167,167,250,83,159,108,108,108,250,119,250};
string text[20] = {"UPTHRUST",
"2-ÁÀÐÍÛÉ ÐÅÂÅÐÑÀËÜÍÛÉ ÐÀÇÂÎÐÎÒ",
"ÍÅÒ ÑÏÐÎÑÀ",
"ÓÑÈËÅÍÈÅ Ê ÐÎÑÒÓ",
"ÊÓËÜÌÈÍÀÖÈß ÏÎÊÓÏÎÊ", 
"ÓÑÈËÅÍÈÅ Ê ÏÀÄÅÍÈÞ ÁÅÇ ÐÅÇÓËÜÒÀÒÀ", 
"ÑÊÐÛÒÛÉ ÏÎÒÅÍÖÈÀË ÏÐÎÄÀÆ", 
"ÏÐÅÊÐÀÙÅÍÈÅ ÐÎÑÒÀ ÐÛÍÊÀ", 
"ÏÐÈÑÎÅÄÈÍÅÍÈÅ (ÂÅÐÕ)",  
"ÎÑÒÀÍÎÂÊÀ ÎÁÚÅÌÀ", 
"ÂÛÒÅÑÍÅÍÈÅ", 
"2-ÁÀÐÍÛÉ ÐÅÂÅÐÑÀËÜÍÛÉ ÎÑÒÀÍÀÂËÈÂÀÞÙÈÉ ÎÁÚÅÌ", 
"ÍÅÒ ÎÁÚÅÌÀ", 
"ÒÅÑÒ ÎÁÚÅÌÀ", 
"ÓÑÈËÅÍÈÅ Ê ÏÀÄÅÍÈÞ", 
"ÊÓËÜÌÈÍÀÖÈß ÏÐÎÄÀÆ", 
"BAG HOLDING", 
"ÑÊÐÛÒÛÉ ÏÎÒÅÍÖÈÀË ÏÎÊÓÏÊÈ", 
"ÏÐÈÑÎÅÄÈÍÅÍÈÅ (ÍÈÇ)", 
"ÏÎÏÛÒÊÀ ÐÎÑÒÀ Ñ ÍÓËÅÂÛÌ ÐÅÇÓËÜÒÀÒÎÌ", 
"ÑÊÐÛÒÛÉ ÒÅÑÒ"};
                  
double pts, dprice, last_dprice;
int sctr, icolor = 0;

int strength = 1;
int weakness = -1;
int up = 1;
int down = -1;
int vperiod, speriod = 0;
int background, meter = 0;

int min2bar_reversal_length = 0;
double mid_body_ratio = 0.60;
double long_body_ratio = 0.80;

double shift=0;

double v0,v1,v2, spread, closelow, avgspread, avgvol, stdvol, stspread; 
bool testmode = false;
string objprefix = "[VSA]";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{  
   SetConstants();   
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
  for(int i=ObjectsTotal();i >= 0;i--)
  {
    if(StringSubstr(ObjectName(i),0,StringLen(objprefix))==objprefix)
    { ObjectDelete(ObjectName(i)); }
    if(StringSubstr(ObjectName(i),0,StringLen(pref))==pref)
    { ObjectDelete(ObjectName(i)); }
  }
 
//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{  
   for(int j = 400; j > 0; j--){
      DrawColorTrend(j);
   }
   //---- exit if not enough bars to calculate average volume or spread
   int period;
   if (vperiod > speriod) { period = vperiod; }
   else {period = speriod;}
   if(Bars<=period) { return(0); }
   
   int counted_bars=IndicatorCounted(); 
   if(counted_bars > 0) { counted_bars--; } 
   int i;
   if(counted_bars>=period) { i=Bars-counted_bars-1; }
   else { i=Bars-period-1; }
   
   //---- determine VSA signals
   if (i>lookbackbars) {i=lookbackbars;}
   
   while(i>0)
   { 
      DetermineBarCharacteristics(i);
      signal = DetermineSignal(i); 
      DetermineBackground(i);
      DisplaySignal(signal, i); 
      prevsignal = signal;
      i--;
   } 
   return(0);
}

double CalcRange(int bar, bool verify=false)
{
   int counter, n=0;
   double Range, AvgRange; 
   if (verify) n=1;
   AvgRange=0;
   for (counter=bar-n; counter<=bar+1;counter++)
   {
      AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
   }
   Range=AvgRange/2;
   return(Range);
}




void SetConstants()
{
   shift =(WindowPriceMax()-WindowPriceMin())/30;
   meter = 0;
   background = 0;
   switch (Period()) {
      case PERIOD_M1:
         vperiod = 40*vollbf;
         speriod = 40*spdlbf; 
         min2bar_reversal_length = 10;
         break;
      case PERIOD_M5:
         vperiod = 30*vollbf;
         speriod = 30*spdlbf; 
         min2bar_reversal_length = 10;
         break;
      case PERIOD_M15:
         vperiod = 25*vollbf;
         speriod = 25*spdlbf; 
         min2bar_reversal_length = 10;
         break;
      case PERIOD_M30:
         vperiod = 24*vollbf;
         speriod = 24*spdlbf; 
         min2bar_reversal_length = 15;
         break;      
      case PERIOD_H1:
         vperiod = 20*vollbf;
         speriod = 20*spdlbf;
         min2bar_reversal_length = 25;
         break;
      case PERIOD_H4:
         vperiod = 20*vollbf;
         speriod = 20*spdlbf;
         min2bar_reversal_length = 20;
         break;
      case PERIOD_D1:
         vperiod = 20*vollbf;
         speriod = 20*spdlbf;
         min2bar_reversal_length = 30;
         break;
      case PERIOD_W1:
         vperiod = 20*vollbf;
         speriod = 20*spdlbf;
         min2bar_reversal_length = 40;
         break;
      case PERIOD_MN1:
         vperiod = 20*vollbf;
         speriod = 20*spdlbf;
         min2bar_reversal_length = 50;
         break;
   }
   if (testmode)
      Comment("vl=",vperiod," sl=",speriod);
}


int Session(datetime dt )
{
   int session = 0;
   int hour = TimeHour(dt);
   if ( (hour >=AsiaBegin) || ( (AsiaBegin>AsiaEnd) && (hour <= AsiaEnd)) )
   { 
      session = 1;
   }
   if ( hour >=EurBegin || ( (EurBegin>EurEnd) && ( hour <= EurEnd)) )
   {
      session = 2;
   }
   if ( (hour>=USABegin && hour>EurEnd) || ( (USABegin>USAEnd) && (hour <= USAEnd)) )
   { 
      session = 3;
   }
   return (session);

}


double CalculateAverageSpread(int cbar)
{
   double as, s = 0;
   for (int i=cbar+speriod; i>=cbar; i--)
   {
      s = High[i]-Low[i];
      as = as+s;
   }   
   return(as/speriod);
}

double CalculateSpdStdDev(double av, int cbar) 
{
   double s, sd, sumspd = 0;
   for (int i=cbar+speriod; i>=cbar; i--)
   {
      s = (High[cbar]-Low[cbar]) - av;
      sumspd = sumspd+MathPow(s,2);
   }   
   sd = MathSqrt(sumspd/speriod);
   return(sd);
}

double CalculateAverageVolume(int cbar)
{
   double av, v = 0;
   for (int i=cbar+vperiod; i>=cbar; i--)
   {
      v = iVolume(NULL,Period(),i);
      av = av+v;
   }   
   return(av/vperiod);
}

double CalculateSessionAverageVolume(int bar)
{
   double av, v = 0;
   int i, c = 0;
   i = bar;
   while (c<vperiod)
   {
      if ( Session(iTime(NULL,Period(),i)) == Session(iTime(NULL,Period(),bar)) )
      {
         v = iVolume(NULL,Period(),i);
         av = av+v;
         c++;
      }
      i++;
      if (i>2*lookbackbars) { break;}
   }   
   return(av/vperiod);
}

double CalculateVolStdDev(double av, int cbar) 
{
   double v, sd, sumv2 = 0;
   for (int i=cbar+vperiod; i>=cbar; i--)
   {
      v = iVolume(NULL,Period(),i) - av;
      sumv2 = sumv2+MathPow(v,2);
   }   
   sd = MathSqrt(sumv2/vperiod);
   return(sd);
}


bool LocalHigh(int bar, int back)
{
   if (bar == iHighest(NULL,0, MODE_HIGH,back,bar))
   { return(true); }
   return(false);
}

bool LocalLow(int bar, int back)
{
   if (bar == iLowest(NULL,0, MODE_LOW,back,bar))
   {  return(true); }
   return(false);

}

bool upbar(int b, int n)
{
   if (Close[b] > Close[b+n])
   { return (true); }
   return (false);
}


bool downbar(int b, int n)
{
   if (Close[b] < Close[b+n])
   { return (true); }
   return (false);
}

void DetermineBarCharacteristics(int bar)
{
   signal = EMPTY_VALUE;
   upclose = false;
   midclose = false;
   downclose = false;
   upbar = false;
   downbar = false;
   pbarup = false;
   pbardown = false;

// spread
   narrowsp = false;
   avgsp = false;
   widesp = false;
   vwidesp = false;
   uwidesp = false;

// volume
   vlowv = false;
   lowv = false;
   avgv = false;
   highv = false;
   vhighv = false; 
   
   v0 = iVolume(NULL, Period(), bar);
   v1 = iVolume(NULL, Period(), bar+1);
   v2 = iVolume(NULL, Period(), bar+2);
   spread = MathAbs(High[bar]-Low[bar]);
   closelow = Close[bar]-Low[bar];
   
   avgspread = CalculateAverageSpread(bar);
   stspread = CalculateSpdStdDev(avgspread,bar);
   
   if (UseSessionAverage)
   { avgvol = CalculateSessionAverageVolume(bar); }
   else
   { avgvol = CalculateAverageVolume(bar); }
   
   stdvol = CalculateVolStdDev(avgvol,bar); 
   
   // is up bar or down bar
   if (Close[bar] > Close[bar+1]){ upbar = true; }
   else { downbar = true; }
    
   if (Close[bar+1] > Close[bar+2]) { pbarup = true; }
   else { pbardown = true; }
       
   // up close, mid close or down close bar
   if (spread>0) 
   { 
      if    ( (closelow/spread >=0.35) && (closelow/spread <= 0.65) )  { midclose = true; }
      else if (closelow/spread > 0.65)  { upclose = true; }
      else if (closelow/spread < 0.35)  { downclose = true; }
   }
   
   // these tests are wrong - fix
   
   // determine category for bar's spread  
   if      (  spread < (avgspread-0.4*stspread) ) { narrowsp = true; }
   else if (  spread < (avgspread+0.4*stspread) ) { avgsp = true; }
   else if (  spread < (avgspread+0.7*stspread) ) { widesp = true; }
   else if (  spread < (avgspread+1.0*stspread) ) { vwidesp = true; }
   else { uwidesp = true; }
   
   // determine category for bar's volume
   if      ( v0 < (avgvol-1.0*stdvol) ) { vlowv = true; }
   else if ( v0 < (avgvol-0.5*stdvol) ) { lowv = true;  }
   else if ( v0 < (avgvol+0.5*stdvol) ) { avgv = true; }
   else if ( v0 < (avgvol+1.0*stdvol) ) { highv = true; }
   else { vhighv = true; }
   
}


void DetermineBackground(int bar)
{
   if (bar==0){return;}
   
// need to rework this section take account of the idea of effort vs result
     
   if ( (signal == EFFORT_TO_RISE) || (signal == BUYING_CLIMAX) ) { background = weakness; meter = -1; } // successful effort to rise - reset background meter
   if ( (signal == EFFORT_TO_FALL) || (signal == SELLING_CLIMAX)) { background = strength; meter =  1; } // successful effort to fall - reset background meter
     
   // weakness
   if ( (signal == UPTHRUST) || (signal == TWO_BAR_REV_UT) )
     { meter = meter-1; }    
   
   // strength
   if ( (signal == STOPPING_VOLUME) || (signal == TWO_BAR_REV_SV) )
     { meter = meter+1; }

   if (signal == SHAKEOUT)
     { meter = meter+1; } 
     
   // check previous signal and revise background as required
//   if (prevsignal == TEST_OF_SUPPLY && upbar && (v0>avgvol) )  { meter = meter + strength; } // confirmation
//   if (prevsignal == HIDDEN_TEST && upbar && (v0>avgvol) )     { meter = meter + weakness; } // confirmation
   if (prevsignal == EFFORT_TO_FALL && upbar && (highv || vhighv) )   { meter = meter - 1; } // failed effort
   if (prevsignal == EFFORT_TO_RISE && downbar && (highv || vhighv) ) { meter = meter + 1; } // failed effort
   
   if ( (meter < 1) && (meter > -1) )
     { background = 0; }
   if (meter > 1) 
     { background = strength; }
   if (meter < -1)
     { background = weakness; }
}

int DetermineSignal(int bar)  // determine current VSA signal 
{    
   // signs of WEAKNESS - order of these tests is important

   // effort to rise
   if( upbar && upclose && (widesp || vwidesp || uwidesp) && (highv || vhighv ) && LocalHigh(bar, 5) 
             && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) )  // checking for close near high
   { signal = EFFORT_TO_RISE; }
   
   if( upbar && upclose && (vwidesp || uwidesp) && (avgv) && LocalHigh(bar, 5)
             && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) )  // checking for close near high
   { signal = EFFORT_TO_RISE; }
   
   // buying climax
   if( upbar && upclose && upbar(bar+1,1) && (vwidesp || uwidesp) && (vhighv) 
       && LocalHigh(bar,20) && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) ) 
   { signal = BUYING_CLIMAX; }
   
   // squat (up)  
   if (upbar && (downclose || midclose || upclose) && narrowsp && (highv || vhighv) )
   { signal = SQUAT_UP; }
   
   // hidden potential selling
   if (upbar && (midclose || downclose) && (avgsp || widesp || vwidesp) && (vhighv) && LocalHigh(bar, 5)
       && ((MathAbs(Close[bar]-Open[bar]))/spread < long_body_ratio) )
   { signal = HIDDEN_POTENTIAL_SELLING; }
   
   // end of a rising market 
   if (upbar && (midclose || upclose) && narrowsp && vhighv && LocalHigh(bar, 20) )
   { signal = END_OF_RISING_MARKET; }
   
   // 2-bar reversal stopping volume
   if ( (Open[bar+1]>Close[bar+1])&&(Close[bar]>Open[bar])&&(Close[bar]>=Open[bar+1])&&((Close[bar]-Open[bar])>(1.3*(Open[bar+1]-Close[bar+1])))
      && ( (MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio ) 
      && ( (MathAbs(Open[bar+1]-Close[bar+1]))/spread > mid_body_ratio ) 
      && ( spread>=(min2bar_reversal_length*Point) )
      && (widesp || vwidesp) && (avgv|| highv || vhighv ) 
      && LocalLow(bar+1,5) )
   { signal = TWO_BAR_REV_SV; } 
   
   // upthrust
   if( upbar && downclose && (avgsp || widesp || vwidesp) && (avgv || highv || vhighv) && LocalHigh(bar,5) )
   { signal = UPTHRUST; } 
   
   if( downbar && downclose && upbar(bar+1,1) && (widesp || vwidesp) && (avgv || highv || vhighv) && LocalHigh(bar,5) )
   { signal = UPTHRUST; }  // could change to PSEUDO UPTHRUST */
   
   // no demand
   if( upbar && (narrowsp || avgsp) && (midclose || downclose) && (vlowv || lowv) )
   { signal = NO_DEMAND; } 
      
   if( upbar && (narrowsp || avgsp) && (midclose || downclose) && ((v0<v1) && (v0<v2)) )
   { signal = NO_DEMAND; }   
   
   // signs of strength - order of these tests is important
   
   // effort to fall   
   if( downbar && downclose && (widesp || vwidesp || uwidesp) && (highv || vhighv)&& LocalLow(bar, 5) 
       && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) ) // checking for open near high
   { signal = EFFORT_TO_FALL; }
   
   if( downbar && downclose && (vwidesp || uwidesp) && (avgv || lowv) && LocalLow(bar, 5)
       && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) ) // checking for open near high
   { signal = EFFORT_TO_FALL; }
   
   // selling climax
   if( downbar && (downclose || midclose) && downbar(bar+1,1) && (vwidesp || uwidesp) && (vhighv) 
       && LocalLow(bar,20) && ((MathAbs(Close[bar]-Open[bar]))/spread > mid_body_ratio) ) 
   { signal = SELLING_CLIMAX; }
   
   // bag holding
   if (downbar && (midclose || upclose) && narrowsp && vhighv && LocalLow(bar, 20) )
   { signal = BAG_HOLDING; }
   
   // hidden potential buying
   if (downbar && (midclose || upclose) && (avgsp || widesp) && (vhighv) && LocalLow(bar, 5)
       && ((MathAbs(Close[bar]-Open[bar]))/spread < long_body_ratio) )
   { signal = HIDDEN_POTENTIAL_SELLING; }
   
   // squat (down)
   if (downbar && (midclose || downclose) && narrowsp && (highv || vhighv) )
   { signal = SQUAT_DOWN; }
   
   // 2bar reversal upthrust   
   if ( (Close[bar+1]>Open[bar+1]) &&(Open[bar]>Close[bar])&&(Open[bar]>=Close[bar+1])&&(Open[bar+1]>=Close[bar])&&((Open[bar]-Close[bar])>(Close[bar+1]-Open[bar+1]))&&(spread>=(min2bar_reversal_length*Point))  
      && ( (MathAbs(Open[bar]-Close[bar]))/spread > mid_body_ratio ) 
      && ( (MathAbs(Close[bar+1]-Open[bar+1]))/spread > mid_body_ratio ) 
      && (widesp || vwidesp) && (avgv || highv || vhighv ) )
 //     && LocalHigh(bar+1,5) )
   { signal = TWO_BAR_REV_UT; } 
    
   // shakeout   
   if( upbar && LocalLow(bar,3) && (midclose||upclose) && (avgv || highv) && ( (lowv || avgv) || ((v0>v1) && (v0>v2)) )
       && ( (Close[bar]-Open[bar])/spread < mid_body_ratio)  )
   { signal = SHAKEOUT; }
   
   // stopping volume
   if( downbar && LocalLow(bar,15) && (widesp || vwidesp) && (midclose||upclose) && (highv || vhighv) )
   { signal = STOPPING_VOLUME; }
   
   // no supply       
   if( downbar && (narrowsp || avgsp) && midclose && ( (vlowv || lowv) || ((v0 < v1) && (v0 < v2))) )
   { signal = NO_SUPPLY; }

      // test of supply
   if( downbar && (narrowsp || avgsp) && upclose && ((vlowv || lowv) || ((v0 < v1) && (v0 < v2))) ) 
   { signal = TEST_OF_SUPPLY; } 
   
   if (background == strength)
   {
      // hidden test
      if( upbar && downbar(bar+1,1) && narrowsp && upclose && ((vlowv || lowv) || ((v0 < v1) && (v0 < v2)) ) ) 
      { signal = HIDDEN_TEST; } 
   }
   
   if (testmode && bar == 6) // set the bar number to inspect the values and confirm against signals criteria
   {
      string t = "Bar ="+DoubleToStr(bar,0)+" signal= "+DoubleToStr(signal,0)+"\n";
      t= t+"spread - ns:"+DoubleToStr(narrowsp,0)+" avgsb:"+DoubleToStr(avgsp,0)+" wsb:"+DoubleToStr(widesp,0)+" vwsb:"+DoubleToStr(vwidesp,0)+" uwsb:"+DoubleToStr(uwidesp,0)+"\n";
      t= t+"bar type - downbar:"+DoubleToStr(downbar,0)+" upbar:"+DoubleToStr(upbar,0)+" pbarup:"+DoubleToStr(pbarup,0)+" pbardown:"+DoubleToStr(pbardown,0)+" upclose:"+DoubleToStr(upclose,0)+" downclose:"+DoubleToStr(downclose,0)+" midclose:"+DoubleToStr(midclose,0)+"\n";
      t= t+"vol - vl:"+DoubleToStr(vlowv,0)+" l:"+DoubleToStr(lowv,0)+" a:"+DoubleToStr(avgv,0)+" high:"+DoubleToStr(highv,0)+" vhigh:"+DoubleToStr(vhighv,0)+"\n";
      t= t+"v0:"+DoubleToStr(v0,0)+" v1:"+DoubleToStr(v1,0)+" v2:"+DoubleToStr(v2,0)+" av:"+DoubleToStr(avgvol,0)+" sd:"+DoubleToStr(stdvol,0)+"\n";
      t= t+"LocalHigh(5):" + LocalHigh(bar,5) + " LocalLow(15):" + LocalLow(bar,15)+"\n";
      t= t+"LocalHigh(20):" + LocalHigh(bar,20) + " LocalLow(20):" + LocalLow(bar,20)+"\n";
      t= t+"Body/Wick ratio=" + DoubleToStr(((MathAbs(Close[bar]-Open[bar]))/spread),2)+"\n";
      t= t+"Spread ="+DoubleToStr(spread,2)+" 2bar rev length="+ DoubleToStr(min2bar_reversal_length*Point,2)+"\n";
      t= t+"Background = "+DoubleToStr(background,0)+" Meter ="+DoubleToStr(meter,0);
      Comment(t);
   }   
   return(signal);
}

int DisplaySignal(int s, int bar)
{
   if (s==EMPTY_VALUE)
   { return(0);}
   
   icolor = wrong_background;  // if wrong background, show signal in gray
   if (s < 9) 
   { 
     dprice = High[bar] + 0.1*CalcRange(bar, false);
     if (background == weakness) // background weakness, signal weakness, mark with red
     { icolor = weakness_color; }
   } 
   else 
   { 
     dprice = Low[bar] - 0.1*CalcRange(bar, false); 
     if (background == strength)  // background strength, signal strength, mark with blue
     { icolor = strength_color; }
   }
   if (ObjectCreate(objprefix+" "+text[s]+" ("+bar+")", OBJ_ARROW, 0, Time[bar], dprice) == true)
   {
      ObjectSet(objprefix+" "+text[s]+" ("+bar+")", OBJPROP_ARROWCODE, code[s]);     
      ObjectSet(objprefix+" "+text[s]+" ("+bar+")", OBJPROP_COLOR, icolor);
      SetIndexArrow(3,code[s]);
      sctr++; 
   }
   last_dprice = dprice; // might use last signal position to clear and rewrite signals for those that need confirmation
   return(0);
}
//îòðèñîâûâàåì ñâå÷è â çàâèñèìîñòè îò òðåíäà
void DrawColorTrend(int i){
   
   if(cTime == Time[i])
      return;
   
   clr = clrYellowGreen;
   name = pref+(char)m;
   
   time1 = Time[i];
   time2 = Time[i+1];
   
   if(High[i] > High[i+1])
      price1 = NormalizeDouble(High[i], Digits());
   else
      price1 = NormalizeDouble(High[i+1],Digits());
      
   if(Low[i] < Low[i+1])
      price2 = NormalizeDouble(Low[i], Digits());
   else
      price2 = NormalizeDouble(Low[i+1], Digits());
   
   Print("name = ",name);
   
   ResetLastError();
   if(!ObjectCreate(name, OBJ_RECTANGLE, 0, time1, price1, time2, price2)){
      Print(__FUNCTION__, GetLastError());
      return;
   };
   ObjectSet(name, OBJPROP_COLOR, clr);
   m++;
   cTime = Time[i];
}





//+------------------------------------------------------------------+



