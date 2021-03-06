//+------------------------------------------------------------------+
//|                                                   eaWeekTick.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

enum days{
   //d0,      //Воскресенье
   d1 = 1,      //Понедельник
   d2,      //Вторник
   d3,      //Среда
   d4,      //Четверг
   d5,      //Пятница
   d6       //Суббота
};

input int         magic       = 565623;   //Magic
input string      oSession    = "11:25";  //Часы начала торговли (+11 GMT)
input string      cSession    = "13:00";  //Часы авершения торговли (+11 GMT)

input days        day1        = d2;       //День выставления позиций 
input days        day2        = d5;       //День закрытия позиций

input int         offset      = 50;       //сдвиг ордеров от закрытия предыдущего дня
input int         sl          = 60;       //Стоплос

input double      volume      = 0.01;     //Объем
input double      k           = 2.0;      //коэф. мартин

string botName = WindowExpertName();
int mtp;
int day;
MqlDateTime GMT;
string string_day = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(botName);  
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10; 
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   static ushort n = 0;
   TimeLocal(GMT); 
   day = GMT.day_of_week;
   
   switch(day){
      case 0: string_day = "Воскресенье";break;
      case 1: string_day = "Понедельник";break;
      case 2: string_day = "Вторник";    break;
      case 3: string_day = "Среда";      break;
      case 4: string_day = "Четверг";    break;
      case 5: string_day = "Пятница";    break;
      case 6: string_day = "Суббота";    break;
   };
   Comment("Текущее время ",GMT.hour,":",GMT.min,"\n",string_day);
   StringToTime(oSession);
   
   short total = Total();
   
   if(day == day1 && TimeLocal() >= StringToTime(oSession) && total == 0 && n == 0){
      if(Send())n = 1;
   }
   else if(day >= day2 && TimeLocal() >= StringToTime(cSession)){
      n = 0;
      if(total > 0){
         trade.CloseTrades();
         trade.DeletePendings();
      }
   }
   Trade();
}

bool Send(){
   MqlRates D1Rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1, 0, 1, D1Rates);
   if(ArraySize(D1Rates)<1)return false; 
   ArraySetAsSeries(D1Rates, true);
   
   if(trade.BuyStop(Symbol(), Martin(), NormalizeDouble(D1Rates[0].open+offset*mtp*Point(), Digits()), 0, 0) &&
      trade.SellStop(Symbol(), Martin(), NormalizeDouble(D1Rates[0].open-offset*mtp*Point(), Digits()), 0, 0))return true;
   return false;
}

void Trade(){
   int t = -1;
   int p = -1;
   for(int i = OrdersTotal() - 1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            t = OrderType();
            if(OrderStopLoss() == 0.0 && sl > 0.0)
               x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()-sl*mtp*Point(), Digits), OrderTakeProfit(), 0);
         }
         else if(OrderType() == OP_SELL){
            t = OrderType();
            if(OrderStopLoss() == 0.0 && sl > 0.0)
               x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice()+sl*mtp*Point(), Digits), OrderTakeProfit(), 0);
         }
         else if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
            p = OrderTicket();
      }
   }  
   if(p != -1 && t != -1)trade.DeletePending(p);
}

short Total(short t = -1){
   if(OrdersTotal() == 0)
      return 0;
   bool x = false;
   short count = 0;
   for(int i = OrdersTotal() - 1; i>= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(t == -1 || OrderType() == t)count++;
      }
   }
   return count;
}

double Martin(){
   if(OrdersHistoryTotal()>0){
      for(int i = OrdersHistoryTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               if(OrderProfit()<0.0)return OrderLots()*k;
               else return volume;
            }
         }
      }
   }
   return volume;
}