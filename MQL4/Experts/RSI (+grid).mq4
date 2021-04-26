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

input int magic = 45123; //Magic
input ushort stopOffset = 20; //O����� ��������� �� ������� ����
ushort impulse  = 60;   //�������
input int TP = 0;   //TP
input int SL = 0;   //SL
input int OTS = 20;  //Order tral step
input int be = 20;   //���������
input int tral = 30; //tral step
input double prof = 1.0;//������ ������ �� ��������
input bool auto = false; //������� �� �����
input double volume = 0.01; //lot
input cents risk = 20;  //���� ��� ��������
input int top = 70;//RSI TOP
input int bottom = 30; //RSI BOTTOM
input int period = 18; //RSI PERIOD
input bool autoclose = true;//������������ �� �������
input cents prft = 5;//������
input cents loss = 20;//��������
string botName = "RSI";
int mtp;
ushort mode;
double avrCnd;
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
   if(!CheckEquity() && autoclose)
      trade.CloseTrades();
   Mode1();
   ModifyStops();
   //Mode2();
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

short Signal(){
   /*if(iRSI(Symbol(), NULL, 61, PRICE_CLOSE, 1)>60)return 0;
   if(iRSI(Symbol(), NULL, 61, PRICE_CLOSE, 1)<40)return 1;*/
   if(iCustom(Symbol(), 0, "Sentiment", 100, 0, 1) > 0.0 && iCustom(Symbol(), 0, "Sentiment", 500, 0, 1) > 0.0 && iCustom(Symbol(), 0, "Sentiment", 1000, 0, 1)>0.0)return 0;
   if(iCustom(Symbol(), 0, "Sentiment", 100, 0, 1) < 0.0 && iCustom(Symbol(), 0, "Sentiment", 500, 0, 1) < 0.0 && iCustom(Symbol(), 0, "Sentiment", 1000, 0, 1)<0.0)return 1;
   return -1;
}
/*
ushort GetMode(ushort i){
   if(OrdersTotal() == 0)return 1;
   double profit = 0.0;
   bool x = false;
   for(int j = OrdersTotal(); j >= 0; j--){
      x = OrderSelect(j, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == i)
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      
   }
   if(profit >= 0.0 && (Total(i) == 1 || Total((ushort)(i+4)) == 1))return 1;
   else return 2;
}
*/
void Mode1(){
   short s = Signal();      
   switch(s){
      case 0:
         //trade.CloseSell();
         //trade.DeleteType(OP_SELLSTOP);
         if(LastTrade() == OP_SELL || LastTrade() == -1)trade.Buy(Symbol(), MartinLot(OP_BUY), SL, TP, botName);
         break;
            //trade.BuyStop(Symbol(), AutoLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
             //if(Total(OP_SELLLIMIT) == 0 && (type == limits || type == both))trade.SellLimit(Symbol(), AutoLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
      case 1:
         //trade.CloseBuy();
         //trade.DeleteType(OP_BUYSTOP);
         if(LastTrade() == OP_BUY || LastTrade() == -1)trade.Sell(Symbol(), MartinLot(OP_SELL), SL, TP, botName);
         break;
            //trade.SellStop(Symbol(), AutoLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
             //if(Total(OP_BUYLIMIT) == 0 &&(type == limits || type == both))trade.BuyLimit(Symbol(), AutoLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
   }
   //TralOrders();
   //TralStops();
}
/*
void Mode2(){
   if(CalculateAverageCandle()){
      BuildGrid();
      //TakeProfit(i);
   }
}*/


bool CalculateAverageCandle(){
   double count = 0.;
   MqlRates rates[];
   RefreshRates();
   
   int bars = 100;

   CopyRates(Symbol(), PERIOD_CURRENT, 1, bars - 1, rates);
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
   if(Total()>15)
      return;
   double price = 0.0;
   bool x = false;
   for(int j = OrdersTotal() - 1; j >= 0; j--){
      x = OrderSelect(j, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(OrderType() == OP_BUY){
            if(Ask < (OrderOpenPrice() - avrCnd*3))trade.Buy(Symbol(), OrderLots(), 0, 0, botName);
            return;         
         }
         if(OrderType() == OP_SELL){
            if(Bid > (OrderOpenPrice() + avrCnd*3))trade.Sell(Symbol(), OrderLots(), 0, 0, botName);
            return;
         }
      }
   }
}

void TakeProfit(ushort i){
   if(OrdersTotal() == 0)return;
   double profit = 0.0;
   double lot = 0.0;
   for(int j = OrdersTotal() - 1; j >= 0; j--){
      ResetLastError();
      if(!OrderSelect(j, SELECT_BY_POS)){
         Print(__FUNCTION__," ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == i){
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
         lot = OrderLots();
      }     
   }
   if(profit > prof*lot/MarketInfo(Symbol(), MODE_MINLOT)){
      switch(i){
         case 0: trade.CloseBuy();break;
         case 1: trade.CloseSell();break;
      }
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

double MartinLot(int dir = -1){
   double vol = volume;
   if(dir == -1)
      return vol;
   if(OrdersTotal() > 0){
      bool x = false;
      for(int i = OrdersTotal() - 1; i>= 0; i--){
         x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() != dir)return vol = OrderLots()*2;
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

int LastTrade(){
   if(OrdersTotal() == 0)
      return -1;
   bool x = false;
   for(int i = OrdersTotal() - 1; i>=0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         return OrderType();
   }
   return -1;
}

void ModifyStops(){
   if(Total() > 1){   
      bool x = false;
      for(int i = OrdersTotal()-1; i>= 0; i--){
         x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderTakeProfit() > 0.0){
            x = OrderModify(OrderTicket(), OrderOpenPrice(), 0.0, 0.0, OrderExpiration());
         }
      }
   }
}