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

input string      comment3    = "ОБЩИЕ ПАРАМЕТРЫ"; //.
input int         magic       = 45123; //Magic
input string      comment4    = "ПАРАМЕТРЫ ВХОДА В СДЕЛКУ"; //.
input ushort      time        = 10;    //Время формирования импульса (сек)
input ushort      impulse     = 60;    //Импульс
input string      comment5    = "ПАРАМЕТРЫ ОРДЕРОВ"; //.
input ushort      stopOffset  = 10;    //Oтступ стоповика от текущей цены
input int         OTS         = 10;    //Order tral step
input int         TP          = 40;    //TP отложки
input int         SL          = 40;    //SL отложки
input int         TP2         = 40;    //TP рыночного
input int         SL2         = 40;    //SL рыночного
input double      volume      = 0.01;  //lot
input string      comment6    = "СОПРОВОЖДЕНИЕ СДЕЛОК"; //.
input int         be          = 10;    //Безубыток
input int         tral        = 20;    //tral step
input bool        auto        = true;  //Автолот от риска
input cents       risk        = 2;     //риск для автолота
input string      comment2    = "ПАРАМЕТРЫ ЭКВИТИ-КОНТРОЛЯ";//.
input bool        autoclose   = true;  //автозакрытие по профиту
input bool        USB         = true; //Первоначальный ввод баланса
input double      startBalance= 1000;  //Стартовый контрольный баланс
input cents       prft        = 5;     //Профит
input cents       loss        = 20;    //Просадка
input string      comment1    = "ПАРАМЕТРЫ МА";//.
input MAPosition  pos         = none;  //Использовать МА
input int         MAperiod    = 100;   //МА период
input int         MAshift     = 0;     //МА сдвиг

Types type = stops;//Типы ордеров
string botName = "ICHIMOKU CHIKOU SPAN (+equitycontroller)";
int mtp;
bool useStartBlnc;
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
   for(ushort i = 0; i <= 1; i++)Mode1(i);
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

short Signal(ushort j){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 4, rates);
   if(ArraySize(rates)<4)
      return -1;
   switch(j){
      case 0:{
         if(rates[1].close < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,1) && rates[1].open < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,1) &&
            ((rates[2].close > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,2) && rates[2].open > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,2))||
            (rates[3].close > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,3) && rates[3].open > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,3))))return 0;
      }break;
      
      case 1:{
         if(rates[1].close > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,1) && rates[1].open > iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,1) &&
            ((rates[2].close < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,2) && rates[2].open < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,2))||
            (rates[3].close < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,3) && rates[3].open < iIchimoku(Symbol(),PERIOD_CURRENT,9,26,52,MODE_CHIKOUSPAN,3))))return 1;
      }break;
   }
   return -1;
}

ushort GetMode(ushort j){
   if(OrdersTotal() == 0)return 1;
   double profit = 0.0;
   bool x = false;
   for(int i = OrdersTotal(); i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      
   }
   if(profit >= 0.0 &&(Total(j) == 1 || Total((ushort)(j+4)) == 1))return 1;
   else return 2;
}

void Mode1(ushort j){
   short s = Signal(j);   
   switch(s){
      case 0:
         if(Total(OP_BUY) == 0 ){
            trade.Buy(Symbol(), AutoLot(volume), SL, TP, botName);
            trade.CloseSell();
         }
         break;
             //if(Total(OP_SELLLIMIT) == 0 && (type == limits || type == both))trade.SellLimit(Symbol(), AutoLot(volume), NormalizeDouble(Ask + stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
      case 1:
         if(Total(OP_SELL) == 0){
            trade.Sell(Symbol(), AutoLot(volume), SL, TP, botName);
            trade.CloseBuy();
         }
         break;
             //if(Total(OP_BUYLIMIT) == 0 &&(type == limits || type == both))trade.BuyLimit(Symbol(), AutoLot(volume), NormalizeDouble(Bid - stopOffset*mtp*Point(), Digits()), SL, TP, botName);break;
   }
   TralOrders();
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

short CheckMA(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 4, rates);
   
   if(ArraySize(rates)<4)
      return -1;
   
   switch(pos){
      case 0:return 0;  //Если не использовать МА, то возвращает 0
      case 1:           //Если против направления, то 1 - для покупки, 2 - для продажи
         if(rates[1].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1))
            return 1;
         if(rates[1].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1))
            return 2;
         break;
      case 2:
         if(rates[1].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1))
            return 2;   //Если по направлению, то 1 - для покупки, 2 - для продажи
         if(rates[1].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, MAshift, MODE_EMA, PRICE_CLOSE, 1))
            return 1;
         break;
   }
   
   return -1;
}

bool CheckTime(){
   static ushort _time = 0;
   static MqlDateTime prevTime;
   MqlDateTime curTime;
   TimeLocal(curTime);
   if(_time < time){
      if(prevTime.sec != curTime.sec){
         prevTime.sec = curTime.sec;
         _time++;
      }
      return true;
   }
   else{
      _time = 0;
      ZeroMemory(prevTime);
      return false;
   }
   return false;
}

void TakeProfit(){
   if(OrdersTotal() == 0)
      return;
   double profit = 0.0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      
   }
   /*
   int direction = -1;
   
   double price = 0.0;
   
   double level = SetLevelOfClose(avrCnd);
   
   int dir = GridDirection();
   
   if(dir == OP_BUY){
      if(tick.bid >= level){
         price = tick.bid;
      }
   }
   else if(dir == OP_SELL){
      if(tick.ask <= level){
         price = tick.ask;
      }
   }
   
   if(price != 0.0){
      CloseAllGrid(dir);
   }   */
   if(profit > 0.0){
      trade.CloseTrades();
      trade.DeletePendings();
   }
}