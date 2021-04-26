//+------------------------------------------------------------------+
//|                                               eHeikenAshi_v3.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

input int      magic          = 543345;   //Магик
input double   volume         = 0.01;     //Объем
input int      TP             = 50;       //Тейкпрофит
//input int      SL             = 25;     //Стоплос
input bool     terminator     = true;    //Использовать терминатора
input string   comment0       = "   ФИЛЬТРЫ   ";//-------------------->
input ushort   n              = 3;        //Количество свечей
input bool     useMA          = true;    //Фильтр МА
input bool     useTrueMA      = true;    //--> Правильный МА
input bool     useFilterBody  = false;    //Фильтр тел
input bool     useFilterTails = false;    //Фильтр теней

enum dir{unknown, bull, bear};


double HA_H1_body[];
double HA_H1_upperTail[];
double HA_H1_lowerTail[];
double HA_H1_open[];
double HA_H1_close[];
double HA_H1_high[];
double HA_H1_low[];
   
double HA_H4_body[];
double HA_H4_upperTail[];
double HA_H4_lowerTail[];
double HA_H4_open[];
double HA_H4_close[];
double HA_H4_high[];
double HA_H4_low[];
   
double HA_D1_body[];
double HA_D1_upperTail[];
double HA_D1_lowerTail[];
double HA_D1_open[];
double HA_D1_close[];
double HA_D1_high[];
double HA_D1_low[];

double MA_H4[];
double MA_D1[];
   
dir HA_H1_direction[];
dir HA_H4_direction[];
dir HA_D1_direction[];

double tkp;
//double stl;
int type;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){ 
   
   tkp = NormalizeDouble(TP * Point(), Digits());
   //stl = NormalizeDouble(SL * Point(), Digits());
   
   if(Digits() == 3 || Digits() == 5){
      tkp = NormalizeDouble(TP * Point(), Digits()) * 10;
      //stl = NormalizeDouble(SL * Point(), Digits()) * 10;
   }
   type = -1;
   
   ArrayResize(HA_H1_open, n+1);
   ArrayResize(HA_H4_open, n+1);
   ArrayResize(HA_D1_open, n+1);   
   HA_H1_open[n] = 0.0;
   HA_H4_open[n] = 0.0;
   HA_D1_open[n] = 0.0;
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   
   if(n < 2){
      Comment("Не достаточное количество свечей");
      return;
   }
   
   if(Trading()){
      Tral();
      if(terminator)
         if(CalculateHAPatterns())
            if(DefineDirection())
               if(/*!TrueMA() && */!FilterBody()/* && !FilterTails()*/)
                  Terminator();
      return;
   }
   
   Trade();
}
//+------------------------------------------------------------------+
//|
//|   Trading()
//|   Если ордер открыт, то возвращает true
//|   Если ордеров нет, то false
//|
//+------------------------------------------------------------------+

bool Trading(){
   if(OrdersTotal() > 0){
      for(int i = 0; i < OrdersTotal(); i++){
         _OrderSelect(i);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
            return true;
      }
   }
   return false;
}


//+------------------------------------------------------------------+
//|
//|   Trade()
//|   1. Рассчитываем HeikenAshi свечи.
//|   2. Определяем направление и передаем его в переменную type
//|   3. Проходим через фильтрацию
//|   4. Устанавливаем параметры выставляемого ордера
//|   5. Выставляем ордер
//|
//+------------------------------------------------------------------+
void Trade(){
   
   ArrayResize(HA_H1_body, n);
   ArrayResize(HA_H1_upperTail, n);
   ArrayResize(HA_H1_lowerTail, n);
   ArrayResize(HA_H1_open, n+1);
   ArrayResize(HA_H1_close, n+1);
   ArrayResize(HA_H1_high, n);
   ArrayResize(HA_H1_low, n);
   
   ArrayResize(HA_H4_body, n);
   ArrayResize(HA_H4_upperTail, n);
   ArrayResize(HA_H4_lowerTail, n);
   ArrayResize(HA_H4_open, n+1);
   ArrayResize(HA_H4_close, n+1);
   ArrayResize(HA_H4_high, n);
   ArrayResize(HA_H4_low, n);
   
   ArrayResize(HA_D1_body, n);
   ArrayResize(HA_D1_upperTail, n);
   ArrayResize(HA_D1_lowerTail, n);
   ArrayResize(HA_D1_open, n+1);
   ArrayResize(HA_D1_close, n+1);
   ArrayResize(HA_D1_high, n);
   ArrayResize(HA_D1_low, n);
   
   ArrayResize(HA_H1_direction, n);
   ArrayResize(HA_H4_direction, n);
   ArrayResize(HA_D1_direction, n);
   
   ArrayResize(MA_H4, n);
   ArrayResize(MA_D1, n);
   
   
   if(!CalculateHAPatterns())
      return;
   
   if(!DefineDirection())
      return;
   
   if(useMA)
      if(!FilterMA())
         return;
   
   if(useTrueMA)
      if(!TrueMA())
         return;
      
   
   if(useFilterBody)
      if(!FilterBody())
         return;
         
   if(useFilterTails)
      if(!FilterTails())
         return;
   
   int cmd = -1;
   double price = 0.0;
   double sl = 0.0;
   double tp = 0.0;
   
   if(!SetParameters(cmd, price, sl, tp))
      return;
   
   _SendOrder(cmd, price, sl, tp);
}


//+------------------------------------------------------------------+
//|
//|   CalculateHAPatterns()
//|   
//|   Может вызываться в любом месте программы.
//|   
//|   Рассчитываем HA-свечи, направление HA-свечей и координаты iMA на H4 и D1
//|   Если количество скопированных котировок меньше, чем необходимых
//|   свечей (ArraySize(rates) < n), то возвращает false и выходим
//|
//+------------------------------------------------------------------+
bool CalculateHAPatterns(){
   MqlRates H1_rates[];
   MqlRates H4_rates[];
   MqlRates D1_rates[];
   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_H1, 0, n+1, H1_rates);
   CopyRates(Symbol(), PERIOD_H4, 0, n+1, H4_rates);
   CopyRates(Symbol(), PERIOD_D1, 0, n+1, D1_rates);
   
   ArraySetAsSeries(H1_rates, true);
   ArraySetAsSeries(H4_rates, true);
   ArraySetAsSeries(D1_rates, true);
 
   if(ArraySize(H1_rates) < n+1 || ArraySize(H4_rates) < n+1 || ArraySize(D1_rates) < n+1)
      return false;
   
   if(HA_H1_open[n] == 0.0)
      HA_H1_open[n] = H1_rates[n].open;
   if(HA_H4_open[n] == 0.0)
      HA_H4_open[n] = H4_rates[n].open;
   if(HA_D1_open[n] == 0.0)
      HA_D1_open[n] = D1_rates[n].open;
   
   HA_H1_close[n] = NormalizeDouble((H1_rates[n].open + H1_rates[n].close + H1_rates[n].high + H1_rates[n].low)/4, Digits());
   HA_H4_close[n] = NormalizeDouble((H4_rates[n].open + H4_rates[n].close + H4_rates[n].high + H4_rates[n].low)/4, Digits());
   HA_D1_close[n] = NormalizeDouble((D1_rates[n].open + D1_rates[n].close + D1_rates[n].high + D1_rates[n].low)/4, Digits());
   
   for(int i = n - 1; i >= 0; i--){
      
      //H1      
      HA_H1_close[i]= NormalizeDouble((H1_rates[i].open + H1_rates[i].close + H1_rates[i].high + H1_rates[i].low)/4, Digits());
      HA_H1_open[i] = NormalizeDouble((HA_H1_open[i+1] + HA_H1_close[i+1])/2, Digits());
      HA_H1_high[i] = NormalizeDouble(Max(HA_H1_open[i], HA_H1_close[i], H1_rates[i].high), Digits());
      HA_H1_low[i]  = NormalizeDouble(Min(HA_H1_open[i], HA_H1_close[i], H1_rates[i].low), Digits());
      
      
      if(HA_H1_open[i] < HA_H1_close[i]){
         HA_H1_body[i] = NormalizeDouble(HA_H1_close[i] - HA_H1_open[i], Digits());
         
         //if(HA_H1_high[i] == HA_H1_close[i]
         
         HA_H1_upperTail[i] = NormalizeDouble(HA_H1_high[i] - HA_H1_close[i], Digits());
         HA_H1_lowerTail[i] = NormalizeDouble(HA_H1_open[i] - HA_H1_low[i], Digits());
         HA_H1_direction[i] = bull;
      }
      else{
         HA_H1_body[i] = NormalizeDouble(HA_H1_open[i] - HA_H1_close[i], Digits());
         HA_H1_upperTail[i] = NormalizeDouble(HA_H1_high[i] - HA_H1_open[i], Digits());
         HA_H1_lowerTail[i] = NormalizeDouble(HA_H1_close[i] - HA_H1_low[i], Digits());
         HA_H1_direction[i] = bear;
      }
      
      //H4
      HA_H4_close[i]= NormalizeDouble((H4_rates[i].open + H4_rates[i].close + H4_rates[i].high + H4_rates[i].low)/4, Digits());
      HA_H4_open[i] = NormalizeDouble((HA_H4_open[i+1] + HA_H4_close[i+1])/2, Digits());
      HA_H4_high[i] = NormalizeDouble(Max(HA_H4_open[i], HA_H4_close[i], H4_rates[i].high), Digits());
      HA_H4_low[i]  = NormalizeDouble(Min(HA_H4_open[i], HA_H4_close[i], H4_rates[i].low), Digits());
      
      
      if(HA_H4_open[i] < HA_H4_close[i]){
         HA_H4_body[i] = NormalizeDouble(HA_H4_close[i] - HA_H4_open[i], Digits());
         HA_H4_upperTail[i] = NormalizeDouble(HA_H4_high[i] - HA_H4_close[i], Digits());
         HA_H4_lowerTail[i] = NormalizeDouble(HA_H4_open[i] - HA_H4_low[i], Digits());
         HA_H4_direction[i] = bull;
      }
      else{
         HA_H4_body[i] = NormalizeDouble(HA_H4_open[i] - HA_H4_close[i], Digits());
         HA_H4_upperTail[i] = NormalizeDouble(HA_H4_high[i] - HA_H4_open[i], Digits());
         HA_H4_lowerTail[i] = NormalizeDouble(HA_H4_close[i] - HA_H4_low[i], Digits());
         HA_H4_direction[i] = bear;
      }
      
      //D1
      HA_D1_close[i]= NormalizeDouble((D1_rates[i].open + D1_rates[i].close + D1_rates[i].high + D1_rates[i].low)/4, Digits());
      HA_D1_open[i] = NormalizeDouble((HA_D1_open[i+1] + HA_D1_close[i+1])/2, Digits());
      HA_D1_high[i] = NormalizeDouble(Max(HA_D1_open[i], HA_D1_close[i], D1_rates[i].high), Digits());
      HA_D1_low[i]  = NormalizeDouble(Min(HA_D1_open[i], HA_D1_close[i], D1_rates[i].low), Digits());
      
      
      if(HA_D1_open[i] < HA_D1_close[i]){
         HA_D1_body[i] = NormalizeDouble(HA_D1_close[i] - HA_D1_open[i], Digits());
         HA_D1_upperTail[i] = NormalizeDouble(HA_D1_high[i] - HA_D1_close[i], Digits());
         HA_D1_lowerTail[i] = NormalizeDouble(HA_D1_open[i] - HA_D1_low[i], Digits());
         HA_D1_direction[i] = bull;
      }
      else{
         HA_D1_body[i] = NormalizeDouble(HA_D1_open[i] - HA_D1_close[i], Digits());
         HA_D1_upperTail[i] = NormalizeDouble(HA_D1_high[i] - HA_D1_open[i], Digits());
         HA_D1_lowerTail[i] = NormalizeDouble(HA_D1_close[i] - HA_D1_low[i], Digits());
         HA_D1_direction[i] = bear;
      }
      //MA
      MA_H4[i] = iMA(Symbol(), PERIOD_H4, 24, 0, MODE_EMA, PRICE_CLOSE, i);
      MA_D1[i] = iMA(Symbol(), PERIOD_D1, 24, 0, MODE_EMA, PRICE_CLOSE, i);
   }   
   return true;
}

//+------------------------------------------------------------------+
//|
//|   DefineDirection()
//|   
//|   Для работы необходим проход функции:
//|      CalculateHAPatterns()
//|   
//|   Если тренда нет (type == -1), то возвращает false
//|
//+------------------------------------------------------------------+
bool DefineDirection(){
   
   type = -1;
   
   for(int i = 0; i < n; i++){
      if(HA_H1_direction[i] == bull && HA_H4_direction[i] == bull && HA_D1_direction[i] == bull)
         type = 0;
      else
         break;
   }
   for(int i = 0; i < n; i++){
      if(HA_H1_direction[i] == bear && HA_H4_direction[i] == bear && HA_D1_direction[i] == bear)
         type = 1;
      else
         break;
   }
   
   if(type >= 0)
      return true;
   else
      return false;
   
}

//+------------------------------------------------------------------+
//|
//|   FilterMA()
//|
//|   Для работы необходим проход функций:
//|      CalculateHAPatterns(), DefineDirection()
//|
//|   1. Если направление на BUY (type = 0), возвратит false, если хоть один MA над открытием HA-свечи
//|      Иначе - возвращает true;
//|   2. Если направление на SELL(type = 1), возвратит false, если хоть один MA под открытием HA-свечи
//|      Иначе - возвращает true;
//|
//+------------------------------------------------------------------+
bool FilterMA(){
   
   switch(type){
      case 0:
         for(int i = 0; i < n; i++){
            if(MA_H4[i] > HA_H4_open[i] || MA_D1[i] > HA_D1_open[i])
               return false;
         }return true;
      case 1:
         for(int i = 0; i < n; i++){
            if(MA_H4[i] < HA_H4_open[i] || MA_D1[i] < HA_D1_open[i])
               return false;
         }return true;
      default: return false;
   }
}


//+------------------------------------------------------------------+
//|
//|   TrueMA()
//|
//|   Для работы необходим проход функций:
//|      CalculateHAPatterns(), DefineDirection()
//|
//|   Рассчитывает изгиб MA
//|   
//|   Определяем по четыре точки MA на H4 и D1
//|
//+------------------------------------------------------------------+
bool TrueMA(){
  
   double D1_point[4];
   double H4_point[4];
   
   ZeroMemory(D1_point);
   ZeroMemory(H4_point);
   
   for(int i = 0; i < 4; i++){
      H4_point[i] = iMA(Symbol(), PERIOD_H4, 24, 0, MODE_EMA, PRICE_CLOSE, i);
      D1_point[i] = iMA(Symbol(), PERIOD_D1, 24, 0, MODE_EMA, PRICE_CLOSE, i);
   }
   
   switch(type){
      case 0:
         for(int i = 0; i < 2; i++){            
            if(H4_point[i] <= H4_point[i+1] || D1_point[i] <= D1_point[i+1])
               return false;
            if((H4_point[i] - H4_point[i+1]) < (H4_point[i+1] - H4_point[i+2]) || (D1_point[i] - D1_point[i+1]) < (D1_point[i+1] - D1_point[i+2]))
               return false;
         }
         return true;
      case 1:
         for(int i = 0; i < n - 2; i++){            
            if(H4_point[i] >= H4_point[i+1] || D1_point[i] >= D1_point[i+1])
               return false;
            if((H4_point[i + 1] - H4_point[i]) < (H4_point[i+2] - H4_point[i+1]) || (D1_point[i + 1] - D1_point[i]) < (D1_point[i+2] - D1_point[i+1]))
               return false;
         }
         return true;
      default: return false;
   }
}

//+------------------------------------------------------------------+
//|
//|   FilterBody()
//|
//|   Для работы необходим проход функций:
//|      CalculateHAPatterns(), DefineDirection()
//|
//|   тело должно быть больше теней
//|   
//|   
//|
//+------------------------------------------------------------------+
bool FilterBody(){
   
   for(int i = 0; i < n; i++){
      if(HA_H1_body[i] < HA_H1_lowerTail[i] || HA_H1_body[i] < HA_H1_upperTail[i] || 
         HA_H4_body[i] < HA_H4_lowerTail[i] || HA_H4_body[i] < HA_H4_upperTail[i] ||
         HA_D1_body[i] < HA_D1_lowerTail[i] || HA_D1_body[i] < HA_D1_upperTail[i]){
         
         return false;   
      }
   }   
   return true;
}

//+------------------------------------------------------------------+
//|
//|   FilterTails()
//|
//|   Для работы необходим проход функций:
//|      CalculateHAPatterns(), DefineDirection()
//|
//|   Противоположного хвоста не должно быть   
//|
//+------------------------------------------------------------------+
bool FilterTails(){

   switch(type){
      case 0:
         for(int i = 0; i < n; i++){
            if(HA_H1_open[i] > HA_H1_low[i] ||
               HA_H4_open[i] > HA_H4_low[i] ||
               HA_D1_open[i] > HA_D1_low[i]){
               return false;
            }
         }
         return true;
      case 1:
         for(int i = 0; i < n; i++){
            if(HA_H1_open[i] < HA_H1_high[i] ||
               HA_H4_open[i] < HA_H4_high[i] ||
               HA_D1_open[i] < HA_D1_high[i]){
               return false;
            }
         }
         return true;
      default: return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//|
//|   SetParameters()
//|   
//|   Вызывается в любом месте
//|   
//|   Устанавливает параметры для отправки ордера
//|
//+------------------------------------------------------------------+
bool SetParameters(int &cmd, double &price, double &sl, double &tp){
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);   
   
   if(type == 0){
      cmd   = OP_BUY;
      price = NormalizeDouble(tick.ask, Digits());
      sl    = 0.0;//NormalizeDouble(price - stl, Digits());
      tp    = NormalizeDouble(price + tkp, Digits());
      return true;
   }   
   if(type == 1){
      cmd   = OP_SELL;
      price = NormalizeDouble(tick.bid, Digits());
      sl    = 0.0;//NormalizeDouble(price + stl, Digits());
      tp    = NormalizeDouble(price - tkp, Digits());
      return true;
   }
   return false;
}


//+------------------------------------------------------------------+
//|
//|   Tral()
//|   
//|   Вызывается в любом месте
//|   
//|   Тянет стоплос по мувингу D1
//|
//|   Если ордеров нет, то выходим.
//|   Если есть ордера, но нет ордера, выставленного советником по символу,
//|   то тоже выходим.
//|   
//|   Если стоплос равен тралу, то выходим
//+------------------------------------------------------------------+
void Tral(){

   if(OrdersTotal() == 0)
      return;
      
   for(int i = 0; i < OrdersTotal(); i++){
      _OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         double tral = NormalizeDouble(iMA(Symbol(), PERIOD_D1, 24, 0, MODE_EMA, PRICE_CLOSE, 1), Digits());
         double sl = OrderStopLoss();
         
         if(sl == tral)
            return;
         else sl = tral;
         
         if(OrderType() == OP_BUY){
            if(OrderStopLoss() < sl){
               ResetLastError();
               if(!OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0)){
                  return;
               }  
            }
         }
         else if(OrderType() == OP_SELL){
            if(OrderStopLoss() > sl || OrderStopLoss() == 0.0){
               ResetLastError();
               if(!OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0)){
                  return;
               }  
            }
         }                
      }
      else
         return;
   }
}


//+------------------------------------------------------------------+
//|
//|   Terminator()
//|   
//|   Вызывается в любом месте
//|   
//|   Убивает любой плюсовой ордер.
//|
//+------------------------------------------------------------------+
void Terminator(){
   if(OrdersTotal() == 0)
      return;
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   int slp = (int)(tick.ask - tick.bid);
   
   for(int i = 0; i < OrdersTotal(); i++){
      _OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         
         if(OrderType() == OP_BUY && OrderOpenPrice() < tick.ask + slp * Point()){
            if(!OrderClose(OrderTicket(), OrderLots(), tick.bid, slp)){
               Print(__FUNCTION__,"Ошибка закрытия ордера. ", GetLastError());
               return;
            }
         }
         if(OrderType() == OP_SELL && OrderOpenPrice() > tick.bid - slp * Point()){ 
            if(!OrderClose(OrderTicket(), OrderLots(), tick.ask, slp)){
               Print(__FUNCTION__,"Ошибка закрытия ордера. ", GetLastError());
               return;
            }
         }
      }
   }   
}

//+------------------------------------------------------------------+
//|
//|   Вспомогательные функции
//|   
//|   Вызываются в любом месте
//|   
//+------------------------------------------------------------------+
void _OrderSelect(int i, int pool = SELECT_BY_POS){  
   ResetLastError();
   if(!OrderSelect(i, pool)){
      Print("Ошибка выбора ордера: ",GetLastError());
      return;
   }
}

void _SendOrder(int cmd = -1, double price = 0.0, double sl = 0.0, double tp = 0.0){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   int slp = (int)(tick.ask - tick.bid);
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, NULL, magic)){
      Print("Ошибка отправки ордера: ",GetLastError());
      return;
   }
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