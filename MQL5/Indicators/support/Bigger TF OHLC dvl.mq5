//+------------------------------------------------------------------+
//|                                                   BTF_Source.mq4 |
//|                             Copyright (c) 2016, Gehtsoft USA LLC | 
//|                                            http://fxcodebase.com |
//|                                   Paypal: https://goo.gl/9Rj74e  | 
//+------------------------------------------------------------------+
//|                                      Developed by : Mario Jemic  |                    
//|                                          mario.jemic@gmail.com   |
//|                   BitCoin : 15VCJTLaz12Amr7adHSBtL9v8XomURo9RF   |
//+------------------------------------------------------------------+
#property copyright "© Mario Jemic, Александр2, Tankk,  27 августа 2019,  http://forexsystemsru.com/" 
#property link      "https://forexsystemsru.com/threads/indikatory-sobranie-sochinenij-tankk.86203/"  ////https://forexsystemsru.com/forums/indikatory-foreks.41/
#property version "2.22"
//#property strict
#property indicator_chart_window
//------
//enum e_cycles{ min5, min15, min30, min60, min240, Daily, Weekly, Monthly };
enum modeTF { Previous, Current };
enum showLN { Hide,/*hide Lines*/ Prev,/*only Previous*/ Curr,/*only Current*/ Full/*all Lines*/ };
//------
//------
//input e_cycles BTF             = Daily;
input ENUM_TIMEFRAMES TimeFrame  = PERIOD_D1;
input modeTF   Method             = Current;
input int      CountTF            = 12;
/*input*/ bool ShowCurrent       = true;
input int      LinesPlusTF        = 0;
input showLN   ShowOpen           = Curr,
               ShowHigh           = Prev,
               ShowLow            = Prev,
               ShowClose          = Prev;
input color   OpenColor          = clrGold,  //clrDarkGray;
               HighColor          = clrRed,
               LowColor           = clrLime,
               CloseColor         = clrRoyalBlue,
               Separator          = clrDarkViolet;  //clrDimGray;
input ENUM_LINE_STYLE LinesStyle = STYLE_SOLID;
input int      LinesWidth         = 2;
input bool     ShowLabels         = true;
//------
//------
string PREF;
//int Periodo, Minutes;
ENUM_TIMEFRAMES time_frame = TimeFrame;
int lines_plus_tf = LinesPlusTF;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   time_frame = fmax(time_frame,Period());   
   //CountTF = fmax(CountTF,1);   
   lines_plus_tf = fmax(lines_plus_tf+1,1);   
   //---
   PREF = stringMTF(time_frame)+": BTF OHLC dvl: "+EnumToString(Method)+" ["+IntegerToString(CountTF)+"] ";
   //---
   IndicatorSetString(INDICATOR_SHORTNAME, stringMTF(time_frame)+": Bigger TF OHLC dvl");
   //if (Check()) Alert("The Bigger TF Source selected for this Time Frame cannot be calculated");
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
//---
    if (time_frame==_Period) {
       Comment
        (
         "\n" 
         + "Bigger TF OHLC dvl:  индикатор отключён!" 
         + "\n" 
         + "TimeFrame должен быть больше текущего периода графика!"
        );  return(0); }   
//**************************************************************************//
//**************************************************************************//
   int i, bar;   int zero = (ShowCurrent) ? 0 : 1;
   double OPEN, HIGH, LOW, CLOSE;
   datetime LineStart, LineEnd;   bool DrawLabel;     int limit = (CountTF>0) ? CountTF-1 : (Bars(Symbol(), PERIOD_CURRENT)-2)/(time_frame/_Period);
//**************************************************************************//
//**************************************************************************//
   //if (Check()==false){
   for (i=limit; i>=zero; i--)
    {
     //if (BTF==0){ Periodo = PERIOD_M5;  Minutes = 5;     }
     //if (BTF==1){ Periodo = PERIOD_M15; Minutes = 15;    }
     //if (BTF==2){ Periodo = PERIOD_M30; Minutes = 30;    }
     //if (BTF==3){ Periodo = PERIOD_H1;  Minutes = 60;    }
     //if (BTF==4){ Periodo = PERIOD_H4;  Minutes = 240;   }
     //if (BTF==5){ Periodo = PERIOD_D1;  Minutes = 1440;  }
     //if (BTF==6){ Periodo = PERIOD_W1;  Minutes = 10080; }
     //if (BTF==7){ Periodo = PERIOD_MN1; Minutes = 43200; }
     
     // enum modeTF { Previous, Current };
     if (Method==0) bar = i+1;  else bar = i;  
     
     // Calculations
     OPEN = iOpen(NULL,time_frame,bar);
     HIGH = iHigh(NULL,time_frame,bar);
     LOW = iLow(NULL,time_frame,bar);
     CLOSE = iClose(NULL,time_frame,bar);
     
      // Drawing the Lines
      
      datetime time[1];
      CopyTime(Symbol(), time_frame, i, 1, time);
      LineStart = time[0];
      LineEnd = time[0] + 60 * tf_to_minutes(time_frame) * lines_plus_tf;
      
     if (i==0) DrawLabel = true;   else DrawLabel = false;
     
     // enum showLN { Hide, Prev, Curr, Full };
     if (ShowOpen!=0 && OpenColor!=clrNONE) { 
         if (i!=0 && (ShowOpen==1 || ShowOpen==3)) Pivot("OPEN",i,LineStart,OPEN,LineEnd, OpenColor,LinesWidth+1, DrawLabel);
         if (i==0 && (ShowOpen==2 || ShowOpen==3)) Pivot("OPEN",i,LineStart,OPEN,LineEnd, OpenColor,LinesWidth+1, DrawLabel); }
     //---
     if (ShowHigh!=0 && HighColor!=clrNONE) { 
      if (i!=0 && (ShowHigh==1 || ShowHigh==3)) Pivot("HIGH",i,LineStart,HIGH,LineEnd, HighColor,LinesWidth, DrawLabel);
      if (i==0 && (ShowHigh==2 || ShowHigh==3)) Pivot("HIGH",i,LineStart,HIGH,LineEnd, HighColor,LinesWidth, DrawLabel); }
     //---
     if (ShowLow!=0 && LowColor!=clrNONE) {   
         if (i!=0 && (ShowLow==1 || ShowLow==3)) Pivot("LOW",i,LineStart,LOW,LineEnd, LowColor,LinesWidth, DrawLabel);
         if (i==0 && (ShowLow==2 || ShowLow==3)) Pivot("LOW",i,LineStart,LOW,LineEnd, LowColor,LinesWidth, DrawLabel); }
     //---
     if (ShowClose!=0 && CloseColor!=clrNONE) {
         if (i!=0 && (ShowClose==1 || ShowClose==3)) Pivot("CLOSE",i,LineStart,CLOSE,LineEnd, CloseColor,LinesWidth, DrawLabel);
         if (i==0 && (ShowClose==2 || ShowClose==3)) Pivot("CLOSE",i,LineStart,CLOSE,LineEnd, CloseColor,LinesWidth, DrawLabel); }
     //---
     if (Separator!=clrNONE) {  
                   SetSeparator("Sepr",i,LineStart);  ///, Separator, 0, STYLE_DOT);
         if (i==0) SetSeparator("SeprF",0,LineStart+60*time_frame*1); }
   //------
    } //*конец цикла*
   //} // if Check==false
//--- return value of prev_calculated for next call
   return(rates_total);
  }
  
void OnDeinit(const int reason){
    ALL_OBJ_DELETE();  Comment("");
    ChartRedraw();
}

void ALL_OBJ_DELETE(){
   string name;
   for (int s=ObjectsTotal(ChartID())-1; s>=0; s--) {
        name=ObjectName(ChartID(), s);
        if (StringSubstr(name,0,StringLen(PREF))==PREF) ObjectDelete(ChartID(), name); }
}

//------
//------
void Pivot(string Name, int i, datetime tiempo1, double precio1, datetime tiempo2, color bpcolor, int Size, bool drawText)
{
   string objName = PREF+Name+IntegerToString(i); 
   ObjectDelete(ChartID(), objName);
   ObjectCreate(ChartID(), objName, OBJ_TREND, 0, tiempo1, precio1, tiempo2, precio1);
   ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, bpcolor);
   ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, LinesStyle);
   ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, Size);
   ObjectSetInteger(ChartID(), objName, OBJPROP_RAY, false);
   ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, true );
   ObjectSetInteger(ChartID(), objName, OBJPROP_SELECTABLE, false );
   
   if (ShowLabels && drawText)
    {
     ObjectDelete(ChartID(), objName+"T");
     ObjectCreate(ChartID(), objName+"T", OBJ_TEXT, 0, tiempo2+(3*_Period*60), precio1 );
     // ObjectSetString(ChartID(), objName+"T", Name, 8, "Arial Black", bpcolor );  ///StringSubstr(objName,0,StringLen(objName)-1)
     ObjectSetString(ChartID(), objName+"T", OBJPROP_TEXT, Name);
     ObjectSetInteger(ChartID(), objName+"T", OBJPROP_FONTSIZE, 8);
     ObjectSetString(ChartID(), objName+"T", OBJPROP_FONT, "Arial Black");
     ObjectSetInteger(ChartID(), objName+"T", OBJPROP_COLOR, bpcolor);
     ObjectSetInteger(ChartID(), objName+"T", OBJPROP_BACK, true );
     ObjectSetInteger(ChartID(), objName+"T", OBJPROP_SELECTABLE, false );
     ObjectSetDouble(ChartID(), objName+"T", OBJPROP_ANGLE, 0); 
     ObjectSetInteger(ChartID(), objName+"T", OBJPROP_ANCHOR, ANCHOR_LEFT);  //ANCHOR_RIGHT_LOWER);
     //ObjectSet(objName+"T", OBJPROP_TIME1, tiempo2+(2*_Period*60));
     //ObjectSet(objName+"T", OBJPROP_PRICE1, precio1);
    }
}
//------
//------
// Draw Separator
void SetSeparator(string Name, int i, datetime tiempo1)  ///, color sesscolor, int ancho, int style){
{
   string objName = PREF+Name+(string)i; 
   ObjectDelete(ChartID(), objName);
   ObjectCreate(ChartID(), objName, OBJ_VLINE, 0, tiempo1, ChartGetDouble(ChartID(), CHART_PRICE_MAX));
   ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, Separator);
   ObjectSetInteger(ChartID(), objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, 0);
   ObjectSetInteger(ChartID(), objName, OBJPROP_BACK, true);
   ObjectSetInteger(ChartID(), objName, OBJPROP_SELECTABLE, false);
}
//------
//------
//bool Check ()
//{
//   bool wrong_tf = false;
//   if (_Period==5     && BTF<2) wrong_tf = true;
//   if (_Period==15    && BTF<3) wrong_tf = true;
//   if (_Period==30    && BTF<4) wrong_tf = true;
//   if (_Period==60    && BTF<5) wrong_tf = true;
//   if (_Period==240   && BTF<6) wrong_tf = true;
//   if (_Period==1440  && BTF<7) wrong_tf = true;
//   if (_Period==10080 && BTF<8) wrong_tf = true;
//   if (_Period==43200)          wrong_tf = true;
//   return(wrong_tf);
//}
//------
//------
string stringMTF(int perMTF)
{  
   if (perMTF==0)      perMTF=_Period;
   if (perMTF==1)      return("M1");
   if (perMTF==5)      return("M5");
   if (perMTF==15)     return("M15");
   if (perMTF==30)     return("M30");
   if (perMTF==60)     return("H1");
   if (perMTF==240)    return("H4");
   if (perMTF==1440)   return("D1");
   if (perMTF==10080)  return("W1");
   if (perMTF==43200)  return("MN1");
   if (perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||       /// нестандартные периоды для грфиков Renko
               10 || 11 || 12 || 13 || 14 || 16 || 17 || 18)  return("M"+(string)_Period);
//------
   return("Ошибка периода");
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                            iMAX AA MTF TT                            %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int tf_to_minutes(const ENUM_TIMEFRAMES tf){
   switch(tf){
      case PERIOD_M1:   return 1;
      case PERIOD_M2:   return 2;
      case PERIOD_M3:   return 3;
      case PERIOD_M4:   return 4;
      case PERIOD_M5:   return 5;
      case PERIOD_M6:   return 6;
      case PERIOD_M10:  return 10;
      case PERIOD_M12:  return 12;
      case PERIOD_M15:  return 15;
      case PERIOD_M20:  return 20;
      case PERIOD_M30:  return 30;
      case PERIOD_H1:   return 60;
      case PERIOD_H2:   return 120;
      case PERIOD_H3:   return 180;
      case PERIOD_H4:   return 240;
      case PERIOD_H6:   return 360;
      case PERIOD_H8:   return 480;
      case PERIOD_H12:  return 720;
      case PERIOD_D1:   return 1440;
      case PERIOD_W1:   return 10080;
      case PERIOD_MN1:  return 43200;
   }
   return 0;
}