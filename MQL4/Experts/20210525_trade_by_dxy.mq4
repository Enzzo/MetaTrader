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

input int      MAGIC          = 981939;
input string   SYMBOLS        = "AUDUSD EURUSD USDJPY GBPUSD";
input string   DELIM          = " ";
input string   BASE           = "_DXY";
input string   OPEN_SESSION   = "14:00";
input string   CLOSE_SESSION  = "20:00";

CTrade trade;

struct order{
   string symbol;
   int ticket;
   bool is_open;
   bool reverse;
   int signal;
};

string symbols[];
order orders[];

void SplitIntoSymbols(const string&, string& [], const string&);
void FillSymbols(const string& [], order& []);
const bool SessionIsOpen();
const short Signal(const string&);

datetime current[];
datetime prev = 0;

//DEBUG
template <typename T>
void ShowArray(const T&[]);
void ShowTime(const MqlDateTime&);
const string ITS(const int);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(MAGIC);
   SplitIntoSymbols(SYMBOLS, symbols, DELIM);
   
   FillSymbols(symbols, orders);
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
   
   
   //ПРОВЕРЯЕМ СИГНАЛ ПО БАЗЕ
   const short base = Signal(BASE);
   
   //ПРОБЕГАЕМСЯ ПО ВСЕМ ОРДЕРАМ
   for(int i = 0; i < ArraySize(orders); ++i){
      short signal = Signal(orders[i].symbol);
      
      if(orders[i].reverse) orders[i].signal = -signal;
      
      if(OrderSelect(orders[i].ticket, SELECT_BY_TICKET)){
         //if(OrderType() == OP_BUY && (base != 0 
      }
      
      //ищем открытие
      else{
         if(SessionIsOpen()){
            
         }
      }
   }
}
//+------------------------------------------------------------------+

//query - строка, которую надо разделить
//delim - символ разделителя
void SplitIntoSymbols(const string& query, string& to[], const string& delim){
   
   int begin = 0;
   int end;
   int step = StringLen(delim);
   
   while(true){
      end = StringFind(query, delim, begin);
      const int size = ArraySize(to) + 1;
      
      if(end != -1){
         ArrayResize(to, size);
         to[size-1] = StringSubstr(query, begin, end - begin);
         begin = end + step;
      }
      else{
         //заполнить последний кусок строки (если он валидный) и выйти
         ArrayResize(to, size);
         to[size-1] = StringSubstr(query, begin, StringLen(query));
         return;
      }
   }
}

const bool SessionIsOpen(){

   MqlDateTime t;
   TimeLocal(t);
   
   const datetime hour = TimeLocal();
   const int day = t.day_of_week;
   const datetime open = StringToTime(OPEN_SESSION);
   const datetime close = StringToTime(CLOSE_SESSION);
      
   return (day > 1 && day < 5 && hour >= open && hour < close);
}

void FillSymbols(const string& from[], order& to[]){
   
   const int size = ArraySize(from);
   ArrayResize(to, size);
   
   for(int i = 0; i < size; ++i){
      to[i].symbol = from[i];
      if(StringFind(from[i], "USD") == 0){
         to[i].reverse = false;
      }
      else{
         to[i].reverse = true;
      }
   }
}

const short Signal(const string& symbol){
   const double d_10_1 = iMA(symbol, PERIOD_D1, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double d_10_2 = iMA(symbol, PERIOD_D1, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   const double d_5_1  = iMA(symbol, PERIOD_D1, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double d_5_2  = iMA(symbol, PERIOD_D1, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   const double h_10_1 = iMA(symbol, PERIOD_H1, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_10_2 = iMA(symbol, PERIOD_H1, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   const double h_5_1  = iMA(symbol, PERIOD_H1, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(symbol, PERIOD_H1, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   
   //buy
   if(d_5_2 < d_5_1 && d_10_2 < d_10_1 && d_10_1 < d_5_1 && d_10_2 < d_5_2 && 
      h_5_2 < h_5_1 && h_10_2 < h_10_1 && h_10_1 < h_5_1 && h_10_2 < h_5_2){
      return 1;
   }
   
   //sell
   if(d_5_2 > d_5_1 && d_10_2 > d_10_1 && d_10_1 > d_5_1 && d_10_2 > d_5_2 && 
      h_5_2 > h_5_1 && h_10_2 > h_10_1 && h_10_1 > h_5_1 && h_10_2 > h_5_2){
      return -1;
   }
   
   return 0;
}

//DEBUG
template <typename T>
void ShowArray(const T& array[]){
   for(int i = 0; i < ArraySize(array); ++i){
      Print(array[i]);
   }
}

void ShowMqlDateTime(const MqlDateTime& t){
   Comment("Day of week: "+ITS(t.day_of_week)+"\nYear: "+ITS(t.year)+"\nMon: "+ITS(t.mon)+"\nDay: "+ITS(t.day)+"\ntime: "+ITS(t.hour)+":"+ITS(t.min)+":"+ITS(t.sec));
}

const string ITS(const int i){
   return IntegerToString(i);
}