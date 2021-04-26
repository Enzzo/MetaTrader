//+------------------------------------------------------------------+
//|                                             Color Stochastic.mq4 |
//|                                                           mladen |
//| Stochastic_Color_v1.02clasicB  'classic style'   ki              |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      ""

#property indicator_separate_window
#property indicator_buffers   6
#property indicator_minimum   0
#property indicator_maximum 100
#property indicator_color1 DimGray
#property indicator_color2 SlateGray
#property indicator_color3 ForestGreen
#property indicator_color4 Red
#property indicator_color5 Lime
#property indicator_color6 Tomato

#property indicator_style1 STYLE_DOT
#property indicator_width2 2
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 3
#property indicator_width6 3

#property indicator_level1  80
#property indicator_level2  50
#property indicator_level3  20
#property indicator_levelcolor DarkSlateGray
#property indicator_levelstyle 2


//---- input parameters
//
//    nice setings for trend = 35,10,1
//
//

extern int       KPeriod       =  14;
extern int       Slowing       =   3;
extern int       DPeriod       =   3;
extern int       MAMethod      =   2;
extern int       PriceField    =   0;
extern int       overBought    =  80;
extern int       overSold      =  20;
extern string    timeFrame     =  "Current TF";
extern string    note_timeFrames = "M1;5,15,30,60\H1;H4;D1;W1;MN||0-CurrentTF";

extern bool      showBars      = false;
extern int       BarsLevel     = 5;    //BarsLevel 0-100
extern int       BarsSize      = 2;    //0-5
extern bool      showArrows    = true;
extern color     ArrowUpRevClr = LimeGreen;
extern color     ArrowDnRevClr = Red;
extern int       ArrowRevSize  =  1;
extern color     ArrowUpClr = Green;
extern color     ArrowDnClr = Maroon;
extern int       ArrowSize  = 0;

extern bool      alertsOn      = false;
extern bool      alertsMessage = true;
extern bool      alertsSound   = false;
extern bool      alertsEmail   = false;

extern int       AddSigScreans  = 1;
//#define SignalName  ""StochasticSignal" 

//---- buffers
//
//
//
//
//

double   KFull[];
double   DFull[];
double   Upper[];
double   Lower[];
double   Uptrend[];
double   Downtrend[];

//
//
//
//
//

int      TimeFrame;
datetime TimeArray[];
int      maxArrows;
int      SignalGap;
string   SignalName;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{

      SetIndexBuffer(0,DFull);
      SetIndexBuffer(1,KFull);
      SetIndexBuffer(2,Upper);
      SetIndexBuffer(3,Lower);
      SetIndexBuffer(4,Uptrend);
      SetIndexBuffer(5,Downtrend);
         
         //
         //
         //
         //
         //
         
      if (showBars)
         {      
            SetIndexStyle(0,DRAW_NONE);
            SetIndexStyle(1,DRAW_NONE);
            SetIndexStyle(2,DRAW_ARROW,0,BarsSize);
            SetIndexStyle(3,DRAW_ARROW,0,BarsSize);
            SetIndexStyle(4,DRAW_ARROW,0,BarsSize);
            SetIndexStyle(5,DRAW_ARROW,0,BarsSize);
     
              SetIndexArrow (2,167);
              SetIndexArrow (3,167);
              SetIndexArrow (4,167);
              SetIndexArrow (5,167);

           
            SetIndexLabel(0,NULL);
            SetIndexLabel(1,NULL);
            SetIndexLabel(2,"Stochastic");
            SetIndexLabel(3,"Stochastic");
            SetIndexLabel(4,"Stochastic");
            SetIndexLabel(5,"Stochastic");
         }                  
      else
         {
            SetIndexLabel(0,"Stochastic");
            SetIndexLabel(1,"Stochastic");
            SetIndexLabel(2,NULL);
            SetIndexLabel(3,NULL);
            SetIndexLabel(4,NULL);
            SetIndexLabel(5,NULL);
            SetIndexStyle(0,DRAW_LINE);
            SetIndexStyle(1,DRAW_LINE);
            SetIndexStyle(2,DRAW_LINE);
            SetIndexStyle(3,DRAW_LINE);
            SetIndexStyle(4,DRAW_NONE);
            SetIndexStyle(5,DRAW_NONE);
           
            DPeriod = MathMax(DPeriod,1);
            if (DPeriod==1) {
                  SetIndexStyle(0,DRAW_NONE);
                  SetIndexLabel(0,NULL);
               }
            else {
                  SetIndexStyle(0,DRAW_LINE); 
                  SetIndexLabel(0,"Signal");
               }               
         }
              
         //
         //
         //
         //
         //
         
   TimeFrame        =stringToTimeFrame(timeFrame);
   string shortName = "Stochastic ("+TimeFrameToString(TimeFrame)+","+KPeriod+","+Slowing+","+DPeriod+","+maDescription(MAMethod)+","+priceDescription(PriceField);

         if (overBought < overSold) overBought = overSold;
         if (overBought < 100)      shortName  = shortName+","+overBought;
         if (overSold   >   0)      shortName  = shortName+","+overSold;
   IndicatorShortName(shortName+")");

SignalName=MakeUniqueName("Stoch102 #"," (" +KPeriod+","+Slowing+","+DPeriod+") ["+TimeFrameToString(TimeFrame)+"]");
//SignalName=MakeUniqueName("Stoch102 #", shortName);

   return(0);
}

//
//
//
//
//

int deinit()
{
   DeleteArrows();
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
{
   int    counted_bars=IndicatorCounted();
   int    limit;
   int    i,y;
   
   

   
   if(counted_bars<0) return(-1);
         limit=MathMax(Bars-counted_bars,TimeFrame/Period());
         ArrayCopySeries(TimeArray ,MODE_TIME ,NULL,TimeFrame);
            
      
   //
   //
   //
   //
   //
   
   for(i=0,y=0; i<limit; i++)
      {
         if(Time[i]<TimeArray[y]) y++;
            KFull[i] = iStochastic(NULL,TimeFrame,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_MAIN,y);
            DFull[i] = iStochastic(NULL,TimeFrame,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_SIGNAL,y);
      }
   for(i=limit,y=0; i>=0; i--)
      {
         if (showBars)
            {
               Upper[i]     = EMPTY_VALUE;
               Lower[i]     = EMPTY_VALUE;
               while(true)
                  {
                     if (KFull[i] > overBought) { Upper[i]     = BarsLevel; break;}
                     if (KFull[i] < overSold)   { Lower[i]     = BarsLevel; break;}
                     if (KFull[i] > KFull[i+1]) { Uptrend[i]   = BarsLevel; break;}
                     if (KFull[i] < KFull[i+1]) { Downtrend[i] = BarsLevel; break;}
                        Uptrend[i]   = Uptrend[i+1];
                        Downtrend[i] = Downtrend[i+1];
                     break;
                  }
            }
         else
            {
               if (KFull[i] > overBought) { Upper[i] = KFull[i]; Upper[i+1] = KFull[i+1]; }
               else                       { Upper[i] = EMPTY_VALUE;
                                            if (Upper[i+2] == EMPTY_VALUE)
                                                Upper[i+1]  = EMPTY_VALUE; }
               if (KFull[i] < overSold)   { Lower[i] = KFull[i]; Lower[i+1] = KFull[i+1]; }
               else                       { Lower[i] = EMPTY_VALUE;
                                            if (Lower[i+2] == EMPTY_VALUE)
                                                Lower[i+1]  = EMPTY_VALUE; }
            }                                                
      }                                             

   //
   //
   //
   //
   //

   DeleteArrows();
   if (showArrows)
      {
         if  (AddSigScreans<=0) AddSigScreans=1;

         SignalGap = MathCeil(iATR(NULL,0,50,0)/Point);
         for (i=0; i<WindowBarsPerChart()* AddSigScreans;i++)
            {
               if (KFull[i]<overBought && KFull[i+1]>overBought) DrawArrow(i,"dnRev");
               if (KFull[i]>overBought && KFull[i+1]<overBought) DrawArrow(i,"up");
     
               if (KFull[i]>overSold   && KFull[i+1]<overSold)   DrawArrow(i,"upRev");
               if (KFull[i]<overSold   && KFull[i+1]>overSold)   DrawArrow(i,"down");

            }
      }            
   if (alertsOn)
         {
            if (KFull[0]<overBought && KFull[1]>overBought) doAlert(overBought+" StochOverBought;ReverseDn");
            if (KFull[0]>overBought && KFull[1]<overBought) doAlert(overBought+" StochOverBought;ContinueUp");
      
            if (KFull[0]>overSold   && KFull[1]<overSold)   doAlert(overSold+" StochOversold;ReverseUp");
            if (KFull[0]<overSold   && KFull[1]>overSold)   doAlert(overSold+"StochOversold;ContinueDn");
       }
   
   //
   //
   //
   //
   //
 
   return(0);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//
//
//
//

string MakeUniqueName(string first, string rest)
{
   string result = first+(MathRand()%1001)+rest;

      while (WindowFind(result)>= 0)
             result = first+(MathRand()%1001)+rest;
   return(result);
}


//
//
//
//

void DrawArrow(int i,string type)
{
   maxArrows++;
      string name = StringConcatenate(SignalName,maxArrows);
         
      ObjectCreate(name,OBJ_ARROW,0,Time[i],0);
      if (type=="down")
         {
            ObjectSet(name,OBJPROP_PRICE1,High[i]+(SignalGap*Point));
            ObjectSet(name,OBJPROP_ARROWCODE,242);
            ObjectSet(name,OBJPROP_COLOR,ArrowDnClr);
            ObjectSet(name,OBJPROP_WIDTH,ArrowSize);
         }
      if (type=="dnRev")
         {
            ObjectSet(name,OBJPROP_PRICE1,High[i]+(SignalGap*Point));
            ObjectSet(name,OBJPROP_ARROWCODE,242);
            ObjectSet(name,OBJPROP_COLOR,ArrowDnRevClr);
            ObjectSet(name,OBJPROP_WIDTH,ArrowRevSize);
         }

      if (type=="up")
    
         {
            ObjectSet(name,OBJPROP_PRICE1,Low[i]-(SignalGap*Point));
            ObjectSet(name,OBJPROP_ARROWCODE,241);
            ObjectSet(name,OBJPROP_COLOR,ArrowUpClr);
            ObjectSet(name,OBJPROP_WIDTH,ArrowSize);
         }
      if (type=="upRev")
    
         {
            ObjectSet(name,OBJPROP_PRICE1,Low[i]-(SignalGap*Point));
            ObjectSet(name,OBJPROP_ARROWCODE,241);
            ObjectSet(name,OBJPROP_COLOR,ArrowUpRevClr);
            ObjectSet(name,OBJPROP_WIDTH,ArrowRevSize);
         }
}
void DeleteArrows()
{
   while(maxArrows>0) { ObjectDelete(StringConcatenate(SignalName,maxArrows)); maxArrows--; }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];
      
          //
          //
          //
          //
          //
            
          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Stochastic ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsSound)   PlaySound("alert2.wav");
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," Stochastic crossing"),message);
      }        
}


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

string priceDescription(int mode)
{
   string answer;
   switch(mode)
   {
      case 0:  answer = "Low/High"    ; break; 
      case 1:  answer = "Close/Close" ; break;
      default: answer = "Invalid price field requested";
                                    Alert(answer);
   }
   return(answer);
}
string maDescription(int mode)
{
   string answer;
   switch(mode)
   {
      case MODE_SMA:  answer = "SMA"  ; break; 
      case MODE_EMA:  answer = "EMA"  ; break;
      case MODE_SMMA: answer = "SMMA" ; break;
      case MODE_LWMA: answer = "LWMA" ; break;
      default:        answer = "Invalid MA mode requested";
                                    Alert(answer);
   }
   return(answer);
}
int stringToTimeFrame(string tfs)
{
   int tf=0;
       tfs = StringUpperCase(tfs);
         if (tfs=="M1" || tfs=="1M"   || tfs=="1"  )                tf=PERIOD_M1 ;
         if (tfs=="M5" || tfs=="5M"   || tfs=="5"  )                tf=PERIOD_M5 ;
         if (tfs=="M15"|| tfs=="15M"  || tfs=="15" )                tf=PERIOD_M15;
         if (tfs=="M30"|| tfs=="30M"  || tfs=="30" )                tf=PERIOD_M30;
         if (tfs=="H1" || tfs=="1H"   || tfs=="60" )                tf=PERIOD_H1 ;
         if (tfs=="H4" || tfs=="4H"   || tfs=="240")                tf=PERIOD_H4 ;
         if (tfs=="D1" || tfs=="1D"   || tfs=="D" || tfs=="1440")   tf=PERIOD_D1 ;
         if (tfs=="W1" || tfs=="10080"|| tfs=="1W"|| tfs=="W")      tf=PERIOD_W1 ;
         if (tfs=="MN" || tfs=="43200") tf=PERIOD_MN1;
         if (tf<Period()) tf=Period();
  return(tf);
}
string TimeFrameToString(int tf)
{
   string tfs="CurrentTF";
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN1";
   }
   return(tfs);
}

//
//
//
//
//

string StringUpperCase(string str)
{
   string   s = str;
   int      lenght = StringLen(str) - 1;
   int      char;
   
   while(lenght >= 0)
      {
         char = StringGetChar(s, lenght);
         
         //
         //
         //
         //
         //
         
         if((char > 96 && char < 123) || (char > 223 && char < 256))
                  s = StringSetChar(s, lenght, char - 32);
          else 
              if(char > -33 && char < 0)
                  s = StringSetChar(s, lenght, char + 224);
         lenght--;
   }
   
   //
   //
   //
   //
   //
   
   return(s);
}