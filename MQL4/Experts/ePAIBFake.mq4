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

enum directions{
   forward,       //прямое 
   backward,      //обратное
   both,          //в обе стороны
   fakeForward,   //фейковое прямое
   fakeBackward,  //фейковое обратное
   fakeBoth       //фейковое в обе стороны
};

input int      magic       = 123321;//Магик
input directions dir       = 0;     //направление
input double   volume      = 0.01;  //Объем
input int      offset      = 5;     //Сдвиг для ордера (пункты)
input int      stoploss    = 20;    //СЛ (пункты)
input int      takeprofit  = 40;    //ТП (пункты)
input int      expiration  = 8;     //экспирация (часы)

int type;
double offs;
double SL;
double TP;

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
         Trade();
   else{   
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
      type = -1;
      if(rates[0].close > rates[0].open && rates[1].close < rates[1].open)
         type = 0;//buy
      if(rates[0].close < rates[0].open && rates[1].close > rates[1].open)
         type = 1;//sell
      DrawIB();
      return true;
   }
   
   return false;
};

void SendOrder_old(void){
   
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
   
   if(dir == backward){
      if(type == 1)
         type = 0;
      else if(type == 0)
         type = 1;
   }
   
   if(dir == both)
      type = 0;
   
   switch(type){
      case 0:
         cmd   = OP_BUYSTOP;
         price = NormalizeDouble(rates[1].high + offs, Digits());
         sl    = NormalizeDouble(price - SL,   Digits());
         tp    = NormalizeDouble(price + TP,   Digits());
         clr   = clrBlue;
         
         if(dir == both){
            ResetLastError();
            if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, NULL, magic, expir, clr)){
               Print(__FUNCTION__, " Ошибка выставления ордера. ", GetLastError());
               return;
            }
         }
         else
            break;
      case 1:
         cmd   = OP_SELLSTOP;
         price = NormalizeDouble(rates[1].low - offs, Digits());
         sl    = NormalizeDouble(price + SL,   Digits());
         tp    = NormalizeDouble(price - TP,   Digits());
         clr   = clrRed;
         break;
      default: return;
   }
 
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

void Trade(){  
   
   int    cmd   =  -1;
   color  clr   = NULL;
   double price = 0.0;
   double sl    = 0.0;
   double tp    = 0.0;   
   
   if(dir == backward || dir == fakeBackward){
      if(type == 1)
         type = 0;
      else
         type = 1;
   }
   
   if(dir == both || dir == fakeBoth){
      type = 0;
   }      
   
   switch(type){
      case 0:
         if(dir < 3){
            cmd   = OP_BUYSTOP;
            clr   = clrBlue;
            price = NormalizeDouble(rates[1].high + offs, Digits());
            sl    = NormalizeDouble(price - SL, Digits());
            tp    = NormalizeDouble(price + TP, Digits());
            SendOrder(cmd, price, sl, tp, clr);
            if(dir != both)
               break;
         }
         else{
            cmd   = OP_SELLLIMIT;
            clr   = clrRed;
            price = NormalizeDouble(rates[1].high + offs, Digits());
            sl    = NormalizeDouble(price + SL, Digits());
            tp    = NormalizeDouble(price - TP, Digits());
            SendOrder(cmd, price, sl, tp, clr);
            if(dir != fakeBoth)
               break;
         }
      case 1:
         if(dir < 3){
            cmd   = OP_SELLSTOP;
            clr   = clrRed;
            price = NormalizeDouble(rates[1].low - offs, Digits());
            sl    = NormalizeDouble(price + SL, Digits());
            tp    = NormalizeDouble(price - TP, Digits());
            SendOrder(cmd, price, sl, tp, clr);
            break;
         }
         else{
            cmd   = OP_BUYLIMIT;
            clr   = clrBlue;
            price = NormalizeDouble(rates[1].low - offs, Digits());
            sl    = NormalizeDouble(price - SL, Digits());
            tp    = NormalizeDouble(price + TP, Digits());
            SendOrder(cmd, price, sl, tp, clr);
            break;
         }
      default: return;
   }
}

void SendOrder(int cmd, double price = 0.0, double sl = 0.0, double tp = 0.0, color clr = NULL){
      
   if(price == 0.0)
      return;
   
   MqlTick tick;
   int      slp   = 0;
   datetime expir = TimeCurrent() + expiration * 3600;
   
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   slp = (int)(tick.ask - tick.bid);
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, NULL, magic, expir, clr)){
      Print(__FUNCTION__, " Ошибка выставления ордера. ", GetLastError());
      return;
   }
}