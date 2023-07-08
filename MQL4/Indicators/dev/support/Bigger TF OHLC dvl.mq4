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
//extern e_cycles BTF             = Daily;
extern ENUM_TIMEFRAMES TimeFrame  = PERIOD_D1;
extern modeTF  Method             = Current;
extern int     CountTF            = 12;
/*extern*/ bool ShowCurrent       = true;
extern int     LinesPlusTF        = 0;
extern showLN  ShowOpen           = Curr,
               ShowHigh           = Prev,
               ShowLow            = Prev,
               ShowClose          = Prev;
extern color   OpenColor          = clrGold,  //clrDarkGray;
               HighColor          = clrRed,
               LowColor           = clrLime,
               CloseColor         = clrRoyalBlue,
               Separator          = clrDarkViolet;  //clrDimGray;
extern ENUM_LINE_STYLE LinesStyle = STYLE_SOLID;
extern int     LinesWidth         = 2;
extern bool    ShowLabels         = true;
//------
//------
string PREF;
//int Periodo, Minutes;
//------
//------
int init()
{
   TimeFrame = fmax(TimeFrame,_Period);   
   //CountTF = fmax(CountTF,1);   
   LinesPlusTF = fmax(LinesPlusTF+1,1);   
   //---
   PREF = stringMTF(TimeFrame)+": BTF OHLC dvl: "+EnumToString(Method)+" ["+(string)CountTF+"] ";
   //---
   IndicatorShortName(stringMTF(TimeFrame)+": Bigger TF OHLC dvl");   ///Source");
   //if (Check()) Alert("The Bigger TF Source selected for this Time Frame cannot be calculated");
//---
return(0);
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%              Custom indicator deinitialization function              &&&
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
///void OnDeinit(const int reason)  { ObjectsDeleteAll(0,PREF,-1,-1); }     
int deinit()  { ALL_OBJ_DELETE();  Comment("");  return(0); }
//+++======================================================================+++
void ALL_OBJ_DELETE()
{
   string name;
   for (int s=ObjectsTotal()-1; s>=0; s--) {
        name=ObjectName(s);
        if (StringSubstr(name,0,StringLen(PREF))==PREF) ObjectDelete(name); }
}  
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                 Custom indicator iteration function                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int start()
{
   if (TimeFrame==_Period) {
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
   datetime LineStart, LineEnd;   bool DrawLabel;     int limit = (CountTF>0) ? CountTF-1 : (Bars-2)/(TimeFrame/_Period);
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
     OPEN = iOpen(NULL,TimeFrame,bar);
     HIGH = iHigh(NULL,TimeFrame,bar);
     LOW = iLow(NULL,TimeFrame,bar);
     CLOSE = iClose(NULL,TimeFrame,bar);
     
     // Drawing the Lines
     LineStart = iTime(NULL,TimeFrame,i);
     LineEnd = iTime(NULL,TimeFrame,i)+60*TimeFrame*LinesPlusTF;   ///LineEnd = iTime(NULL,TimeFrame,i-1);

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
         if (i==0) SetSeparator("SeprF",0,LineStart+60*TimeFrame*1); }
   //------
    } //*конец цикла*
   //} // if Check==false
//------
return(0);
}
//------
//------
void Pivot(string Name, int i, datetime tiempo1, double precio1, datetime tiempo2, color bpcolor, int Size, bool drawText)
{
   string objName = PREF+Name+(string)i; 
   ObjectDelete(objName);
   ObjectCreate(objName, OBJ_TREND, 0, tiempo1, precio1, tiempo2, precio1);
   ObjectSet(objName, OBJPROP_COLOR, bpcolor);
   ObjectSet(objName, OBJPROP_STYLE, LinesStyle);
   ObjectSet(objName, OBJPROP_WIDTH, Size);
   ObjectSet(objName, OBJPROP_RAY, false);
   ObjectSet(objName, OBJPROP_BACK, true );
   ObjectSet(objName, OBJPROP_SELECTABLE, false );
   
   if (ShowLabels && drawText)
    {
     ObjectDelete(objName+"T");
     ObjectCreate(objName+"T", OBJ_TEXT, 0, tiempo2+(3*_Period*60), precio1 );
     ObjectSetText(objName+"T", Name, 8, "Arial Black", bpcolor );  ///StringSubstr(objName,0,StringLen(objName)-1)
     ObjectSet(objName+"T", OBJPROP_BACK, true );
     ObjectSet(objName+"T", OBJPROP_SELECTABLE, false );
     ObjectSet(objName+"T", OBJPROP_ANGLE, 0); 
     ObjectSet(objName+"T", OBJPROP_ANCHOR, ANCHOR_LEFT);  //ANCHOR_RIGHT_LOWER);
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
   ObjectDelete(objName);
   ObjectCreate(objName, OBJ_VLINE, 0, tiempo1, WindowPriceMax());
   ObjectSet(objName, OBJPROP_COLOR, Separator);
   ObjectSet(objName, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(objName, OBJPROP_WIDTH, 0);
   ObjectSet(objName, OBJPROP_BACK, true);
   ObjectSet(objName, OBJPROP_SELECTABLE, false);
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