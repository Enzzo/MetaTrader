//+------------------------------------------------------------------+
//|                                                      PING_V2.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "2.00"


//+---------------------------------------------------------------------------------------+
//|   Берется сформированная дневная свеча и по ней выставляются                          |
//|   уровни ордеров.                                                                     |
//|   level1 = High[1]                                                                    |
//|   level4 = Low[1]                                                                     |
//|   level2 = level1 - (level1 - level4)/3                                               |
//|   level3 = level4 + (level1 - level4)/3                                               |
//|                                                                                       |
//|   Если цена выше level2, то ставятся ордера BUYLIMIT(0.01) и SELLSTOP(0.01)           |
//|   Если цена ниже level3, то ставятся ордера BUYSTOP(0.01) и SELLLIMIT(0.01)           |
//|   Если цена между level3 и level2, то ставятся ордера BUYSTOP(0.01) и SELLSTOP(0.01)  |
//|                                                                                       |
//|   Если висит хоть один ордер, то триггер action = true                                |
//|   Если нет, то запускаем функцию Init() и в ней action = false                        |
//+---------------------------------------------------------------------------------------+

input int    magic      = 823328;  //Магик
input double volume     = 0.01;    //Объем
input int    expiration = 24;       //Экспирация (ч)

bool     action;     //Триггер
double   level1;     //Максимум предыдущей дневной свечи (ТП для BUY)
double   level2;     //Уровень открытия ордера BUY
double   level3;     //Уровень открытия ордера SELL
double   level4;     //Минимум предыдущей дневной свечи (ТП для SELL)
datetime cTime[1];   //Время новой открытой свечи 
datetime pTime;      //Время для сравнения

int OnInit(){
   action = false;
   //Init();
   pTime = 0;
   CheckOldSet();
   return(INIT_SUCCEEDED);
}


void OnTick(){
   
   if(!action)
      Start();
   else
      Continue();   
}


//+---------------------------------------------------------------------------------------+
//|   Init()                                                                              |
//|   Не зависима.                                                                        |
//|   Обнуляет начальные параметры                                                        |
//+---------------------------------------------------------------------------------------+
void Init(){
   action = false;
   level1 = 0.0;
   level2 = 0.0;
   level3 = 0.0;
   level4 = 0.0;
}


//+---------------------------------------------------------------------------------------+
//|   CheckOldSet()                                                                       |
//|   Не зависима.                                                                        |
//|   Если уже выставлены ордера этим советником, то присваиваем уровням параметры        |
//|   ордеров и action = true.                                                            |
//+---------------------------------------------------------------------------------------+
void CheckOldSet(){
   if(OrdersTotal() == 0)
      return;
   
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, " Ошибка выбора ордера: ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         action = true;
         if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
         }
         else if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT){
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit();
         }
      }
   }
}

//+---------------------------------------------------------------------------------------+
//|   Start()                                                                             |
//|   Не зависима.                                                                        |
//|   Устанавливает уровни по сформированной дневной свече и выставляет по ним два        |
//|   отложенника. action = true.                                                         |
//|                                                                                       |
//|   level1 = High[1]                                                                    |
//|   level4 = Low[1]                                                                     |
//|   level2 = level1 - (level1 - level4)/3                                               |
//|   level3 = level4 + (level1 - level4)/3                                               |
//|                                                                                       |
//|   Если цена выше level2, то ставятся ордера BUYLIMIT(0.01) и SELLSTOP(0.01)           |
//|   Если цена ниже level3, то ставятся ордера BUYSTOP(0.01) и SELLLIMIT(0.01)           |
//|   Если цена между level3 и level2, то ставятся ордера BUYSTOP(0.01) и SELLSTOP(0.01)  |
//+---------------------------------------------------------------------------------------+
void Start(){
   MqlRates rates[];
   MqlTick  tick;
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1, 1, 1, rates);
   SymbolInfoTick(Symbol(), tick);
   
   int cmdBuy  = -1; //Тип операции на buy
   int cmdSell = -1; //Тип операции на sell
   int slp     = (tick.ask - tick.bid)/Point();
   int expire  = TimeCurrent() + expiration * 3600;
   
   level1 = NormalizeDouble(rates[0].high, Digits());
   level4 = NormalizeDouble(rates[0].low, Digits());
   level2 = NormalizeDouble(level1 - (level1 - level4)/3, Digits());
   level3 = NormalizeDouble(level4 + (level1 - level4)/3, Digits());
   
   if(tick.ask > level2){
      cmdBuy  = OP_BUYLIMIT;
      cmdSell = OP_SELLSTOP;
   }
   else if(tick.bid < level3){
      cmdBuy  = OP_BUYSTOP;
      cmdSell = OP_SELLLIMIT;
   }
   else{
      cmdBuy  = OP_BUYSTOP;
      cmdSell = OP_SELLSTOP;
   }
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmdBuy, volume, level2, slp, level3, level1, NULL, magic, expire)){
      Print(__FUNCTION__, " Ошибка выставления ордера: ", GetLastError());
      return;
   }
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmdSell, volume, level3, slp, level2, level4, NULL, magic, expire)){
      Print(__FUNCTION__, " Ошибка выставления ордера: ", GetLastError());
      return;
   }
   
   action = true;
}


//+---------------------------------------------------------------------------------------+
//|   Continue()                                                                          |
//|   Не зависима.                                                                        |
//|   Основная функция                                                                    |
void Continue(){
   
   //Если ордеров нет, то action = false и выходим
   if(OrdersTotal() == 0){
      action = false;
      return;
   }
   
   bool cur  = false;      //рыночные   ордера
   bool pend = false;      //отложенные ордера
   int  cTicket = 0;       //тикет рыночного ордера
   int  pTicket = 0;       //тикет отложенника
   ushort n = 0;           //количество отложенников
      
      
   //Сканируем ордера
   //Если ордеров, выставленных советником, нет, то выходим и action = false
   //Если есть, то идем дальше
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, " Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      //Если нашли ордер, выставленный экспертом, то сохраняем его тикет
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cur = true;
            cTicket = OrderTicket();
         }
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP){
            pend = true;
            pTicket = OrderTicket();
            n++;
         }
      }/*
      else{
         action = false;
         return;
      }*/
   }
   
   if(!cur && !pend){
      action = false;
      return;
   }
   
   //Если отложенников два, то выходим и ждем, пока один не сработает
   if(n == 2){
      action = true;
      return;
   }
   
   ///ЕЩЕ НАДО УДАЛИТЬ ОТЛОЖЕННИК С ЛОТОМ 0.01!!!!!!!!!!!!!!!!
   if(cur && pend){
      ResetLastError();
      if(!OrderSelect(pTicket, SELECT_BY_TICKET)){
         Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      if(OrderLots() == volume){
         ResetLastError();
         if(!OrderDelete(pTicket)){
            Print(__FUNCTION__," Ошибка удаления ордера: ", GetLastError());
            return;
         }
      }
      action = true;
      return;
   }
   
   //Если только один отложенник и нет рыночного ордера, то удаляем его на следующей минуте и action = false;
   if(!cur && pend){
      //Через минуту удаляем отложенник
      /*CopyTime(Symbol(), PERIOD_M1, 0, 1, cTime);
      if(pTime == cTime[0])
         return;
      pTime = cTime[0];
      */
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," Ошибка удаления ордера: ",GetLastError());
         return;
      }
      action = false;
      return;
   }
   
   //Если только рыночник, то выставляем отложенник с двойным лотом по уровням (level1 - level4) action = true;
   if(cur && !pend){
      ResetLastError();
      if(!OrderSelect(cTicket, SELECT_BY_TICKET)){
         Print(__FUNCTION__, " Ошибка выбора рыночного ордера: ", GetLastError());
         return;
      }
      
      MqlTick tick;
      RefreshRates();
      SymbolInfoTick(Symbol(), tick);
      int cmd = -1;
      double price = 0.0;
      double sl = 0.0;
      double tp = 0.0;
      double vol = OrderLots() * 2;
      int slp = (tick.ask - tick.bid)/Point();
      
      if(OrderType() == OP_BUY){    
         cmd   = OP_SELLSTOP;
         price = level3;
         sl    = level2;
         tp    = level4;
      }
      else if(OrderType() == OP_SELL){
         cmd   = OP_BUYSTOP;
         price = level2;
         sl    = level3;
         tp    = level1;
      }
      
      if(!OrderSend(Symbol(), cmd, vol, price, slp, sl, tp, NULL, magic)){
         Print(__FUNCTION__, " Ошибка отправки ордера: ", GetLastError());
         return;
      }
      action = true;
   }
}