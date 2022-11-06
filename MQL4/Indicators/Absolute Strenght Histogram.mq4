//+------------------------------------------------------------------+
//|                                  Absolute Strength histogram.mq4 |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 2
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_width1 4
#property indicator_width2 4

extern int    Length =  3; // Period
extern int    Smooth =  3; // Period of smoothing
extern int    Signal =  3; // Period of Signal Line
extern ENUM_MA_METHOD ModeMA = MODE_EMA; // Mode of Moving Average
extern int    SuperSignalsPeriod = 96;   

extern bool   ShowAlertLines   = true;
extern int    BarsToCountLines = 500;
extern color  LineUpColor      = clrBlue;
extern color  LineDnColor      = clrRed;
extern ENUM_LINE_STYLE LinesStyle = STYLE_DASH;
extern int    LinesWidth       = 1;
extern string SignalName       ="ASH line";
extern string AlertSound       ="alert2";
extern bool   AlertsOn         = true;
extern bool   AlertsMesage     = true;
extern bool   AlertsSound      = false;
extern bool   AlertsEmail      = false;

double Bulls[],Bears[],AvgBulls[],AvgBears[],SmthBulls[],SmthBears[],SigBulls[],SigBears[],b1[],b2[];
double Price1,Price2,hhb,llb;
bool   UpTrend = false;
bool   DnTrend = false;
int    maxArrows,TimeFrame;
int    shift=SuperSignalsPeriod/2;

//-------------------------------------------------------------------+
int deinit() {if (ShowAlertLines) DeleteArrows(); return(0);}
//+------------------------------------------------------------------+

int init()
  {
   IndicatorBuffers(10);
   SetIndexBuffer(0,SigBulls); SetIndexStyle(0,DRAW_HISTOGRAM); SetIndexLabel(0,"Bulls");
   SetIndexBuffer(1,SigBears); SetIndexStyle(1,DRAW_HISTOGRAM); SetIndexLabel(1,"Bears");
   SetIndexBuffer(2,SmthBulls); 
   SetIndexBuffer(3,SmthBears); 
   SetIndexBuffer(4,Bulls);
   SetIndexBuffer(5,Bears);
   SetIndexBuffer(6,AvgBulls);
   SetIndexBuffer(7,AvgBears);
   SetIndexBuffer(8,b1);
   SetIndexBuffer(9,b2);
   
   TimeFrame  = MathMax(TimeFrame,_Period);
   IndicatorShortName(timeFrameToString(TimeFrame)+" Absolute Strenght histogram ("+Length+","+Smooth+","+Signal+","+SuperSignalsPeriod+")");
   SetIndexDrawBegin(0,Length+Smooth+Signal);
   SetIndexDrawBegin(1,Length+Smooth+Signal);
   SetIndexDrawBegin(2,Length+Smooth+Signal);
   SetIndexDrawBegin(3,Length+Smooth+Signal);
 
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
   SetIndexEmptyValue(7,0.0);
   return(0);
  }

//+------------------------------------------------------------------+

int start()
{
   int i, limit, counted_bars=IndicatorCounted();
   if (counted_bars < 0) return(-1);
   if (counted_bars ==0) limit=Bars-Length+Smooth+Signal-1;
   if (counted_bars < 1)
    
   for(i=1;i<Length+Smooth+Signal;i++) 
      {
         Bulls[Bars-i]=0;    
         Bears[Bars-i]=0;  
         AvgBulls[Bars-i]=0;    
         AvgBears[Bars-i]=0;  
         SmthBulls[Bars-i]=0;    
         SmthBears[Bars-i]=0;  
         SigBulls[Bars-i]=0;    
         SigBears[Bars-i]=0;  
      }

   if(counted_bars>0) limit=Bars-counted_bars;
   limit--;
   
   for( i=limit; i>=0; i--)
      {
         Price1 = iMA(NULL,0,1,0,0,0,i);
         Price2 = iMA(NULL,0,1,0,0,0,i+1); 
         Bulls[i] = 0.5*(MathAbs(Price1-Price2)+(Price1-Price2));
         Bears[i] = 0.5*(MathAbs(Price1-Price2)-(Price1-Price2));
      }
      
   for( i=limit; i>=0; i--)
      {
         AvgBulls[i]=iMAOnArray(Bulls,0,Length,0,ModeMA,i);     
         AvgBears[i]=iMAOnArray(Bears,0,Length,0,ModeMA,i);
      }
      
   for( i=limit; i>=0; i--)
      {
         SmthBulls[i]=iMAOnArray(AvgBulls,0,Smooth,0,ModeMA,i);     
         SmthBears[i]=iMAOnArray(AvgBears,0,Smooth,0,ModeMA,i);
         if(SmthBulls[i]-SmthBears[i]>0) {SigBulls[i]=1; SigBears[i]=0;} 
         else {SigBears[i]=1; SigBulls[i]=0;} 
         
         hhb = Highest(NULL,0,MODE_HIGH,SuperSignalsPeriod,i-shift);
         llb = Lowest(NULL,0,MODE_LOW,SuperSignalsPeriod,i-shift);
         if (i==hhb) {b1[i]=1; DnTrend=true; UpTrend=false;} 
         else if (i==llb) {b2[i]=1; UpTrend=true; DnTrend=false;}
         else if (DnTrend==true) {b1[i]=b1[i+1]; b2[i]=0;}
         else if (UpTrend==true) {b2[i]=b2[i+1]; b1[i]=0;}
      }

  if (AlertsOn)
      {
         if (SigBulls[0]>0 && SigBulls[1]==0 && b2[0]>0) doAlert(" BUY alert @ ");
         if (SigBears[0]>0 && SigBears[1]==0 && b1[0]>0) doAlert(" SELL alert @ ");
      }
           
   if (ShowAlertLines)
      {
         DeleteArrows();
         for (i=0; i<BarsToCountLines ;i++)
            {
               if (SigBulls[i]>0 && SigBulls[i+1]==0 && b2[i]>0) DrawArrow(i,"up");
               if (SigBears[i]>0 && SigBears[i+1]==0 && b1[i]>0) DrawArrow(i,"down");
            }
      }
           
   return(0);
}

//+------------------------------------------------------------------+

void DrawArrow(int i,string type)
{
   maxArrows++;
      string name  = StringConcatenate(SignalName,maxArrows);
               
      ObjectCreate(name,OBJ_VLINE,0,Time[i],0);
      
      if (type=="up")
         {
            ObjectSet(name,OBJPROP_STYLE,LinesStyle);    
            ObjectSet(name,OBJPROP_WIDTH,LinesWidth);    
            ObjectSet(name,OBJPROP_COLOR,LineUpColor);
         }
      else if (type=="down")
      
         {
            ObjectSet(name,OBJPROP_STYLE,LinesStyle);
            ObjectSet(name,OBJPROP_WIDTH,LinesWidth);
            ObjectSet(name,OBJPROP_COLOR,LineDnColor);
         }
}

//--------------------------------------------------------------------

void DeleteArrows()
{
   while(maxArrows>0) { ObjectDelete(StringConcatenate(SignalName,maxArrows));maxArrows--; }
}

//+-------------------------------------------------------------------

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[0]) 
      {
         previousAlert  = doWhat;
         previousTime   = Time[0];
         message = timeFrameToString(TimeFrame)+" ASH "+Symbol()+doWhat+DoubleToStr(Close[0],Digits);
         if (AlertsMesage) Alert(message);
         if (AlertsSound)  PlaySound("alert2.wav");
         if (AlertsEmail)  SendMail(StringConcatenate(Symbol(),"ASH "),message);
      }
} 

//--------------------------------------------------------------------

string sTfTable[] = {"M1","M2","M3","M5","M10","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,2,3,5,10,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//--------------------------------------------------------------------
