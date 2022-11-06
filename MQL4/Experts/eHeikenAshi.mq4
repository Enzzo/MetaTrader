//+------------------------------------------------------------------+
//|                                                  eHeikenAshi.mq4 |
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

input int      magic    = 878787; //магик
input int      SL       = 20;     //СЛ
input int      TP       = 40;     //ТП
input double   volume   = 0.01;   //объем
input int      D1_MA_period = 24; //мувинг для D1
input int      H4_MA_period = 24; //мувинг для H4

double sl;
double tp;

int OnInit(){
   
   sl = NormalizeDouble(SL*Point(),Digits());
   tp = NormalizeDouble(TP*Point(), Digits());
   
   if(Digits() == 3 || Digits() == 5){
      sl = NormalizeDouble(SL*Point()*10,Digits());
      tp = NormalizeDouble(TP*Point()*10, Digits());
   }
   
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
   if(Idle()){
      Scan();
   }
}
//+------------------------------------------------------------------+

bool Idle(){
   if(OrdersTotal() > 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__, " Ошибка выбора ордера для проверки. ", GetLastError());
            continue;
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic)
            return false;
      }
   }
   return true;
}

void Scan(){
   MqlRates D1_rates[];
   MqlRates H4_rates[];
   MqlRates H1_rates[];
   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1, 1, 1, D1_rates);
   CopyRates(Symbol(), PERIOD_H4, 1, 1, H4_rates);
   CopyRates(Symbol(), PERIOD_H1, 1, 2, H1_rates);
   
   if(ArraySize(D1_rates) < 1 || ArraySize(H4_rates) < 1 || ArraySize(H1_rates) < 2)
      return;
      
   ArraySetAsSeries(H1_rates, true);
   
   double D1_MA = iMA(Symbol(), PERIOD_D1, D1_MA_period, 0, MODE_EMA, PRICE_CLOSE, 1);
   double H4_MA = iMA(Symbol(), PERIOD_H4, H4_MA_period, 0, MODE_EMA, PRICE_CLOSE, 1);

   double H1_Open   = (H1_rates[1].open  +  H1_rates[1].close)/2;
   double H1_Close  = (H1_rates[0].open  +  H1_rates[0].close  +  H1_rates[0].high + H1_rates[0].low)/4;
   //double H1_High   = Max(H1_rates[0].open, H1_rates[0].close, H1_rates[0].high);
   //double H1_Low    = Min(H1_rates[0].open, H1_rates[0].close, H1_rates[0].low);
   
   //double H4_Open   = (H4_rates[1].open  +  H4_rates[1].close)/2;
   double H4_Close  = H4_rates[0].close;//(H4_rates[0].open  +  H4_rates[0].close  +  H4_rates[0].high + H4_rates[0].low)/4;
   //double H4_High   = Max(H4_rates[0].open, H4_rates[0].close, H4_rates[0].high);
   //double H4_Low    = Min(H4_rates[0].open, H4_rates[0].close, H4_rates[0].low);
   
   //double D1_Open   = (D1_rates[1].open  +  D1_rates[1].close)/2;
   double D1_Close  = D1_rates[0].close;//(D1_rates[0].open  +  D1_rates[0].close  +  D1_rates[0].high + D1_rates[0].low)/4;
   //double D1_High   = Max(D1_rates[0].open, D1_rates[0].close, D1_rates[0].high);
   //double D1_Low    = Min(D1_rates[0].open, D1_rates[0].close, D1_rates[0].low);
   
   /*
   Print("H1_Open: ",H1_Open," H1_Close: ",H1_Close," H1_High: ",H1_High," H1_Low: ",H1_Low);
   Print("H4_Open: ",H4_Open," H4_Close: ",H4_Close," H4_High: ",H4_High," H4_Low: ",H4_Low);
   Print("D1_Open: ",D1_Open," D1_Close: ",D1_Close," D1_High: ",D1_High," D1_Low: ",D1_Low);
   Print("                                   ");*/
   //BUY
   if(/*D1_Open < D1_Close && D1_High > D1_MA &&
      H4_Open < H4_Close && H4_High > H4_MA &&
      H1_Open < H1_Close*/
      D1_Close > D1_MA &&
      H4_Close > H4_MA &&
      H1_Open  < H1_Close){
      //Print(H1_Open," < ",H1_Close,"  ",H4_Close," > ",H4_MA,"  ",D1_Close," > ",D1_MA);
      
      Print("buy");
      SendOrder(0);
      
   }
   
   //SELL
   if(/*D1_Open > D1_Close && D1_Low < D1_MA &&
      H4_Open > H4_Close && H4_Low < H4_MA &&
      H1_Open > H1_Close*/
      D1_Close < D1_MA &&
      H4_Close < H4_MA &&
      H1_Open  > H1_Close){
      //Print(H1_Open," > ",H1_Close,"  ",H4_Close," < ",H4_MA,"  ",D1_Close," < ",D1_MA);
      Print("sell");
      SendOrder(1);
   }
}

void SendOrder(ushort type = -1){
   
   int    _cmd   = -1;
   int    _slp   = 0;
   double _price = 0.0;
   double _sl    = 0.0;
   double _tp    = 0.0;
   MqlTick last;
   
   RefreshRates();
   SymbolInfoTick(Symbol(), last);
   _slp = (int)(last.ask - last.bid);
   
   switch(type){
      case 0:
         _cmd = OP_BUY;
         _price = NormalizeDouble(last.ask, Digits());
         _sl = _price - sl;
         _tp = _price + tp;
         break;
      case 1:
         _cmd = OP_SELL;
         _price = NormalizeDouble(last.bid, Digits());         
         _sl = _price + sl;
         _tp = _price - tp;
         break;
      default:    return;
   }
   
   if(_price == 0.0)
      return;
   
   ResetLastError();
   if(!OrderSend(Symbol(), _cmd, volume, _price, _slp, _sl, _tp, NULL, magic)){
      Print(__FUNCTION__, " Ошибка выставления ордера. ", GetLastError());
      return;
   }
   return;   
}

double Min(double o, double c, double l){
   double min = o;
   if(min > c)
      min = c;
   if(min > l)
      min = l;
   return min;
}

double Max(double o, double c, double h){
   double max = o;
   if(max < c)
      max = c;
   if(max < h)
      max = h;
   return max;
}
