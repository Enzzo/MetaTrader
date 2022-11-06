//+------------------------------------------------------------------+
//| EA_1Click_12Pairs_OnChart_V06.mq4
//+------------------------------------------------------------------+
#property strict

#define INTERVAL   10        //--- OnTick loop interval in seconds
#define MAXSIZE    12        //--- Max number of Symbols
#define MAXTRY     10        //--- Max number of Order Functions retries

extern int    ECN_BROKER  = 0;
extern int    MAGIC       = 20161025;
extern string SYMBOL_00   = "EURUSD";
extern string SYMBOL_01   = "AUDUSD";
extern string SYMBOL_02   = "USDCAD";
extern string SYMBOL_03   = "USDCHF";
extern string SYMBOL_04   = "USDJPY";
extern string SYMBOL_05   = "EURCHF";
extern string SYMBOL_06   = "EURJPY";
extern string SYMBOL_07   = "EURAUD";
extern string SYMBOL_08   = "EURCAD";
extern string SYMBOL_09   = "EURGBP";
extern string SYMBOL_10   = "GBPUSD";
extern string SYMBOL_11   = "GBPJPY";

extern double SLIP        = 2.5;                 // slippage in pips
extern double TP          = 25.0;                // target profit in pips
extern double SL          = 50.0;                // stoploss in pips
extern double GAP         = 15.0;                // gap for pending orders in pips 
extern double TRAIL       = 20.0;                // trailing stop in pips (to be implemented)
extern double LOT         = 0.02;                // trading min lot size
extern int    TIMEFRAME   = PERIOD_M15;          // Signal Timeframe

string A_Symbols[MAXSIZE];
string A_SymbolObj[MAXSIZE];
string A_SignalObj[MAXSIZE];
string A_CloseObj[MAXSIZE];
string A_BuyObj[MAXSIZE];
string A_SellObj[MAXSIZE];
string A_BuyStopObj[MAXSIZE];
string A_SellStopObj[MAXSIZE];
string A_CountObjB[MAXSIZE];
string A_CountObjS[MAXSIZE];
string A_PP_Obj[MAXSIZE];
int    A_SignalBars[MAXSIZE];
int    A_Signals[MAXSIZE][2];

bool   b_StopEA=false;
int    aidx,i_Digits,i_Slippage,i_Ticket=0;
double d_Pip2Double,d_Bid,d_Ask;
int    i_BarCounter=0;
string l_Prefix,l_ECN,l_Lot,l_Slip,l_TP,l_SL,l_Gap,l_Trail,l_Bal,l_Eq,l_EqLoss,l_DayPP,l_OpenPP,l_OrdCnt,l_Time;
string l_H1,l_H2,l_H3,l_H4,l_H5,l_H6,l_L1,l_L2;
string u_Abort;
string s_text;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   l_Prefix=IntegerToString(MAGIC,10,'0');

//--- Static Labels and Buttons Naming
   l_H1=StringConcatenate(l_Prefix,"_h1_label");
   l_H2=StringConcatenate(l_Prefix,"_h2_label");
   l_H3=StringConcatenate(l_Prefix,"_h3_label");
   l_H4=StringConcatenate(l_Prefix,"_h4_label");
   l_H5=StringConcatenate(l_Prefix,"_h5_label");
   l_H6=StringConcatenate(l_Prefix,"_h6_label");
   l_ECN=StringConcatenate(l_Prefix,"_ecn_label");
   l_Lot=StringConcatenate(l_Prefix,"_lot_label");
   l_Slip=StringConcatenate(l_Prefix,"_slip_label");
   l_TP=StringConcatenate(l_Prefix,"_tp_label");
   l_SL=StringConcatenate(l_Prefix,"_sl_label");
   l_Gap=StringConcatenate(l_Prefix,"_gap_label");
   l_Trail=StringConcatenate(l_Prefix,"_trail_label");
   l_Bal=StringConcatenate(l_Prefix,"_balance_label");
   l_Eq=StringConcatenate(l_Prefix,"_equity_label");
   l_EqLoss=StringConcatenate(l_Prefix,"_eqloss_label");
   l_DayPP=StringConcatenate(l_Prefix,"_daypp_label");
   l_OpenPP=StringConcatenate(l_Prefix,"_openpp_label");
   l_OrdCnt=StringConcatenate(l_Prefix,"_ordcnt_label");
   l_Time=StringConcatenate(l_Prefix,"_time_label");
   l_L1=StringConcatenate(l_Prefix,"_l1_label");
   l_L2=StringConcatenate(l_Prefix,"_l2_label");
   u_Abort=StringConcatenate(l_Prefix,"_abort_button");

//--- Chart Header
   objLabel(l_H1,CORNER_LEFT_UPPER,10,5,"Fixedsys",9,clrGold,"*SYMBOLS*");
   objLabel(l_H2,CORNER_LEFT_UPPER,120,5,"Fixedsys",9,clrGold,"*STRENGTH [bars]*");
   objLabel(l_H3,CORNER_LEFT_UPPER,305,5,"Fixedsys",9,clrGold,"*MARKET ORDERS*");
   objLabel(l_H4,CORNER_LEFT_UPPER,490,5,"Fixedsys",9,clrGold,"*STOP ORDERS*");
   objLabel(l_H5,CORNER_LEFT_UPPER,660,5,"Fixedsys",9,clrGold,"*CLOSE*");
   objLabel(l_H6,CORNER_LEFT_UPPER,750,5,"Fixedsys",9,clrGold,"*BUYS*  *SELLS*    *PIPS / PROFIT*");
   objLabel(l_L1,CORNER_LEFT_UPPER,10,420,"Fixedsys",9,clrGold,"============================================================");
   objLabel(l_L2,CORNER_LEFT_UPPER,490,420,"Fixedsys",9,clrGold,"============================================================");

   if(ECN_BROKER==0) objLabel(l_ECN,CORNER_LEFT_UPPER,10,505,"Fixedsys",9,clrIvory,"ECN Broker      = No");
   else if(ECN_BROKER==1) objLabel(l_ECN,CORNER_LEFT_UPPER,10,505,"Fixedsys",9,clrIvory,"ECN Broker      = Yes");
   objLabel(l_Lot,CORNER_LEFT_UPPER,10,525,"Fixedsys",9,clrIvory,"Trade Lot Size  = "+DoubleToString(LOT,2));

   objLabel(l_Slip,CORNER_LEFT_UPPER,300,445,"Fixedsys",9,clrIvory,"Slippage  =  "+DoubleToString(SLIP,1)+" pips");
   objLabel(l_TP,CORNER_LEFT_UPPER,300,465,"Fixedsys",9,clrIvory,"T/P       = "+DoubleToString(TP,1)+" pips");
   objLabel(l_SL,CORNER_LEFT_UPPER,300,485,"Fixedsys",9,clrIvory,"S/L       = "+DoubleToString(SL,1)+" pips");
   objLabel(l_Gap,CORNER_LEFT_UPPER,300,505,"Fixedsys",9,clrIvory,"Limit Gap = "+DoubleToString(GAP,1)+" pips");
   objLabel(l_Trail,CORNER_LEFT_UPPER,300,525,"Fixedsys",9,clrIvory,"Trailing  = "+DoubleToString(TRAIL,1)+" pips");

//--- Abort Button
   objButton(u_Abort,CORNER_LEFT_UPPER,640,450,100,25,clrYellow,clrMagenta,10,"CLOSE ALL");

//--- Init Arrays
   ArrayInitialize(A_SignalBars,0);

   A_Symbols[0]  = SYMBOL_00;
   A_Symbols[1]  = SYMBOL_01;
   A_Symbols[2]  = SYMBOL_02;
   A_Symbols[3]  = SYMBOL_03;
   A_Symbols[4]  = SYMBOL_04;
   A_Symbols[5]  = SYMBOL_05;
   A_Symbols[6]  = SYMBOL_06;
   A_Symbols[7]  = SYMBOL_07;
   A_Symbols[8]  = SYMBOL_08;
   A_Symbols[9]  = SYMBOL_09;
   A_Symbols[10] = SYMBOL_10;
   A_Symbols[11] = SYMBOL_11;

//--- Detect duplicate symbols
   for(aidx=0; aidx<MAXSIZE; aidx++)
     {
      for(int i=0; i<MAXSIZE; i++)
        {
         if(i!=aidx && A_Symbols[i]==A_Symbols[aidx])
           {
            b_StopEA=true;
            Print("Aborting EA: duplicate symbols passed as EA input!");
            return INIT_FAILED;
            break;
           }
        }
     }

//--- Init Object Name Arrays
   for(aidx=0; aidx<MAXSIZE; aidx++)
     {
      A_SymbolObj[aidx]=StringConcatenate(l_Prefix,"_symbol_label_",A_Symbols[aidx]);
      A_SignalObj[aidx]=StringConcatenate(l_Prefix,"_signal_label_",A_Symbols[aidx]);
      A_BuyObj[aidx]=StringConcatenate(l_Prefix,"_buy_button_",A_Symbols[aidx]);
      A_SellObj[aidx]=StringConcatenate(l_Prefix,"_sell_button_",A_Symbols[aidx]);
      A_BuyStopObj[aidx]=StringConcatenate(l_Prefix,"_buystop_button_",A_Symbols[aidx]);
      A_SellStopObj[aidx]=StringConcatenate(l_Prefix,"_sellstop_button_",A_Symbols[aidx]);
      A_CloseObj[aidx]=StringConcatenate(l_Prefix,"_close_button_",A_Symbols[aidx]);
      A_CountObjB[aidx]=StringConcatenate(l_Prefix,"_bcount_label_",A_Symbols[aidx]);
      A_CountObjS[aidx]=StringConcatenate(l_Prefix,"_scount_label_",A_Symbols[aidx]);
      A_PP_Obj[aidx]=StringConcatenate(l_Prefix,"_pp_label_",A_Symbols[aidx]);
     }

//--- Create All Buttons
   for(aidx=0; aidx<MAXSIZE; aidx++)
     {
      if(StringLen(A_Symbols[aidx])<6) s_text=A_Symbols[aidx];
      else if(StringLen(A_Symbols[aidx])==6) s_text=StringSubstr(A_Symbols[aidx],0,3)+"/"+StringSubstr(A_Symbols[aidx],3,3);

      objLabel(A_SymbolObj[aidx],CORNER_LEFT_UPPER,10,50+aidx*30,"Impact",14,clrAqua,s_text);
      objButton(A_BuyObj[aidx],CORNER_LEFT_UPPER,300,50+aidx*30,60,25,clrBlack,clrLime,10,"BUY");
      objButton(A_SellObj[aidx],CORNER_LEFT_UPPER,370,50+aidx*30,60,25,clrWhite,clrRed,10,"SELL");
      objButton(A_BuyStopObj[aidx],CORNER_LEFT_UPPER,480,50+aidx*30,60,25,clrBlack,clrMediumSeaGreen,10,"Buy");
      objButton(A_SellStopObj[aidx],CORNER_LEFT_UPPER,550,50+aidx*30,60,25,clrWhite,clrOrangeRed,10,"Sell");
      objButton(A_CloseObj[aidx],CORNER_LEFT_UPPER,660,50+aidx*30,60,25,clrBlack,clrDeepSkyBlue,10,"CLOSE");
     }

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   objClear(l_Prefix);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(b_StopEA==true) return;

   static datetime CURRENT_TIME;
   if(TimeCurrent()<CURRENT_TIME) return;
   CURRENT_TIME=TimeCurrent()+INTERVAL;

   string _cur_time=TimeToStr(TimeCurrent(),TIME_SECONDS);
   objLabel(l_Time,CORNER_RIGHT_UPPER,30,5,"Fixedsys",9,clrIvory,"Server Time: "+_cur_time);

//--- Show Account Eq/Balance and Total P/L
   double d_AccEqPctLoss=(AccountEquity()-AccountBalance())/AccountBalance()*100;
   objLabel(l_Bal,CORNER_LEFT_UPPER,10,445,"Fixedsys",9,clrAqua,"Account Balance = "+DoubleToString(AccountBalance(),2));
   objLabel(l_Eq,CORNER_LEFT_UPPER,10,465,"Fixedsys",9,clrAqua,"Account Equity  = "+DoubleToString(AccountEquity(),2));
   objLabel(l_EqLoss,CORNER_LEFT_UPPER,10,485,"Fixedsys",9,clrTomato,"Equity Loss Pct = "+DoubleToString(d_AccEqPctLoss,2)+" (%)");

   int _open_orders=0;
   double _total_pips_open=0,_total_profit_open=0,_total_pips_day=0,_total_prof_day=0;
   color _clr_up_down=clrNONE;

//--- Trend Signal checks on new bar
   if(newBar(TimeCurrent(),TIMEFRAME,false,0,false)==true)
     {
      i_BarCounter++;

      for(aidx=0; aidx<MAXSIZE; aidx++)
        {
         if(i_BarCounter==1)
           {
            A_Signals[aidx][1]=0;                                            // prev signal
            A_Signals[aidx][0]=TrendSignalCheck(A_Symbols[aidx],TIMEFRAME);  // curr signal
           }
         else
           {
            A_Signals[aidx][1]=A_Signals[aidx][0];                           // prev signal
            A_Signals[aidx][0]=TrendSignalCheck(A_Symbols[aidx],TIMEFRAME);  // curr signal
           }

         if(A_Signals[aidx][0]!=A_Signals[aidx][1]) A_SignalBars[aidx]=0;
         else A_SignalBars[aidx]=A_SignalBars[aidx]+1;

         if(A_Signals[aidx][0]==2)
           {
            if(iClose(A_Symbols[aidx],TIMEFRAME,1)<iOpen(A_Symbols[aidx],TIMEFRAME,1))
               s_text=StringConcatenate("STRONG   [",IntegerToString(A_SignalBars[aidx],2)," ]  #");
            else s_text=StringConcatenate("STRONG   [",IntegerToString(A_SignalBars[aidx],2)," ]");
            objLabel(A_SignalObj[aidx],CORNER_LEFT_UPPER,120,50+aidx*30,"Impact",14,clrLime,s_text);
           }
         else if(A_Signals[aidx][0]==-2)
           {
            if(iClose(A_Symbols[aidx],TIMEFRAME,1)>iOpen(A_Symbols[aidx],TIMEFRAME,1))
               s_text=StringConcatenate("STRONG   [",IntegerToString(A_SignalBars[aidx],2)," ]  #");
            else s_text=StringConcatenate("STRONG   [",IntegerToString(A_SignalBars[aidx],2)," ]");
            objLabel(A_SignalObj[aidx],CORNER_LEFT_UPPER,120,50+aidx*30,"Impact",14,clrRed,s_text);
           }
         else if(A_Signals[aidx][0]==1)
            objLabel(A_SignalObj[aidx],CORNER_LEFT_UPPER,120,50+aidx*30,"Impact",14,clrMediumSeaGreen,"WEAK   ["+IntegerToString(A_SignalBars[aidx],2)+" ]");
         else if(A_Signals[aidx][0]==-1)
            objLabel(A_SignalObj[aidx],CORNER_LEFT_UPPER,120,50+aidx*30,"Impact",14,clrOrangeRed,"WEAK   ["+IntegerToString(A_SignalBars[aidx],2)+" ]");
         else ObjectDelete(A_SignalObj[aidx]);
        }
     }

//--- Scan Symbol Array and do calculations for each symbol
   for(aidx=0; aidx<MAXSIZE; aidx++)
     {
      int _buy_count=0,_sell_count=0,_open_count=0;
      double _symbol_pips_open=0,_symbol_prof_open=0,_symbol_pips_day=0,_symbol_prof_day=0;

      ScanSymbolOrders(MAGIC,A_Symbols[aidx],_symbol_pips_open,_symbol_prof_open,_buy_count,_sell_count);
      CalcDailyProfits(MAGIC,A_Symbols[aidx],_symbol_pips_day,_symbol_prof_day);

      _open_count=_buy_count+_sell_count;
      _total_pips_open=_total_pips_open+_symbol_pips_open;
      _total_profit_open=_total_profit_open+_symbol_prof_open;
      _total_pips_day=_total_pips_day+_symbol_pips_day;
      _total_prof_day=_total_prof_day+_symbol_prof_day;

      if(_buy_count>0) objLabel(A_CountObjB[aidx],CORNER_LEFT_UPPER,765,55+aidx*30,"Fixedsys",9,clrDeepSkyBlue,"["+IntegerToString(_buy_count)+"]");
      else  ObjectDelete(A_CountObjB[aidx]);
      if(_sell_count>0) objLabel(A_CountObjS[aidx],CORNER_LEFT_UPPER,830,55+aidx*30,"Fixedsys",9,clrDeepSkyBlue,"["+IntegerToString(_sell_count)+"]");
      else ObjectDelete(A_CountObjS[aidx]);

      if(_open_count>0)
        {
         _open_orders=_open_orders+_open_count;

         string _symbol_pp_text=StringConcatenate(DoubleToString(_symbol_pips_open,1)," / ",DoubleToString(_symbol_prof_open,2));

         if(_symbol_pips_open>=0) objLabel(A_PP_Obj[aidx],CORNER_LEFT_UPPER,900,55+aidx*30,"Fixedsys",9,clrLime,_symbol_pp_text);
         else objLabel(A_PP_Obj[aidx],CORNER_LEFT_UPPER,900,55+aidx*30,"Fixedsys",9,clrRed,_symbol_pp_text);
        }
      else ObjectDelete(A_PP_Obj[aidx]);
     }

//--- Calculate and display global/day profits
   if(_total_pips_open>=0) _clr_up_down=clrLimeGreen;
   else _clr_up_down=clrOrangeRed;
   s_text=StringConcatenate("Open Orders : [",IntegerToString(_open_orders),"] ",DoubleToString(_total_pips_open,1)," pips / ",DoubleToString(_total_profit_open,2)," USD");
   objLabel(l_OpenPP,CORNER_LEFT_UPPER,780,445,"Fixedsys",9,_clr_up_down,s_text);

   if(_total_pips_day>=0) _clr_up_down=clrLimeGreen;
   else _clr_up_down=clrOrangeRed;
   s_text=StringConcatenate("Daily Totals: ",DoubleToString(_total_pips_day,1)," pips / ",DoubleToString(_total_prof_day,2)," USD");
   objLabel(l_DayPP,CORNER_LEFT_UPPER,780,465,"Fixedsys",9,_clr_up_down,s_text);

   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   double d_SL=0,d_TP=0,d_BuyStop=0,d_SellStop=0;

   RefreshRates();

//--- Check if Abort Close (ALL IS LOST)
   if(sparam==u_Abort)
     {
      for(aidx=0; aidx<MAXSIZE; aidx++)
        {
         //--- Close ALL open/pending orders for ALL 12 pairs
         GetSymbolMarketData(A_Symbols[aidx],SLIP,i_Digits,d_Pip2Double,i_Slippage,d_Bid,d_Ask);
         CloseAllPositions(MAGIC,A_Symbols[aidx],i_Slippage);
        }
      ObjectSetInteger(0,u_Abort,OBJPROP_STATE,false);
     }
   else
     {
      for(aidx=0; aidx<MAXSIZE; aidx++)
        {
         //--- Get MarketInfo data for each Symbol
         GetSymbolMarketData(A_Symbols[aidx],SLIP,i_Digits,d_Pip2Double,i_Slippage,d_Bid,d_Ask);

         if(sparam==A_CloseObj[aidx]) //--- Check if Close Button Pressed
           {
            CloseAllPositions(MAGIC,A_Symbols[aidx],i_Slippage);
            ObjectSetInteger(0,A_CloseObj[aidx],OBJPROP_STATE,false);
           }
         else if(sparam==A_BuyObj[aidx]) //--- Check if Buy Button Pressed
           {
            d_SL=NormalizeDouble(d_Bid-SL*d_Pip2Double,i_Digits);
            d_TP=NormalizeDouble(d_Ask+TP*d_Pip2Double,i_Digits);

            i_Ticket=OrderSend(A_Symbols[aidx],OP_BUY,LOT,d_Ask,i_Slippage,d_SL,d_TP,"One-Click OP_BUY",MAGIC,0,clrNONE);

            ObjectSetInteger(0,A_BuyObj[aidx],OBJPROP_STATE,false);
           }
         else if(sparam==A_SellObj[aidx]) //--- Check if Sell Button Pressed
           {
            d_SL=NormalizeDouble(d_Ask+SL*d_Pip2Double,i_Digits);
            d_TP=NormalizeDouble(d_Bid-TP*d_Pip2Double,i_Digits);

            i_Ticket=OrderSend(A_Symbols[aidx],OP_SELL,LOT,d_Bid,i_Slippage,d_SL,d_TP,"One-Click OP_SELL",MAGIC,0,clrNONE);

            ObjectSetInteger(0,A_SellObj[aidx],OBJPROP_STATE,false);
           }
         else if(sparam==A_BuyStopObj[aidx])
           {
            d_BuyStop=NormalizeDouble(d_Ask+GAP*d_Pip2Double,i_Digits);
            d_SL=NormalizeDouble(d_Ask+GAP*d_Pip2Double-SL*d_Pip2Double,i_Digits);
            d_TP=NormalizeDouble(d_Ask+GAP*d_Pip2Double+TP*d_Pip2Double,i_Digits);

            i_Ticket=OrderSend(A_Symbols[aidx],OP_BUYSTOP,LOT,d_BuyStop,i_Slippage,d_SL,d_TP,"One-Click OP_BUYSTOP",MAGIC,0,clrNONE);

            ObjectSetInteger(0,A_BuyStopObj[aidx],OBJPROP_STATE,false);
           }
         else if(sparam==A_SellStopObj[aidx])
           {
            d_SellStop=NormalizeDouble(d_Bid-GAP*d_Pip2Double,i_Digits);
            d_SL=NormalizeDouble(d_Bid-GAP*d_Pip2Double+SL*d_Pip2Double,i_Digits);
            d_TP=NormalizeDouble(d_Bid-GAP*d_Pip2Double-TP*d_Pip2Double,i_Digits);

            i_Ticket=OrderSend(A_Symbols[aidx],OP_SELLSTOP,LOT,d_SellStop,i_Slippage,d_SL,d_TP,"One-Click OP_SELLSTOP",MAGIC,0,clrNONE);

            ObjectSetInteger(0,A_SellStopObj[aidx],OBJPROP_STATE,false);
           }
        }
     }

   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetSymbolMarketData(string _symbol,double _pip_slippage,int &_digits,double &_p2p,int &_slippage,double &_bid,double &_ask)
  {
   double _point=MarketInfo(_symbol,MODE_POINT);

   _bid=MarketInfo(_symbol,MODE_BID);
   _ask=MarketInfo(_symbol,MODE_ASK);

   _digits=(int)MarketInfo(_symbol,MODE_DIGITS);
   _p2p=_point*MathPow(10,_digits%2);

   if(_point==0.00001 || _point==0.001) _slippage=(int)_pip_slippage*10;
   else _slippage=(int)_pip_slippage;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TrendSignalCheck(string _symbol,int _timeframe)
  {
   int _up_count=0,_dn_count=0,_trend=0;

   double d_EMA50=iMA(_symbol,_timeframe,50,0,MODE_EMA,PRICE_CLOSE,1);
   double d_EMA200=iMA(_symbol,_timeframe,200,0,MODE_EMA,PRICE_CLOSE,1);

   if(d_EMA50>d_EMA200) _trend=1;
   else if(d_EMA50<d_EMA200) _trend=-1;
   else return(0);

   if(_trend!=0)
     {
      double d_EMA=iMA(_symbol,_timeframe,10,0,MODE_EMA,PRICE_CLOSE,1);
      double d_MACD=iMACD(_symbol,_timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double d_CCI=iCCI(_symbol,_timeframe,50,PRICE_CLOSE,1);
      double d_RSI=iRSI(_symbol,_timeframe,14,PRICE_CLOSE,1);
      double d_STO=iStochastic(_symbol,_timeframe,30,5,5,MODE_SMA,0,MODE_MAIN,1);

      if(d_EMA>d_EMA50) _up_count++;
      else if(d_EMA<d_EMA50) _dn_count++;
      if(d_MACD>0) _up_count++;
      else if(d_MACD<0) _dn_count++;
      if(d_CCI>0) _up_count++;
      else if(d_CCI<0) _dn_count++;
      if(d_RSI>50) _up_count++;
      else if(d_RSI<50) _dn_count++;
      if(d_STO>50) _up_count++;
      else if(d_STO<50) _dn_count++;

      //--- Result: +1 - weak signal up, +2 - strong signal up, -1 - weak signal down, -2 - strong signal down
      if(_trend>0 && _up_count==4) return(1);
      else if(_trend>0 && _up_count==5) return(2);
      else if(_trend<0 && _dn_count==4) return(-1);
      else if(_trend<0 && _dn_count==5) return(-2);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllPositions(int _magic,string _symbol,int _slippage)
  {
   for(int apos=OrdersTotal()-1; apos>=0; apos--)
     {
      if(OrderSelect(apos,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==_symbol && OrderMagicNumber()==_magic)
           {
            if(OrderType()<=OP_SELL) //--- Close Open Orders here
              {
               int _ticket=OrderTicket();

               for(int _try=1; _try<=MAXTRY; _try++)
                 {
                  RefreshRates();

                  if(OrderClose(_ticket,OrderLots(),OrderClosePrice(),_slippage,clrNONE)==true)
                    {
                     Print("CloseAllPositions SUCCESS: Magic # ",_magic," Ticket # ",_ticket);
                     break;
                    }
                  else
                    {
                     if(_try==MAXTRY) Print("CloseAllPositions ERROR: Magic # ",_magic," maximum attempts reached # ",MAXTRY);
                     else Print("CloseAllPositions ERROR: Magic # ",_magic," Ticket # ",_ticket," Error # ",GetLastError());
                     Sleep(3000); //--- Wait 3 seconds before retrying to close the open order
                    }
                 }
              }
            else if(OrderType()>OP_SELL) //--- Delete Limit/Pending Orders here
              {
               int _ticket=OrderTicket();

               if(OrderDelete(OrderTicket())==true) Print("CloseAllPositions SUCCESS: Magic # ",_magic," Ticket # ",_ticket);
               else Print("CloseAllPositions Pending ERROR: Magic # ",_magic," Ticket # ",_ticket," Error # ",GetLastError());
              }
           }
        }
     }
  }
//+------------------------------------------------------------------------------------------------+
//| Calculate realized and unrealized pips & profit totals, resulting from all open and closed trades
//| for specific Symbol/MagicNo and including all tickets since specific timestamp. 
//| Includes total number of orders (both BUY/SELL)
//+------------------------------------------------------------------------------------------------+
void ScanSymbolOrders(int _magic,string _symbol,double &_total_pips,double &_total_profit,int &_buy_orders,int &_sell_orders)
  {
   _total_pips=0.0;
   _total_profit=0.0;
   _buy_orders=0;
   _sell_orders=0;

   int DIGITS=(int)MarketInfo(_symbol,MODE_DIGITS);
   double PIP2DBL=MarketInfo(_symbol,MODE_POINT)*MathPow(10,DIGITS%2);

   for(int apos=0; apos<OrdersTotal(); apos++)
     {
      if(OrderSelect(apos,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==_symbol && OrderMagicNumber()==_magic && OrderType()<=OP_SELL)
           {
            if(OrderType()==OP_BUY) _buy_orders++;
            else if(OrderType()==OP_SELL) _sell_orders++;

            _total_profit=_total_profit+OrderProfit()+OrderSwap()+OrderCommission();

            if(OrderType()==OP_BUY) _total_pips=_total_pips+((OrderClosePrice()-OrderOpenPrice())/PIP2DBL);
            else if(OrderType()==OP_SELL) _total_pips=_total_pips+((OrderOpenPrice()-OrderClosePrice())/PIP2DBL);
           }
        }
     }

   _total_pips=NormalizeDouble(_total_pips,1);
   _total_profit=NormalizeDouble(_total_profit,2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalcDailyProfits(int _magic,string _symbol,double &_total_pips,double &_total_profit)
  {
   datetime _day_start=iTime(_symbol,PERIOD_D1,0);
   _total_pips=0.0;
   _total_profit=0.0;

   int DIGITS=(int)MarketInfo(_symbol,MODE_DIGITS);
   double PIP2DBL=MarketInfo(_symbol,MODE_POINT)*MathPow(10,DIGITS%2);

//--- Closed Orders
   for(int hpos=0; hpos<OrdersHistoryTotal(); hpos++)
     {
      if(OrderSelect(hpos,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderSymbol()==_symbol && OrderMagicNumber()==_magic && OrderType()<=OP_SELL && OrderOpenTime()>_day_start)
           {
            _total_profit=_total_profit+OrderProfit()+OrderSwap()+OrderCommission();

            if(OrderType()==OP_BUY) _total_pips=_total_pips+((OrderClosePrice()-OrderOpenPrice())/PIP2DBL);
            else if(OrderType()==OP_SELL) _total_pips=_total_pips+((OrderOpenPrice()-OrderClosePrice())/PIP2DBL);
           }
        }
     }

//--- Open Orders
   for(int apos=0; apos<OrdersTotal(); apos++)
     {
      if(OrderSelect(apos,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==_symbol && OrderMagicNumber()==_magic && OrderType()<=OP_SELL && OrderOpenTime()>_day_start)
           {
            _total_profit=_total_profit+OrderProfit()+OrderSwap()+OrderCommission();

            if(OrderType()==OP_BUY) _total_pips=_total_pips+((OrderClosePrice()-OrderOpenPrice())/PIP2DBL);
            else if(OrderType()==OP_SELL) _total_pips=_total_pips+((OrderOpenPrice()-OrderClosePrice())/PIP2DBL);
           }
        }
     }

   _total_pips=NormalizeDouble(_total_pips,1);
   _total_profit=NormalizeDouble(_total_profit,2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime lastBarTime(datetime _currentTime,int _period,bool _period_in_second=false,int _advance=0,bool _advanced_in_second=false)
  {
   int iAdvance=(_advance*60);
   if(_advanced_in_second) iAdvance=_advance;

   datetime iCurrentTime=_currentTime+=iAdvance;

   int iPeriod=(_period*60);
   if(_period_in_second) iPeriod=_period;

   if(_period==PERIOD_W1) return((iCurrentTime-(datetime)MathMod(iCurrentTime,(PERIOD_D1*60)))-(((TimeDayOfWeek(iCurrentTime)-1)*PERIOD_D1)*60));
   else if(_period==PERIOD_MN1) return((iCurrentTime-(datetime)MathMod(iCurrentTime,(PERIOD_D1*60)))-(((TimeDay(iCurrentTime)-1)*PERIOD_D1)*60));
   else
     {
      if(_period>0) return(iCurrentTime-(datetime)MathMod(iCurrentTime,iPeriod));
      else return(iCurrentTime);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool newBar(datetime _currentTime,int _period,bool _period_in_second=false,int _advance=0,bool _advanced_in_second=false)
  {
   static datetime gsLastBarTime;

   int iAdvance=(_advance*60);
   if(_advanced_in_second) iAdvance=_advance;

   datetime iCurrentTime=_currentTime+=iAdvance;

   int iPeriod=(_period*60);
   if(_period_in_second) iPeriod=_period;

   if((iCurrentTime-gsLastBarTime)>=iPeriod)
     {
      gsLastBarTime=lastBarTime(_currentTime,_period,_period_in_second,_advance,_advanced_in_second);
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objClear(string _prefix)
  {
   string _name;
   int obj_total=ObjectsTotal();

   for(int i=obj_total-1; i>=0; i--)
     {
      _name=ObjectName(i);
      if(StringFind(_name,_prefix)==0) ObjectDelete(_name);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objLabel(string _name,int _corner,int _xpos,int _ypos,string _font,int _fsize,color _fcolor,string _text)
  {
   if(ObjectFind(_name)<0)
     {
      ObjectCreate(_name,OBJ_LABEL,0,0,0);
      ObjectSet(_name,OBJPROP_CORNER,_corner);
      ObjectSet(_name,OBJPROP_XDISTANCE,_xpos);
      ObjectSet(_name,OBJPROP_YDISTANCE,_ypos);
     }

   ObjectSetText(_name,_text,_fsize,_font,_fcolor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objButton(string _name,int _corner,int _xpos,int _ypos,int _width,int _hight,color _fcolor,color _bcolor,int _fsize,string _text)
  {
   if(ObjectFind(_name)<0)
     {
      ObjectCreate(0,_name,OBJ_BUTTON,0,0,0);
      ObjectSetInteger(0,_name,OBJPROP_CORNER,_corner);
      ObjectSetInteger(0,_name,OBJPROP_XDISTANCE,_xpos);
      ObjectSetInteger(0,_name,OBJPROP_YDISTANCE,_ypos);
      ObjectSetInteger(0,_name,OBJPROP_XSIZE,_width);
      ObjectSetInteger(0,_name,OBJPROP_YSIZE,_hight);
      ObjectSetInteger(0,_name,OBJPROP_COLOR,_fcolor);
      ObjectSetInteger(0,_name,OBJPROP_BGCOLOR,_bcolor);
      ObjectSetInteger(0,_name,OBJPROP_BORDER_COLOR,_bcolor);
      ObjectSetInteger(0,_name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,_name,OBJPROP_BACK,false);
      ObjectSetInteger(0,_name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,_name,OBJPROP_STATE,false);
      ObjectSetInteger(0,_name,OBJPROP_FONTSIZE,_fsize);
     }

   ObjectSetString(0,_name,OBJPROP_TEXT,_text);
  }
//+------------------------------------------------------------------+
