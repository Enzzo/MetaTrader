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
double   prof  = 2.0;      //стартовая сумма закрытия ордеров
//input int      grid  = 30;     //Сетка
input int      maxOrders = 50;   //Макс ордерс
input cents    risk  = 15;        //Риск
input int      sprd  = 0;        //Спред для начала торговли
//int TP = grid;    //ТП
input double   min = 0.001;//мин
input double   max = 0.002;//макс
input int      fast = 12;
input int      slow = 26;
input int      MACD = 9;

//double grd;
//double tkp;
double avrCnd;
double sVol;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
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
      if(Total(i)==0 && sc.CompareSpread(sprd))
         Start(i);
      else{
         if(Total(i) < maxOrders)
            Continue(i);
         TakeProfit();
      }
   }
   
   
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
   if(!CalculateAverageCandle())
      return;
   double price = 0.0;
   double tp = 0.0;
   MqlTick tick;
   MqlRates rates[];
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   /*CopyRates(Symbol(), PERIOD_M1, 1, 3, rates);
   ArraySetAsSeries(rates, true);
   
   if(ArraySize(rates)<3)
      return;
   */
   int slp = (int)MarketInfo(Symbol(), MODE_SPREAD);
   
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
      
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) < -min && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) < -min &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5) < -min &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) > -max && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) > -max &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5) > -max &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) && 
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) &&
      iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5)) //iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 3) < 25 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 2) < 30 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 1) > 32){
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
           
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) > min && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) > min &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5) > min &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) < max && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) < max &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5) < max &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 1) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 2) < iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) &&
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 3) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) && 
           iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 4) > iMACD(Symbol(), PERIOD_CURRENT, fast, slow, MACD, PRICE_CLOSE, MODE_EMA, 5))//iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 3) > 75 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 2) > 70 && iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 1) < 68){
           price = NormalizeDouble(tick.bid, Digits());
   
   else
      return;
   if(price != 0.0){
      sVol = (AccountEquity()/100*risk) / (avrCnd/Point())/*((price - sl)/Point()) *// MarketInfo(Symbol(), MODE_TICKVALUE)/ maxOrders;
      if(sVol < MarketInfo(Symbol(), MODE_MINLOT))
         sVol = MarketInfo(Symbol(), MODE_MINLOT);
      if(sVol > MarketInfo(Symbol(), MODE_MAXLOT))
         sVol = MarketInfo(Symbol(), MODE_MAXLOT);
   
      if(!OrderSend(Symbol(), cmd, sVol, price, slp, 0.0, 0.0, "Grid_3(+autolot +parallel)", magic)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
   }
}
//+---------------------------------------------------------------------+
//|   Continue()
//|   Выставляет ордера по достижении уровня сетки.
//|   
void Continue(int dir = -1){
   //int dir = GridDirection();   
   BuildGrid(dir);
}
//+---------------------------------------------------------------------+
//|   TakeProfit()
//|   Имитирует тейкпрофит.
//|   
void TakeProfit(){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   double profit = 0.0;
   int total = OrdersTotal();
   
   for(int i = 0; i < total; i++){
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
   if(profit > prof*sVol/MarketInfo(Symbol(), MODE_MINLOT))
      CloseAllGrid();
}
//+---------------------------------------------------------------------+
//|   CloseAllGrid()
//|   Закрывает все ордера.
//|   Вызывается при помощи функции TakeProfit()
void CloseAllGrid(){
   while(Total() > 0){
      MqlTick tick;
      RefreshRates();
      SymbolInfoTick(Symbol(), tick);
      int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
      int total = OrdersTotal();
      double price = 0.0;
      
         Print("Не правильная цена.");
      for(int i = total - 1; i >= 0; i--){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__, "  ",GetLastError());
            
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            if(OrderType() == OP_BUY)
               price = tick.bid;
            else if(OrderType() == OP_SELL)
               price = tick.ask;
            else
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
double SetLevelOfClose(double tp){
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

//+---------------------------------------------------------------------+
//|   GridDirection()
//|   возвращает направление сетки.
//|   BUY или SELL

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

//+---------------------------------------------------------------------+
//|   GainedLevel()
//|   Если достигнут уровень, то можно выставлять ордер.
//|   Перебираем с последних выставленных ордеров (задом наперед)

void BuildGrid(int dir = -1){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)((tick.ask - tick.bid)/Point());
   double price = 0.0;
   
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--){
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(dir == OP_BUY){
            if(tick.ask < (OrderOpenPrice() - avrCnd)){
               price = tick.ask;
               break;
            }
         }
         if(dir == OP_SELL){
            if(tick.bid > (OrderOpenPrice() + avrCnd)){
               price = tick.bid;
               break;
            }
         }
      }
   }

   if(price != 0){
      ResetLastError();
      if(!OrderSend(Symbol(), dir, sVol*2, price, slp, 0.0, 0.0, "Grid_3(+autolot +parallel)", magic)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
   }
}


bool CalculateAverageCandle(){
   double count = 0.;
   MqlRates rates[];
   RefreshRates();
   
   int bars = iBars(Symbol(), PERIOD_CURRENT);
   
   if(bars < 2)
      return false;
 
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