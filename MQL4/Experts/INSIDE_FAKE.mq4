//+------------------------------------------------------------------+
//|                                                         FAKE.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>
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
CTrade trade;

input int magic = 65438; //Magic
input int sl    = 10;    //Сдвиг стоплоса
input string tp = "4/2"; //Соотношение тейкпрофита к стоплосу
input cents risk = 20;
input int offset = 20;     //Мин. пробитие (п)
input bool useTral = true; //Tral

string botName = "FAKE";
int mtp;
datetime cTime[];
datetime pTime;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
   pTime = 0;
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
   CopyTime(Symbol(), PERIOD_CURRENT, 0, 1, cTime);
   if(pTime == cTime[0])
      return;
   pTime = cTime[0];
   
   int s = Signal();
   static int dir = -1;
   switch(s){
      case 0:
         if(Total(0) == 0 || dir == 1)Alert(Symbol()+"  BUY\nPrice: "+DoubleToString(NormalizeDouble(Ask,Digits()))+"\nSL: "+DoubleToString(SL(0))+"\nTP: "+DoubleToString(TP(0)));//trade.Buy(Symbol(), Autolot(), SL(0), TP(0), botName);
         dir = 0;
         break;
      case 1:
         if(Total(1) == 0 || dir == 0)Alert(Symbol()+"  SELL\nPrice: "+DoubleToString(NormalizeDouble(Bid,Digits()))+"\nSL: "+DoubleToString(SL(1))+"\nTP: "+DoubleToString(TP(1)));//trade.Sell(Symbol(), Autolot(), SL(1), TP(1), botName);
         dir = 1;
         break;
   }
   if(useTral)
      Tral();
}
//+------------------------------------------------------------------+

int Signal(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 4, rates);
   if(ArraySize(rates) < 4)
      return -1;
   ArraySetAsSeries(rates, true);
   
   double level1[4] = {};
   double level2[4] = {};
   double level3[4] = {};
   double level4[4] = {};
   
   for(int i = 0; i < 4; i++){
      level1[i] = rates[i].high;
      level4[i] = rates[i].low;
      if(rates[i].close > rates[i].open){
         level2[i] = rates[i].close;
         level3[i] = rates[i].open;
      }
      else{
         level2[i] = rates[i].open;       
         level3[i] = rates[i].close;
      }
   }
   
   if(level1[2] >= level1[1] && level4[2] <= level4[1] && level2[2] >= level2[1] && level3[2] <= level3[1]){
      if(level1[0] > level1[2] + NormalizeDouble(offset*mtp*Point(), Digits()) && rates[0].close < level2[2])
         return 1;
      if(level4[0] < level4[2] - NormalizeDouble(offset*mtp*Point(), Digits()) && rates[0].close > level3[2])
         return 0;
   }
   
   if(level1[3] >= level1[2] && level4[3] <= level4[2] && level2[3] >= level2[2] && level3[3] <= level3[2]){
      if(level1[0] > level1[3] + NormalizeDouble(offset*mtp*Point(), Digits()) && rates[0].close < level2[3])
         return 1;
      if(level4[0] < level1[3] - NormalizeDouble(offset*mtp*Point(), Digits()) && rates[0].close > level3[3])
         return 0;
   }
   return -1;   
}

int Total(int dir = -1){
   int count = 0;
   if(OrdersTotal() != 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__,"  ",GetLastError());
            return count;
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == dir){
            count++;
         }
      }
   }
   int k = 0;
   return count;
}

double SL(int dir = -1){
   if(dir == -1)
      return 0.0;
      
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 1, rates);
   if(ArraySize(rates) < 1)
      return 0.0;
      
   switch(dir){
      case 0:
         return NormalizeDouble(rates[0].low - sl*Point()*mtp, Digits());
      case 1:
         return NormalizeDouble(rates[0].high + sl*Point()*mtp, Digits());
   }
   return 0.0;
}

double TP(int dir = -1){
   if(dir == -1)
      return 0.0;
      
   MqlRates rates[];
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 2, rates);
   if(ArraySize(rates) < 2)
      return 0.0;
   
   int n = StringFind(tp, "/");
   
   if(n <= 0)
      return 0.0;
   
   string t = StringSubstr(tp, 0, n);
   string s = StringSubstr(tp, n+1);
   
   int _t = (int)StringToInteger(t);
   int _s = (int)StringToInteger(s);
   
   
   
   double _tp = 0.0;
   
   switch(dir){
      case 0:
         _tp = (tick.ask - (rates[1].low - NormalizeDouble(sl*Point()*mtp, Digits())))/_s*_t;
         return NormalizeDouble(tick.ask  + _tp, Digits());
         break;
      case 1:
         _tp = ((rates[1].high + NormalizeDouble(sl*Point()*mtp, Digits()))- tick.bid)/_s*_t;
         return NormalizeDouble(tick.bid - _tp, Digits());
         break;
   }
   return 0.0;
} 

void Tral(){
   if(OrdersTotal() == 0)
      return;
      
   
   static double buyTral = 0.0;
   static double sellTral = 0.0;
   
   if(Total(0) == 0)
      buyTral = 0.0;
   if(Total(1) == 0)
      sellTral = 0.0;
   
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            if(buyTral == 0.0) buyTral = OrderOpenPrice() - OrderStopLoss();
            trade.TralPoints(OrderTicket(), buyTral);
         }
         if(OrderType() == OP_SELL){
            if(sellTral == 0.0) sellTral = OrderStopLoss() - OrderOpenPrice();
            trade.TralPoints(OrderTicket(), sellTral);
         }
      }
   }   
}

double Autolot(){
   double vol = AccountEquity()/100*risk / 2000;
   if(vol < MarketInfo(Symbol(), MODE_MINLOT))
      vol = MarketInfo(Symbol(), MODE_MINLOT);
   if(vol > MarketInfo(Symbol(), MODE_MAXLOT))
      vol = MarketInfo(Symbol(), MODE_MAXLOT);
   return vol;
}