//+------------------------------------------------------------------+
//|                                                          123.mq4 |
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
input int magic    = 324;  //Magic
//input double vol   = 0.01; //Объем
input cents    risk  = 10;        //Риск
input int      maxOrders = 20;   //Макс ордерс
input int offset   = 100;  //Отступ от МА
input int MAperiod = 233;  //Период МА
input double k = 2.0;      //Коэффициент сетки
double   prof  = 2.0;      //стартовая сумма закрытия ордеров
int mtp;
int SL = 0;
int TP = 0;
string botName = "123456";
double avrCnd;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   avrCnd = 0.0;
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
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
   if(!CalculateAverageCandle())
      return;
   SendOrders();
   Handling();
}
//+------------------------------------------------------------------+

void SendOrders(){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 20, rates);
   if(ArraySize(rates) < 20)
      return;
   bool buy = false;
   bool sell = false;
   bool t = false;
   if(OrdersTotal() > 0){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         t = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP)
               buy = true;
            if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP)
               sell = true;
         }
      }
   }
   if(!buy){
      if(rates[0].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  1) &&
         rates[1].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  2) &&
         rates[2].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  3) &&
         rates[3].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  4) &&
         rates[4].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  5) &&
         rates[5].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  6) &&
         rates[6].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  7) &&
         rates[7].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  8) &&
         rates[8].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  9) &&
         rates[9].high  < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 10) &&
         rates[10].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 11) &&
         rates[11].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 12) &&
         rates[12].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 13) &&
         rates[13].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 14) &&
         rates[14].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 15) &&
         rates[15].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 16) &&
         rates[16].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 17) &&
         rates[17].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 18) &&
         rates[18].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 19) &&
         rates[19].high < iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 20))
         trade.BuyStop(Symbol(), PERIOD_CURRENT, Vol(), NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) + offset*mtp*Point(), Digits()), SL, TP);
         
   }
   if(!sell){
      if(rates[0].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  1) &&
         rates[1].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  2) &&
         rates[2].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  3) &&
         rates[3].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  4) &&
         rates[4].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  5) &&
         rates[5].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  6) &&
         rates[6].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  7) &&
         rates[7].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  8) &&
         rates[8].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE,  9) &&
         rates[9].low  > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 10) &&
         rates[10].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 11) &&
         rates[11].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 12) &&
         rates[12].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 13) &&
         rates[13].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 14) &&
         rates[14].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 15) &&
         rates[15].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 16) &&
         rates[16].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 17) &&
         rates[17].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 18) &&
         rates[18].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 19) &&
         rates[19].low > iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 20))
         trade.SellStop(Symbol(), PERIOD_CURRENT, Vol(), NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1) - offset*mtp*Point(), Digits()), SL, TP);
   
   }
}

void Handling(){
   TralStops();
   BuildGrid();
   for(int i = 0; i < 2; i++){
      TakeProfit(i);
   }
}

void TralStops(){
   if(OrdersTotal() == 0)
      return;
   bool t = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         double buy = NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1)+offset*mtp*Point(), Digits());
         double sell = NormalizeDouble(iMA(Symbol(), PERIOD_CURRENT, MAperiod, 0, MODE_EMA, PRICE_CLOSE, 1)-offset*mtp*Point(), Digits());
         if(OrderType() == OP_BUYSTOP && OrderOpenPrice() > buy){
            t = OrderModify(OrderTicket(), buy, OrderStopLoss(), OrderTakeProfit()/*NormalizeDouble(buy - SL*mtp*Point(), Digits()), NormalizeDouble(buy + TP*mtp*Point(), Digits())*/, 0);
            //Print("SL: ",NormalizeDouble(OrderStopLoss()+ offset*mtp*Point(), Digits()), "  TP: ",NormalizeDouble(OrderTakeProfit()+ offset*mtp*Point(), Digits()));
         }
         if(OrderType() == OP_SELLSTOP && OrderOpenPrice() < sell){
            t = OrderModify(OrderTicket(),sell, OrderStopLoss(), OrderTakeProfit()/*NormalizeDouble(sell + SL*mtp*Point(), Digits()), NormalizeDouble(sell - TP*mtp*Point(), Digits())*/, 0);
            //Print("SL: ",NormalizeDouble(OrderStopLoss()- offset*mtp*Point(), Digits()), "  TP: ",NormalizeDouble(OrderTakeProfit()- offset*mtp*Point(), Digits()));
         }
      }
   }
}

void BuildGrid(){
   if(OrdersTotal() == 0)
      return;
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)MarketInfo(Symbol(), MODE_SPREAD);
   double price = 0.0;
   bool t = false;
   if(Total(0) < maxOrders){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         t = OrderSelect(i, SELECT_BY_POS);
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            if(OrderType() == OP_BUY){
               if(tick.ask < (OrderOpenPrice() - avrCnd)){
                  trade.Buy(Symbol(), PERIOD_CURRENT, OrderLots(), 0, 0, botName);
                  price = tick.ask;
               }
               break;
            }
         }
      }
   }
   if(Total(1) < maxOrders){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         t = OrderSelect(i, SELECT_BY_POS);
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            if(OrderType() == OP_SELL){
               if(tick.bid > (OrderOpenPrice() + avrCnd)){
                  trade.Sell(Symbol(), PERIOD_CURRENT, OrderLots(), 0, 0, botName);
               }
               break;
            }
         }
   }  
   } 
}

bool CalculateAverageCandle(){
   double count = 0.;
   MqlRates rates[];
   RefreshRates();
   
   
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 100, rates);
   if(ArraySize(rates) < 100){
      return false;
   }
  
   for(int i = 0; i < ArraySize(rates); i++){
      count += (rates[i].high - rates[i].low);
   }
   
   avrCnd = NormalizeDouble((count/ArraySize(rates))*k, Digits());
   return true;
}

void TakeProfit(int dir = -1){
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
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == dir)
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      
   }
   if(profit > prof*Vol()/MarketInfo(Symbol(), MODE_MINLOT))
      CloseAllGrid(dir);
}

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

double Vol(){
      double sVol = (AccountEquity()/100*risk) / (avrCnd/Point())/*((price - sl)/Point()) *// MarketInfo(Symbol(), MODE_TICKVALUE)/ maxOrders;
      if(sVol < MarketInfo(Symbol(), MODE_MINLOT))
         sVol = MarketInfo(Symbol(), MODE_MINLOT);
      if(sVol > MarketInfo(Symbol(), MODE_MAXLOT))
         sVol = MarketInfo(Symbol(), MODE_MAXLOT);
   return sVol;
}

double MartinLot(){
   if(OrdersHistoryTotal() == 0)
      return Vol();
   bool t = false;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         if(OrderProfit() < 0.0)
            return Vol();//OrderLots()*2;
         else
            return Vol();
   }
   return Vol();
}