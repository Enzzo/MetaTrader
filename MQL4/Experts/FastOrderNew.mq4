//+------------------------------------------------------------------+
//|                                                 FastOrderNew.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#define VERSION "1.02"
#property version   VERSION
#property strict

#include <stderror.mqh>
#include <stdlib.mqh>

extern double RiskPercent          = 2;
extern bool   ShowPending          = true;
extern bool   ConfirmOrders        = true;
extern bool   ShowLegend           = true;
extern bool   DisplayStatus        = true;
extern bool   ShowBarCountdown     = true;
extern int    MagicNumber          = 145361659;

enum _TradeMode { Pending, Market };
string order_type[6] = {"Buy","Sell","Buy limit","Sell limit","Buy stop","Sell stop"};
enum _direction { BUY, SELL };

struct _order_data {
   double profit;
   double pips;
   datetime opentime;
   double lots;
   double openprice;
   double sl;
   double tp;
   _direction direction;
};

string Prefix = "FastOrder_";
bool ButtonBuyEnabled=true;
bool ButtonSellEnabled=true;
bool ButtonCloseEnabled=true;
bool ButtonPendingEnabled=true;
bool ButtonMarketEnabled=true;
bool ButtonHideEnabled=true;
bool HideLines = false;
bool LastHideState = false;
_TradeMode TradeMode = Market;
_TradeMode PrevTradeMode = Market;
double SLprice = 0;
double TPprice = 0;
double EntryPrice = 0;
double lastSLprice = 0;
double lastTPprice = 0;
double Lot = 0;
double old_point = 0.0001;
bool AllowTrade;
int ordercount = 0, prevordercount = 0;
int buycount = 0, sellcount = 0;
int marketcount = 0, pendingcount = 0;
double stoplevel;
double SLdistance = 0;
double TPdistance = 0;
double Risk = 0, Proj_Profit;
string status_string = "";
int status_error=0;
bool last_isBlack = false;
_order_data order_data;
double chartwidth, chartheight, prevchartwidth, prevchartheight;
long chartbgcolor, prevchartbgcolor;

color colorLabelText = clrBlack;
color colorLabelProfit = clrGreen;
color colorLabelLoss = clrCrimson;
color colorStatusOk = clrGreen;
color colorStatusError = clrRed;
color colorStopLoss = clrCrimson;
color colorEntry = clrMediumVioletRed;
color colorTakeProfit = clrMediumBlue;
color colorButtonActive = clrLightGray;
color colorButtonInactive = clrWhite;
color colorButtonTextInactive = clrLightGray;
color colorButtonBuyText = clrBlue;
color colorButtonSellText = clrRed;
color colorButtonCloseText = clrBlack;
color colorButtonHideText = clrBlack;
color colorButtonPendingText = clrPurple;
color colorButtonMarketText = clrSeaGreen;
color colorButtonHide = clrWhiteSmoke;
   
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,0,true);
   
   SetColorScheme();

   if (_Digits <= 3) old_point = 0.01;
                else old_point = 0.0001;
                
   if (MarketInfo(Symbol(),MODE_MARGINCALCMODE) >= 1) { old_point = _Point*10; }
               
   stoplevel = MarketInfo(Symbol(),MODE_STOPLEVEL)*_Point;
   
   int centerx = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)/2;
   
   ButtonCreate(0,Prefix+"Buy",0,5,115,110,30,CORNER_LEFT_LOWER,"Buy","Arial Black",18,colorButtonBuyText,colorButtonActive,clrNONE);
   ButtonCreate(0,Prefix+"Sell",0,5,75,110,30,CORNER_LEFT_LOWER,"Sell","Arial Black",18,colorButtonSellText,colorButtonActive,clrNONE);
   ButtonCreate(0,Prefix+"Close",0,5,35,110,30,CORNER_LEFT_LOWER,"Close","Arial Black",18,colorButtonCloseText,colorButtonActive,clrNONE);
   DisableBuyButton();
   DisableSellButton();
   DisableCloseButton();
   bool pendingbuttonenabled = TradeMode == Pending && !HideLines;
   bool marketbuttonenabled = TradeMode == Market && !HideLines;
   bool hidebuttonenabled = HideLines;
   if (ShowPending) ButtonCreate(0,Prefix+"Pending",0,centerx-215,0,130,30,CORNER_LEFT_UPPER,"Pending","Arial Black",18,colorButtonPendingText,colorButtonActive,clrNONE,pendingbuttonenabled);
   ButtonCreate(0,Prefix+"Market",0,centerx-215+140,0,130,30,CORNER_LEFT_UPPER,"Market","Arial Black",18,colorButtonMarketText,colorButtonActive,clrNONE,marketbuttonenabled);
   ButtonCreate(0,Prefix+"Hide",0,centerx-205+280,0,130,30,CORNER_LEFT_UPPER,"Hide Lines","Tahoma",16,colorButtonHideText,colorButtonHide,clrNONE,hidebuttonenabled);
   EnablePendingButton();
   EnableMarketButton();
   EnableHideButton();
   //TradeMode = Market;
   if (SLprice == 0) {
      double startdist=10*old_point;
      SLprice = Ask-CalcSLDist()+startdist;
      TPprice = Ask+CalcSLDist()+startdist;
      EntryPrice = Ask+startdist;
      }
   CountOrder(ordercount,marketcount,pendingcount,buycount,sellcount);
   if (ordercount == 0 && !HideLines) CreateLines();
   prevordercount = 0;
   RefreshData();
   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  EventKillTimer();
  ButtonDelete(0,Prefix+"Buy"); 
  ButtonDelete(0,Prefix+"Sell"); 
  ButtonDelete(0,Prefix+"Close"); 
  ButtonDelete(0,Prefix+"Pending"); 
  ButtonDelete(0,Prefix+"Market"); 
  ButtonDelete(0,Prefix+"Hide"); 
  DeleteLineEntry();
  DeleteLineSL();
  DeleteLineTP();
  DeleteStatusText();
  DeleteCountdownText();
  DeleteLegendText();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   RefreshData();
  }
  
void OnTimer()
{
   RefreshData();
} 

//+------------------------------------------------------------------+
//| Refresh data                                                     |
//+------------------------------------------------------------------+
void RefreshData()
  {
//---
   RefreshRates();
   
   SetColorScheme();
   
   if (ObjectFind(0,Prefix+"LineSL") >= 0) SLprice = ObjectGetDouble(0,Prefix+"LineSL",OBJPROP_PRICE,0);
   if (ObjectFind(0,Prefix+"LineTP") >= 0) TPprice = ObjectGetDouble(0,Prefix+"LineTP",OBJPROP_PRICE,0);
   if (ObjectFind(0,Prefix+"LineEntry") >= 0) EntryPrice = ObjectGetDouble(0,Prefix+"LineEntry",OBJPROP_PRICE,0);
   bool isActive=ChartGetInteger(0,CHART_BRING_TO_TOP);
   if (isActive) {
      int centerbar = WindowFirstVisibleBar()-WindowBarsPerChart()/2;
      if (ObjectFind(0,Prefix+"LineSLText") >= 0) {
         ObjectMove(0,Prefix+"LineSLText",0,iTime(NULL,PERIOD_CURRENT,centerbar),SLprice);
         ObjectSetString(0,Prefix+"LineSLText",OBJPROP_TEXT,"Stop Loss: "+DoubleToString(SLprice,_Digits)); 
         }
      if (ObjectFind(0,Prefix+"LineTPText") >= 0) {
         ObjectMove(0,Prefix+"LineTPText",0,iTime(NULL,PERIOD_CURRENT,centerbar),TPprice);
         ObjectSetString(0,Prefix+"LineTPText",OBJPROP_TEXT,"Take Profit: "+DoubleToString(TPprice,_Digits)); 
         }
      if (ObjectFind(0,Prefix+"LineEntryText") >= 0) {
         ObjectMove(0,Prefix+"LineEntryText",0,iTime(NULL,PERIOD_CURRENT,centerbar),EntryPrice);
         ObjectSetString(0,Prefix+"LineEntryText",OBJPROP_TEXT,"Entry: "+DoubleToString(EntryPrice,_Digits)); 
         }
      int centerx = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)/2;
      ButtonMove(0,Prefix+"Pending",centerx-215);
      ButtonMove(0,Prefix+"Market",centerx-215+140);
      ButtonMove(0,Prefix+"Hide",centerx-205+280);
      }
 
   _direction direction = -1;
   AllowTrade = true;
   status_string = ""; status_error = 0;
   CountOrder(ordercount,marketcount,pendingcount,buycount,sellcount);
   order_data = GetOrderData();
   if (ordercount > 0) {
      SLprice = order_data.sl;
      TPprice = order_data.tp;
      EntryPrice = order_data.openprice;
      SLdistance = EntryPrice-SLprice;
      TPdistance = TPprice-EntryPrice;
      if (order_data.direction == SELL) { SLdistance = -SLdistance; TPdistance = -TPdistance; }
      Lot = order_data.lots;
      }   
   if (marketcount > 0) {
      if (buycount > 0) status_string = "Active Buy";
      if (sellcount > 0) status_string = "Active Sell";
      }  
   if (pendingcount > 0) {
      if (buycount > 0) status_string = "Pending Buy";
      if (sellcount > 0) status_string = "Pending Sell";
      } 
   if (ordercount == 0) {    
      if (TradeMode == Market) {
         if (SLprice<=Bid) { 
            SLdistance = Ask-SLprice;
            TPdistance = TPprice-Ask;
            direction = BUY;
            }
         else if (SLprice>=Ask) { 
            SLdistance = SLprice-Bid;
            TPdistance = Bid-TPprice;
            direction = SELL;
            }
         else {
            SLdistance = SLprice-Bid;
            TPdistance = Bid-TPprice;
            direction = -1;
            AllowTrade = false;
            status_string = "Wrong SL/TP position";
            status_error = 1;
            }
         }
      if (TradeMode == Pending) {
         if (SLprice<=EntryPrice) { 
            SLdistance = EntryPrice-SLprice;
            TPdistance = TPprice-EntryPrice;
            direction = BUY;
            }
         else { 
            SLdistance = SLprice-EntryPrice;
            TPdistance = EntryPrice-TPprice;
            direction = SELL;
            }
         }
      if (HideLines) { // to prevent blocking of buy/sell button
         SLdistance = CalcSLDist();
         TPdistance = CalcSLDist();
         SLprice = Bid - SLdistance;
         TPprice = Bid + TPdistance;
         }
      if (SLdistance <= 0 || TPdistance <= 0) { AllowTrade = false; status_string = "Wrong SL/TP position"; status_error = 1; }
      double checkprice = EntryPrice;
      if (direction == BUY) {
         if (TradeMode == Market) checkprice = Bid;
         if (TradeMode == Pending && MathAbs(EntryPrice-Ask) < stoplevel) { AllowTrade = false; status_string = "Price is too close"; status_error = 1; }
         if (MathAbs(checkprice-SLprice) < stoplevel) { AllowTrade = false; status_string = "Stop Loss is too close"; status_error = 1; }
         if (MathAbs(TPprice-checkprice) < stoplevel) { AllowTrade = false; status_string = "Take Profit is too close"; status_error = 1; }
         }
      if (direction == SELL) {
         if (TradeMode == Market) checkprice = Ask;
         if (TradeMode == Pending && MathAbs(EntryPrice-Bid) < stoplevel) { AllowTrade = false; status_string = "Price is too close"; status_error = 1; }
         if (MathAbs(SLprice-checkprice) < stoplevel) { AllowTrade = false; status_string = "Stop Loss is too close"; status_error = 1; }
         if (MathAbs(checkprice-TPprice) < stoplevel) { AllowTrade = false; status_string = "Take Profit is too close"; status_error = 1; }
         }
      if (SLdistance>0) Lot = CalcLot(SLdistance); else Lot = 0; 
      } // ordercount == 0
      
   Risk = DistToCurrency(SLdistance,Lot);
   Proj_Profit = DistToCurrency(TPdistance,Lot);
   
   if (ordercount > 0 && ordercount != prevordercount) {
      EnableCloseButton();
      LastHideState = HideLines;
      HideLines = true;
      PressHideLines();      
      //DeleteLineEntry();
      //DeleteLineSL();
      //DeleteLineTP();
      DisablePendingButton();
      DisableMarketButton();  
      DisableHideButton();    
      }
    if (ordercount == 0 && ordercount != prevordercount) {
      DisableCloseButton();
      //ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,false); 
      HideLines = LastHideState;
      EnablePendingButton();
      EnableMarketButton();
      EnableHideButton();
      PressHideLines();
      //SwitchButtonMarketPending();
      //CreateLines();
      }
   if (!AllowTrade || ordercount > 0) {
      DisableSellButton();
      DisableBuyButton();
      }
   if (AllowTrade && ordercount == 0) {
      if (direction == BUY || HideLines) EnableBuyButton(); else DisableBuyButton();
      if (direction == SELL || HideLines) EnableSellButton(); else DisableSellButton();
      }
   prevordercount = ordercount;  
   UpdateStatusText();
   UpdateCountdownText();
   UpdateLegendText();
   ChartRedraw();
  }

//+------------------------------------------------------------------+ 
//| Create the horizontal line                                       | 
//+------------------------------------------------------------------+ 
bool HLineCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="HLine",      // line name 
                 const int             sub_window=0,      // subwindow index 
                 double                price=0,           // line price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selectable=true,    // highlight to move 
                 const bool            selection=false,    // highlight to move 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0)         // priority for mouse click 
  { 
//--- if the price is not set, set it at the current Bid price level 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- reset the error value 
   ResetLastError(); 
//--- create a horizontal line 
   bool isExists = false;
   if (ObjectFind(chart_ID,name) < 0) {
      if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price)) 
        { 
         Print(__FUNCTION__, 
               ": failed to create a horizontal line! Error code = ",GetLastError()); 
         return(false); 
        } 
     } else isExists = true;
//--- set line color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set line display style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- set line width 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the line by mouse 
//--- when creating a graphical object using ObjectCreate function, the object cannot be 
//--- highlighted and moved by default. Inside this method, selection parameter 
//--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selectable); 
   if (!isExists) ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Delete a horizontal line                                         | 
//+------------------------------------------------------------------+ 
bool HLineDelete(const long   chart_ID=0,   // chart's ID 
                 const string name="HLine") // line name 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- delete a horizontal line 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete a horizontal line! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // chart's ID 
                  const string            name="Button",            // button name 
                  const int               sub_window=0,             // subwindow index 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="Button",            // text 
                  const string            font="Arial",             // font 
                  const int               font_size=10,             // font size 
                  const color             clr=clrBlack,             // text color 
                  const color             back_clr=C'236,233,216',  // background color 
                  const color             border_clr=clrNONE,       // border color 
                  const bool              state=false,              // pressed/released 
                  const bool              back=false,               // in the background 
                  const bool              selection=false,          // highlight to move 
                  const bool              hidden=true,              // hidden in the object list 
                  const long              z_order=0)                // priority for mouse click 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- create the button 
   if (ObjectFind(chart_ID,name) < 0) {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) 
        { 
         Print(__FUNCTION__, 
               ": failed to create the button! Error code = ",GetLastError()); 
         return(false); 
        } 
     }
//--- set button coordinates 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- set button size 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- set the chart's corner, relative to which point coordinates are defined 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- set the text 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- set text font 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- set font size 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- set text color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set background color 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- set border color 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- set button state 
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state); 
//--- enable (true) or disable (false) the mode of moving the button by mouse 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 

//+------------------------------------------------------------------+ 
//| Delete the button                                                | 
//+------------------------------------------------------------------+ 
bool ButtonDelete(const long   chart_ID=0,    // chart's ID 
                  const string name="Button") // button name 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- delete the button 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete the button! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Move the button                                                  | 
//+------------------------------------------------------------------+ 
bool ButtonMove(const long   chart_ID=0,    // chart's ID 
                const string name="Button", // button name 
                const int    x=0,           // X coordinate 
                const int    y=0)           // Y coordinate 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- move the button 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move X coordinate of the button! Error code = ",GetLastError()); 
      return(false); 
     } 
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move Y coordinate of the button! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
  
//+------------------------------------------------------------------+ 
//| Change button text                                               | 
//+------------------------------------------------------------------+ 
bool ButtonSetColor(const long   chart_ID,         // chart's ID 
                   const string name,              // button name 
                   const color clr,                // text color 
                   const color back_clr,           // background color
                   const color border_clr=clrNONE) // border color
  { 
//--- reset the error value 
   ResetLastError(); 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   bool res=true;
//--- set text color 
   res = res && ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set background color 
   res = res && ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- set border color 
   res = res && ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
   if(!res) 
     { 
      Print(__FUNCTION__, 
            ": failed to change text color! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 

//+------------------------------------------------------------------+ 
//| Create lines                                                     | 
//+------------------------------------------------------------------+ 
void CreateLines() {
   if (TradeMode == Pending) CreateLineEntry();
   CreateLineSL();
   CreateLineTP(); 
}

void CreateLineEntry()
{
   HLineCreate(0,Prefix+"LineEntry",0,EntryPrice,colorEntry,STYLE_SOLID,2,false,true,false,true,0);
   TextCreate(0,Prefix+"LineEntryText",0,iTime(NULL,PERIOD_CURRENT,WindowFirstVisibleBar()-WindowBarsPerChart()/2),EntryPrice,"Entry: "+DoubleToString(EntryPrice,_Digits),"Arial",10,colorEntry,0,ANCHOR_LOWER);
}

void CreateLineSL() 
{
   HLineCreate(0,Prefix+"LineSL",0,SLprice,colorStopLoss,STYLE_SOLID,2,false,true,false,true,0);
   TextCreate(0,Prefix+"LineSLText",0,iTime(NULL,PERIOD_CURRENT,WindowFirstVisibleBar()-WindowBarsPerChart()/2),SLprice,"Stop Loss: "+DoubleToString(SLprice,_Digits),"Arial",10,colorStopLoss,0,ANCHOR_LOWER);
}

void CreateLineTP() 
{
   HLineCreate(0,Prefix+"LineTP",0,TPprice,colorTakeProfit,STYLE_SOLID,2,false,true,false,true,0);
   TextCreate(0,Prefix+"LineTPText",0,iTime(NULL,PERIOD_CURRENT,WindowFirstVisibleBar()-WindowBarsPerChart()/2),TPprice,"Take Profit: "+DoubleToString(TPprice,_Digits),"Arial",10,colorTakeProfit,0,ANCHOR_LOWER);
}

void DeleteLineEntry() 
{
   HLineDelete(0,Prefix+"LineEntry");
   TextDelete(0,Prefix+"LineEntryText");
}

void DeleteLineSL() 
{
   HLineDelete(0,Prefix+"LineSL");
   TextDelete(0,Prefix+"LineSLText");
}

void DeleteLineTP() 
{
   HLineDelete(0,Prefix+"LineTP");
   TextDelete(0,Prefix+"LineTPText");
}

void RedrawLines() {
   if (ObjectFind(0,Prefix+"LineEntry") >= 0) CreateLineEntry();
   if (ObjectFind(0,Prefix+"LineSL") >= 0) CreateLineSL();
   if (ObjectFind(0,Prefix+"LineTP") >= 0) CreateLineTP();
}

void UpdateCountdownText()
{
   if (ShowBarCountdown) {
      LabelCreate(0,Prefix+"lblCountdown",0,180,14,CORNER_RIGHT_UPPER,"Bar Countdown:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"Countdown",0,5,14,CORNER_RIGHT_UPPER,TimeToString(BarCountdownTimer(),TIME_MINUTES|TIME_SECONDS),"Verdana",10,colorLabelText,0,ANCHOR_RIGHT_UPPER);
      }
   else {
      DeleteCountdownText();
      }
}

void DeleteCountdownText()
{   
   LabelDelete(0,Prefix+"lblCountdown");
   LabelDelete(0,Prefix+"Countdown");
}
   
void UpdateStatusText()
{
   if (DisplayStatus) {
      string lblLotsText="Projected Trade Lots:";
      string lblRiskText="Projected Trade Risk:";
      string lblProjProfitText="Projected Profit:";
      if (ordercount > 0) {
         lblLotsText="Current Trade Lots:";
         lblRiskText="Current Trade Risk:";
         lblProjProfitText="Potential Profit:";
         }
      LabelCreate(0,Prefix+"lblStatus",0,240,42,CORNER_RIGHT_UPPER,"Status:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblLots",0,240,42+28,CORNER_RIGHT_UPPER,lblLotsText,"Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblRisk",0,240,42+28+14,CORNER_RIGHT_UPPER,lblRiskText,"Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblActualRisk",0,240,42+28+28,CORNER_RIGHT_UPPER,"Actual Risk Percent:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblProjectedProfit",0,240,42+28+42,CORNER_RIGHT_UPPER,lblProjProfitText,"Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblSLdist",0,240,42+98,CORNER_RIGHT_UPPER,"SL Distance:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblTPdist",0,240,42+98+14,CORNER_RIGHT_UPPER,"TP Distance:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblSpread",0,240,42+98+28,CORNER_RIGHT_UPPER,"Spread:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
      
      if (marketcount > 0) {
         LabelCreate(0,Prefix+"lblTradeTime",0,240,42+154,CORNER_RIGHT_UPPER,"Trade Time:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
         LabelCreate(0,Prefix+"lblTradeProfit",0,240,42+154+14,CORNER_RIGHT_UPPER,"Trade Profit:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
         LabelCreate(0,Prefix+"lblTradePips",0,240,42+154+28,CORNER_RIGHT_UPPER,"Trade Pips:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
         }
      else if (pendingcount > 0) {
         LabelCreate(0,Prefix+"lblTradePips",0,240,42+154,CORNER_RIGHT_UPPER,"Distance to Activate:","Verdana",10,colorLabelText,0,ANCHOR_LEFT_UPPER);
         }
      else {
         LabelDelete(0,Prefix+"lblTradeTime");
         LabelDelete(0,Prefix+"lblTradeProfit");
         LabelDelete(0,Prefix+"lblTradePips");
         }   
      color clrstatus = colorStatusOk;
      if (status_error == 1) clrstatus = colorStatusError;
      color clrrisk = colorLabelLoss;
      if (Risk < 0) clrrisk = colorLabelProfit;
      color clrsldist = colorLabelLoss;
      if (SLdistance < 0) clrsldist = colorLabelProfit;
      color clrprofit = colorLabelProfit;
      if (Proj_Profit < 0) clrprofit = colorLabelLoss;
      color clrtpdist = colorLabelProfit;
      if (TPdistance < 0) clrtpdist = colorLabelLoss;
      LabelCreate(0,Prefix+"Status",0,5,42,CORNER_RIGHT_UPPER,status_string,"Verdana",10,clrstatus,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"Lots",0,5,42+28,CORNER_RIGHT_UPPER,DoubleToString(Lot,2),"Verdana",10,colorLabelText,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"Risk",0,5,42+28+14,CORNER_RIGHT_UPPER,StringFormat("%+.2f %s",-Risk,AccountCurrency()),"Verdana",10,clrrisk,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"ActualRisk",0,5,42+28+28,CORNER_RIGHT_UPPER,StringFormat("%+.2f%%",-CalcRiskPercent(Risk)),"Verdana",10,clrrisk,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"ProjectedProfit",0,5,42+28+42,CORNER_RIGHT_UPPER,StringFormat("%.2f %s",Proj_Profit,AccountCurrency()),"Verdana",10,clrprofit,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"SLdist",0,5,42+98,CORNER_RIGHT_UPPER,StringFormat("%+.1f pips",-SLdistance/old_point),"Verdana",10,clrsldist,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"TPdist",0,5,42+98+14,CORNER_RIGHT_UPPER,StringFormat("%.1f pips",TPdistance/old_point),"Verdana",10,clrtpdist,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"Spread",0,5,42+98+28,CORNER_RIGHT_UPPER,DoubleToString((Ask-Bid)/old_point,1)+" pips","Verdana",10,colorLabelText,0,ANCHOR_RIGHT_UPPER);
      if (marketcount > 0) {
         LabelCreate(0,Prefix+"TradeTime",0,5,42+154,CORNER_RIGHT_UPPER,CalcTradeTime(order_data.opentime),"Verdana",10,colorLabelText,0,ANCHOR_RIGHT_UPPER);
         color clrtradeprofit = colorLabelProfit;
         if (order_data.profit < 0) clrtradeprofit = colorLabelLoss;
         LabelCreate(0,Prefix+"TradeProfit",0,5,42+154+14,CORNER_RIGHT_UPPER,DoubleToString(order_data.profit,2) + " "+AccountCurrency(),"Verdana",10,clrtradeprofit,0,ANCHOR_RIGHT_UPPER);
         LabelCreate(0,Prefix+"TradePips",0,5,42+154+28,CORNER_RIGHT_UPPER,DoubleToString(order_data.pips,1),"Verdana",10,clrtradeprofit,0,ANCHOR_RIGHT_UPPER);
         }
      else if (pendingcount > 0) {
         double dist = 0;
         if (order_data.direction == BUY) dist = MathAbs(order_data.openprice - Ask)/old_point;
         if (order_data.direction == SELL) dist = MathAbs(Bid - order_data.openprice)/old_point;
         LabelCreate(0,Prefix+"TradePips",0,5,42+154,CORNER_RIGHT_UPPER,DoubleToString(dist,1)+" pips","Verdana",10,colorLabelProfit,0,ANCHOR_RIGHT_UPPER);
         }
      else {
         LabelDelete(0,Prefix+"TradeTime");
         LabelDelete(0,Prefix+"TradeProfit");
         LabelDelete(0,Prefix+"TradePips");
         }
      }
   else {
      DeleteStatusText();
      }
}

void DeleteStatusText()
{   
   LabelDelete(0,Prefix+"lblStatus");
   LabelDelete(0,Prefix+"lblLots");
   LabelDelete(0,Prefix+"lblRisk");
   LabelDelete(0,Prefix+"lblActualRisk");
   LabelDelete(0,Prefix+"lblProjectedProfit");
   LabelDelete(0,Prefix+"lblSLdist");
   LabelDelete(0,Prefix+"lblTPdist");
   LabelDelete(0,Prefix+"lblSpread");
   LabelDelete(0,Prefix+"lblTradeTime");
   LabelDelete(0,Prefix+"lblTradeProfit");
   LabelDelete(0,Prefix+"lblTradePips");
   
   LabelDelete(0,Prefix+"Status");
   LabelDelete(0,Prefix+"Lots");
   LabelDelete(0,Prefix+"Risk");
   LabelDelete(0,Prefix+"ActualRisk");
   LabelDelete(0,Prefix+"ProjectedProfit");
   LabelDelete(0,Prefix+"SLdist");
   LabelDelete(0,Prefix+"TPdist");
   LabelDelete(0,Prefix+"Spread");
   LabelDelete(0,Prefix+"TradeTime");
   LabelDelete(0,Prefix+"TradeProfit");
   LabelDelete(0,Prefix+"TradePips");
}

void UpdateLegendText() {  
   if (ShowLegend && (!HideLines || ordercount > 0)) {
      LabelCreate(0,Prefix+"lblSLlevel",0,5,80,CORNER_LEFT_UPPER,"Stop Loss:","Verdana",12,colorStopLoss,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblEntryLevel",0,5,100,CORNER_LEFT_UPPER,"Entry:","Verdana",12,colorEntry,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"lblTPlevel",0,5,120,CORNER_LEFT_UPPER,"Take Profit:","Verdana",12,colorTakeProfit,0,ANCHOR_LEFT_UPPER);
      LabelCreate(0,Prefix+"SLlevel",0,180,80,CORNER_LEFT_UPPER,DoubleToString(SLprice,_Digits),"Verdana",12,colorStopLoss,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"EntryLevel",0,180,100,CORNER_LEFT_UPPER,DoubleToString(EntryPrice,_Digits),"Verdana",12,colorEntry,0,ANCHOR_RIGHT_UPPER);
      LabelCreate(0,Prefix+"TPlevel",0,180,120,CORNER_LEFT_UPPER,DoubleToString(TPprice,_Digits),"Verdana",12,colorTakeProfit,0,ANCHOR_RIGHT_UPPER);
      }
   else {
      DeleteLegendText();
      }
}

void DeleteLegendText() {
   LabelDelete(0,Prefix+"lblSLlevel");
   LabelDelete(0,Prefix+"lblEntryLevel");
   LabelDelete(0,Prefix+"lblTPlevel");
   
   LabelDelete(0,Prefix+"SLlevel");
   LabelDelete(0,Prefix+"EntryLevel");
   LabelDelete(0,Prefix+"TPlevel");
}
//+------------------------------------------------------------------+ 
//| Creating Text object                                             | 
//+------------------------------------------------------------------+ 
bool TextCreate(const long              chart_ID=0,               // chart's ID 
                const string            name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrRed,               // color 
                const double            angle=0.0,                // text slope 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                const bool              back=false,               // in the background 
                const bool              selection=false,          // highlight to move 
                const bool              hidden=true,              // hidden in the object list 
                const long              z_order=0)                // priority for mouse click 
  { 
//--- set anchor point coordinates if they are not set 
   //ChangeTextEmptyPoint(time,price); 
//--- reset the error value 
   ResetLastError(); 
//--- create Text object 
   if (ObjectFind(chart_ID,name) < 0) {
      if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price)) 
        { 
         Print(__FUNCTION__, 
               ": failed to create \"Text\" object! Error code = ",GetLastError()); 
         return(false); 
        } 
     }
//--- set the text 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- set text font 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- set font size 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- set the slope angle of the text 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- set anchor type 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- set color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the object by mouse 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Delete Text object                                               | 
//+------------------------------------------------------------------+ 
bool TextDelete(const long   chart_ID=0,  // chart's ID 
                const string name="Text") // object name 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- delete the object 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete \"Text\" object! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create a text label                                              | 
//+------------------------------------------------------------------+ 
bool LabelCreate(const long              chart_ID=0,               // chart's ID 
                 const string            name="Label",             // label name 
                 const int               sub_window=0,             // subwindow index 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const string            font="Arial",             // font 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const double            angle=0.0,                // text slope 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                 const bool              back=false,               // in the background 
                 const bool              selection=false,          // highlight to move 
                 const bool              hidden=true,              // hidden in the object list 
                 const long              z_order=0)                // priority for mouse click 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- create a text label 
   if (ObjectFind(chart_ID,name) < 0) {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)) 
        { 
         Print(__FUNCTION__, 
               ": failed to create text label! Error code = ",GetLastError()); 
         return(false); 
        } 
     }
//--- set label coordinates 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- set the chart's corner, relative to which point coordinates are defined 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- set the text 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- set text font 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- set font size 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- set the slope angle of the text 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
//--- set anchor type 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- set color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the label by mouse 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Delete a text label                                              | 
//+------------------------------------------------------------------+ 
bool LabelDelete(const long   chart_ID=0,   // chart's ID 
                 const string name="Label") // label name 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- delete the label 
   if (ObjectFind(chart_ID,name) < 0) return(true);
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete a text label! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 

//+------------------------------------------------------------------+ 
//| Enable and disable buttons                                       | 
//+------------------------------------------------------------------+ 
void EnableBuyButton()
{
   ButtonSetColor(0,Prefix+"Buy",colorButtonBuyText,colorButtonActive,clrNONE); 
   ButtonBuyEnabled = true;
}
void DisableBuyButton()
{
   ButtonSetColor(0,Prefix+"Buy",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ButtonBuyEnabled = false;
}
void EnableSellButton()
{
   ButtonSetColor(0,Prefix+"Sell",colorButtonSellText,colorButtonActive,clrNONE); 
   ButtonSellEnabled = true;
}
void DisableSellButton()
{
   ButtonSetColor(0,Prefix+"Sell",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ButtonSellEnabled = false;
}
void EnableCloseButton()
{
   ButtonSetColor(0,Prefix+"Close",colorButtonCloseText,colorButtonActive,clrNONE); 
   ButtonCloseEnabled = true;
}
void DisableCloseButton()
{
   ButtonSetColor(0,Prefix+"Close",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ButtonCloseEnabled = false;
}
void EnablePendingButton()
{
   ButtonSetColor(0,Prefix+"Pending",colorButtonPendingText,colorButtonActive,clrNONE); 
   ButtonPendingEnabled = true;
}
void DisablePendingButton()
{
   ButtonSetColor(0,Prefix+"Pending",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ObjectSetInteger(0,Prefix+"Pending",OBJPROP_STATE,false); 
   ButtonPendingEnabled = false;
}
void EnableMarketButton()
{
   ButtonSetColor(0,Prefix+"Market",colorButtonMarketText,colorButtonActive,clrNONE); 
   ButtonMarketEnabled = true;
}
void DisableMarketButton()
{
   ButtonSetColor(0,Prefix+"Market",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ObjectSetInteger(0,Prefix+"Market",OBJPROP_STATE,false);
   ButtonMarketEnabled = false;
}
void EnableHideButton()
{
   ButtonSetColor(0,Prefix+"Hide",colorButtonHideText,colorButtonHide,clrNONE); 
   ButtonHideEnabled = true;
}
void DisableHideButton()
{
   ButtonSetColor(0,Prefix+"Hide",colorButtonTextInactive,colorButtonInactive,colorButtonInactive); 
   ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,false);  
   ButtonHideEnabled = false;
}

void RedrawButtons()
{
   if (ButtonBuyEnabled) EnableBuyButton(); else DisableBuyButton();
   if (ButtonSellEnabled) EnableSellButton(); else DisableSellButton();
   if (ButtonCloseEnabled) EnableCloseButton(); else DisableCloseButton();
   if (ButtonPendingEnabled) EnablePendingButton(); else DisablePendingButton();
   if (ButtonMarketEnabled) EnableMarketButton(); else DisableMarketButton();
   if (ButtonHideEnabled) EnableHideButton(); else DisableHideButton();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id == CHARTEVENT_MOUSE_MOVE){
      if (((int)sparam & 1) == 1) {
            RefreshData();
         }
      }
   if(id == CHARTEVENT_KEYDOWN)
      {
      RefreshData();
      }
   if(id == CHARTEVENT_CHART_CHANGE)
      {
      bool isActive = ChartGetInteger(0,CHART_BRING_TO_TOP);
      if (isActive) {
         prevchartwidth = chartwidth;
         prevchartheight = chartheight;
         prevchartbgcolor = chartbgcolor;
         chartwidth = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
         chartheight = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
         chartbgcolor = ChartGetInteger(0,CHART_COLOR_BACKGROUND);
         if (chartwidth != prevchartwidth || chartheight != prevchartheight || chartbgcolor != prevchartbgcolor) {
            RefreshData();
            }
         }
      }
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == Prefix+"Buy") {
         string ordertype = "Market";
         if (TradeMode == Pending) ordertype = "Pending";
         if (ButtonBuyEnabled && AllowTrade && (!ConfirmOrders || MessageBox("Execute "+ordertype+" Buy order?","Confirm",MB_YESNO|MB_ICONQUESTION) == IDYES)) {
            RefreshData();
            if (!AllowTrade) {
               Print("Price has changed. Could not open trade.");
               return;
               }
            int cmd = OP_BUY;
            double price = Ask;
            if (TradeMode == Pending) {
               price = NormalizeDouble(EntryPrice,_Digits);
               if (EntryPrice < Ask) cmd = OP_BUYLIMIT; else cmd = OP_BUYSTOP;
               }
            double sl = NormalizeDouble(SLprice,_Digits);
            double tp = NormalizeDouble(TPprice,_Digits);
            double sldist = SLdistance;
            if (HideLines) {
               price = Ask; cmd = OP_BUY;
               sldist = CalcSLDist();
               if (sldist <= 0) {
                  Print("Could not calculate SL distance. Could not open trade.");
                  return;
                  }
               sl = NormalizeDouble(price-sldist,_Digits);
               tp = NormalizeDouble(price+sldist,_Digits);
               Lot = CalcLot(sldist);
               }
            double risk = CalcRiskPercent(DistToCurrency(sldist,Lot)); 
            string q = "Opening %s order %.2f at %.5f (sl = %.5f, tp = %.5f), SL dist = %.1f pips, Risk = %.2f%%";
            string dig = "%."+IntegerToString(_Digits)+"f";
            StringReplace(q,"%.5f",dig);    
            q = StringFormat(q,order_type[cmd],Lot,price,sl,tp,sldist/old_point,risk);
            Print(q);
            string _Comment = "FastOrder v"+VERSION+" Risk="+DoubleToString(risk,2)+"%";
            int ticket = OrderSend(_Symbol,cmd,Lot,price,5,sl,tp,_Comment,MagicNumber,0,clrBlue);
            if (ticket<0) {
               int Error = GetLastError();
               Print("Error opening "+ordertype+" Buy order. Error code = "+IntegerToString(Error)+": ",ErrorDescription(Error));
               }
            else { 
               Print("Order has been successfully opened. Ticket = ",IntegerToString(ticket));
               }
            }
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false); 
         }
      if(sparam == Prefix+"Sell") {
         string ordertype = "Market";
         if (TradeMode == Pending) ordertype = "Pending";
         if (ButtonSellEnabled && AllowTrade && (!ConfirmOrders || MessageBox("Execute "+ordertype+" Sell order?","Confirm",MB_YESNO|MB_ICONQUESTION) == IDYES)) {
            RefreshData();
            if (!AllowTrade) {
               Print("Price has changed. Could not open trade.");
               return;
               }
            int cmd = OP_SELL;
            double price = Bid;
            if (TradeMode == Pending) {
               price = NormalizeDouble(EntryPrice,_Digits);
               if (EntryPrice > Bid) cmd = OP_SELLLIMIT; else cmd = OP_SELLSTOP;
               }
            double sl = NormalizeDouble(SLprice,_Digits);
            double tp = NormalizeDouble(TPprice,_Digits);
            double sldist = SLdistance;
            if (HideLines) {
               price = Bid; cmd = OP_SELL;
               sldist = CalcSLDist();
               if (sldist <= 0) {
                  Print("Could not calculate SL distance. Could not open trade.");
                  return;
                  }
               sl = NormalizeDouble(price+sldist,_Digits);
               tp = NormalizeDouble(price-sldist,_Digits);
               Lot = CalcLot(sldist);
               }
            double risk = CalcRiskPercent(DistToCurrency(sldist,Lot));
            string q = "Opening %s order %.2f at %.5f (sl = %.5f, tp = %.5f), SL dist = %.1f pips, Risk = %.2f%%";
            string dig = "%."+IntegerToString(_Digits)+"f";
            StringReplace(q,"%.5f",dig);    
            q = StringFormat(q,order_type[cmd],Lot,price,sl,tp,sldist/old_point,risk);
            Print(q);
            string _Comment = "FastOrder v"+VERSION+" Risk="+DoubleToString(risk,2)+"%";
            int ticket = OrderSend(_Symbol,cmd,Lot,price,5,sl,tp,_Comment,MagicNumber,0,clrRed);
            if (ticket<0) {
               int Error = GetLastError();
               Print("Error opening "+ordertype+" Sell order. Error code = "+IntegerToString(Error)+": ",ErrorDescription(Error));
               }
            else { 
               Print("Order has been successfully opened. Ticket = ",IntegerToString(ticket));
               }
            }
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false); 
         }
      if(sparam == Prefix+"Close") {
         if (ButtonCloseEnabled && (!ConfirmOrders || MessageBox("Close order?","Confirm",MB_YESNO|MB_ICONQUESTION) == IDYES)) {
            CloseOrders();
            }
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false); 
         }
      if(sparam == Prefix+"Pending") {
         if (ButtonPendingEnabled) {
            TradeMode = Pending;
            HideLines = false;
            SwitchButtonMarketPending();            
            SaveRestoreLinesPrice();
            ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,false); 
            CreateLines();
            }
         else { ObjectSetInteger(0,sparam,OBJPROP_STATE,false);  }
         RefreshData();
         }
      if(sparam == Prefix+"Market") {
         if (ButtonMarketEnabled) {
            TradeMode = Market;
            HideLines = false;
            SwitchButtonMarketPending();
            SaveRestoreLinesPrice();            
            ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,false); 
            DeleteLineEntry();
            CreateLines();
            }
         else { ObjectSetInteger(0,sparam,OBJPROP_STATE,false);  }
         RefreshData();
         }
      if(sparam == Prefix+"Hide") {
         if (ButtonHideEnabled) {
            HideLines = ObjectGetInteger(0,Prefix+"Hide",OBJPROP_STATE);
            PressHideLines();
            RefreshData();
            }
         else { 
            ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
            }   
         }
   }
   
}

void SwitchButtonMarketPending() {
   bool btnmarketstate = (TradeMode == Market && ButtonMarketEnabled && !HideLines);
   bool btnpendingstate = (TradeMode == Pending && ButtonPendingEnabled && !HideLines);
   ObjectSetInteger(0,Prefix+"Market",OBJPROP_STATE,btnmarketstate); 
   ObjectSetInteger(0,Prefix+"Pending",OBJPROP_STATE,btnpendingstate); 

}

void PressHideLines() {
   SaveRestoreLinesPrice();
   if (HideLines) {
      ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,true);
      PrevTradeMode = TradeMode;
      TradeMode = Market;
      SwitchButtonMarketPending();
      DeleteLineEntry();
      DeleteLineSL();
      DeleteLineTP();
      }
   else {
      ObjectSetInteger(0,Prefix+"Hide",OBJPROP_STATE,false);
      TradeMode = PrevTradeMode;
      SwitchButtonMarketPending();
      if (ordercount == 0) CreateLines();
      }
}

void SaveRestoreLinesPrice() {
   if (HideLines) {
      lastSLprice = SLprice;
      lastTPprice = TPprice;
      }
   else {
      SLprice = lastSLprice;
      TPprice = lastTPprice;
      }
}

double GetTickValue() {
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   if (MarketInfo(Symbol(),MODE_MARGINCALCMODE)==3) {
      string symb2 = SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE);
      double mult2=1;
      if (symb2 == "EUR") mult2 = SymbolInfoDouble("EURUSD",SYMBOL_BID);
      if (symb2 == "GBP") mult2 = SymbolInfoDouble("GBPUSD",SYMBOL_BID);
      if (symb2 == "JPY") mult2 = 1/SymbolInfoDouble("USDJPY",SYMBOL_BID);
      if (symb2 == "CHF") mult2 = 1/SymbolInfoDouble("USDCHF",SYMBOL_BID);
      if (symb2 == "AUD") mult2 = SymbolInfoDouble("AUDUSD",SYMBOL_BID);
      if (symb2 == "ZAR") mult2 = 1/SymbolInfoDouble("USDZAR",SYMBOL_BID);
      if (symb2 == "HKD") mult2 = 1/SymbolInfoDouble("USDHKD",SYMBOL_BID);
      if (mult2 != 0) TickValue *= mult2;
      string account_currency = AccountInfoString(ACCOUNT_CURRENCY);
      if (account_currency != "USD") {
         string newsymb = ""; int m = 1;
         if (account_currency == "AUD") newsymb = "AUDUSD";
         if (account_currency == "EUR") newsymb = "EURUSD";
         if (account_currency == "GBP") newsymb = "GBPUSD";
         if (account_currency == "RUB") { newsymb = "USDRUB"; m = -1; }
         double TV2 = MarketInfo(newsymb, MODE_TICKVALUE);
         TickValue *= pow(TV2,m);
         }
      }
   return(TickValue);
}

double CalcLot(double distance) {
   double lot = 0;
   double TickValue = GetTickValue();
   if (distance > 0 && TickValue > 0) lot = (AccountBalance() * (RiskPercent / 100)) / (distance / _Point) / TickValue; 
   double lotstep = MarketInfo(Symbol(), MODE_LOTSTEP); 
   if (lotstep != 0) lot = MathFloor(lot/lotstep)* lotstep; 
   lot = MathMin(MathMax(lot, MarketInfo(Symbol(), MODE_MINLOT)), MarketInfo(Symbol(), MODE_MAXLOT)); 
   return lot;
}

double DistToCurrency(double dist, double lot) {
   double TickValue = GetTickValue();
   return(dist/_Point*TickValue*lot);
}

double CalcRiskPercent(double RiskInMoney) {
   return(AccountBalance()>0?RiskInMoney*100/AccountBalance():0);
}

double CalcSLDist() {
   return(iATR(NULL,PERIOD_H1,14,0)*3);
}

void CountOrder(int& cnt, int& market, int& pending, int& buycnt, int& sellcnt) {
   cnt = 0; market = 0; pending = 0; buycnt = 0; sellcnt = 0;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false) continue;
      if(OrderSymbol()!=_Symbol || OrderMagicNumber() != MagicNumber) continue;
      if (OrderType() == OP_BUY) { cnt++; market++; buycnt++; }
      if (OrderType() == OP_SELL) { cnt++; market++; sellcnt++; }
      if (OrderType() == OP_BUYLIMIT) { cnt++; pending++; buycnt++; }
      if (OrderType() == OP_SELLLIMIT) { cnt++; pending++; sellcnt++; }
      if (OrderType() == OP_BUYSTOP) { cnt++; pending++; buycnt++; }
      if (OrderType() == OP_SELLSTOP) { cnt++; pending++; sellcnt++; }
      }
}

_order_data GetOrderData() {
   _order_data order;
   order.profit = 0;
   order.pips=0;
   order.opentime = TimeCurrent();
   order.lots = 0;
   order.direction = -1;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false) continue;
      if(OrderSymbol()!=_Symbol || OrderMagicNumber() != MagicNumber/* || OrderType() > OP_SELL*/) continue;
      
      order.profit += OrderProfit() + OrderCommission() + OrderSwap();
      order.pips += (OrderType()==OP_BUY?Bid-OrderOpenPrice():OrderOpenPrice()-Ask);
      if (OrderOpenTime() < order.opentime) order.opentime = OrderOpenTime();
      order.lots += OrderLots();
      order.sl = OrderStopLoss();
      order.tp = OrderTakeProfit();
      order.openprice = OrderOpenPrice();
      if (OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) order.direction = BUY;
      if (OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) order.direction = SELL;
   }
   order.pips /= old_point;
   return(order);
}

bool CloseOrders() {
   bool result = true;
   for (int i=OrdersTotal()-1;i>=0;i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==false) continue;
      if(OrderSymbol()!=_Symbol || OrderMagicNumber() != MagicNumber) continue;
      bool res = false;
      if (OrderType() <= OP_SELL) {
         double profit = OrderProfit() + OrderCommission() + OrderSwap();
         double price = Bid;
         if (OrderType() == OP_SELL) price = Ask;
         res = OrderClose(OrderTicket(),OrderLots(),price,5,clrViolet);
         if (res) {
            Print("Order #"+IntegerToString(OrderTicket())+" has been successfully closed. Profit = "+DoubleToString(profit,2)+" "+AccountCurrency());
            }
         else {
            int Error = GetLastError();
            Print("Error closing order #"+IntegerToString(OrderTicket())+". Error code = "+IntegerToString(Error)+": ",ErrorDescription(Error));
            result = false;
            }
         }
      else {
         res = OrderDelete(OrderTicket(),clrViolet);
         if (res) {
            Print("Pending order #"+IntegerToString(OrderTicket())+" has been deleted.");
            }
         else {
            int Error = GetLastError();
            Print("Error deleting pending order #"+IntegerToString(OrderTicket())+". Error code = "+IntegerToString(Error)+": ",ErrorDescription(Error));
            result = false;
            }
         }
      }
   return(result);
}

long BarCountdownTimer() {
   long time;
   time = iTime(NULL,PERIOD_CURRENT,0)+PeriodSeconds(PERIOD_CURRENT)-TimeCurrent();
   return(time);
}

string CalcTradeTime(datetime opentime) {
   MqlDateTime dt,dt2;
   long days;
   ZeroMemory(dt);
   TimeToStruct(TimeCurrent()-opentime,dt);
   dt2 = dt;
   dt2.hour = 0;
   dt2.min = 0;
   dt2.sec = 0;
   days = StructToTime(dt2) / 86400;
   string str = TimeToString(TimeCurrent()-opentime,TIME_MINUTES|TIME_SECONDS);
   if (days > 0) str = IntegerToString(days) + "d " + str;
   return(str);
}
   
void SetColorScheme() {
   bool isBlack = false;
   long bgcolor = ChartGetInteger(0,CHART_COLOR_BACKGROUND);
   int r = (int)bgcolor & 0xFF;
   int g = (int)(bgcolor & 0xFF00) >> 8;
   int b = (int)(bgcolor & 0xFF0000) >> 16;
   if ((r+g+b)/3 < 128) isBlack = true;
   if (isBlack) {
      colorLabelText = clrWhite;
      colorLabelProfit = C'85,170,255';//clrLimeGreen;
      colorLabelLoss = clrRed;
      colorStatusOk = C'85,170,255';//clrLime;
      colorStatusError = clrRed;
      colorStopLoss = clrRed;
      colorEntry = clrViolet;
      colorTakeProfit = C'85,170,255';
      colorButtonActive = clrDarkGray;
      colorButtonInactive = C'80,80,80';
      colorButtonTextInactive = C'48,48,48';
      colorButtonBuyText = C'0,0,224';
      colorButtonSellText = C'208,0,0';
      colorButtonCloseText = clrBlack;
      colorButtonHideText = clrBlack;
      colorButtonPendingText = clrPurple;
      colorButtonMarketText = clrGreen;
      colorButtonHide = clrGainsboro;
      }
   else {
      colorLabelText = clrBlack;
      colorLabelProfit = clrMediumBlue;//clrGreen;
      colorLabelLoss = clrCrimson;
      colorStatusOk = clrMediumBlue;//clrGreen;
      colorStatusError = clrRed;
      colorStopLoss = clrCrimson;
      colorEntry = clrMediumVioletRed;
      colorTakeProfit = clrMediumBlue;
      colorButtonActive = clrLightGray;
      colorButtonInactive = clrWhite;
      colorButtonTextInactive = clrLightGray;
      colorButtonBuyText = clrBlue;
      colorButtonSellText = clrRed;
      colorButtonCloseText = clrBlack;
      colorButtonHideText = clrBlack;
      colorButtonPendingText = clrPurple;
      colorButtonMarketText = clrSeaGreen;
      colorButtonHide = clrWhiteSmoke;
      }
   if (isBlack != last_isBlack) {
      RedrawButtons();
      RedrawLines();
      last_isBlack = isBlack;
      }  
}