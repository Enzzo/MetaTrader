#import "kernel32.dll"
   void OutputDebugStringA(string msg);
#import

//void log(string s1, string s2 = "", string s3 = "", string s4 = "", string s5 = "", string s6 = "", string s7 = "", string s8 = ""){ OutputDebugStringA(StringTrimRight(StringConcatenate(WindowExpertName(), ".mq4 ", NULL, " ", s1, " ", s2, " ", s3, " ", s4, " ", s5, " ", s6, " ", s7, " ", s8))); }

#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 8

#property indicator_color1 Red
#property indicator_color2 DeepSkyBlue
#property indicator_color3 LightGray
#property indicator_color4 Lime
#property indicator_color5 Black
#property indicator_color6 Magenta
#property indicator_color7 DarkOrange
#property indicator_color8 Gray

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 3
#property indicator_width8 1

// ********** Extern ********** //

extern string  Note = "0 - display all bars";
extern int     NumberOfBars = 500;
extern int     MAPeriod = 50;
extern int     LookBack = 20;
extern int     ATRRange = 5;
extern color   FontColor = Black;
extern color   UpTrendColor = Lime;
extern color   DownTrendColor = OrangeRed;
extern bool    UseClosePrice = true;

// ********** Global ********** //

string FontName  = "Trebuchet MS";
int    FontSize  = 13;
int    XDistance = 10;
int    YDistance = 5;
int    DeltaFactor = 2;

// ****** VolumeHistogram ***** //

double VolClimaxHigh[], VolNeutral[], VolLow[], VolChurn[], VolClimaxLow[], VolClimaxChurn[], VolAverage[];
   
// ******* Volume Delta ******* //

double VolDelta[];

// *********** Init *********** //

int init()
{
   SetIndexBuffer(0, VolClimaxHigh);
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexLabel(0, "Climax High");
   
   SetIndexBuffer(1, VolNeutral);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexLabel(1, "Neutral");
   
   SetIndexBuffer(2, VolLow);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexLabel(2, "Low");
   
   SetIndexBuffer(3, VolChurn);
   SetIndexStyle(3, DRAW_HISTOGRAM);
   SetIndexLabel(3, "HighChurn");
   
   SetIndexBuffer(4, VolClimaxLow);
   SetIndexStyle(4, DRAW_HISTOGRAM);
   SetIndexLabel(4, "Climax Low");
   
   SetIndexBuffer(5, VolClimaxChurn);
   SetIndexStyle(5, DRAW_HISTOGRAM);
   SetIndexLabel(5, "ClimaxChurn");
   
   SetIndexBuffer(6, VolDelta);   
   SetIndexStyle(6, DRAW_HISTOGRAM, STYLE_SOLID);
   SetIndexLabel(6, "VolumeDeltaValues");
   
   SetIndexBuffer(7, VolAverage);
   SetIndexStyle(7, DRAW_LINE, STYLE_DOT, 1);
   SetIndexLabel(7, "Average(" + MAPeriod + ")");
   
   IndicatorShortName("VSAN");

   return(0);
}

// ********** DeInit ********** //

int deinit()
{
   ObjectDelete("BarTimer");
   ObjectDelete("VolumeDelta");
   ObjectDelete("VolumeAverage");
   ObjectDelete("VolumeDeltaDescription");
   ObjectDelete("VolumeAverageDescription");
   ObjectDelete("SignalDescription");

   return(0);
}

// *********** Start ********** //

int start()
{
   DrawHistogram();
   VolumeDelta();
   BarTimer();
   PriceRange();
   SignalDescription();

   return(0);
}

// ******* DrawHistogram ****** //
    
int DrawHistogram()
{
   int countedBars = IndicatorCounted();

   if (countedBars > 0) 
   {
      countedBars--;
   }
   
   if (NumberOfBars == 0)
   {
      NumberOfBars = Bars - countedBars;
   }

   // Get only selected bars
   
   for (int i = 0; i < NumberOfBars; i++)   
   {
      double volClimaxCurrent = 0, volChurnCurrent = 0, volSummary = 0, volClimaxGlobal = 0, volChurnGlobal = 0, climax = 0, churn = 0, priceMin = Low[i], priceMax = High[i];

      // Get either Open / Close or High / Low prices
      
      if (UseClosePrice) 
      {
         priceMin = Open[i]; 
         priceMax = Close[i];
      }
      
      // Inverse prices on down bars
      
      EnsureMaxMin(priceMin, priceMax);
      
      double range = priceMax - priceMin;
      
      // Climax = (volume) x (price range) - maximal price range on high volume, possible trend
      
      volClimaxCurrent = Volume[i] * range;

      // Churn = (volume) x (price range) - minimal price range on high volume, possible consolidation
   
      if (range != 0)
      {
         volChurnCurrent = Volume[i] / range;
      }

      // Look out for previous bars to find out local Max & Min and compare with current bar
   
      for (int n = i; n < i + LookBack; n++)
      {
         double minPriceLocal = Low[n], maxPriceLocal = High[n];
   
         // Get either Open / Close or High / Low prices
   
         if (UseClosePrice) 
         {
            minPriceLocal = Open[n]; 
            maxPriceLocal = Close[n];
         }
      
         // Inverse prices on down bars
      
         EnsureMaxMin(minPriceLocal, maxPriceLocal);
      
         climax = Volume[n] * (maxPriceLocal - minPriceLocal); 
         
         // Previous maximal price range can be found here
         
         if (climax >= volClimaxGlobal)
         {
            volClimaxGlobal = climax;
         }
         
         // Previous consolidation can be found here
           
         if (climax != 0)
         {           
            churn = Volume[n] / (maxPriceLocal - minPriceLocal);
            
            if (churn > volChurnGlobal) 
            {
               volChurnGlobal = churn; 
            }
         } 
      }
      
      // By default volume is neutral
      
      VolNeutral[i] = NormalizeDouble(Volume[i], 0);
      VolClimaxHigh[i] = 0; VolChurn[i] = 0; VolClimaxLow[i] = 0; VolClimaxChurn[i] = 0; VolLow[i] = 0; 
      
      // Volume is low when all previous values were higher
      
      if (Volume[i] == Volume[iLowest(NULL, 0, MODE_VOLUME, LookBack, i)])
      {
         VolLow[i] = NormalizeDouble(Volume[i], 0);
         VolClimaxHigh[i] = 0; VolChurn[i] = 0; VolClimaxLow[i] = 0; VolClimaxChurn[i] = 0; VolNeutral[i] = 0;
      }
      
      // When volume is equal to one seen before mark it as accummulation / distribution - profit is taken
                             
      if (volChurnCurrent == volChurnGlobal)
      {
         VolChurn[i] = NormalizeDouble(Volume[i], 0); 
         VolClimaxHigh[i] = 0; VolLow[i] = 0; VolClimaxLow[i] = 0; VolClimaxChurn[i] = 0; VolNeutral[i] = 0;               
      }

      // When volume is higher than all previous and price is going up - start or end of the up trend

      if (volClimaxCurrent == volClimaxGlobal && Close[i] > (priceMax + priceMin) / 2)
      {
         VolClimaxHigh[i] = NormalizeDouble(Volume[i], 0);
         VolLow[i] = 0; VolChurn[i] = 0; VolClimaxLow[i] = 0; VolClimaxChurn[i] = 0; VolNeutral[i] = 0;
      }
      
      // When volume is extra high and price is not changing - absolute consolidation or fast accummulation / distribution
      
      if (volClimaxCurrent == volClimaxGlobal && volChurnCurrent == volChurnGlobal)
      {
         VolClimaxChurn[i] = NormalizeDouble(Volume[i], 0);
         VolClimaxHigh[i] = 0; VolLow[i] = 0; VolChurn[i] = 0; VolClimaxLow[i] = 0; VolNeutral[i] = 0;
      }

      // When volume is higher than all previous and price is going down - start or end of the down trend

      if (volClimaxCurrent == volClimaxGlobal && Close[i] < (priceMax + priceMin) / 2)
      {
         VolClimaxLow[i] = NormalizeDouble(Volume[i], 0);
         VolClimaxHigh[i] = 0; VolLow[i] = 0; VolChurn[i] = 0; VolClimaxChurn[i] = 0; VolNeutral[i] = 0;
      }
      
      // Calculate average volume for MA
      
      for (int k = i; k < i + MAPeriod; k++)
      {
         volSummary = Volume[k] + volSummary; 
      }
      
      VolAverage[i] = NormalizeDouble(volSummary / MAPeriod, 0);
   }

   return(0);
}

// ******* EnsureMaxMin ******* //

int EnsureMaxMin(double& priceMin, double& priceMax)
{
   double price;

   // Ensure that Max is real maximum and Min is real minimum - identify Open / Close as High / Low

   if (priceMax < priceMin) 
   {
      price = priceMin;
      priceMin = priceMax;
      priceMax = price;
   }

   return(0);
}

// ********* BarTimer ********* //

int BarTimer()
{
   int sec = TimeCurrent() - Time[0];
   double pc = 100.0 * sec / (Period() * 60);
   string barTimer = StringConcatenate("BAR : ", DoubleToStr(pc, 0), "%");

   // Show in percents how many ticks left to the end of current bar
   
   ShowLabel("BarTimer", barTimer, YDistance, FontSize - 5, FontColor);

   return(0);
}

// ******** PriceRange ******** //

int PriceRange()
{
   double priceMax = High[iHighest(NULL, 0, MODE_HIGH, ATRRange)];
   double priceMin = Low[iLowest(NULL, 0, MODE_LOW, ATRRange)];
   string priceRange = StringConcatenate("ATR : ", DoubleToStr(priceMax - priceMin, Digits));

   // Show how volatile market is

   ShowLabel("ATRRange", priceRange, YDistance + 15, FontSize - 5, FontColor);

   return(0);
}

// ******** VolumeDelta ******* //

void VolumeDelta()
{
   double V1 = 0, V2 = 0;
   int indexPrevious = -1, bars = iBars(NULL, PERIOD_M1);

   for (int i = 0; i < bars; i++)
   {
      // Get first M1 bar inside current bar
   
      int index = iBarShift(NULL, Period(), iTime(NULL, PERIOD_M1, i), true);

	  // Start new calculation when new bar opens and new index of opening M1 is found

	  if (indexPrevious != index)
	  {
		 V1 = 0; V2 = 0; VolDelta[index] = 0;
	  }
	  
      if (index != -1)
      {
         double close = iClose(NULL, PERIOD_M1, i);
         double closePrevious = iClose(NULL, PERIOD_M1, i + 1);
         double volCurrent = iVolume(NULL, PERIOD_M1, i);
         
         // Up bar means that delta is positive
         
         if (close > closePrevious)
         {
            V1 = V1 + volCurrent;
         }
   
         // Down bar means that delta is negative
   
         if (close < closePrevious)
         {
            V2 = V2 - volCurrent;
         }
         
         // When price does not change get average volume
         
         if (close == closePrevious)
         {
            V1 = V1 + volCurrent;
            V2 = V2 - volCurrent;
         }
         
         // To prevent high delta values to hide volume on chart divide delta by some factor
         
         VolDelta[index] = (V1 + V2) / DeltaFactor; 
         indexPrevious = index;
      }
   }
   
   // Show delta values and compare it with previous values to find new players on market
   
   string volumeDeltaDescription = "BELOW";
   string volumeDelta = StringConcatenate("DELTA : ", DoubleToStr(VolDelta[0] * DeltaFactor, 0));
   color volumeDeltaColor = DownTrendColor;
   
   if (IsRising(VolDelta)) 
   {
      volumeDeltaDescription = "ABOVE";
   }
   
   if (VolDelta[0] > 1) 
   {
      volumeDeltaColor = UpTrendColor;
   }
   
   ShowLabel("VolumeDelta", volumeDelta, YDistance + 30, FontSize, volumeDeltaColor);
   ShowLabel("VolumeDeltaDescription", volumeDeltaDescription + " AVERAGE", YDistance + 50, FontSize - 5, FontColor);
   
   // Show volume and compare it with previous values to know whether volume is growing or falling
   
   string volumeAverageDescription = "BELOW";
   string volumeAverage = StringConcatenate("VOLUME : ", DoubleToStr(VolAverage[0], 0));
   color volumeAverageColor = DownTrendColor;
   
   if (IsRising(VolAverage)) 
   {
      volumeAverageDescription = "ABOVE";
      volumeAverageColor = UpTrendColor;
   }
   
   ShowLabel("VolumeAverage", volumeAverage, YDistance + 65, FontSize, volumeAverageColor);
   ShowLabel("VolumeAverageDescription", volumeAverageDescription + " AVERAGE", YDistance + 85, FontSize - 5, FontColor);

   return(0);
}

// ***** SignalDescription **** //

int SignalDescription()
{
   int fontSize = FontSize - 6;

   // Show description for every closed volume bar
   
   ShowLabel("SignalDescription", "", YDistance + 100, fontSize, FontColor);

   if (VolClimaxHigh[1] > 1)  { ObjectSetText("SignalDescription", "START/END OF UP TREND - PULLBACK ON DOWN TREND", fontSize, FontName, indicator_color1); }
   if (VolNeutral[1] > 1)     { ObjectSetText("SignalDescription", "NO SIGNAL - NEUTRAL", fontSize, FontName, indicator_color2); }
   if (VolLow[1] > 1)         { ObjectSetText("SignalDescription", "END OF UP/DOWN TREND - PULLBACK MID-TREND", fontSize, FontName, indicator_color3); }
   if (VolChurn[1] > 1)       { ObjectSetText("SignalDescription", "END OF UP/DOWN TREND - PROFIT TAKING MID-TREND", fontSize, FontName, indicator_color4); }
   if (VolClimaxLow[1] > 1)   { ObjectSetText("SignalDescription", "START/END OF DOWN TREND - PULLBACK ON UP TREND", fontSize, FontName, indicator_color5); }
   if (VolClimaxChurn[1] > 1) { ObjectSetText("SignalDescription", "SEEN ON TOPS AND BOTTOMS - REVERSAL OR CONTINUATION", fontSize, FontName, indicator_color6); }
}

// ********* ShowLabel ******** //

int ShowLabel(string name, string value, int positionTop, int fontSize, color fontColor)
{
   if (ObjectFind(name) < 0)
   {
      ObjectCreate(name, OBJ_LABEL, WindowFind("VSAN"), 0, 0);
   }
   
   ObjectSet(name, OBJPROP_CORNER, 1);
   ObjectSet(name, OBJPROP_XDISTANCE, XDistance);
   ObjectSet(name, OBJPROP_YDISTANCE, positionTop);
   ObjectSetText(name, value, fontSize, FontName, fontColor);

   return(0);
}

// ********* IsRising ********* //

bool IsRising(double list[])
{
   int result = true;

   // Compare current value with previous to make sure that current is maximum

   for (int i = 0; i < LookBack; i++) 
   {
      if (MathAbs(list[0]) < MathAbs(list[i]))
      {
         result = false;
      }
   }
   
   return(result);
}