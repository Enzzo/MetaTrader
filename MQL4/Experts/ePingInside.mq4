//+------------------------------------------------------------------+
//|                                                    ePAIBFake.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
/*
enum directions{
   direct,  //прямое 
   fake,    //фейковое
   both     //в обе стороны
};*/

input int      magic       = 123321;//Магик
//input directions dir       = 0;     //направление
input double   volume      = 0.01;  //Объем
input int      offset      = 5;     //Сдвиг для ордера (пункты)
input int      stoploss    = 20;    //СЛ (пункты)
input int      takeprofit  = 40;    //ТП (пункты)
input int      expiration  = 8;     //экспирация (часы)

int type;
double offs;
double SL;
double TP;
double level1;
double level2;
double level3;
double level4;
double vol;

MqlRates rates[];

int OnInit(){
//---
   type = -1;
   
   if(Digits() == 3 || Digits() == 5){
      offs  = NormalizeDouble(offset      * Point(), Digits()) * 10;
      SL    = NormalizeDouble(stoploss    * Point(), Digits()) * 10;
      TP    = NormalizeDouble(takeprofit  * Point(), Digits()) * 10;
   }
   else{
      offs  = NormalizeDouble(offset      * Point(), Digits());
      SL    = NormalizeDouble(stoploss    * Point(), Digits());
      TP    = NormalizeDouble(takeprofit  * Point(), Digits());
   }
   
   level1 = 0.0;
   level2 = 0.0;
   level3 = 0.0;
   level4 = 0.0;
   vol    = volume;
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name;
   for(int i = 0; i<total; i++){
      name = "IB_" + IntegerToString(i);
         if(ObjectFind(ChartID(), name)!= -1)
            ObjectDelete(ChartID(), name);

   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   if(Idle())
      if(InsideBar())
         SendOrder();
   else{   
      Ping();
      //bu
      //tral
   }
}
//+------------------------------------------------------------------+

bool Idle(void){
   
   if(OrdersTotal() > 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__, " Ошибка выбора ордера. ",GetLastError());
            return false;
         }
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            return false;
         }
      }
   }   
   return true;
};

bool InsideBar(void){
   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 2, rates);
   
   if(ArraySize(rates) < 2)
      return false;
   
   ArraySetAsSeries(rates, true);
   
   if(rates[0].high < rates[1].high && rates[0].low > rates[1].low){
      //type = -1;
      if(rates[0].close > rates[0].open && rates[1].close < rates[1].open){
         type = 0;//buy
         DrawIB();
         return true;
      }
      if(rates[0].close < rates[0].open && rates[1].close > rates[1].open){
         type = 1;//sell
         DrawIB();
         return true;
      }
   }
   
   return false;
};

void SendOrder(void){
   
   MqlTick tick;
   
   int      cmd   = -1;
   double   price = 0.0;
   int      slp = 0;
   double   sl = 0.0;
   double   tp = 0.0;
   datetime expir = TimeCurrent() + expiration * 3600;
   color    clr;
   
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   slp = (int)(tick.ask - tick.bid);
   
   /*
   if(dir == fake){
      if(type == 1)
         type = 0;
      else if(type == 0)
         type = 1;
   }
   
   if(dir == both)
      type = 0;
   
   switch(type){
      case 0:*/
   cmd   = OP_BUYSTOP;
   price = NormalizeDouble(rates[1].high + offs, Digits());
   sl    = NormalizeDouble(price - SL,   Digits());
   tp    = NormalizeDouble(price + TP,   Digits());
   clr   = clrBlue;
         
   //      if(dir == both){
   ResetLastError();
      if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, NULL, magic, expir, clr)){
         Print(__FUNCTION__, " Ошибка выставления ордера. ", GetLastError());
         return;
      }
   /*}
         else
            break;
      case 1:*/
   cmd   = OP_SELLSTOP;
   price = NormalizeDouble(rates[1].low - offs, Digits());
   sl    = NormalizeDouble(price + SL,   Digits());
   tp    = NormalizeDouble(price - TP,   Digits());
   clr   = clrRed;
   /*break;
      default: return;
   }
   */
   ResetLastError();
   if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, NULL, magic, expir, clr)){
      Print(__FUNCTION__, " Ошибка выставления ордера. ", GetLastError());
      return;
   }
}

void DrawIB(){
   static int n = 0;
   string name = "IB_"+IntegerToString(n);
   long clr = 0;
   static datetime ctime = 0;
   
   if(ctime == Time[0])
      return;
   ctime = Time[0];
      
   double price[2];
   datetime time[2];
   
   price[0] = rates[1].high;
   price[1] = rates[1].low;
   
   time[0] = rates[0].time;
   time[1] = rates[1].time;
      
   switch(type){
      case 0:
         n++; clr = clrBlue; break;
      case 1:
         n++; clr = clrRed; break;
      default: return;
   }
   
   ObjectCreate(ChartID(),name, OBJ_RECTANGLE, 0, time[0], price[0], time[1], price[1]);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, clr);
}

void Ping(void){
   if(CanPing())
      Continue();
   else
      return;
}

bool CanPing(){
   
   int curTicket  = 0;
   int pendTicket = 0;
   
   if(OrdersTotal() > 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__, " Ошибка выбора ордера. ",GetLastError());
            return false;
         }
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               curTicket = OrderTicket();
               
               if(OrderType() == OP_BUY){
                  level1 = OrderTakeProfit();
                  level2 = OrderOpenPrice();
                  level3 = OrderStopLoss();
                  level4 = OrderStopLoss() - (OrderOpenPrice() - OrderStopLoss());
               }
               else if(OrderType() == OP_SELL){
                  level1 = OrderStopLoss() + (OrderStopLoss() - OrderOpenPrice());
                  level2 = OrderStopLoss();
                  level3 = OrderOpenPrice();
                  level4 = OrderTakeProfit();
               }
               
            }
            if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
               pendTicket = OrderTicket();
            }
         }
      }
   } 
   if(curTicket > 0 && pendTicket > 0){
      ResetLastError();
      if(!OrderSelect(pendTicket, SELECT_BY_TICKET)){
         Print(__FUNCTION__, " Ошибка выбора ордера. ",GetLastError());
         return false;
      }
      if(OrderLots() == volume){
         ResetLastError();
         if(!OrderDelete(pendTicket)){
            Print(__FUNCTION__, " Ошибка удаления ордера. ",GetLastError());
            return false;
         }
      }
      
      return true;
   }
   if(curTicket > 0)
      return true;
   
   return false;
}

void Continue(){  
   
   int pTicket = 0;
   int _type    = 0;
   bool cur    = false;
   bool pend   = false;
   int slp     = 0.0;
 
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            _type = OrderType();
            cur = true;
            vol = OrderLots();
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
            pTicket = OrderTicket();
            pend = true;
         }
      }         
   }
   
   if(cur && !pend){
      int lCmd;
      double lPrice  = 0.0;
      double lTP     = 0.0;
      double lSL     = 0.0;
      
      if(_type == OP_BUY){
         lCmd = OP_SELLSTOP;
         lSL    = level2;
         lPrice = level3;
         lTP    = level4;
      }
      
      else if(_type == OP_SELL){
         lCmd = OP_BUYSTOP;
         lPrice = level2;
         lSL    = level3;
         lTP    = level1;
      }
      if(lPrice != 0.0){
      
         vol *= 2;
         RefreshRates();
         slp = (int)((MarketInfo(Symbol(), MODE_ASK) - MarketInfo(Symbol(), MODE_BID))/Point());
         ResetLastError();
         if(!OrderSend(Symbol(), lCmd, vol, lPrice, slp, lSL, lTP, NULL, magic)){
            Print(__FUNCTION__, " Ошибка удаления ордера: ", GetLastError());
            return;
         }        
      }
      CheckOrders();
      return;
   }
   
   if(cur && pend){
      CheckOrders();
      return;
   }
   
   if(!cur && pend){
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," Ошибка удаления ордера: ", GetLastError());
         return;
      }
      CheckOrders();
      //Init();
   }  
}
void CheckOrders(){
   bool isBuy = false;     //начилие баевских
   bool isSell = false;    //наличие селовских
   int ticket = 0;
   double _lots =  0.0;
   double _price = 0.0;
   int slp = 0;
   
   int total = OrdersTotal();
   
   if (total == 0)
      return;
      
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ошибка выбора ордера для проверки." ,GetLastError());
         return;
      }
      
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP)
            isBuy = true;
         if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP)
            isSell = true;
      }
   }
   
   if((isBuy && !isSell) || (!isBuy && isSell)){
      //Print("buy = ",isBuy, "  sell = ",isSell);
      for(int i = 0; i < total; i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," ошибка выбора ордера." ,GetLastError());
            return;
         }
         
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            
            ticket = OrderTicket();
            if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
               if(!OrderDelete(ticket)){
                  Print(__FUNCTION__," ошибка удаления ордера." ,GetLastError());
                  return;
               }
            }
            
            if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               if(OrderType() == OP_BUY){
                  RefreshRates();
                  _price = MarketInfo(Symbol(), MODE_ASK);//last.ask;
               }
               if(OrderType() == OP_SELL){
                  RefreshRates();
                  _price = MarketInfo(Symbol(), MODE_BID);//last.bid;
               }
               _lots = OrderLots();
               
               RefreshRates();
               slp = (int)((MarketInfo(Symbol(), MODE_ASK) - MarketInfo(Symbol(), MODE_BID))/Point());
               if(!OrderClose(ticket, _lots, _price, slp)){
                  Print(__FUNCTION__," ошибка удаления ордера. " ,GetLastError());
                  return;
               }
            }
         }
      }
      //Init();
   }
}