//+------------------------------------------------------------------+
//|                                              AAA_RESURRECTED.mq4 |
//|                                                             Enzo |
//|                                        https://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://vk.com/id29520847"
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

enum entries{
   single = 1, //одинарный
   both,       //двойной
   three       //тройной
};

input int               magic    = 5539832;        //магик
input ENUM_TIMEFRAMES   tf       = PERIOD_CURRENT; //таймфрейм
input double            volume   = 0.01;           //Лот
input bool              auto     = true;           //Автолот
input cents             risk     = 5;              //Риск автолота
input bool              useMrtn  = true;           //Мартин
input double            k        = 2.0;            //Коэффициент мартина
input entries           enter    = single;         //Вход по первому сигналу
input bool              useFill1 = true;           //Доливка 1
input bool              useFill2 = true;           //Доливка 2 
input int               SL       = 20;             //СЛ
input int               TP1      = 50;             //ТП1
input int               TP2      = 100;            //ТП2
input int               TP3      = 200;            //ТП3
input bool              useTral  = true;           //Трал
input int               step     = 10;             //Шаг
input int               stop     = 100;            //Тралстоп
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
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
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   static datetime time = 0;
   if(time == Time[0]) return;
   time = Time[0];
   Trade();
   if(useTral)trade.TralPointsGeneral(step, stop);
}

void Trade(){
   double ema1 = iMA(Symbol(), tf, 5, 0, MODE_EMA, PRICE_CLOSE,1);
   double ema2 = iMA(Symbol(), tf, 5, 0, MODE_EMA, PRICE_CLOSE,3);
   double sma1 = iMA(Symbol(), tf, 10,0, MODE_SMA, PRICE_CLOSE,1);
   double sma2 = iMA(Symbol(), tf, 10,0, MODE_SMA, PRICE_CLOSE,3);
   double ao1  = iAO(Symbol(), tf, 1);
   double ao2  = iAO(Symbol(), tf, 2);
   double ao3  = iAO(Symbol(), tf, 3);
   double ac1  = iAC(Symbol(), tf, 1);
   double ac2  = iAC(Symbol(), tf, 2);
   double ac3  = iAC(Symbol(), tf, 3);
   double mtfs0 = NormalizeDouble(iCustom(Symbol(), tf, "MTFS", 1440, 10, 3, 3, 0, 0, 0, 1), Digits());
   double mtfs1 = NormalizeDouble(iCustom(Symbol(), tf, "MTFS", 1440, 10, 3, 3, 0, 0, 1, 1), Digits());
   
   static short dir = -1;
   
   if(dir == 0 && ema1 < sma1)dir = -1;
   if(dir == 1 && ema1 > sma1)dir = -1;
   
   if(!fCheckPosition(OP_BUY) && mtfs0 > mtfs1){ 
      if(ema1 > sma1 && ema2 < sma2 && ao1 > ao2 && ao2 > ao3 && ac1 > ac2 && ac2 > ac3){
         dir = 0;
         switch(enter){
            case 1:
               trade.Buy(Symbol(), AutoLot(), SL, TP1);
            break;
            case 2:
               trade.Buy(Symbol(), AutoLot(), SL, TP1);
               trade.Buy(Symbol(), AutoLot(), SL, TP2);
            break;
            case 3:
               trade.Buy(Symbol(), AutoLot(), SL, TP1);
               trade.Buy(Symbol(), AutoLot(), SL, TP2);
               trade.Buy(Symbol(), AutoLot(), SL, TP3);
            break;
         }
         
         //trade.CloseSell();
         return;
      }
      if(dir == 0){
         if(ao1 > ao2 && ao2 < ao3  && ac1 > ac2 && ac2 < ac3){
            //trade.CloseSell();
            if(useFill1)trade.Buy(Symbol(), AutoLot(), SL, TP1);
            return;
         }
         if((ao1 > ao2 && ao2 < ao3) || (ac1 > ac2 && ac2 < ac3)){
            //trade.CloseSell();
            if(useFill2)trade.Buy(Symbol(), AutoLot(), SL, TP1);
            return;
         }
      }
   }
         
   if(!fCheckPosition(OP_SELL) && mtfs0 < mtfs1){ 
      if(ema1 < sma1 && ema2 > sma2 && ao1 < ao2 && ao2 < ao3 && ac1 < ac2 && ac2 < ac3){
         dir = 1;         
         //trade.CloseBuy();
         switch(enter){
            case 1:
               trade.Sell(Symbol(), AutoLot(), SL, TP1);
            break;
            case 2:
               trade.Sell(Symbol(), AutoLot(), SL, TP1);
               trade.Sell(Symbol(), AutoLot(), SL, TP2);
            break;
            case 3:
               trade.Sell(Symbol(), AutoLot(), SL, TP1);
               trade.Sell(Symbol(), AutoLot(), SL, TP2);
               trade.Sell(Symbol(), AutoLot(), SL, TP3);
            break;
         }
         return;
      }
      if(dir == 1){
         if(ao1 < ao2 && ao2 > ao3  && ac1 < ac2 && ac2 > ac3){
            //trade.CloseBuy();
            if(useFill1)trade.Sell(Symbol(), AutoLot(), SL, TP1);
            return;
         }
         if((ao1 < ao2 && ao2 > ao3) || (ac1 < ac2 && ac2 > ac3)){
            //trade.CloseBuy();
            if(useFill2)trade.Sell(Symbol(), AutoLot(), SL, TP1);
            return;
         }
      }
   }
}

bool fCheckPosition(int type = -1, string cmnt = ""){
   if(OrdersTotal() > 0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if((type == -1 || type == OrderType()) && (cmnt == "" || StringFind(OrderComment(),cmnt)>-1)){
               return true;
            }
         }
      }
   }
   return false;
}

double AutoLot(){
   double Free =AccountFreeMargin();
   double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
   double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
   double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
   double Lot = auto == true?MathFloor(Free*risk/100/One_Lot/Step/3)*Step:volume;
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
//+------------------------------------------------------------------+
/*0
NormalizeDouble(iCustom(Symbol(), tf, "MTFS", 1440, 10, 3, 3, 0, 0, 0, 1), Digits());
NormalizeDouble(iCustom(Symbol(), tf, "MTFS", 1440, 10, 3, 3, 0, 0, 1, 1), Digits());
iCustom(Symbol(), tf, "SAR",  0, 0);
iCustom(Symbol(), tf, "SAR",  1, 0);*/