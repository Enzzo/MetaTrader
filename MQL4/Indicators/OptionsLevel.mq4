//+------------------------------------------------------------------+
//|                                                 OptionsLevel.mq4 |
//|                                              Copyright 2016, AM2 |
//|                                      http://www.forexsystems.biz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, AM2"
#property link      "http://www.forexsystems.biz"
#property version   "1.00"
#property strict
#property indicator_chart_window

input double Call_1_Strike  = 1115;     // Call Strike Price 1
input double Call_1_Prem    = 7.6;      // Call Premium 1
input double Call_1_Vol     = 471;      // Call Volume 1
input double Call_1_OI      = 1513;     // Call Open Interest 1

input double Call_2_Strike  = 1120;     // Call Strike Price 2
input double Call_2_Prem    = 5.8;      // Call Premium 2
input double Call_2_Vol     = 419;      // Call Volume 2
input double Call_2_OI      = 3016;     // Call Open Interest 2

input double Call_3_Strike  = 1130;     // Call Strike Price 3
input double Call_3_Prem    = 3.1;      // Call Premium 3
input double Call_3_Vol     = 696;      // Call Volume 3
input double Call_3_OI      = 2738;     // Call Open Interest 3

input double Put_1_Strike   = 1080;     // Put Strike Price 1
input double Put_1_Prem     = 1.9;      // Put Premium 1
input double Put_1_Vol      = 694;      // Put Volume 1
input double Put_1_OI       = 2541;     // Put Open Interest 1

input double Put_2_Strike   = 1100;     // Put Strike Price 2
input double Put_2_Prem     = 6.2;      // Put Premium 2
input double Put_2_Vol      = 655;      // Put Volume 2
input double Put_2_OI       = 3148;     // Put Open Interest 2

input double Put_3_Strike   = 1090;     // Put Strike Price 3
input double Put_3_Prem     = 3.5;      // Put Premium 3
input double Put_3_Vol      = 286;      // Put Volume 3
input double Put_3_OI       = 7061;     // Put Open Interest 3

input double Multiplier     = 0.001;    // Premium Multiplier

input string Line_Inputs="**** Line Inputs *****";

input int    LineWidth      = 2;        // Line Width
input int    LineStyle      = 0;        // Line Style
input int    LineStart      = 0;        // Start bar of the line
input int    LineEnd        = 15;       // End bar of the line
input color  CallColor      = Red;      // Call Line Color 
input color  PutColor       = Lime;     // Put Line Color 

input string Text_Inputs="**** Text_Inputs *****";

input int    StartText      = 6;        // Start bar of the text
input int    FontSize       = 6;        // Font Size
input string FontName       = "Arial";  // Font Name  
input color  CallText       = Blue;     // Call Text Color
input color  PutText        = Blue;     // Put Text Color 
input bool   ShowText       = true;     // Show Text
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,0,OBJ_TEXT);
   ObjectsDeleteAll(0,0,OBJ_TREND);
  }
//+------------------------------------------------------------------+
//| Put Line Function                                                |
//+------------------------------------------------------------------+
void PutTrendLine(string name,datetime time1,double price1,datetime time2,double price2,color clr)
  {
   ObjectDelete(0,name);
   ObjectCreate(0,name,OBJ_TREND,0,time1,price1,time2,price2);
//--- set line color 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
//--- set the display style of the line 
   ObjectSetInteger(0,name,OBJPROP_STYLE,LineStyle);
//--- set line thickness 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,LineWidth);
//--- enable (true) or disable (false) the mode of continuing the line display to the right 
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
  }
//+------------------------------------------------------------------+
//| Put Text Function                                                |
//+------------------------------------------------------------------+
void Text(string name,const string text,double price,datetime time,const color clr)
  {
   ObjectDelete(0,name);
//--- create a "Text" object 
   ObjectCreate(0,name,OBJ_TEXT,0,time,price);
//--- set the text
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//--- set the font of the text
   ObjectSetString(0,name,OBJPROP_FONT,FontName);
//--- set the font size
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
//--- set the method binding
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_UPPER);
//--- set the color
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
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
   double pr=0;
   
// Call 1 
   if(Call_1_Strike>0)
     {
      pr=NormalizeDouble(Call_1_Strike*0.001+Call_1_Prem*Multiplier,_Digits);
      PutTrendLine("Call_1",time[LineStart],pr,time[LineEnd],pr,CallColor);
      if(ShowText)
         Text("Call 1 Text ","VOL="+DoubleToString(Call_1_Vol,0)+" OI="+DoubleToString(Call_1_OI,0)+" PT="+DoubleToString(Call_1_Prem,1),pr,time[StartText],CallText);
     }
     
// Call 2
   if(Call_2_Strike>0)
     {
      pr=NormalizeDouble(Call_2_Strike*0.001+Call_2_Prem*Multiplier,_Digits);
      PutTrendLine("Call_2",time[LineStart],pr,time[LineEnd],pr,CallColor);
      if(ShowText)
         Text("Call 2 Text ","VOL="+DoubleToString(Call_2_Vol,0)+" OI="+DoubleToString(Call_2_OI,0)+" PT="+DoubleToString(Call_2_Prem,1),pr,time[StartText],CallText);
     }

// Call 3
   if(Call_3_Strike>0)
     {
      pr=NormalizeDouble(Call_3_Strike*0.001+Call_3_Prem*Multiplier,_Digits);
      PutTrendLine("Call_3",time[LineStart],pr,time[LineEnd],pr,CallColor);
      if(ShowText)
         Text("Call 3 Text ","VOL="+DoubleToString(Call_3_Vol,0)+" OI="+DoubleToString(Call_3_OI,0)+" PT="+DoubleToString(Call_3_Prem,1),pr,time[StartText],CallText);
     }

// Put 1
   if(Put_1_Strike>0)
     {
      pr=NormalizeDouble(Put_1_Strike*0.001-Put_1_Prem*Multiplier,_Digits);
      PutTrendLine("Put_1",time[LineStart],pr,time[LineEnd],pr,PutColor);
      if(ShowText)
         Text("Put 1 Text ","VOL="+DoubleToString(Put_1_Vol,0)+" OI="+DoubleToString(Put_1_OI,0)+" PT="+DoubleToString(Put_1_Prem,1),pr,time[StartText],PutText);
     }
     
// Put 2
   if(Put_2_Strike>0)
     {
      pr=NormalizeDouble(Put_2_Strike*0.001-Put_2_Prem*Multiplier,_Digits);
      PutTrendLine("Put_2",time[LineStart],pr,time[LineEnd],pr,PutColor);
      if(ShowText)
         Text("Put 2 Text ","VOL="+DoubleToString(Put_2_Vol,0)+" OI="+DoubleToString(Put_2_OI,0)+" PT="+DoubleToString(Put_2_Prem,1),pr,time[StartText],PutText);
     }

// Put 3
   if(Put_3_Strike>0)
     {
      pr=NormalizeDouble(Put_3_Strike*0.001-Put_3_Prem*Multiplier,_Digits);
      PutTrendLine("Put_3",time[LineStart],pr,time[LineEnd],pr,PutColor);
      if(ShowText)
         Text("Put 3 Text ","VOL="+DoubleToString(Put_3_Vol,0)+" OI="+DoubleToString(Put_3_OI,0)+" PT="+DoubleToString(Put_3_Prem,1),pr,time[StartText],PutText);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
