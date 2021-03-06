//+------------------------------------------------------------------+
//|                                        20210525_trade_by_dxy.mq4 |
//|                                                   Sergey_Vasilev |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Sergey_Vasilev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <trade.mqh>

input int               MAGIC          = 981939;
input string            OPEN_SESSION   = "9:00";
input string            CLOSE_SESSION  = "20:00";
input double            RISK           = .5;
input ENUM_TIMEFRAMES   SL_PERIOD      = PERIOD_H1;
input ENUM_TIMEFRAMES   SIGNAL_PERIOD  = PERIOD_H1;

CTrade trade;

bool reverse = true;
const string base = "_DXY";
const string sym = Symbol();
ENUM_ORDER_TYPE order;

datetime current[];
datetime prev = 0;
MqlTick tk;

const string ITS(const int);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(MAGIC);
   trade.SetExpertComment("TEST");
   
   if(StringFind(sym, "USD") == 0){
      reverse = false;
   }
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   Comment("");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   //КАЖДЫЙ ЧАС
   CopyTime(base, SIGNAL_PERIOD, 1, 1, current);
   if(current[0] == prev){
      return;
   }
   prev = current[0];
   /////////////////////////////////////////  
   order = CheckOrder();
   
   if (order != -1){
      /*
      if(order != SubSignal(base, reverse)){
         CloseOrder(order);
      }
      else{
         trade.TralCandles();
      }
      */
      Tral();
   }
   //else{
      if(SessionIsOpen()){
         ENUM_ORDER_TYPE signal = Signal(base, reverse);
         //order = Signal(base, reverse);
         if(order != signal){
            RefreshRates();
            SymbolInfoTick(sym, tk);
            const double spr = MarketInfo(sym, MODE_SPREAD); 
            const double offset = iATR(sym, SL_PERIOD, 14, 1); 
            
            if(signal == OP_BUY){
               const double sl = tk.bid-offset;
               const int pts = (int)((tk.bid-sl)/Point());
               trade.Buy(sym, AutoLot(RISK, pts), sl, 0.0, 5, TimeToString(TimeCurrent())+"_"+DoubleToString(spr, 1));
            }
            else if(signal == OP_SELL){
               const double sl = tk.ask+offset;
               const int pts = (int)((sl-tk.ask)/Point());
               trade.Sell(sym, AutoLot(RISK, pts), sl, 0.0, 5, TimeToString(TimeCurrent())+"_"+DoubleToString(spr, 1));
            }
         }         
      }
   //}
}
//+------------------------------------------------------------------+

void Tral(){
   int mtp = (Digits() == 5 || Digits() == 3)?10:1;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == MAGIC && OrderSymbol() == sym){
         
         const int type          = OrderType();
         const double stoploss   = OrderStopLoss();
         const double openprice  = OrderOpenPrice();
         const int ticket        = OrderTicket();
         const double takeprofit = OrderTakeProfit();
         
         MqlRates rates[];
         CopyRates(sym, SL_PERIOD, 1, 1, rates);
         const double h = NormalizeDouble(rates[0].high, Digits());
         const double l = NormalizeDouble(rates[0].low, Digits());    
              
         if(type == OP_BUY && stoploss < l && l < Bid)
            x = OrderModify(ticket, openprice, l, takeprofit, OrderExpiration());
         if(type == OP_SELL && stoploss != 0.0 && stoploss > h && h > Ask)
            x = OrderModify(ticket, openprice, h, takeprofit, OrderExpiration());
      }
   }
}

ENUM_ORDER_TYPE CheckOrder(){
   const int total = OrdersTotal();
   for(int i = total -1; i >= 0; --i){
      if(OrderSelect(i, SELECT_BY_POS)){
         if(OrderSymbol() == Symbol()){
            if(OrderMagicNumber() == MAGIC){                  
               return (ENUM_ORDER_TYPE)OrderType();
            }
         }
      }
   }
   return -1;
}

void CloseOrder(const ENUM_ORDER_TYPE& o){
   if(o == OP_BUY){
      trade.CloseBuy();
   }
   else if(o == OP_SELL){
      trade.CloseSell();
   }
}

const bool SessionIsOpen(){

   MqlDateTime tl;
   TimeCurrent(tl);
   
   const datetime hour  = TimeCurrent();
   const int      day   = tl.day_of_week;
   const datetime open  = StringToTime(OPEN_SESSION);
   const datetime close = StringToTime(CLOSE_SESSION);
   
   return (day > 1 && day < 5 && hour >= open && hour < close);
}


const ENUM_ORDER_TYPE Signal(const string& s, const bool rev = false){
   const double h_10_1 = iMA(s, SIGNAL_PERIOD, 50, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_10_2 = iMA(s, SIGNAL_PERIOD, 50, 0, MODE_SMA, PRICE_MEDIAN, 2);
   
   const double h_5_0  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 0);
   const double h_5_1  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   //buy
   if(h_5_2 < h_5_1 && h_5_1 < h_5_0 && h_10_2 < h_10_1 && h_10_1 < h_5_1 && h_10_2 < h_5_2){
      if(rev){
         return OP_SELL;
      }
      else{
         return OP_BUY;
      }
   }
   
   //sell
   if(h_5_2 > h_5_1 && h_5_1 > h_5_0 && h_10_2 > h_10_1 && h_10_1 > h_5_1 && h_10_2 > h_5_2){
      if(rev){
         return OP_BUY;
      }
      else{
         return OP_SELL;
      }
   }
   
   return -1;
}

//Упрощённые условия.
//Разработан для выхода из сделки
//Замеряет младшие периоды и таймфреймы
const ENUM_ORDER_TYPE SubSignal(const string& s, const bool rev = false){
   
   const double h_5_0  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 0);
   const double h_5_1  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(s, SIGNAL_PERIOD, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);   
   
   //buy
   if(h_5_2 < h_5_1 && h_5_1 < h_5_0){
      if(rev){
         return OP_SELL;
      }
      else{
         return OP_BUY;
      }
   }
   
   //sell
   if(h_5_2 > h_5_1 && h_5_1 > h_5_0){
      if(rev){
         return OP_BUY;
      }
      else{
         return OP_SELL;
      }
   }
   
   return -1;
}

//+------------------------------------------------------------------+
//r - риск %, p - пункты до стоплосса
const double AutoLot(const double r, const int p){
   double l = MarketInfo(Symbol(), MODE_MINLOT);
   double tv = MarketInfo(Symbol(), MODE_TICKVALUE);
   double div = p*tv;
   
   if(div != 0.0 && r != 0.0){
      l = NormalizeDouble((AccountBalance()/100*r/div), 2);
   }
   else{
      return -1;
   }
   
   if(l > MarketInfo(Symbol(), MODE_MAXLOT))l = MarketInfo(Symbol(), MODE_MAXLOT);
   if(l < MarketInfo(Symbol(), MODE_MINLOT))l = MarketInfo(Symbol(), MODE_MINLOT);
   return l;
}

const string ITS(const int i){
   return IntegerToString(i);
}