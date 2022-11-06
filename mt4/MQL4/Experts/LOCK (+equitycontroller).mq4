//+------------------------------------------------------------------+
//|                                                      IMPULSE.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <Trade.mqh>

CTrade trade;

enum cents{
   _1 = 1,  //  1%
   _2,      //  2%
   _3,      //  3%
   _4,      //  4%
   _5,      //  5%
   _6,      //  6%
   _7,      //  7%
   _8,      //  8%
   _9,      //  9%
   _10,     // 10%
   _11,     // 11%
   _12,     // 12%
   _13,     // 13%
   _14,     // 14%
   _15,     // 15%
   _16,     // 16%
   _17,     // 17%
   _18,     // 18%
   _19,     // 19%
   _20,     // 20%
   _21,     // 21%
   _22,     // 22%
   _23,     // 23%
   _24,     // 24%
   _25,     // 25%
   _26,     // 26%
   _27,     // 27%
   _28,     // 28%
   _29,     // 29%
   _30,     // 30%
   _31,     // 31%
   _32,     // 32%
   _33,     // 33%
   _34,     // 34%
   _35,     // 35%
   _36,     // 36%
   _37,     // 37%
   _38,     // 38%
   _39,     // 39%
   _40,     // 40%
   _41,     // 41%
   _42,     // 42%
   _43,     // 43%
   _44,     // 44%
   _45,     // 45%
   _46,     // 46%
   _47,     // 47%
   _48,     // 48%
   _49,     // 49%
   _50,     // 50%
   _51,     // 51%
   _52,     // 52%
   _53,     // 53%
   _54,     // 54%
   _55,     // 55%
   _56,     // 56%
   _57,     // 57%
   _58,     // 58%
   _59,     // 59%
   _60,     // 60%
   _61,     // 61%
   _62,     // 62%
   _63,     // 63%
   _64,     // 64%
   _65,     // 65%
   _66,     // 66%
   _67,     // 67%
   _68,     // 68%
   _69,     // 69%
   _70,     // 70%
   _71,     // 71%
   _72,     // 72%
   _73,     // 73%
   _74,     // 74%
   _75,     // 75%
   _76,     // 76%
   _77,     // 77%
   _78,     // 78%
   _79,     // 79%
   _80,     // 80%
   _81,     // 81%
   _82,     // 82%
   _83,     // 83%
   _84,     // 84%
   _85,     // 85%
   _86,     // 86%
   _87,     // 87%
   _88,     // 88%
   _89,     // 89%
   _90,     // 90%
   _91,     // 91%
   _92,     // 92%
   _93,     // 93%
   _94,     // 94%
   _95,     // 95%
   _96,     // 96%
   _97,     // 97%
   _98,     // 98%
   _99,     // 99%
   _100     //100%
};

enum days{
   //d0,      //Воскресенье
   d1 = 1,      //Понедельник
   d2,      //Вторник
   d3,      //Среда
   d4,      //Четверг
   d5,      //Пятница
   d6       //Суббота
};


input int magic = 45123; //Magic
input string      oSession    = "11:25";     //Открытие сессии
input string      cSession    = "13:00";     //Закрытие сессии

input days        day1        = d1;       //Начало торговли
input days        day2        = d5;       //Завершение торговли
input ushort stopOffset = 10; //Oтступ стоповика от текущей цены
input int TP = 40;   //TP
input int SL = 40;   //SL
input int OTS = 10;  //Order tral step
input int be = 10;   //Безубыток
input int tral = 20; //tral step
input double volume = 0.01; //lot
input cents risk = 20;  //риск для автолота
input bool autoclose = true;//автозакрытие по профиту
input cents prft = 5;//Профит
input cents loss = 20;//Просадка

string botName = "LOCK (+equitycontroller)";
int mtp;
int day;
MqlDateTime GMT;
string string_day = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   trade.SetExpertMagic(magic);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(!CheckEquity() && autoclose)
      trade.CloseTrades();

      
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
   
   Comment("Текущее время ",GMT.hour,":",GMT.min < 10 ? "0"+IntegerToString(GMT.min) : IntegerToString(GMT.min),"\n",string_day);
   StringToTime(oSession);
   
   if((day >= day1 && day <= day2) && (TimeLocal() >= StringToTime(oSession) &&  TimeLocal() < StringToTime(cSession))){
      
      if(Total(OP_BUYSTOP) == 0)trade.BuyStop(Symbol(), MartinLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);
      if(Total(OP_SELLSTOP) == 0)trade.SellStop(Symbol(), MartinLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);
   //if(Total(OP_BUYLIMIT) == 0 && (type == limits || type == both))trade.BuyLimit(Symbol(), MartinLot(volume), NormalizeDouble(Ask - stopOffset*mtp*Point(), Digits()), SL, TP, botName);
   //if(Total(OP_SELLLIMIT) == 0 && (type == limits || type == both))trade.SellLimit(Symbol(), MartinLot(volume), NormalizeDouble(Bid + stopOffset*mtp*Point(), Digits()), SL, TP, botName);
   }
   TralOrders();
   TralStops();
}
//+------------------------------------------------------------------+

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

void TralOrders(){
   if(OrdersTotal() == 0)
      return;
   bool x = false;

   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYSTOP  && OrderOpenPrice() > NormalizeDouble(Ask + OTS * mtp * Point() + stopOffset * mtp * Point(), Digits()))
            x = OrderModify(OrderTicket(), NormalizeDouble(Ask+stopOffset*mtp*Point(), Digits()), SL == 0 ? 0.0 : NormalizeDouble(Ask+stopOffset*mtp*Point()-SL*mtp*Point(), Digits()), TP == 0 ? 0.0 : NormalizeDouble(Ask + stopOffset*mtp*Point() + TP*mtp*Point(), Digits()), OrderExpiration());

         if(OrderType() == OP_SELLSTOP && OrderOpenPrice() < NormalizeDouble(Bid - OTS * mtp * Point() - stopOffset * mtp * Point(), Digits()))
            x = OrderModify(OrderTicket(), NormalizeDouble(Bid-stopOffset*mtp*Point(), Digits()), SL == 0 ? 0.0 : NormalizeDouble(Bid- stopOffset*mtp*Point()+SL*mtp*Point(), Digits()), TP == 0 ? 0.0 : NormalizeDouble(Bid - stopOffset*mtp*Point() - TP*mtp*Point(), Digits()), OrderExpiration());
      }
   }
}
void TralStops(){
   if(OrdersTotal() == 0)
      return;
   bool x = false;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderStopLoss() != 0.0)trade.TralPoints(OrderTicket(), tral);
         else trade.Breakeven(OrderTicket(), be);         
      }
   }
}


double MartinLot(double v){
   double vol = AccountEquity()/100*risk / 2000;
   if(vol < MarketInfo(Symbol(), MODE_MINLOT))
      vol = MarketInfo(Symbol(), MODE_MINLOT);
   if(vol > MarketInfo(Symbol(), MODE_MAXLOT))
      vol = MarketInfo(Symbol(), MODE_MAXLOT);
   return vol;
   /*return v;
   if(OrdersHistoryTotal() == 0)
      return v;
   bool x = false;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderProfit() < 0.0)
            v= OrderLots()*2;
         break;
      }   
   }
   if(v < MarketInfo(Symbol(), MODE_MINLOT))
      v = MarketInfo(Symbol(), MODE_MINLOT);
   if(v > MarketInfo(Symbol(), MODE_MAXLOT))
      v = MarketInfo(Symbol(), MODE_MAXLOT);
   return v;*/
}

bool CheckEquity(){
   if(OrdersTotal() == 0)
      return true;
      
   static double balance = 0.0;
   //Print("Balance = ",balance);
   static double pr = 0.0;
   static double ls = 0.0;
   if(balance == 0.0){
      balance = AccountBalance();
      pr = NormalizeDouble(balance/100*prft, Digits());
      ls = NormalizeDouble(balance/100*loss*(-1), Digits());
   }
   if(pr == 0.0 || ls == 0.0)
      return true;
   bool x = false;
   double p = 0.0;
   /*for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         p += NormalizeDouble(OrderProfit(), Digits());
      }
   }*/
   p = AccountEquity() - balance;
   
   if(p >= pr || p <= ls){
      balance = 0.0;
      pr = 0.0;
      ls = 0.0;
      return false;
   }
   
   return true;
}