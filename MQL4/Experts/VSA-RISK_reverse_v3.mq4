//+------------------------------------------------------------------+
//|                                                     VSA-RISK.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <trade.mqh>


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

input int         magic       = 41134; //Магик
input int         SL          = 0;    //СЛ(п)
input int         TP          = 0;    //ТП(п)
input bool auto = true; //Автолот от риска
input cents risk = 2;  //риск для автолота
input double volume = 0.01;
input int         offset      = 100;     //Отступ от МА
input int         MAperiod   = 111;
input cents prft = 5;//Профит
input cents loss = 20;//Просадка

int mtp;
string botName = "VSA-RISK";

int OnInit(){
//---
   trade.SetExpertMagic(magic);
   
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;

   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectDelete(0, "Send");
   ObjectDelete(0, "Close");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---

   SendOrders();
   TralOrders();
   
   if(!CheckEquity())
      trade.CloseTrades();
}
void SendOrders(){

   double spr;
   RefreshRates();
   spr = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD)*Point()*mtp, Digits());
   bool t = false;
   
   if(Bid > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1)){
      if(Total(OP_SELLSTOP) == 0)trade.SellStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_21");
      return;
   }
   if(Bid < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1)){
      if(Total(OP_BUYSTOP) == 0)trade.BuyStop(Symbol(), volume, NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits()), SL, TP, botName+"_MA_21");
      return;
   }
}

void CloseOrders(){
   if(Total() == 0)
      return;
   trade.CloseBuy();
   trade.CloseSell();
   trade.DeletePendings();
}

void TralOrders(){
   if(Total() == 0)
      return;
   double spr;
   RefreshRates();
   spr = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD)*Point()*mtp, Digits());
   int total = OrdersTotal();
   bool t = false;
   double price21  = 0.0;
   for(int i = 0; i < total; i++){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYSTOP){
            price21  = NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1) + offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() > price21)
               t = OrderModify(OrderTicket(), price21, SL == 0 ? 0.0 : NormalizeDouble(price21 - SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price21 + TP*Point()*mtp, Digits()), OrderExpiration());
           
         }
         if(OrderType() == OP_SELLSTOP){
            price21  = NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1) - offset*Point()*mtp, Digits());
            if(StringFind(OrderComment(), "21", 0) > -1 && OrderOpenPrice() < price21)
               t = OrderModify(OrderTicket(), price21, SL == 0 ? 0.0 : NormalizeDouble(price21 + SL*Point()*mtp, Digits()), TP == 0 ? 0.0 : NormalizeDouble(price21 - TP*Point()*mtp, Digits()), OrderExpiration());
            
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
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

   p = AccountEquity() - balance;
   
   if(p >= pr || p <= ls){
      balance = 0.0;
      pr = 0.0;
      ls = 0.0;
      return false;
   }
   
   return true;
}