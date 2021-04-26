//+------------------------------------------------------------------+
//|                                                         Grid.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <SpreadController.mqh>
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

SpreadController sc;


input int      magic = 53124312;
//input double   lot   = 0.01;
input double   prof  = 0.1;      //стартовый профит
//input int      grid  = 30;     //Сетка
input int      maxOrders = 20;   //Макс ордерс
input cents    risk  = 3;        //Риск
int SL = 0;
input int TP = 20;   //Тейкпрофит первого ордера
input double k = 1.0;
int EMA1_period=10;
int EMA2_period=50;
int EMA3_period=200;
int Stochastic_period=30;
int CCI_period=50;
int RSI_period=14;
int MACD_period=20;
int      sprd  = 0;        //Спред для начала торговли
//int TP = grid;    //ТП
double   min = 0.000;//мин
double   max = 10.000;//макс
int      fast = 12;
int      slow = 26;
//int      macd = 9;
int      MAperiod = 240;
//double grd;
//double tkp;
double avrCnd;
double sVol;
string botName = "Cross";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   trade.SetExpertMagic(magic);
   sVol = 0.01;
   /*int mtp = 1;
   
   if(Digits() == 5 && Digits() == 3)
      mtp = 10;
   
   grd = NormalizeDouble(grid * Point(), Digits()) * mtp;
   tkp = NormalizeDouble(TP * Point(), Digits()) * mtp;
   */
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   sc.DestroyInfo();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   sc.ShowSpread(1, 10, 15, sprd);
   if(!CalculateAverageCandle()){
      return;
   };
   Trade();   
}
//+------------------------------------------------------------------+

void Trade(){
   
   
   for(int i = 0; i < 2; i++){
      if(Total(i)==0)// && sc.CompareSpread(sprd))
         Start(i);
     /*else{
         if(Total(i) < maxOrders)
            Continue(i);
         TakeProfit(i);
         /*if(Total(i) == maxOrders)
            StopLoss(i);*/
      }
   //}
   
   
   /*if(Total() == 0 && sc.CompareSpread(sprd))
      Start();
   else{      
      if(Total() < maxOrders)
         Continue();
      TakeProfit();
   }*/
}

//---> Количество ордеров, выставленных экспертом на символе
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
   //Print("count = ",count);
   return count;
}

void Start(int cmd = -1){
   /*if(!CalculateAverageCandle())
      return;*/
   double price = 0.0;
   double tp = 0.0;
   MqlTick tick;
   MqlRates rates[];
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 5, rates);
   ArraySetAsSeries(rates, true);
   
   if(ArraySize(rates)<5)
      return;
   
   int slp = (int)MarketInfo(Symbol(), MODE_SPREAD);
   /*
   if(cmd == OP_BUY && 
      /*iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) > -MACDminlimit &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) < -MACDminlimit &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) < -MACDminlimit &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4) < -MACDminlimit)*/
      /*iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) > 0.0 &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) > 0.0 &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) < 0.0 &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4) < 0.0 &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) > iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) > iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) &&
      iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) > iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4)
      ) */     
      /*
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) < -min &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) < -min &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) > -max &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) > -max &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) && //iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 3) < 25 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 2) < 30 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 1) > 32){
      
      rates[0].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) &&
      rates[1].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 2) &&
      rates[2].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 3))// &&
      //rates[3].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 4) &&
      //rates[4].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 5))
      
      price = NormalizeDouble(tick.ask, Digits());
   
   else if(cmd == OP_SELL && 
           /*iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) < MACDminlimit &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) > MACDminlimit &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) > MACDminlimit &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4) > MACDminlimit)*/
           /*iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) < 0.0 &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) < 0.0 &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) > 0.0 &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4) > 0.0 &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 1) < iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 2) < iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) &&
           iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 3) < iMACD(Symbol(), PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_EMA, 4)
           )*/
           /*
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) > min &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) > min &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) < max &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) < max &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 1) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 2) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 3) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 4) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, macd, PRICE_CLOSE, MODE_EMA, 5) &&//iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 3) > 75 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 2) > 70 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 1) < 68){
           
           rates[0].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) &&
           rates[1].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 2) &&
           rates[2].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 3))// &&
           //rates[3].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 4) &&
           //rates[4].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 5))
      
           price = NormalizeDouble(tick.bid, Digits());*/
   
   //else
      //return;
   
   sVol = (AccountEquity()/100*risk) / (avrCnd/Point())/*((price - sl)/Point()) *// MarketInfo(Symbol(), MODE_TICKVALUE)/ maxOrders;
   if(sVol < MarketInfo(Symbol(), MODE_MINLOT))
      sVol = MarketInfo(Symbol(), MODE_MINLOT);
   if(sVol > MarketInfo(Symbol(), MODE_MAXLOT))
      sVol = MarketInfo(Symbol(), MODE_MAXLOT);
   
   int d = Signal();
   
   if(d == 1 && d == cmd){
      trade.Sell(Symbol(), NULL, sVol, SL, TP, botName);
      //CloseAllGrid(0);
      return;
   }
   if(d == 0 && d == cmd){
      trade.Buy(Symbol(), NULL, sVol, SL, TP, botName);
      //CloseAllGrid(1);
      return;
   }
   /*
   if(price != 0.0){
      
   
      if(!OrderSend(Symbol(), cmd, sVol, price, slp, 0.0, 0.0, "Grid_3(+autolot +parallel)", magic)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
   }*/
}
//+---------------------------------------------------------------------+
//|   Continue()
//|   Выставляет ордера по достижении уровня сетки.
//|   
/*void Continue(int dir = -1){
   //int dir = GridDirection();   
   BuildGrid(dir);
}*/
//+---------------------------------------------------------------------+
//|   TakeProfit()
//|   Имитирует тейкпрофит.
//|   
/*void TakeProfit(int dir = -1){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   double profit = 0.0;
   int total = OrdersTotal();
   
   if(Total(dir) == 1)
      return;
   
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == dir)
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
   }   
   if(profit > prof*sVol/MarketInfo(Symbol(), MODE_MINLOT))
      CloseAllGrid(dir);
}*/

//+---------------------------------------------------------------------+
//|   CloseAllGrid()
//|   Закрывает все ордера.
//|   Вызывается при помощи функции TakeProfit()
void CloseAllGrid(int dir){
   while(Total(dir) > 0){
      MqlTick tick;
      RefreshRates();
      SymbolInfoTick(Symbol(), tick);
      int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
      int total = OrdersTotal();
      double price = 0.0;
      if(dir == OP_BUY)
         price = tick.bid;
      else if(dir == OP_SELL)
         price = tick.ask;
      else
         Print("Не правильная цена.");
      for(int i = total - 1; i >= 0; i--){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__, "  ",GetLastError());
            
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == dir){
            ResetLastError();
            if(!OrderClose(OrderTicket(), OrderLots(), price, slp)){
               Print(__FUNCTION__, "  ",GetLastError());
               
            }
         }
      }
   }
}
//+---------------------------------------------------------------------+
//|   SetLevelOfClose()
//|   Возвращает уровень тейкпрофита.
//|   
/*double SetLevelOfClose(double tp){
   int direction = -1;     //направление ордеров   
   int n = 0;              //счетчик открытых ордеров
   double commonPrice = 0.0;//общая цена открытых ордеров, которую будем делить на количество ордеров
   double level = 0.0;     //Уровень закрытия (ТП)
   int total = OrdersTotal();
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, "  ",GetLastError());
         return level;
      }
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         n++;
         commonPrice += OrderOpenPrice();
         if(OrderType() == OP_BUY)
            direction = OP_BUY;
         else if(OrderType() == OP_SELL)
            direction = OP_SELL;
      }
   } 
   if(n == 1){
      if(direction == OP_BUY)
         level = commonPrice + tp;
      else if(direction == OP_SELL)
         level = commonPrice - tp;
   }
   if(n > 1){
      level = NormalizeDouble(commonPrice/n, Digits());
   }
   return level;
}
*/
//+---------------------------------------------------------------------+
//|   GridDirection()
//|   возвращает направление сетки.
//|   BUY или SELL
/*
int GridDirection(){
   int dir = -1;
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__,"  ",GetLastError());
         return -1;
      }
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(OrderType() == OP_BUY)
            dir = OP_BUY;
         else if(OrderType() == OP_SELL)
            dir = OP_SELL;
      }
   }
   return dir;
}
*/
//+---------------------------------------------------------------------+
//|   GainedLevel()
//|   Если достигнут уровень, то можно выставлять ордер.
//|   Перебираем с последних выставленных ордеров (задом наперед)

/*void BuildGrid(int dir = -1){
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)MarketInfo(Symbol(), MODE_SPREAD);
   double price = 0.0;
   
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--){
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(dir == OP_BUY){
            if(tick.ask < (OrderOpenPrice() - avrCnd * k)){
               trade.Buy(Symbol(), NULL, OrderLots(), 0, 0, botName);
               return;
            }
         }
         if(dir == OP_SELL){
            if(tick.bid > (OrderOpenPrice() + avrCnd * k)){
               trade.Sell(Symbol(), NULL, OrderLots(), 0, 0, botName);
               return;
            }
         }
      }
   }
}

void StopLoss(int dir = -1){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--){
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == dir){
         if(dir == OP_BUY){
            if(tick.ask < (OrderOpenPrice() - avrCnd)){
               CloseAllGrid(0);
               return;
            }
         }
         if(dir == OP_SELL){
            if(tick.bid > (OrderOpenPrice() + avrCnd)){
               CloseAllGrid(1);
               return;
            }
         }
         return;
      }
   }
}
*/
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

int Signal(){
   double ema1,ema2,sto1, sto2, sto3, cci1, cci2, cci3, rsi1, rsi2, rsi3, macd, macds, ema3;
   ema1=iMA(Symbol(),NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema2=iMA(Symbol(),NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema3=iMA(Symbol(),NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto1 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   cci1 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,0); 
   rsi1 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,0); 
   sto2 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,1);   
   cci2 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,1); 
   rsi2 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,1); 
   sto3 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,2);   
   cci3 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,2); 
   rsi3 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,2); 
   macd=iMACD(Symbol(),NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
   macds=iMACD(Symbol(),NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
   int buy = 0;
   int sell = 0;
   
      if ( ema1>ema2 && ema2>ema3 ) buy++; 
      else CloseAllGrid(0);
      if ( ema1<ema2 && ema2<ema3 ) sell++; 
      else CloseAllGrid(1);
      //if ( sto1 < 50 /*&& sto2 < 20 /*&& sto3 < 20*/)sell++;
      //if ( sto1 > 50 /*&& sto2 > 80 /*&& sto3 > 80*/)buy++;     
      
      //if ( cci1 < -100/* && cci2 < -100 && cci3 < -100*/)buy++;
      //if ( cci1 > 100/* && cci2 > 100 && cci3 > 100*/) sell++;
      
      
      //if ( rsi1 < 50 /*&& rsi2 < 50 && rsi3 < 50*/)buy++; 
      //if ( rsi1 > 50 /*&& rsi2 > 50 && rsi3 > 50*/)sell++;           

      //if ( macd<0 /*&& macd<macds */)sell++;
      //if ( macd>0 /*&& macd>macds */)buy++;
      
      if(buy == 1)
         return 0;
      if(sell == 1)
         return 1;
      
   return -1;
}