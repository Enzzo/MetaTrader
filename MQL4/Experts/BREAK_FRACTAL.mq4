//+------------------------------------------------------------------+
//|                                                BREAK_FRACTAL.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property description "На пробитии сформированного фрактала"
#property description "выставляет ордер в направлении пробития"

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

enum eTypes{
   breakdown,  //на пробой фрактала
   rebound     //на отбой от фрактала
};

input int               magic    = 23111981;       //Magic
input ENUM_TIMEFRAMES   tf       = PERIOD_CURRENT; //Timeframe
input double            volume   = 0.01;           //Volume
input int               TP       = 40;             //TP (points)
input int               SL       = 40;             //SL (points)
input eTypes            type     = breakdown;      //Сигнал
input ushort            fractal  = 5;              //Bars to calculate the fractal(odd, since 3)
input bool              useAuto  = true;           //Автолот
input cents             risk     = 3;              //Риск
input bool              useMrtn  = true;           //Use Martin
input double            k        = 2.0;            //коэффициент мартина
input int               offset   = 10;             //Breakthrough fractal (points)
input bool              tral     = true;           //Tral
input int               tralStep = 10;             //Tral Step (points)
input int               tralStop = 50;             //Tral Stop (points)
input bool              drawFrac = true;           //Отрисовывать фракталы

int mtp;

int OnInit(){
//---
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
      
   if(fractal < 3 || fractal%2 == 0){
      Alert("Неверное количество баров для рассчета фрактала.\nМинимальное количество баров = 3\nКоличество должно быть нечетным\nСоветник не работает!!! Заданное количество: "+IntegerToString(fractal));
      return -1;
   }
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   for(int i = ObjectsTotal()-1; i>=0; i--){
      if(StringFind(ObjectName(0, i, 0),"FRACTAL",0)!=-1)ObjectDelete(0, ObjectName(0, i, 0));
   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   static datetime time = 0;
   if(time == Time[0])return;
   time = Time[0];
   
   if(fractal < 3 || fractal%2 == 0){
      return;
   }
   Trade();
   if(tral)trade.TralPointsGeneral(tralStep, tralStop);
}
//+------------------------------------------------------------------+

void Trade(){
   double upper = Fractal(1, fractal);
   double lower = Fractal(2, fractal);
   static double up = 0.0;
   static double dn = 0.0;
   if(upper != 0.0)up = upper;
   if(lower != 0.0)dn = lower;
   
   if(up > 0.0){
      if(type == breakdown && Ask > up+NormalizeDouble(offset*mtp*Point(), Digits())){
         up = 0.0;
         trade.Buy(Symbol(), AutoLot(), SL, TP);
      }
      if(type == rebound && Bid > up+NormalizeDouble(offset*mtp*Point(), Digits())){
         up = 0.0;
         trade.Sell(Symbol(), AutoLot(), SL, TP);
      }
      
   }
   if(dn > 0.0){
      if(type == breakdown && Bid < dn-NormalizeDouble(offset*mtp*Point(), Digits())){
         dn = 0.0;
         trade.Sell(Symbol(), AutoLot(), SL, TP);
      }
      if(type == rebound && Ask < dn-NormalizeDouble(offset*mtp*Point(), Digits())){
         dn = 0.0;
         trade.Buy(Symbol(), AutoLot(), SL, TP);
      }
   }
}

//md - режим (1 - UPPER, 2 - LOWER)
//cnt - количество свечей для рассчета
double Fractal(ushort md, ushort cnt){
   if(Bars < cnt+1)
      return 0.0;   
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), tf, 1, cnt, rates);
   if(ArraySize(rates)<cnt)
      return 0.0;
   double frctl = 0.0;
   ushort n = 0.0;
   double max = 0.0;
   double min = 0.0;
   switch(md){
      case 1:
         for(ushort i = 0; i < cnt-1; i++){
            if(max == 0.0 || max < rates[i].high){
               max = rates[i].high;
               n = i;
            }
         }
         if(n == (double)(cnt-1)/2){
            fDrawArrow(md, n);
            frctl = max;    
         }     
      break;
      case 2:
         for(ushort i = 0; i < cnt-1; i++){
            if(min == 0.0 || min > rates[i].low){
               min = rates[i].low;
               n = i;
            }
         }
         if(n == (double)(cnt-1)/2){
            fDrawArrow(md, n);
            frctl = min;
         }
      break;
   }
   return frctl;
}

double AutoLot(){
   double Free =AccountFreeMargin();
   double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
   double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
   double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
   double Lot = useAuto == true?MathFloor(Free*risk/100/One_Lot/Step)*Step:volume;
   if (Lot<Min_Lot) Lot=Min_Lot;
   if (Lot>Max_Lot) Lot=Max_Lot;
   
   if(OrdersHistoryTotal() > 0 && useMrtn){
      for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            if(OrderProfit() < 0.0){
               double modLot = OrderLots()*k;
               if(modLot<Min_Lot) modLot=Min_Lot;
               if(modLot>Max_Lot) modLot=Max_Lot;
               if(AccountFreeMarginCheck(Symbol(), OrderType()==OP_BUY?OP_SELL:OP_BUY, modLot) <= 0.0)return Lot;
               else return modLot;
            }
            else return Lot;
         }         
      }
   }
   return Lot;
}

void fDrawArrow(int t = 0, int x = -1){
   if(!drawFrac)return;
   if (x == -1 || t == 0)return;
   static ushort n = 0;
   string name = StringConcatenate("FRACTAL_", n);
   n++;
   ObjectCreate(ChartID(), name, t == 1?OBJ_ARROW_UP:OBJ_ARROW_DOWN, 0, Time[x+1], t == 1?NormalizeDouble(High[x+1]+2*Point()*mtp, Digits()):NormalizeDouble(Low[x+1]-2*Point()*mtp, Digits()));
   ObjectSetInteger(ChartID(), name, OBJPROP_ANCHOR, t == 1?ANCHOR_BOTTOM:ANCHOR_TOP);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, t == 1?clrBlue:clrRed);
}