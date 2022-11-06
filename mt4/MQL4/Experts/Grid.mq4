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

SpreadController sc;

input int      magic = 53124312;
input double   lot   = 0.01;
//input int      grid  = 30;    //Сетка
input int      maxOrders = 7; //Макс ордерс
input int      sprd  = 5;  //Спред для начала торговли
//int TP = grid;    //ТП

//double grd;
//double tkp;
double avrCnd;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
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
   if(Total() == 0 && sc.CompareSpread(sprd))
      Start();
   else{
      TakeProfit();
      if(Total() < maxOrders)
         Continue();
   }
}

//---> Количество ордеров, выставленных экспертом на символе
int Total(){
   int count = 0;
   if(OrdersTotal() != 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__,"  ",GetLastError());
            return count;
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            count++;
         }
      }
   }
   //Print("count = ",count);
   return count;
}

void Start(){
   int cmd = -1;
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
   int slp = (int)((tick.ask - tick.bid)/Point());
   if(/*rates[0].open < rates[0].close && 
      rates[1].open < rates[1].close && 
      rates[2].open < rates[2].close*/
      iRSI(Symbol(), PERIOD_H1, 14, PRICE_CLOSE, 0) <= 30){
      
      cmd   = OP_BUY;
      price = NormalizeDouble(tick.ask, Digits());
   }
   else if(/*rates[0].open > rates[0].close && 
           rates[1].open > rates[1].close && 
           rates[2].open > rates[2].close*/
      iRSI(Symbol(), PERIOD_H1, 14, PRICE_CLOSE, 0) >= 70){
           
      cmd   = OP_SELL;
      price = NormalizeDouble(tick.bid, Digits());
   }
   else
      return;
   if(price != 0.0){
      if(!OrderSend(Symbol(), cmd, lot, price, slp, 0.0, 0.0, NULL, magic)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
   }
}
//+---------------------------------------------------------------------+
//|   Continue()
//|   Выставляет ордера по достижении уровня сетки.
//|   
void Continue(){
   int dir = GridDirection();   
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
}
//+---------------------------------------------------------------------+
//|   CloseAllGrid()
//|   Закрывает все ордера.
//|   Вызывается при помощи функции TakeProfit()
void CloseAllGrid(int dir){
   while(Total() > 0){
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
      for(int i = 0; i < total; i++){
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
      if(!OrderSend(Symbol(), dir, lot*2, price, slp, 0.0, 0.0, NULL, magic)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
   }
}


bool CalculateAverageCandle(){
   double count = 0.;
   MqlRates rates[];
   RefreshRates();
   
   int bars = iBars(Symbol(), PERIOD_H1);
   
   if(bars < 2)
      return false;
 
   CopyRates(Symbol(), PERIOD_H1, 1, bars - 1, rates);
   if(ArraySize(rates) == 0){
      return false;
   }
  
   for(int i = 0; i < ArraySize(rates); i++){
      count += (rates[i].high - rates[i].low);
   }
   
   avrCnd = NormalizeDouble((count/ArraySize(rates)), Digits());
   return true;
}