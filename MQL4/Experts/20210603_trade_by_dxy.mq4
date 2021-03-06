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

input int      MAGIC          = 985939;
input string   OPEN_SESSION   = "06:00";
input string   CLOSE_SESSION  = "20:00";
input double   RISK           = 1;

CTrade trade;

bool reverse = true;
const string base = "_DXY";
const string sym = Symbol();

const bool SessionIsOpen();
const short Signal(const string&, const ENUM_TIMEFRAMES, const bool);
const double AutoLot(const double, const int);

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
   /*
   //КАЖДЫЙ ЧАС
   CopyTime(BASE, PERIOD_H1, 1, 1, current);
   if(current[0] == prev){
      return;
   }
   prev = current[0];
   /////////////////////////////////////////  
   */
   //ПРОБЕГАЕМСЯ ПО ВСЕМ ОРДЕРАМ
   //ПРОВЕРЯЕМ СИГНАЛ ПО БАЗЕ И ПОДСТРАИВАЕМ ЕГО ПОД ТОРГУЕМЫЙ ИНСТРУМЕНТ ПРИ ПОМОЩИ reverse 
   short base_signal = MicroSignal(base, PERIOD_M1, reverse);   
   bool is_open = false;
   
   //Проверяем сигнал на инструменте
   //const short signal = Signal(sym);
   short signal = base_signal;
   const double spr = MarketInfo(sym, MODE_SPREAD);
   
   if(signal != -1){
      const int total = OrdersTotal();
      for(int i = total -1; i >= 0; --i){
         if(OrderSelect(i, SELECT_BY_POS)){
            if(OrderSymbol() == sym){
               if(OrderMagicNumber() == MAGIC){
                  //Если сигнал направление машек не соответствует направлению сделки и профит отрицательный, то НЕ закрываем ордер
                  if(OrderType() != signal){
                               
                     RefreshRates();                  
                     SymbolInfoTick(sym, tk);
                     const double close_price = (OrderType() == OP_BUY)?tk.bid:tk.ask;                  
                     bool x = OrderClose(OrderTicket(), OrderLots(), close_price, 3);
                  }
                  else{
                     is_open = true;                   
                  }
                  break;
               }
            }
         }
      }
   }
   //ищем открытие
   base_signal = Signal(base, PERIOD_H1, reverse);
   signal = MicroSignal(base, PERIOD_M1, reverse);
   
   if(SessionIsOpen() && !is_open && signal != -1 && signal == base_signal){
      RefreshRates();
      SymbolInfoTick(sym, tk);
      const double offset = iATR(sym, PERIOD_H1, 14, 1);      
      
      if(signal == 0){   
         const double sl = tk.bid-offset;
         const int pts = (int)((tk.bid-sl)/Point());
         trade.Buy(sym, AutoLot(RISK, pts), sl, 0.0, 5, TimeToString(TimeCurrent())+"_"+DoubleToString(spr, 1));
      }
      else if(signal == 1){
         const double sl = tk.ask+offset;
         const int pts = (int)((sl-tk.ask)/Point());
         trade.Sell(sym, AutoLot(RISK, pts), sl, 0.0, 5, TimeToString(TimeCurrent())+"_"+DoubleToString(spr, 1));
      }
   }
}
//+------------------------------------------------------------------+

const bool SessionIsOpen(){

   MqlDateTime tl;
   TimeCurrent(tl);
   
   const datetime hour  = TimeCurrent();
   const int      day   = tl.day_of_week;
   const datetime open  = StringToTime(OPEN_SESSION);
   const datetime close = StringToTime(CLOSE_SESSION);
   
   return (day >= 1 && day < 5 && hour >= open && hour < close);
}


const short Signal(const string& s, const ENUM_TIMEFRAMES p = PERIOD_H1, const bool rev = false){
   const double h_10_1 = iMA(s, p, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_10_2 = iMA(s, p, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   
   const double h_5_0  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 0);
   const double h_5_1  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);   
   
   //buy
   if(h_5_2 < h_5_1 && h_5_1 < h_5_0){// && h_10_2 < h_10_1 && h_10_1 < h_5_1 && h_10_2 < h_5_2){
      if(rev){
         return 1;
      }
      else{
         return 0;
      }
   }
   
   //sell
   if(h_5_2 > h_5_1 && h_5_1 > h_5_0){// && h_10_2 > h_10_1 && h_10_1 > h_5_1 && h_10_2 > h_5_2){
      if(rev){
         return 0;
      }
      else{
         return 1;
      }
   }
   
   return -1;
}

//Упрощённые условия.
//Разработан для выхода из сделки
//Замеряет младшие периоды и таймфреймы
const short MicroSignal(const string& s, const ENUM_TIMEFRAMES p = PERIOD_H1,const bool rev = false){
   
   const double h_5_0  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 0);
   const double h_5_1  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(s, p, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);   
   
   //buy
   if(h_5_2 < h_5_1 && h_5_1 < h_5_0){
      if(rev){
         return 1;
      }
      else{
         return 0;
      }
   }
   
   //sell
   if(h_5_2 > h_5_1 && h_5_1 > h_5_0){
      if(rev){
         return 0;
      }
      else{
         return 1;
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