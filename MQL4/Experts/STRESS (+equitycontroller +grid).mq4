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

enum Types{
   stops,      //STOPS
   limits,     //LIMITS
   both        //BOTH
};

enum MAPosition{
   none,       //нет
   against,    //против направления
   ondir       //по направлению 
};

input int magic = 45123; //Magic
input ushort stopOffset = 10; //Oтступ стоповика от текущей цены
input int TP = 40;   //TP
input int SL = 40;   //SL
input int OTS = 10;  //Order tral step
input int be = 10;   //Безубыток
input int tral = 20; //tral step
input double prof = 1.0;//Профит выхода из просадки
input bool auto = true; //Автолот от риска
input double volume = 0.01; //lot
input cents risk = 2;  //риск для автолота
input bool autoclose = true;//автозакрытие по профиту
input cents prft = 5;//Профит
input cents loss = 20;//Просадка
input MAPosition pos = none;  //Использовать МА
input int MAperiod = 100;     //МА период
input int MAshift = 0;        //МА сдвиг
Types type = stops;//Типы ордеров
string botName = "IMPULSE (+equitycontroller +grid)";
int mtp;
ushort mode;
double avrCnd;
int bars = 2;
int bar  = 1;
enum dir{unknown, bull, bear};
double HA_body[];
double HA_upperTail[];
double HA_lowerTail[];
double HA_open[];
double HA_close[];
double HA_high[];
double HA_low[];
dir HA_direction[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   mode = 1;
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
   //for(ushort i = 0; i <= 1; i++){//Mode1(i);
   /*mode = GetMode();
   switch(mode){
      case 1:Mode1();break;
      case 2:Mode2();break;
      default:mode = 1;
   }*/
   //}

   Mode1();
   Mode2();
   //Signal();
   if(!CheckEquity() && autoclose)
      trade.CloseTrades();
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

double AutoLot(double v){
   double vol;
   if(!auto)return v;
   vol = AccountEquity()/100*risk / 2000;
   if(vol < MarketInfo(Symbol(), MODE_MINLOT))
      vol = MarketInfo(Symbol(), MODE_MINLOT);
   if(vol > MarketInfo(Symbol(), MODE_MAXLOT))
      vol = MarketInfo(Symbol(), MODE_MAXLOT);
   return vol;
}

double MartinLot(){
   double vol = volume;
   if(OrdersTotal() > 0){
      bool x = false;
      for(int i = OrdersTotal() - 1; i>= 0; i--){
         x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)){
            if(OrderProfit() < 0.0)vol = OrderLots()*2;
            break;
         }
      }
   }
   if(vol < MarketInfo(Symbol(), MODE_MINLOT))
      vol = MarketInfo(Symbol(), MODE_MINLOT);
   if(vol > MarketInfo(Symbol(), MODE_MAXLOT))
      vol = MarketInfo(Symbol(), MODE_MAXLOT);
   return vol;
}

short Signal(){
   double st3 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_EMA, 0, MODE_MAIN, 3);
   double st2 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_EMA, 0, MODE_MAIN, 2);
   double st1 = iStochastic(Symbol(), PERIOD_CURRENT, 14, 3, 3, MODE_EMA, 0, MODE_MAIN, 1);
   
   double upblue1 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 0, 1);
   double upblue2 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 0, 2);
   double upblue3 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 0, 3);
   double yellow1 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 1, 1);
   double yellow2 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 1, 2);
   double yellow3 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 1, 3);
   double dnblue1 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 2, 1);
   double dnblue2 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 2, 2);
   double dnblue3 = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 2, 3);
   double green1  = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 3, 1);
   double green2  = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 3, 2);
   double green3  = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 3, 3);
   double red1    = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 4, 1);
   double red2    = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 4, 2);
   double red3    = iCustom(Symbol(), PERIOD_CURRENT, "TDI_RT alerts + divergence", 4, 3);
   double HAclose = iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",0, 1);
   double HAopen  = iCustom(Symbol(), PERIOD_CURRENT, "Heiken_ashi_NK",1, 1);
   
   if(HAclose > HAopen){
      trade.CloseSell();
      trade.DeleteType(OP_SELLSTOP);
   }
   else if(HAopen > HAclose){
      trade.CloseBuy();
      trade.DeleteType(OP_BUYSTOP);
   }
   
   if(st1 > 80 && st2 > 80 && st3 > 80){
      if(green3 < red3 && green1 > red1 && green3 > yellow3 && green2 > yellow2 && red1 > yellow1 && HAopen < HAclose)
         return 0;
   }
   
   if(st1 < 20 && st2 < 20 && st3 < 20){
      if(green3 > red3 && green1 < red1 && green3 < yellow3 && green2 < yellow2 && red1 < yellow1 && HAopen > HAclose)
         return 1;
   }
   return -1;
}

ushort GetMode(){
   if(OrdersTotal() == 0)return 1;
   double profit = 0.0;
   bool x = false;
   for(int i = OrdersTotal(); i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      
   }
   if(profit >= 0.0 && (Total(OP_BUYSTOP) == 1 || Total(OP_SELLSTOP) == 1))return 1;
   else return 2;
}

void Mode1(){
   short s = Signal();   
   switch(s){
      case 0:if(Total(OP_BUYSTOP) == 0 && (type == stops || type == both))trade.BuyStop(Symbol(), AutoLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
             //if(Total(OP_SELLLIMIT) == 0 && (type == limits || type == both))trade.SellLimit(Symbol(), AutoLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
      case 1:if(Total(OP_SELLSTOP) == 0 && (type == stops || type == both))trade.SellStop(Symbol(), AutoLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
             //if(Total(OP_BUYLIMIT) == 0 &&(type == limits || type == both))trade.BuyLimit(Symbol(), AutoLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
   }
   TralOrders();
   TralStops();
}

void Mode2(){
   if(CalculateAverageCandle()){
      BuildGrid();
      TakeProfit();
   }
}


bool CalculateAverageCandle(){
   double count = 0.;
   MqlRates rates[];
   RefreshRates();
   
   int b = 100;

   CopyRates(Symbol(), PERIOD_CURRENT, 1, b - 1, rates);
   if(ArraySize(rates) == 0){
      return false;
   }
  
   for(int i = 0; i < ArraySize(rates); i++){
      count += (rates[i].high - rates[i].low);
   }
   
   avrCnd = NormalizeDouble((count/ArraySize(rates)), Digits());
   return true;
}

void BuildGrid(){
   if(Total()>20)
      return;
   double price = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(OrderType() == OP_BUY){
            if(Ask < (OrderOpenPrice() - avrCnd*5))trade.Buy(Symbol(), OrderLots()*1, 0, 0, botName);
            return;         
         }
         if(OrderType() == OP_SELL){
            if(Bid > (OrderOpenPrice() + avrCnd*5))trade.Sell(Symbol(), OrderLots()*1, 0, 0, botName);
            return;
         }
      }
   }
}

void TakeProfit(){
   if(autoclose)return;
   if(OrdersTotal() == 0)return;
   double profit = 0.0;
   double lot = 0.0;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
         lot = OrderLots();
      }     
   }
   if(profit > prof*lot/MarketInfo(Symbol(), MODE_MINLOT)){
      trade.CloseTrades();
   }
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

short CheckMA(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 4, rates);
   
   if(ArraySize(rates)<4)
      return -1;
   
   switch(pos){
      case 0:return 0;  //Если не использовать МА, то возвращает 0
      case 1:           //Если против направления, то 1 - для покупки, 2 - для продажи
         if(rates[1].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1) &&
            rates[2].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 2) &&
            rates[3].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 3))
            return 1;
         if(rates[1].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1) &&
            rates[2].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 2) &&
            rates[3].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 3))
            return 2;
         break;
      case 2:
         if(rates[1].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1) &&
            rates[2].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 2) &&
            rates[3].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 3))
            return 2;   //Если по направлению, то 1 - для покупки, 2 - для продажи
         if(rates[1].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1) &&
            rates[2].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 2) &&
            rates[3].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 3))
            return 1;
         break;
   }   
   return -1;
}