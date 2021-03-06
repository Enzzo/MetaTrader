//+------------------------------------------------------------------+
//|                                                     ICHIMOKU.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <Trade.mqh>

CTrade trade;

input int magic = 09876;
input double volume = 0.01;
input int tenkan = 9;
input int kijun = 22;
input int senkouspanB = 52;
input int SL = 30;
input int TP = 60;
input int tral = 50;
input int be = 30;

string botName = "ICHIMOKU";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
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
   Start();
   TralStops();
}
//+------------------------------------------------------------------+

void Start(){
   ushort s = Signal();
   switch(s){
      case 0:
         if(Total(OP_BUY) == 0){
            trade.Buy(Symbol(), volume, SL, TP, botName);
            }
            trade.CloseSell();
         
         break;
      case 1:if(Total(OP_SELL) == 0){
            trade.Sell(Symbol(), volume, SL, TP, botName);
            }
            trade.CloseBuy();
         
         break;
   }
}

ushort Signal(){

  /* static datetime pTime = 0;
   datetime cTime[1];
   CopyTime(Symbol(), PERIOD_CURRENT, 1, 1, cTime);
   if(pTime == cTime[0])
      return -1;
   pTime = cTime[0];
   */
   //1 - MODE_TENKANSEN, 2 - MODE_KIJUNSEN, 3 - MODE_SENKOUSPANA, 4 - MODE_SENKOUSPANB, 5 - MODE_CHIKOUSPAN
   
   double ska1 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_SENKOUSPANA, -kijun);
   double ska3 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_SENKOUSPANA, -(kijun-2));
   double skb1 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_SENKOUSPANB, -kijun);
   double skb3 = iIchimoku(Symbol(), PERIOD_CURRENT, tenkan, kijun, senkouspanB, MODE_SENKOUSPANB, -(kijun-2));
   
   if(ska1 > skb1 && ska3 < skb3)return 0;
   if(ska1 < skb1 && ska3 > skb3)return 1;
   /*double tks1 = iIchimoku(Symbol(), PERIOD_CURRENT, 9, 26, 52, MODE_TENKANSEN, 1);
   double tks3 = iIchimoku(Symbol(), PERIOD_CURRENT, 9, 26, 52, MODE_TENKANSEN, 3);
   double kjs1 = iIchimoku(Symbol(), PERIOD_CURRENT, 9, 26, 52, MODE_KIJUNSEN, 1);
   double kjs3 = iIchimoku(Symbol(), PERIOD_CURRENT, 9, 26, 52, MODE_KIJUNSEN, 3);
   
   double cci1 = iCCI(Symbol(),PERIOD_CURRENT,14,PRICE_TYPICAL,1);
   double cci2 = iCCI(Symbol(),PERIOD_CURRENT,14,PRICE_TYPICAL,2);
   
   static short cross = -1;   //Пересечение 0 - золотой крест 1 - мертвый крест
   
   if(tks1 > kjs1 && tks3 <= kjs3)cross = 0;
   if(tks1 < kjs1 && tks3 >= kjs3)cross = 1;
   
   if(cross == 0 && tks1 < kjs1)cross = -1;
   if(cross == 1 && tks1 > kjs1)cross = -1;
   
   if(cross == 0 && cci1 > cci2 *//*&& cci2 < 0.0*/ /*&& tks1 > tks3)return 0;  //buy
   if(cross == 1 && cci1 < cci2 *//*&& cci2 > 0.0*/ /*&& tks1 < tks3)return 1;  //sell
   */
   return -1;
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

void TralStops(){
   if(OrdersTotal() == 0)
      return;
   bool x = false;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         /*if(OrderStopLoss() != 0.0)*/trade.TralPoints(OrderTicket(), tral);
         //else trade.Breakeven(OrderTicket(), be);         
      }
   }
}