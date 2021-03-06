//+----------------------------------------------------------------------------+
//|                                                       _Expert Advisor.mq4  |
//|                             Copyright © 2008-2010, TradingSystemForex.Com  |
//|                                        http://www.tradingsystemforex.com/  |
//|  05.01.2010                                                                |
//+----------------------------------------------------------------------------+

#property copyright "Copyright © 2008-2010, TradingSystemForex.Com"
#property link "http://www.tradingsystemforex.com/"

/*Martingale : You can set a closed martingale : martingale=true, maxtrades=1,
basketpercent or basketpips=true. Or an open martingale : martingale=true,
tradesperbar=100, basketpercent or basketpips=true, addpositions=true.
Scalping : You can use timeout and target, time filter, set maxtrades=1,
changedirection=true to optimize the scalping.*/

//+----------------------------------------------------------------------------+
//|  External inputs                                                           |
//+----------------------------------------------------------------------------+

string comment="EA";                     // comment to display in the order
extern int magic=1234;                   // magic number required if you use different settings on a same pair, same timeframe
bool useprint=false;                     // use print
bool onlybuy=false;                      // only enter buy orders
bool onlysell=false;                     // only enter sell orders

extern string moneymanagement="Money Management";

extern double lots=0.1;                  // lots size
extern bool mm=false;                    // enable risk management
extern double risk=1;                    // risk in percentage of the account
extern double minlot=0.01;               // minimum lots size
extern double maxlot=100;                // maximum lots size
extern int lotdigits=2;                  // lot digits, 1=0.1, 2=0.01
extern bool martingale=false;                   // enable the martingale, set maxtrades to 1
extern double multiplier=2.0;                   // multiplier used for the martingale

extern string profitmanagement="Profit Management";

extern bool basketpercent=false;                // enable the basket percent
extern double profit=0.1;                       // close all orders if a profit of 10 percents has been reached
extern double loss=100;                         // close all orders if a loss of 30 percents has been reached
extern bool basketpips=false;                   // enable the basket pips
extern double profitpips=10;                    // close all orders if a profit of 10 percents has been reached
extern double losspips=10000;                   // close all orders if a loss of 30 percents has been reached
extern bool basketdollars=false;                // enable basket dollars
extern double dollars=5;                        // target in dollars

extern string ordersmanagement="Order Management";

extern bool ecn=false;                   // make the expert compatible with ecn brokers
extern bool oppositeclose=true;          // close the orders on an opposite signal
extern bool reversesignals=false;        // reverse the signals, long if short, short if long
extern int maxtrades=1;                // maximum trades allowed by the traders
extern int tradesperbar=1;               // maximum trades per bar allowed by the expert
extern bool hidesl=false;                // hide stop loss
extern bool hidetp=false;                // hide take profit
extern double stoploss=0;                // stop loss
extern double takeprofit=0;              // take profit
extern double trailingstart=0;           // profit in pips required to enable the trailing stop
extern double trailingstop=0;            // trailing stop
extern double trailingprofit=0;                 // trailing profit
extern double trailingstep=1;            // margin allowed to the market to enable the trailing stop
extern double breakevengain=0;           // gain in pips required to enable the break even
extern double breakeven=0;               // break even
extern int expiration=1440;                     // expiration in minutes for pending orders
extern double slippage=0;                       // maximum difference in pips between signal and order
extern double maxspread=0;               // maximum spread allowed by the expert, 0=disabled

extern string adstopsmanagement="Advanced Stops Management";

extern double slfactor=0;                       // enable dynamic stoploss if different of 0
extern int slmargin=0;                          // margin to add to the stoploss
extern double tpfactor=0;                       // enable dynamic takeprofit if different of 0
extern int stoplevel=15;                        // minimum value for dynamic variables
extern bool atrdynamics=false;                  // dynamic stops based on atr
extern int atrtimeframe=60;                     // timeframe for the atr
extern int atrperiod=14;                        // atr period
extern double tstfactor=0;                      // enable dynamic trailing start if different of 0
extern double tsfactor=0;                       // enable dynamic trailing stop if different of 0
extern double begfactor=0;                      // enable dynamic breakevengain if different of 0
extern double befactor=0;                       // enable dynamic breakeven if different of 0
extern double psfactor=0;                       // enable dynamic pipstep if different of 0
extern double gfactor=0;                        // enable dynamic gap if different of 0
extern bool highlowdynamics=false;              // dynamic stops based on highest/lowest
extern int hltimeframe=0;                       // high low timeframe
extern int candles=7;                           // highest/lowest on the last x candles
extern bool sdldynamics=false;                  // dynamic stops based on slope direction line
extern int sdltimeframe=0;                      // timeframe of the sdl
extern int sdlperiod=15;                        // period of the sdl
extern int method=3;                            // method of the sdl
extern int price=0;                             // price of the sdl

extern string pordersmanagement="Pending Orders Management";

extern bool instantorders=true;                 // instant orders
extern bool stoporders=false;                   // stoporders
extern bool limitorders=false;                  // limit orders
extern bool onecancelother=false;               // cancel opposite pending orders when one is triggered
extern int gap=20;                              // gap for pending orders

extern string aordersmanagement="Added Positions Management";

extern bool eoobexceptaddpos=true;              // we don't consider added pos for enteronopenbar option
extern bool addpositions=false;                 // add positions, set tradesperbar to 100
extern int addposmode=0;                        // 0=counter, 1=follow
extern double pipstep=20;                       // multiplier used for the martingale
extern double pipstepfactor=1.0;                // multiply the pipstep by the number of buy/sell orders

extern string adordersmanagement="Advanced Order Management";

extern bool enteronopenbar=false;        // enter only on open bar
extern bool onetimecalculation=false;    // calculate entry logics one time per bar
extern double stop=0;                    // stoptake=stoploss and takeprofit
extern double trailing=0;                // trailing=trailingstart and trailingstop
extern bool changedirection=false;              // only buy after a sell order, sell after a buy order
extern bool onesideatatime=false;               // enter only long or short when a long or short is already opened

extern string entrylogics="Entry Logics";

extern int SignalGap = 4;
extern int ShowBars = 500;
extern int dist=24;
extern double Calc_Value = 1;
extern int shift=1;                      // bar in the past to take in consideration for the signal

extern string timefilter="Time Filter";

extern bool usetimefilter=false;
extern int summergmtshift=2;                    // gmt offset of the broker
extern int wintergmtshift=1;                    // gmt offset of the broker
extern bool mondayfilter=false;                 // enable special time filter on friday
extern int mondayhour=12;                       // start to trade after this hour
extern int mondayminute=0;                      // minutes of the friday hour
extern bool weekfilter=false;                   // enable time filter
extern int starthour=7;                         // start hour to trade after this hour
extern int startminute=0;                       // minutes of the start hour
extern int endhour=21;                          // stop to trade after this hour
extern int endminute=0;                         // minutes of the start hour
extern bool tradesunday=true;                   // trade on sunday
extern bool fridayfilter=false;                 // enable special time filter on friday
extern int fridayhour=12;                       // stop to trade after this hour
extern int fridayminute=0;                      // minutes of the friday hour

extern bool newsfilter=false;                   // news filter option
extern int minutesbefore=120;                   // minutes before the news
extern int newshour=14;                         // hour of the news
extern int newsminute=30;                       // minute of the news
extern int minutesafter=120;                    // minutes after the news

extern string timeout="Time Outs and Targets";

extern bool usetimeout=false;                   // time out, we close the order if after timeout minutes we are over target pips
extern int timeout1=30;                         // time out 1
extern int target1=7;                           // target 1
extern int timeout2=70;                         // time out 2
extern int target2=5;                           // target 2
extern int timeout3=95;                         // time out 3
extern int target3=4;                           // target 3
extern int timeout4=120;                        // time out 4
extern int target4=2;                           // target 4
extern int timeout5=150;                        // time out 5
extern int target5=-5;                          // target 5
extern int timeout6=180;                        // time out 6
extern int target6=-8;                          // target 6
extern int timeout7=210;                        // time out 7
extern int target7=-15;                         // target 7

//+----------------------------------------------------------------------------+
//|  Internal parameters                                                       |
//+----------------------------------------------------------------------------+

datetime tstart,tend,tfriday,tmonday,lastbuyopentime,tnews,lastsellopentime,time,time2,time3,time4,time5;
int i,bc=-1,cnt,tpb,tps,tries=100,lastorder,buyorderprofit,sellorderprofit,lotsize;
int nstarthour,nnewshour,nendhour,nfridayhour,nmondayhour,number,ticket,gmtshift,tradetime,expire,
total,totalbuy,totalsell,totalstopbuy,totalstopsell,totallimitbuy,totallimitsell;
string istarthour,inewshour,istartminute,iendhour,iendminute,inewsminute,ifridayhour,ifridayminute,imondayhour,imondayminute;
double cb,sl,tp,blots,slots,lastbuylot,lastselllot,lastlot,lastprofit,mlots,win[14],sum[14],totalpips,totalprofit,percentprofit,percentloss;
double lastbuyopenprice,lastsellopenprice,lastbuyprofit,lastsellprofit,tradeprofit,buyorderpips,sellorderpips;

bool closebasket=false;

bool continuebuy=true;
bool continuesell=true;

double pt,mt;

//+----------------------------------------------------------------------------+
//|  Initialization (done only when you attach the EA to the chart)            |
//+----------------------------------------------------------------------------+

int init(){
   if(usetimefilter){
      sum[2012-1999]=D'2012.03.28 02:00:00';win[2012-1999]=D'2012.10.31 03:00:00';
      sum[2011-1999]=D'2011.03.29 02:00:00';win[2011-1999]=D'2011.10.25 03:00:00';
      sum[2010-1999]=D'2010.03.30 02:00:00';win[2010-1999]=D'2010.10.26 03:00:00';
      sum[2009-1999]=D'2009.03.29 02:00:00';win[2009-1999]=D'2009.10.25 03:00:00';
      sum[2008-1999]=D'2008.03.30 02:00:00';win[2008-1999]=D'2008.10.26 03:00:00';
      sum[2007-1999]=D'2007.03.25 02:00:00';win[2007-1999]=D'2007.10.28 03:00:00';
      sum[2006-1999]=D'2006.03.26 02:00:00';win[2006-1999]=D'2006.10.29 03:00:00';
      sum[2005-1999]=D'2005.03.27 02:00:00';win[2005-1999]=D'2005.10.30 03:00:00';
      sum[2004-1999]=D'2004.03.28 02:00:00';win[2004-1999]=D'2004.10.31 03:00:00';
      sum[2003-1999]=D'2003.03.30 02:00:00';win[2003-1999]=D'2003.10.26 03:00:00';
      sum[2002-1999]=D'2002.03.31 02:00:00';win[2002-1999]=D'2002.10.27 03:00:00';
      sum[2001-1999]=D'2001.03.25 02:00:00';win[2001-1999]=D'2001.10.28 03:00:00';
      sum[2000-1999]=D'2000.03.26 02:00:00';win[2000-1999]=D'2000.10.29 03:00:00';
      sum[1999-1999]=D'1999.03.28 02:00:00';win[1999-1999]=D'1999.10.31 03:00:00';
   }
   if(basketpercent){
      percentprofit=AccountBalance()*profit*0.01;
      percentloss=-1*AccountBalance()*loss*0.01;
   }
   if(Digits==3 || Digits==5){
      pt=Point*10;
      mt=10;
   }else{
      pt=Point;
      mt=1;
   }
   if(stop>0){
      stoploss=stop;
      takeprofit=stop;
   }
   if(mm){
      if(minlot>=1){lotsize=100000;}
      if(minlot<1){lotsize=10000;}
      if(minlot<0.1){lotsize=1000;}
   }
   return(0);
}

//+----------------------------------------------------------------------------+
//|  Start (called after each tick)                                            |
//+----------------------------------------------------------------------------+

int start(){




//+----------------------------------------------------------------------------+
//|  One time                                                                  |
//+----------------------------------------------------------------------------+

   bool onetime=true;
   if(onetimecalculation)if(time==Time[0])onetime=false;

//+----------------------------------------------------------------------------+
//|  Counters                                                                  |
//+----------------------------------------------------------------------------+

   if(closebasket || addpositions || onesideatatime || onecancelother || maxtrades<100 || multiplier!=1){
      totalbuy=count(OP_BUY);
      totalsell=count(OP_SELL);
      total=totalbuy+totalsell;
      if(closebasket){
         totalstopbuy=count(OP_BUYSTOP);
         totalstopsell=count(OP_SELLSTOP);
         totallimitbuy=count(OP_BUYLIMIT);
         totallimitsell=count(OP_SELLLIMIT);
      }
   }

//+----------------------------------------------------------------------------+
//|  Basket close                                                              |
//+----------------------------------------------------------------------------+

   if(closebasket)if(total+totalstopbuy+totalstopsell+totallimitbuy+totallimitsell>0){
      close(3);
      Delete(6);
   }
   if(closebasket)if(total+totalstopbuy+totalstopsell+totallimitbuy+totallimitsell==0)closebasket=false;
   if(closebasket)return(0);

//+----------------------------------------------------------------------------+
//|  Visualize the equity curve with the indicator vGrafBalance&Equity.mq4     |
//+----------------------------------------------------------------------------+

/*
   GlobalVariableSet("vGrafBalance",AccountBalance());
   GlobalVariableSet("vGrafEquity",AccountEquity());
*/

//+----------------------------------------------------------------------------+
//|  Break even, trailing, trailingstop and trailing profit                    |
//+----------------------------------------------------------------------------+

   if(breakevengain>0 && onetime)movebreakeven(breakevengain,breakeven);
   if(trailingstop>0 && onetime)movetrailingstop(trailingstart,trailingstop);
   if(trailing>0 && onetime)movetrailingstop(trailing,trailing);
   if(trailingprofit>0 && onetime)movetrailingprofit(trailingstart,trailingprofit);

//+----------------------------------------------------------------------------+
//|  Last open time, price and profits                                         |
//+----------------------------------------------------------------------------+

   if(basketpercent || basketdollars){
      buyorderprofit=0;
      sellorderprofit=0;
   }
   if(basketpips){
      buyorderpips=0;
      sellorderpips=0;
   }
   lastbuyopenprice=0;lastsellopenprice=0;

   if(OrdersTotal()>0){
      for(i=0;i<=OrdersTotal();i++){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderCloseTime()==0){
            if(OrderType()==OP_BUY){
               lastbuyopentime=OrderOpenTime();
               if(addpositions)lastbuyopenprice=OrderOpenPrice();
               if(basketpercent || basketdollars)buyorderprofit=buyorderprofit+OrderProfit();
               if(basketpips)buyorderpips=buyorderpips+OrderProfit()/(OrderLots()*10);
            }
            if(OrderType()==OP_SELL){
               lastsellopentime=OrderOpenTime();
               if(addpositions)lastsellopenprice=OrderOpenPrice();
               if(basketpercent || basketdollars)sellorderprofit=sellorderprofit+OrderProfit();
               if(basketpips)sellorderpips=sellorderpips+OrderProfit()/(OrderLots()*10);
            }
         }
      }
   }
   if(basketpercent || basketdollars)totalprofit=buyorderprofit+sellorderprofit;
   if(basketpips)totalpips=buyorderpips+sellorderpips;

//+----------------------------------------------------------------------------+
//|  Baskets                                                                   |
//+----------------------------------------------------------------------------+

   if(basketpercent)if((mm && totalprofit>=(AccountBalance()*profit*0.01)) || (mm==false && totalprofit>=percentprofit)
   || (mm && totalprofit<=(-1*AccountBalance()*loss*0.01))|| (mm==false && totalprofit<=percentloss)){
      closebasket=true;
   }
   if(basketpips)if((totalpips>=profitpips) || (totalpips<=(-1*losspips))){
      closebasket=true;
   }
   if(basketdollars)if(totalprofit>=dollars){
      closebasket=true;
   }
   if(closebasket)return(0);

//+----------------------------------------------------------------------------+
//|  Trades per bar                                                            |
//+----------------------------------------------------------------------------+

   if(tradesperbar==1){
      if(lastbuyopentime<Time[0])tpb=0;else tpb=1;
      if(lastsellopentime<Time[0])tps=0;else tps=1;
   }
   if(tradesperbar!=1 && bc!=Bars){tpb=0;tps=0;bc=Bars;}

//+----------------------------------------------------------------------------+
//|  Indicators calling                                                        |
//+----------------------------------------------------------------------------+

   if(onetime || shift==0){
      if(atrdynamics){
         double atr=iATR(NULL,atrtimeframe,atrperiod,shift);
      }
      if(highlowdynamics){
         double high=iHigh(NULL,hltimeframe,iHighest(NULL,0,MODE_HIGH,candles,1));
         double low=iLow(NULL,hltimeframe,iLowest(NULL,0,MODE_LOW,candles,1));
      }
      if(sdldynamics){
         int sdlbar1=0;
         for(i=0;i<=100;i++){
            if(sdlbar1!=0)continue;
            if(iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i)>
            iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+1)
            && iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+1)<
            iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+2))sdlbar1=i;
         }
         int sdlbar2=0;
         for(i=0;i<=100;i++){
            if(sdlbar2!=0)continue;
            if(iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i)<
            iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+1)
            && iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+1)>
            iCustom(NULL,sdltimeframe,"Slope Direction Line",sdlperiod,method,price,2,i+2))sdlbar2=i;
         }
      }
  
   
   
   double ma = iCustom(NULL, sdltimeframe, "super-signals-channel",SignalGap,ShowBars,dist,2, shift);
   double ma1 = iCustom(NULL, sdltimeframe, "super-signals-channel",SignalGap,ShowBars,dist,3, shift); 
   double kts=iCustom(NULL,0,"Kagi Trading System",Calc_Value,0,0);
   double kts1=iCustom(NULL,0,"Kagi Trading System",Calc_Value,1,0);

  

  
      int signal=0;
      if(ma1!=EMPTY_VALUE && kts!=EMPTY_VALUE ) signal=1;//
      if(ma!=EMPTY_VALUE && kts1!=EMPTY_VALUE ) signal=2;//
      

      if(atrdynamics){
         if(signal!=0 && slfactor!=0)stoploss=(atr/pt)*slfactor+slmargin;
         if(signal!=0 && tpfactor!=0)takeprofit=(atr/pt)*tpfactor+slmargin;
         if(signal!=0 && tstfactor!=0)trailingstart=(atr/pt)*tstfactor;
         if(signal!=0 && tsfactor!=0)trailingstop=(atr/pt)*tsfactor;
         if(signal!=0 && begfactor!=0)breakevengain=(atr/pt)*begfactor;
         if(signal!=0 && befactor!=0)breakeven=(atr/pt)*befactor;
         if(signal!=0 && psfactor!=0)pipstep=(atr/pt)*psfactor;
         if(signal!=0 && gfactor!=0)gap=(atr/pt)*gfactor;
      }
      if(highlowdynamics){
         if(signal==1 && slfactor!=0)stoploss=((Ask-low)/pt)*slfactor+slmargin;
         if(signal==1 && tpfactor!=0)takeprofit=((high-Bid)/pt)*tpfactor;
         if(signal==2 && slfactor!=0)stoploss=((high-Bid)/pt)*slfactor+slmargin;
         if(signal==2 && tpfactor!=0)takeprofit=((Ask-low)/pt)*tpfactor;
      }
      if(sdldynamics){
         if(signal==1 && slfactor!=0)stoploss=((Ask-Low[sdlbar1])/pt)*slfactor+slmargin;
         if(signal==1 && tpfactor!=0)takeprofit=((High[sdlbar2]-Bid)/pt)*tpfactor;
         if(signal==2 && slfactor!=0)stoploss=((High[sdlbar2]-Bid)/pt)*slfactor+slmargin;
         if(signal==2 && tpfactor!=0)takeprofit=((Ask-Low[sdlbar1])/pt)*tpfactor;
      }
      if(atrdynamics || highlowdynamics || sdldynamics){
         if(stoploss<stoplevel)stoploss=stoplevel;
         if(takeprofit<stoplevel)takeprofit=stoplevel;
      }

      //if(ma>0 && ma!=EMPTY_VALUE)signal=1;
   }

   //Comment("\nhau = "+DoubleToStr(hau,5),"\nhad = "+DoubleToStr(had,5));
   
//+----------------------------------------------------------------------------+
//|  Time filter                                                               |
//+----------------------------------------------------------------------------+

   bool isTradetime=true;
   if(usetimefilter)if(checktime())isTradetime=false;

//+----------------------------------------------------------------------------+
//|  Signals                                                                   |
//+----------------------------------------------------------------------------+

   bool buy=false;
   bool sell=false;
   


   bool barstatus=true;
   if(enteronopenbar)if(iVolume(NULL,0,0)>1)barstatus=false;

   bool buyaddstatus=true;bool selladdstatus=true;
   if(addpositions){
      if(totalbuy>0)buyaddstatus=false;
      if(totalsell>0)selladdstatus=false;
      if(totalbuy>0){if((addposmode==0 && Ask<=lastbuyopenprice-pipstep*pt*MathPow(pipstepfactor,totalbuy))
      || (addposmode==1 && Ask>=lastbuyopenprice+pipstep*pt*MathPow(pipstepfactor,totalbuy))
      && (eoobexceptaddpos || (eoobexceptaddpos==false && barstatus)))buy=true;}
      if(totalsell>0){if((addposmode==0 && Bid>=lastsellopenprice+pipstep*pt*MathPow(pipstepfactor,totalsell))
      || (addposmode==1 && Bid<=lastsellopenprice-pipstep*pt*MathPow(pipstepfactor,totalsell))
      && (eoobexceptaddpos || (eoobexceptaddpos==false && barstatus)))sell=true;}
   }
   
   bool buyside=true;bool sellside=true;
   if(onesideatatime){if(totalsell>0)buyside=false;if(totalbuy>0)sellside=false;}
   
   if(signal==1 && buyaddstatus && barstatus && buyside && continuebuy && isTradetime){
      if(reversesignals)sell=true;else buy=true;
      if(changedirection){continuebuy=false;continuesell=true;}
   }
   if(signal==2 && selladdstatus && barstatus && sellside && continuesell && isTradetime){
      if(reversesignals)buy=true;else sell=true;
      if(changedirection){continuebuy=true;continuesell=false;}
   }

//+----------------------------------------------------------------------------+
//|  Close and delete                                                          |
//+----------------------------------------------------------------------------+

   if(sell)if(oppositeclose)close(OP_BUY);
   if(buy)if(oppositeclose)close(OP_SELL);
   if(hidetp || hidesl){hideclose(OP_BUY);hideclose(OP_SELL);}
   if(usetimeout && onetime){closetime(OP_BUY);closetime(OP_SELL);}
   if(onecancelother){if(totalsell>0){Delete(OP_BUYSTOP);Delete(OP_BUYLIMIT);}if(totalbuy>0){Delete(OP_SELLSTOP);Delete(OP_SELLLIMIT);}}

//+----------------------------------------------------------------------------+
//|  Closed martingale                                                         |
//+----------------------------------------------------------------------------+

   if(martingale && !addpositions){
      /*lastbuylot=0;
      lastselllot=0;
      lastorder=0;*/

      if(OrdersHistoryTotal()>0){
         for(i=0;i<=OrdersHistoryTotal();i++){
            OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
               lastprofit=OrderProfit();
               lastlot=OrderLots();
               /*if(OrderType()==OP_BUY){
                  lastbuyprofit=OrderProfit();
                  lastbuylot=OrderLots();
                  lastorder=1;
               }
               if(OrderType()==OP_SELL){
                  lastsellprofit=OrderProfit();
                  lastselllot=OrderLots();
                  lastorder=2;
               }*/
            }
         }
      }
      mlots=0;
      if(lastprofit<0)mlots=lastlot*multiplier;else mlots=lots;
   }

//+----------------------------------------------------------------------------+
//|  Max spread, max trades                                                    |
//+----------------------------------------------------------------------------+

   if(maxspread!=0)if((Ask-Bid)>maxspread*mt*pt)return(0);
   if(maxtrades<100)if((total)>=maxtrades)return(0);

   if(mm)if(martingale==false || (martingale && !addpositions && lastprofit>=0) || (martingale && addpositions))lots=lotsoptimized();
   blots=lots;slots=lots;
   if(martingale){
      if(addpositions){blots=lots*MathPow(multiplier,totalbuy);slots=lots*MathPow(multiplier,totalsell);}
      else {blots=mlots;slots=mlots;}
   }

//+----------------------------------------------------------------------------+
//|  Instant and pending orders                                                |
//+----------------------------------------------------------------------------+

   if(buy && tpb<tradesperbar && !onlysell){
      ticket=0;number=0;expire=0;
      if(stoporders || limitorders)if(expiration>0)expire=TimeCurrent()+(expiration*60)-5;
      if(!ecn){
         if(instantorders){
            while(ticket<=0 && number<tries){
               while(!IsTradeAllowed())Sleep(5000);
               RefreshRates();ticket=open(OP_BUY,blots,Ask,stoploss,takeprofit,expire,Blue);
               if(ticket<0){if(useprint)Print("Error opening BUY order! ",errordescription(GetLastError()));number++;}
            }
         }
         if(stoporders)if(time2!=Time[0]){RefreshRates();ticket=open(OP_BUYSTOP,blots,Ask+gap*pt,stoploss,takeprofit,expire,Blue);time2=Time[0];}
         if(limitorders)if(time3!=Time[0]){RefreshRates();ticket=open(OP_BUYLIMIT,blots,Bid-gap*pt,stoploss,takeprofit,expire,Blue);time3=Time[0];}
      }
      if(ecn){
         if(instantorders){
            while(ticket<=0 && number<tries){
               while(!IsTradeAllowed())Sleep(5000);
               RefreshRates();ticket=open(OP_BUY,blots,Ask,0,0,expire,Blue);
               if(ticket<0){if(useprint)Print("Error opening BUY order! ",errordescription(GetLastError()));number++;}
            }
         }
         if(stoporders)if(time2!=Time[0]){RefreshRates();ticket=open(OP_BUYSTOP,blots,Ask+gap*pt,0,0,expire,Blue);time2=Time[0];}
         if(limitorders)if(time3!=Time[0]){RefreshRates();ticket=open(OP_BUYLIMIT,blots,Bid-gap*pt,0,0,expire,Blue);time3=Time[0];}
      }
      if(instantorders)if(ticket<=0){if(useprint)Print("Error Occured : "+errordescription(GetLastError()));}else tpb++;
   }
   if(sell && tps<tradesperbar && !onlybuy){
      ticket=0;number=0;expire=0;
      if(stoporders || limitorders)if(expiration>0)expire=TimeCurrent()+(expiration*60)-5;
      if(!ecn){
         if(instantorders){
            while(ticket<=0 && number<tries){
               while(!IsTradeAllowed())Sleep(5000);
               RefreshRates();ticket=open(OP_SELL,slots,Bid,stoploss,takeprofit,expire,Red);
               if(ticket<0){if(useprint)Print("Error opening BUY order! ",errordescription(GetLastError()));number++;}
            }
         }
         if(stoporders)if(time4!=Time[0]){RefreshRates();ticket=open(OP_SELLSTOP,slots,Bid-gap*pt,stoploss,takeprofit,expire,Red);time4=Time[0];}
         if(limitorders)if(time5!=Time[0]){RefreshRates();ticket=open(OP_SELLLIMIT,slots,Ask+gap*pt,stoploss,takeprofit,expire,Red);time5=Time[0];}
      }
      if(ecn){
         if(instantorders){
            while(ticket<=0 && number<tries){
               while(!IsTradeAllowed())Sleep(5000);
               RefreshRates();ticket=open(OP_SELL,slots,Bid,0,0,expire,Red);
               if(ticket<0){if(useprint)Print("Error opening BUY order! ",errordescription(GetLastError()));number++;}
            }
         }
         if(stoporders)if(time4!=Time[0]){RefreshRates();ticket=open(OP_SELLSTOP,slots,Bid-gap*pt,0,0,expire,Red);time4=Time[0];}
         if(limitorders)if(time5!=Time[0]){RefreshRates();ticket=open(OP_SELLLIMIT,slots,Ask+gap*pt,0,0,expire,Red);time5=Time[0];}
      }
      if(instantorders)if(ticket<=0){if(useprint)Print("Error Occured : "+errordescription(GetLastError()));}else tps++;
   }
   if(ecn)ecnmodify(stoploss,takeprofit);
   if(onetimecalculation)time=Time[0];
   return(0);
}

//+----------------------------------------------------------------------------+
//|  Open orders function                                                      |
//+----------------------------------------------------------------------------+

int open(int type,double _lots,double _price,double _sl,double _tp,int _expire,color clr){
   int _ticket=0;
   if(_lots<minlot)_lots=minlot;
   if(_lots>maxlot)_lots=maxlot;
   if(type==OP_BUY || type==OP_BUYSTOP || type==OP_BUYLIMIT){
      if(hidesl==false && _sl>0){_sl=_price-_sl*pt;}else{_sl=0;}
      if(hidetp==false && _tp>0){_tp=_price+_tp*pt;}else{_tp=0;}
   }
   if(type==OP_SELL || type==OP_SELLSTOP || type==OP_SELLLIMIT){
      if(hidesl==false && _sl>0){_sl=_price+_sl*pt;}else{_sl=0;}
      if(hidetp==false && _tp>0){_tp=_price-_tp*pt;}else{_tp=0;}
   }
   _ticket=OrderSend(Symbol(),type,NormalizeDouble(_lots,lotdigits),NormalizeDouble(_price,Digits),slippage*mt,sl,tp,
   comment+" "+DoubleToStr(magic,0),magic,_expire,clr);
   return(_ticket);
}

//+----------------------------------------------------------------------------+
//|  Lots optimized functions                                                  |
//+----------------------------------------------------------------------------+

double lotsoptimized(){
   double lot;
   if(stoploss>0)lot=AccountBalance()*(risk/100)/(stoploss*pt/MarketInfo(Symbol(),MODE_TICKSIZE)*MarketInfo(Symbol(),MODE_TICKVALUE));
   else lot=NormalizeDouble((AccountBalance()/lotsize)*minlot*risk,lotdigits);
   //lot=AccountFreeMargin()/(100.0*(NormalizeDouble(MarketInfo(Symbol(),MODE_MARGINREQUIRED),4)+5.0)/risk)-0.05;
   return(lot);
}

//+----------------------------------------------------------------------------+
//|  Time filter functions                                                     |
//+----------------------------------------------------------------------------+

bool checktime(){
   if(TimeCurrent()<win[TimeYear(TimeCurrent())-1999] && TimeCurrent()>sum[TimeYear(TimeCurrent())-1999])gmtshift=summergmtshift;
   else gmtshift=wintergmtshift;

   string svrdate=Year()+"."+Month()+"."+Day();

   if(mondayfilter){
      nmondayhour=mondayhour+(gmtshift);if(nmondayhour>23)nmondayhour=nmondayhour-24;
      if(nmondayhour<10)imondayhour="0"+nmondayhour;
      if(nmondayhour>9)imondayhour=nmondayhour;
      if(mondayminute<10)imondayminute="0"+mondayminute;
      if(mondayminute>9)imondayminute=mondayminute;
      tmonday=StrToTime(svrdate+" "+imondayhour+":"+imondayminute);
   }
   if(weekfilter){
      nstarthour=starthour+(gmtshift);if(nstarthour>23)nstarthour=nstarthour-24;
      if(nstarthour<10)istarthour="0"+nstarthour;
      if(nstarthour>9)istarthour=nstarthour;
      if(startminute<10)istartminute="0"+startminute;
      if(startminute>9)istartminute=startminute;
      tstart=StrToTime(svrdate+" "+istarthour+":"+istartminute);

      nendhour=endhour+(gmtshift);if(nendhour>23)nendhour=nendhour-24;
      if(endhour<10)iendhour="0"+nendhour;
      if(endhour>9)iendhour=nendhour;
      if(endminute<10)iendminute="0"+endminute;
      if(endminute>9)iendminute=endminute;
      tend=StrToTime(svrdate+" "+iendhour+":"+iendminute);
   }
   if(fridayfilter){
      nfridayhour=fridayhour+(gmtshift);if(nfridayhour>23)nfridayhour=nfridayhour-24;
      if(nfridayhour<10)ifridayhour="0"+nfridayhour;
      if(nfridayhour>9)ifridayhour=nfridayhour;
      if(fridayminute<10)ifridayminute="0"+fridayminute;
      if(fridayminute>9)ifridayminute=fridayminute;
      tfriday=StrToTime(svrdate+" "+ifridayhour+":"+ifridayminute);
   }
   if(newsfilter){
      nnewshour=newshour+(gmtshift);if(nnewshour>23)nnewshour=nnewshour-24;
      if(nnewshour<10)inewshour="0"+nnewshour;
      if(nnewshour>9)inewshour=nnewshour;
      if(newsminute<10)inewsminute="0"+newsminute;
      if(newsminute>9)inewsminute=newsminute;
      tnews=StrToTime(svrdate+" "+inewshour+":"+inewsminute);
   }
   if(weekfilter)if((nstarthour<=nendhour && TimeCurrent()<tstart || TimeCurrent()>tend) || (nstarthour>nendhour && TimeCurrent()<tstart && TimeCurrent()>tend))return(true);
   if(tradesunday==false)if(DayOfWeek()==0)return(true);
   if(fridayfilter)if(DayOfWeek()==5 && TimeCurrent()>tfriday)return(true);
   if(mondayfilter)if(DayOfWeek()==1 && TimeCurrent()<tmonday)return(true);
   if(newsfilter)if(TimeCurrent()>tnews-minutesbefore*60 && TimeCurrent()<tnews+minutesafter*60)return(true);
   return(false);
}

//+----------------------------------------------------------------------------+
//|  Counter                                                                   |
//+----------------------------------------------------------------------------+

int count(int type){
   cnt=0;
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderType()==type && OrderMagicNumber()==magic)cnt++;
      }
      return(cnt);
   }
}

//+----------------------------------------------------------------------------+
//|  Close functions                                                           |
//+----------------------------------------------------------------------------+

void close(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal()-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt);
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt);
            }
         }
         if(type==3){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==OP_BUY){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage*mt);
            }
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==OP_SELL){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage*mt);
            }
         }
      }
   }
}

void hideclose(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal()-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic
            && (hidesl && stoploss>0 && OrderProfit()<=(-1)*stoploss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt)
            || (hidetp && takeprofit>0 && OrderProfit()>=takeprofit*OrderLots()*10)){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),Bid,slippage*mt);
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic
            && (hidesl && stoploss>0 && OrderProfit()<=(-1)*stoploss*OrderLots()*10-MarketInfo(Symbol(),MODE_SPREAD)*OrderLots()*10/mt)
            || (hidetp && takeprofit>0 && OrderProfit()>=takeprofit*OrderLots()*10)){
               RefreshRates();
               OrderClose(OrderTicket(),OrderLots(),Ask,slippage*mt);
            }
         }
      }
   }
}

void closetime(int type){
   tradeprofit=0;
   tradetime=0;
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type==OP_BUY && OrderType()==OP_BUY){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){ 
               tradeprofit=NormalizeDouble(OrderClosePrice()-OrderOpenPrice(),Digits);
               tradetime=TimeCurrent()-OrderOpenTime();
               if((tradeprofit>=target1*pt &&  tradetime>timeout1*60 && tradetime<timeout2*60)
               || (tradeprofit>=target2*pt &&  tradetime>timeout2*60 && tradetime<timeout3*60)
               || (tradeprofit>=target3*pt &&  tradetime>timeout3*60 && tradetime<timeout4*60)
               || (tradeprofit>=target4*pt &&  tradetime>timeout4*60 && tradetime<timeout5*60)
               || (tradeprofit>=target5*pt &&  tradetime>timeout5*60 && tradetime<timeout6*60)
               || (tradeprofit>=target6*pt &&  tradetime>timeout6*60 && tradetime<timeout7*60)
               || (tradeprofit>=target7*pt &&  tradetime>timeout7*60)){
                  RefreshRates();
                  OrderClose(OrderTicket(),OrderLots(),Bid,slippage*mt);
               }
            }
         }
         if(type==OP_SELL && OrderType()==OP_SELL){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){ 
               tradeprofit=NormalizeDouble(OrderClosePrice()-OrderOpenPrice(),Digits);
               tradetime=TimeCurrent()-OrderOpenTime();
               if((tradeprofit>=target1*pt &&  tradetime>timeout1*60 && tradetime<timeout2*60)
               || (tradeprofit>=target2*pt &&  tradetime>timeout2*60 && tradetime<timeout3*60)
               || (tradeprofit>=target3*pt &&  tradetime>timeout3*60 && tradetime<timeout4*60)
               || (tradeprofit>=target4*pt &&  tradetime>timeout4*60 && tradetime<timeout5*60)
               || (tradeprofit>=target5*pt &&  tradetime>timeout5*60 && tradetime<timeout6*60)
               || (tradeprofit>=target6*pt &&  tradetime>timeout6*60 && tradetime<timeout7*60)
               || (tradeprofit>=target7*pt &&  tradetime>timeout7*60)){
                  RefreshRates();
                  OrderClose(OrderTicket(),OrderLots(),Ask,slippage*mt);
               }
            }
         }
      }
   }
}

void Delete(int type){
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(type!=6){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==type){
               OrderDelete(OrderTicket());
            }
         }
         if(type==6){
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP
            || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)){
               OrderDelete(OrderTicket());
            }
         }   
      }
   }
}

//+----------------------------------------------------------------------------+
//|  Modifications functions                                                   |
//+----------------------------------------------------------------------------+

void movebreakeven(double _breakevengain,double _breakeven){
   RefreshRates();
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble((Bid-OrderOpenPrice()),Digits)>=NormalizeDouble(_breakevengain*pt,Digits)){
                  if((NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),Digits)<NormalizeDouble(_breakeven*pt,Digits)) || OrderStopLoss()==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+_breakeven*pt,Digits),OrderTakeProfit(),0,Blue);
                     return;
                  }
               }
            }
            else{
               if(NormalizeDouble((OrderOpenPrice()-Ask),Digits)>=NormalizeDouble(_breakevengain*pt,Digits)){
                  if((NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),Digits)<NormalizeDouble(_breakeven*pt,Digits)) || OrderStopLoss()==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-_breakeven*pt,Digits),OrderTakeProfit(),0,Red);
                     return;
                  }
               }
            }
         }
      }
   }
}

void movetrailingstop(double _trailingstart,double _trailingstop){
   RefreshRates();
   if(OrdersTotal()>0){
      for(i=OrdersTotal();i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble(Ask,Digits)>NormalizeDouble(OrderOpenPrice()+_trailingstart*pt,Digits)
               && NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-(_trailingstop+trailingstep)*pt,Digits)){
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-_trailingstop*pt,Digits),OrderTakeProfit(),0,Blue);
                  return;
               }
            }
            else{
               if(NormalizeDouble(Bid,Digits)<NormalizeDouble(OrderOpenPrice()-_trailingstart*pt,Digits)
               && (NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+(_trailingstop+trailingstep)*pt,Digits)) || OrderStopLoss()==0)){                 
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+_trailingstop*pt,Digits),OrderTakeProfit(),0,Red);
                  return;
               }
            }
         }
      }
   }
}

void movetrailingprofit(double _trailingstart,double _trailingprofit){
   RefreshRates();
   for(i=OrdersTotal();i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)<=NormalizeDouble((-1)*_trailingstart*pt,Digits)){
                  if(NormalizeDouble(OrderTakeProfit(),Digits)>NormalizeDouble(Bid+(_trailingprofit+trailingstep)*pt,Digits)
                  || NormalizeDouble(OrderTakeProfit(),Digits)==0){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Bid+_trailingprofit*pt,Digits),0,Blue);
                  }
               }
            }
            if(OrderType()==OP_SELL){
               if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)<=NormalizeDouble((-1)*_trailingstart*pt,Digits)){
                  if(NormalizeDouble(OrderTakeProfit(),Digits)<NormalizeDouble(Ask-(_trailingprofit+trailingstep)*pt,Digits)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Ask-_trailingprofit*pt,Digits),0,Red);
                  }
               }
            }
         }
      }
   }
}

void ecnmodify(double _stoploss,double _takeprofit){
   for(i=OrdersTotal();i>=0;i--){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic){
         if(OrderType()==OP_BUY){
            if(OrderStopLoss()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-_stoploss*pt,Digits),OrderTakeProfit(),0,Red);
            }
            if(OrderTakeProfit()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Ask+_takeprofit*pt,Digits),0,Red);
            }
         }
         if(OrderType()==OP_SELL){
            if(OrderStopLoss()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+_stoploss*pt,Digits),OrderTakeProfit(),0,Red);
            }
            if(OrderTakeProfit()==0){
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(Bid-_takeprofit*pt,Digits),0,Red);
            }
         }
      }
   }
}

//+----------------------------------------------------------------------------+
//|  Error functions                                                           |
//+----------------------------------------------------------------------------+

string errordescription(int code){
   string error;
   switch(code){
      case 0:
      case 1:error="no error";break;
      case 2:error="common error";break;
      case 3:error="invalid trade parameters";break;
      case 4:error="trade server is busy";break;
      case 5:error="old version of the client terminal";break;
      case 6:error="no connection with trade server";break;
      case 7:error="not enough rights";break;
      case 8:error="too frequent requests";break;
      case 9:error="malfunctional trade operation";break;
      case 64:error="account disabled";break;
      case 65:error="invalid account";break;
      case 128:error="trade timeout";break;
      case 129:error="invalid price";break;
      case 130:error="invalid stops";break;
      case 131:error="invalid trade volume";break;
      case 132:error="market is closed";break;
      case 133:error="trade is disabled";break;
      case 134:error="not enough money";break;
      case 135:error="price changed";break;
      case 136:error="off quotes";break;
      case 137:error="broker is busy";break;
      case 138:error="requote";break;
      case 139:error="order is locked";break;
      case 140:error="long positions only allowed";break;
      case 141:error="too many requests";break;
      case 145:error="modification denied because order too close to market";break;
      case 146:error="trade context is busy";break;
      case 4000:error="no error";break;
      case 4001:error="wrong function pointer";break;
      case 4002:error="array index is out of range";break;
      case 4003:error="no memory for function call stack";break;
      case 4004:error="recursive stack overflow";break;
      case 4005:error="not enough stack for parameter";break;
      case 4006:error="no memory for parameter string";break;
      case 4007:error="no memory for temp string";break;
      case 4008:error="not initialized string";break;
      case 4009:error="not initialized string in array";break;
      case 4010:error="no memory for array\' string";break;
      case 4011:error="too long string";break;
      case 4012:error="remainder from zero divide";break;
      case 4013:error="zero divide";break;
      case 4014:error="unknown command";break;
      case 4015:error="wrong jump (never generated error)";break;
      case 4016:error="not initialized array";break;
      case 4017:error="dll calls are not allowed";break;
      case 4018:error="cannot load library";break;
      case 4019:error="cannot call function";break;
      case 4020:error="expert function calls are not allowed";break;
      case 4021:error="not enough memory for temp string returned from function";break;
      case 4022:error="system is busy (never generated error)";break;
      case 4050:error="invalid function parameters count";break;
      case 4051:error="invalid function parameter value";break;
      case 4052:error="string function internal error";break;
      case 4053:error="some array error";break;
      case 4054:error="incorrect series array using";break;
      case 4055:error="custom indicator error";break;
      case 4056:error="arrays are incompatible";break;
      case 4057:error="global variables processing error";break;
      case 4058:error="global variable not found";break;
      case 4059:error="function is not allowed in testing mode";break;
      case 4060:error="function is not confirmed";break;
      case 4061:error="send mail error";break;
      case 4062:error="string parameter expected";break;
      case 4063:error="integer parameter expected";break;
      case 4064:error="double parameter expected";break;
      case 4065:error="array as parameter expected";break;
      case 4066:error="requested history data in update state";break;
      case 4099:error="end of file";break;
      case 4100:error="some file error";break;
      case 4101:error="wrong file name";break;
      case 4102:error="too many opened files";break;
      case 4103:error="cannot open file";break;
      case 4104:error="incompatible access to a file";break;
      case 4105:error="no order selected";break;
      case 4106:error="unknown symbol";break;
      case 4107:error="invalid price parameter for trade function";break;
      case 4108:error="invalid ticket";break;
      case 4109:error="trade is not allowed";break;
      case 4110:error="longs are not allowed";break;
      case 4111:error="shorts are not allowed";break;
      case 4200:error="object is already exist";break;
      case 4201:error="unknown object property";break;
      case 4202:error="object is not exist";break;
      case 4203:error="unknown object type";break;
      case 4204:error="no object name";break;
      case 4205:error="object coordinates error";break;
      case 4206:error="no specified subwindow";break;
      default:error="unknown error";
   }
   return(error);
}
/*
iCustom(NULL,0,"StepMA_v7",Length,Kv,StepSize,0,shift);

iAC(NULL,0,shift);
iAD(NULL,0,shift);
iADX(NULL,0,adxperiod,PRICE_CLOSE,MODE_PLUSDI,shift);
iAlligator(NULL,0,jawsperiod,teethperiod,lipsperiod,jawsshift,teethshift,lipsshift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,shift);
iAO(NULL,0,shift);
iATR(NULL,0,atrperiod,shift);
iBands(NULL,0,bbperiod,2,0,PRICE_CLOSE,MODE_LOWER,shift);
iBearsPower(NULL,0,13,PRICE_CLOSE,0);
iBullsPower(NULL,0,13,PRICE_CLOSE,0);
iCCI(NULL,0,cciperiod,PRICE_CLOSE,shift);
iClose(NULL,PERIOD_H1,shift);
iDeMarker(NULL,0,14,shift);
iEnvelopes(NULL,0,13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,shift);
iForce(NULL,0,13,MODE_SMA,PRICE_CLOSE,shift);
iFractals(NULL,0,MODE_UPPER,3);
High[iHighest(NULL,0,MODE_HIGH,candles,1)];
iMA(NULL,0,maperiod,0,MODE_SMA,PRICE_CLOSE,shift);
iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,shift);
iMFI(NULL,0,MFIPeriod,shift);
iMomentum(NULL,0,momentumperiod,PRICE_CLOSE,shift);
iOBV(NULL,0,PRICE_CLOSE,shift);
iOsMA(NULL,0,fastema,slowema,macdsma,PRICE_CLOSE,shift);
iRSI(NULL,0,rsiperiod,PRICE_CLOSE,shift);
iRVI(NULL,0,10,MODE_MAIN,shift);
iSAR(NULL,0,step,maximum,shift);
iStdDev(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,shift);
iStochastic(NULL,0,kperiod,dperiod,slowing,MODE_SMA,0,MODE_MAIN,shift);
iStochastic(NULL,0,kperiod,dperiod,slowing,MODE_SMA,0,MODE_SIGNAL,shift);
iWPR(NULL,0,WPRPeriod,shift);
*/

