//+------------------------------------------------------------------+
//| Magnified Market Price.mq4        ver1.4             by Habeeb   |
//+------------------------------------------------------------------+
//| Magnified Market Price_TRO_MODIFIED_VERSION                      |
//| MODIFIED BY  JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+
#property description " original source by AVERY T. HORTON,"
#property description " modified to show the currency symbol and timeframe"
#property description " on top right hand corner on your chart"
#property description " ___________________________________________________"

#property indicator_chart_window

  int    xAxis      = 10;
  int    yAxis      = 36;
  
  extern string note1       = "Symbol & TF Font Color";
  extern color  FontColor   = Magenta;//...
  
  extern string note2    = "Font Type & Size";
  
  extern string FontType = "Arial Black"; //...
  
  extern int    FontSize   = 14;

  extern string chartNote     = " .. add note here ..";
  extern color  chartNoteColor    = Yellow;
  extern string note3    = "Font Type & Size";
  
  extern string chartNoteFont = "Trebuchet MS"; //...
  extern int    chartNoteSize = 12;
  
 

string   symbol, ChartPeriod,  ShortName ;  
int      period  ; 

 
string shortName ;
 
//+------------------------------------------------------------------+  
   
int init()
{
   period       =  Period() ;     
   ChartPeriod =  TimeFrameToString(period) ;  
   
     
   shortName = "Symbol&TF" ; 
   ObjectCreate("Chart_SymbolTF_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Chart_SymbolTF_Label", OBJPROP_CORNER, 1);//ChartCorner);
   ObjectSet("Chart_SymbolTF_Label", OBJPROP_XDISTANCE, xAxis );
   ObjectSet("Chart_SymbolTF_Label", OBJPROP_YDISTANCE, yAxis );

   if( chartNote != "")
   {
      ObjectCreate("On_Chart_Note", OBJ_LABEL, 0, 0, 0);
      ObjectSet("On_Chart_Note", OBJPROP_CORNER, 1);//ChartCorner);
      ObjectSet("On_Chart_Note", OBJPROP_XDISTANCE, xAxis );
      ObjectSet("On_Chart_Note", OBJPROP_YDISTANCE, 2*FontSize + yAxis );   
   }
return(0);
}
 
  
//+------------------------------------------------------------------+
int deinit()
  {
  ObjectDelete("Chart_SymbolTF_Label"); 
  ObjectDelete("On_Chart_Note"); 
   
  return(0);
  }
//+------------------------------------------------------------------+
int start()
{
    
   string Market_Price = Symbol() + " " + ChartPeriod;
   
   
   ObjectSetText("Chart_SymbolTF_Label", Market_Price, FontSize, FontType, FontColor);
   
   if( chartNote != "")
   {
      ObjectSetText("On_Chart_Note", chartNote, chartNoteSize, chartNoteFont, chartNoteColor);
   }
  return(0);   
}
  
//+------------------------------------------------------------------+  

string TimeFrameToString(int tf)
{
   string tfs;
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}
 
//+------------------------------------------------------------------+   