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

enum MAPosition{
   none,       //íåò
   against,    //ïðîòèâ íàïðàâëåíèÿ
   ondir       //ïî íàïðàâëåíèþ 
};

input string      comment3    = "ÎÁÙÈÅ ÏÀÐÀÌÅÒÐÛ"; //.
input int         magic       = 785123; //Magic
input int         step        = 5;     //Øàã ìåæäó îðäåðàìè
input string      comment5    = "ÏÀÐÀÌÅÒÐÛ ÎÐÄÅÐÎÂ"; //.
input int         TP          = 40;    //TP
input int         SL          = 40;
input double      volume      = 0.01;  //lot
input string      comment6    = "ÑÎÏÐÎÂÎÆÄÅÍÈÅ ÑÄÅËÎÊ"; //.
input int         be          = 10;    //Áåçóáûòîê
input int         tral        = 20;    //tral step
input bool        auto        = true;  //Àâòîëîò îò ðèñêà
input cents       risk        = 2;     //ðèñê äëÿ àâòîëîòà
input string      comment2    = "ÏÀÐÀÌÅÒÐÛ ÝÊÂÈÒÈ-ÊÎÍÒÐÎËß";//.
input bool        autoclose   = true;  //àâòîçàêðûòèå ïî ïðîôèòó
input bool        USB         = true;  //Ïåðâîíà÷àëüíûé ââîä áàëàíñà
input double      startBalance= 1000;  //Ñòàðòîâûé êîíòðîëüíûé áàëàíñ
input cents       prft        = 5;     //Ïðîôèò
input cents       loss        = 20;    //Ïðîñàäêà

string botName = "STEP (+equitycontroller)";
int mtp;
bool useStartBlnc;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
   useStartBlnc = USB;
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
   Trade();
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

void Trade(){
   if(Total() == 0){
      trade.Buy(Symbol(),  AutoLot(volume), SL, TP, botName);
      trade.Sell(Symbol(), AutoLot(volume), SL, TP, botName);
   }
   BuildGrid();
   TralStops();
}

bool CheckEquity(){
   if(OrdersTotal() == 0)
      return true;
      
   static double balance = 0.0;
   //Print("Balance = ",balance);
   static double pr = 0.0;
   static double ls = 0.0;
   
   if(balance == 0.0){
      if(useStartBlnc == true){
         balance = startBalance;
         useStartBlnc = false;
      }
      else if(!useStartBlnc)
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

void BuildGrid(){
   if(OrdersTotal() == 0)
      return;
   double hb  = HighestBuy();
   double lb  = LowestBuy();
   double hs  = HighestSell();
   double ls  = LowestSell();
   
   if((Ask > hb + step*mtp*Point() && hb != 0.0) || 
      (Ask < lb - step*mtp*Point() && Ask > hs + step*mtp*Point() && lb != 0.0 && hs != 0.0) ||
      (Ask > hs + step*mtp*Point() && lb == 0.0 && hb == 0.0)){
      trade.Buy(Symbol(), AutoLot(volume), SL, TP, botName);
      return;
   }
   
   if((Bid < ls - step*mtp*Point() && ls != 0.0) || 
      (Bid > hs + step*mtp*Point() && Bid < lb - step*mtp*Point() && hs != 0.0 && lb != 0.0) ||
      (Bid < lb - step*mtp*Point() && ls == 0.0 && hs == 0.0)){
      trade.Sell(Symbol(), AutoLot(volume), SL, TP, botName);
      return;
   }
   
   /*
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         //if(OrderType() == OP_BUY){
            if((Ask > hb + step*mtp*Point() && hb != 0.0) || 
               (Ask < lb - step*mtp*Point() && Ask > hs + step*mtp*Point() && lb != 0.0 && hs != 0.0) ||
               (Ask > hs + step*mtp*Point() && lb == 0.0 && hb == 0.0)){
               trade.Buy(Symbol(), AutoLot(volume), 0, TP, botName);
               return;
            }
            //break;
         //}
         //if(OrderType() == OP_SELL){
            if((Bid < ls - step*mtp*Point() && ls != 0.0) || 
               (Bid > hs + step*mtp*Point() && Bid < lb - step*mtp*Point() && hs != 0.0 && lb != 0.0) ||
               /*(Bid < lb - step*mtp*Point() && ls == 0.0 && hs == 0.0)){
               trade.Sell(Symbol(), AutoLot(volume), 0, TP, botName);
               return;
            }
            //break;
         //}
      }
   }*/
}

double HighestBuy(){
   double h = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_BUY){
         if(h < OrderOpenPrice())
            h = NormalizeDouble(OrderOpenPrice(), Digits());
      }
   }
   return h;
}

double LowestBuy(){
   double l = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_BUY){
         if(l > OrderOpenPrice() || l == 0.0)
            l = NormalizeDouble(OrderOpenPrice(), Digits());
      }
   }
   return l;
}


double HighestSell(){
   double h = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_SELL){
         if(h < OrderOpenPrice())
            h = NormalizeDouble(OrderOpenPrice(), Digits());
      }
   }
   return h;
}

double LowestSell(){
   double l = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_SELL){
         if(l > OrderOpenPrice() || l == 0.0)
            l = NormalizeDouble(OrderOpenPrice(), Digits());
      }
   }
   return l;
}