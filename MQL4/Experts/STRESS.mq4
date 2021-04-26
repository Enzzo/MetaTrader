//+------------------------------------------------------------------+
//|                                                       STRESS.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;
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

string botName = "STRESS";

input int magic = 1234545123; //Magic
input double volume = 0.01;      //lot
input int SL = 0;
input int TP = 0;
int OnInit(){
   trade.SetExpertMagic(magic);
   ArrayResize(HA_body, bars);
   ArrayResize(HA_upperTail, bars);
   ArrayResize(HA_lowerTail, bars);
   ArrayResize(HA_open, bars+1);
   ArrayResize(HA_close, bars+1);
   ArrayResize(HA_high, bars);
   ArrayResize(HA_low, bars);
   ArrayResize(HA_direction, bars);
   
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
   
}
void OnTick(){
   if(!CalculateHAPatterns())
      return;      
   Start();
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

void Start(){
   short s = Signal();
   switch(s){
      case 0:if(Total(OP_BUY) == 0)trade.Buy(Symbol(), volume, SL, TP, botName);break;
      case 1:if(Total(OP_SELL) == 0)trade.Sell(Symbol(), volume, SL, TP, botName);break;
   }
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

bool CalculateHAPatterns(){
   MqlRates rates[];   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 0, bars, rates);
   
   ArraySetAsSeries(rates,          true);
   ArraySetAsSeries(HA_body,        true);
   ArraySetAsSeries(HA_upperTail,   true);
   ArraySetAsSeries(HA_lowerTail,   true);
   ArraySetAsSeries(HA_open,        true);
   ArraySetAsSeries(HA_close,       true);
   ArraySetAsSeries(HA_high,        true);
   ArraySetAsSeries(HA_low,         true);
   ArraySetAsSeries(HA_direction,   true);
 
   if(ArraySize(rates) < bars)
      return false;
   
   if(HA_open[bar+1] == 0.0)
      HA_open[bar+1] = rates[bar].open;
   
   HA_close[bar+1] = NormalizeDouble((rates[bar].open + rates[bar].close + rates[bar].high + rates[bar].low)/4, Digits());
   
   for(int i = bar; i >= 0; i--){
      
      //H1      
      HA_close[i]= NormalizeDouble((rates[i].open + rates[i].close + rates[i].high + rates[i].low)/4, Digits());
      HA_open[i] = NormalizeDouble((HA_open[i+1] + HA_close[i+1])/2, Digits());
      HA_high[i] = NormalizeDouble(Max(HA_open[i], HA_close[i], rates[i].high), Digits());
      HA_low[i]  = NormalizeDouble(Min(HA_open[i], HA_close[i], rates[i].low), Digits());
      
      
      if(HA_open[i] < HA_close[i]){
         HA_body[i] = NormalizeDouble(HA_close[i] - HA_open[i], Digits());
         HA_upperTail[i] = NormalizeDouble(HA_high[i] - HA_close[i], Digits());
         HA_lowerTail[i] = NormalizeDouble(HA_open[i] - HA_low[i], Digits());
         HA_direction[i] = bull;
      }
      else{
         HA_body[i] = NormalizeDouble(HA_open[i] - HA_close[i], Digits());
         HA_upperTail[i] = NormalizeDouble(HA_high[i] - HA_open[i], Digits());
         HA_lowerTail[i] = NormalizeDouble(HA_close[i] - HA_low[i], Digits());
         HA_direction[i] = bear;
      }
   }   
   return true;
}

double Min(double o, double c, double l){
   double min = o;
   if(min > c)
      min = c;
   if(min > l)
      min = l;
   return min;
}

double Max(double o, double c, double h){
   double max = o;
   if(max < c)
      max = c;
   if(max < h)
      max = h;
   return max;
}