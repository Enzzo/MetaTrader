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
input string   SYMBOLS        = "AUDUSD EURUSD USDCHF NZDUSD XAUUSD USDCAD USDJPY";
input string   DELIM          = " ";
input string   BASE           = "_DXY";
input string   OPEN_SESSION   = "01:00";
input string   CLOSE_SESSION  = "23:00";

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
const double AutoLot(const string&, const double, const int);

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
   trade.SetExpertComment("TEST");
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
   //ПРОБЕГАЕМСЯ ПО ВСЕМ ОРДЕРАМ
   for(int i = 0; i < ArraySize(orders); ++i){
      
      //ПРОВЕРЯЕМ СИГНАЛ ПО БАЗЕ
      short base = BaseSignal(BASE);
      
      orders[i].is_open = false;
      orders[i].ticket = 0;
      
      //Проверяем сигнал на инструменте
      const short signal = Signal(orders[i].symbol);
      
      //сигналы между базой и символом должны быть в одном направлении
      //если символ реверсивный, то меняем знак у базы
      if(orders[i].reverse) base *= -1;
      
      const int total = OrdersTotal();
      for(int j = total -1; j >= 0; --j){
         if(OrderSelect(j, SELECT_BY_POS)){
            if(OrderSymbol() == orders[i].symbol){
               if(OrderMagicNumber() == MAGIC){
                  if((OrderType() == OP_BUY && signal != 1) ||
                  (OrderType() == OP_SELL && signal != -1)){
                  //if(signal != base || base == 0){
                     //закрывать по рыночной цене ask или bid                     
                     
                     RefreshRates();
                     MqlTick tick;
                     SymbolInfoTick(orders[i].symbol, tick);
                     
                     const double close_price = (OrderType() == OP_BUY)?tick.bid:tick.ask;
                     
                     bool x = OrderClose(OrderTicket(), OrderLots(), close_price, 3);
                  }
                  else{
                     orders[i].is_open = true;
                     orders[i].ticket = OrderTicket();                     
                  }
                  break;
               }
            }
         }
      }
      
      //ищем открытие
      if(SessionIsOpen()){
         if(!orders[i].is_open){
            if(signal != 0){// == base){
               MqlTick tick;
               SymbolInfoTick(orders[i].symbol, tick);
               
               if(signal == 1){   
                  int index = iLowest(orders[i].symbol, PERIOD_M1, MODE_LOW, 48, 0);
                  const double sl = iLow(orders[i].symbol, PERIOD_M1, index);
                  const int pts = (int)((tick.ask-sl)/Point());
                  trade.Buy(orders[i].symbol, AutoLot(orders[i].symbol, .1, pts), sl);
               }
               else if(signal == -1){
                  int index = iHighest(orders[i].symbol, PERIOD_M1, MODE_HIGH, 48, 0);
                  const double sl = iHigh(orders[i].symbol, PERIOD_M1, index);
                  const int pts = (int)((sl-tick.bid)/Point());
                  trade.Sell(orders[i].symbol, AutoLot(orders[i].symbol, .1, pts), sl);
               }
            }
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

const short BaseSignal(const string& symbol){
   const double d_10_1 = iMA(symbol, PERIOD_D1, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double d_10_2 = iMA(symbol, PERIOD_D1, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   const double d_5_1  = iMA(symbol, PERIOD_D1, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double d_5_2  = iMA(symbol, PERIOD_D1, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   const double h_10_1 = iMA(symbol, PERIOD_M1, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_10_2 = iMA(symbol, PERIOD_M1, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   const double h_5_1  = iMA(symbol, PERIOD_M1, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(symbol, PERIOD_M1, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   
   //buy
   if(//d_5_2 < d_5_1 && d_10_2 < d_10_1 && d_10_1 < d_5_1 && d_10_2 < d_5_2 && 
      h_5_2 < h_5_1){// && h_10_2 < h_10_1 && h_10_1 < h_5_1 && h_10_2 < h_5_2){
      return 1;
   }
   
   //sell
   if(//d_5_2 > d_5_1 && d_10_2 > d_10_1 && d_10_1 > d_5_1 && d_10_2 > d_5_2 && 
      h_5_2 > h_5_1){// && h_10_2 > h_10_1 && h_10_1 > h_5_1 && h_10_2 > h_5_2){
      return -1;
   }
   
   return 0;
}

const short Signal(const string& symbol){
   const double h_10_1 = iMA(symbol, PERIOD_M1, 10, 0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_10_2 = iMA(symbol, PERIOD_M1, 10, 0, MODE_SMA, PRICE_MEDIAN, 2);
   const double h_5_1  = iMA(symbol, PERIOD_M1, 5,  0, MODE_SMA, PRICE_MEDIAN, 1);
   const double h_5_2  = iMA(symbol, PERIOD_M1, 5,  0, MODE_SMA, PRICE_MEDIAN, 2);
   
   //buy
   if(h_5_2 < h_5_1){// && h_10_2 < h_10_1 && h_10_1 < h_5_1 && h_10_2 < h_5_2){
      return 1;
   }
   
   //sell
   if(h_5_2 > h_5_1){// && h_10_2 > h_10_1 && h_10_1 > h_5_1 && h_10_2 > h_5_2){
      return -1;
   }
   
   return 0;
}

//+------------------------------------------------------------------+
//r - риск %, p - пункты до стоплосса
const double AutoLot(const string& s, const double r, const int p){
   double l = MarketInfo(s, MODE_MINLOT);
   //Print(s);
   //Print(p);
   double div = p*MarketInfo(s, MODE_TICKVALUE);
   if(div != 0.0 && r != 0.0){
      l = NormalizeDouble((AccountBalance()/100*r/div), 2);
   }
   else{
      Alert(s+"  div = "+div);
      return -1;
   }
   
   if(l > MarketInfo(s, MODE_MAXLOT))l = MarketInfo(s, MODE_MAXLOT);
   if(l < MarketInfo(s, MODE_MINLOT))l = MarketInfo(s, MODE_MINLOT);
   Alert(s+"  Lot: "+l);
   return l;
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