
input int      magic      = 999888; //Magic
input int      expiration = 4;      //Экспирация (часы)
input int      offset     = 10;     //Сдвиг ордеров от краев IB (пункты)
input int      SL         = 20;     //Стоплосс (пункты)
input int      TP         = 20;     //Тейкпрофит (пункты)
input double   volume     = 0.01;   //Объем


double offs;
double stl;
double tkp;

ushort level = 0;

void OnInit(){
   
   if(Digits() == 3 || Digits() == 5){
      offs  = NormalizeDouble(offset * Point(), Digits()) * 10;
      stl   = NormalizeDouble(SL     * Point(), Digits()) * 10;
      tkp   = NormalizeDouble(TP     * Point(), Digits()) * 10;
   }
   else{
      offs  = NormalizeDouble(offset * Point(), Digits());
      stl   = NormalizeDouble(SL     * Point(), Digits());
      tkp   = NormalizeDouble(TP     * Point(), Digits());
   }
   
   FindPrevSet();
}

void OnTick(){
   
   switch(level){
      case 0:
         FindIB();
         break;
      case 1:
         Start();
         break;
      case 2:
         FirstStep();
         break;
      case 3:
         Jump();
         break;
      default: level = 0;
   }
}

////////////////////////////////////////////////////////////////////
//                                                                //
//                         FindPrevSet()                          //
//                                                                //
//    Если выставлены два стартовых отложенника, то переключаем   //
//    level = 2                                                   //
//    Если была запущена функция Jump, то инициализируем уровни   //
//    и level = 3

void FindPrevSet(void){
   
   if(OrdersTotal() == 0){
      level = 0;
      return;
   }
   
   int n = 0;        //счетчик ордеров
   //int ticket[2];
   int type[2];
   
   //ZeroMemory(ticket);
   ZeroMemory(type);
      
   for(int i = 0; i < OrdersTotal(); i++){
      _OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         //ticket[n] = OrderTicket();
         type[n]   = OrderType();
         n++;
      } 
   }   
   
   //Если открыты два отложенника, то ИБ найден и ордера выставлены. Переходим в FirstStep() (level 2)
   if((type[0] == OP_BUYSTOP && type[1] == OP_SELLSTOP) ||(type[0] == OP_SELLSTOP && type[1] == OP_BUYSTOP)){
      level = 2;
      return;
   }  
   
   //Если открыта рыночная позиция и один отложенник, то запущена функция Jump() (level 3)
   //Тип первого ордера по списку - рыночный. Второго - отложенный
   if((type[0] == OP_BUY || type[0] == OP_SELL) || (type[1] ==  OP_BUYSTOP || type[1] == OP_SELLSTOP)){
      level = 3;
      return;
   }
}

////////////////////////////////////////////////////////////////////
//                           level = 0                            //
//                            FindIB()                            //
//                                                                //
//    Ищем инсайдбар. Если нашли, то level = 1                    //
//    Если нет, то level = 0;                                     //

void FindIB(void){
   //Print("FindIB()");
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 2, rates);
   
   if(ArraySize(rates) < 2)
      return;
   
   ArraySetAsSeries(rates, true);
   
   if(rates[0].high < rates[1].high && rates[0].low > rates[1].low){
      level = 1;
      return;
   }
}


////////////////////////////////////////////////////////////////////
//                           level = 1                            //
//                            Start()                             //
//                                                                //
//    Выставляем два отложенника и level = 2                      //

void Start(void){
   //Print("Start()");
   int expire = TimeCurrent() + expiration * 3600;
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, 1, 1, rates);
      
   double price = 0.0;
   double sl    = 0.0;
   double tp    = 0.0;
   int cmd      = -1;
   color clr    = NULL;
   string comment = NULL;  
   
   cmd   = OP_BUYSTOP;
   price = NormalizeDouble(rates[0].high + offs, Digits());
   sl    = NormalizeDouble(price - stl,  Digits());
   tp    = NormalizeDouble(price + tkp,  Digits());
   clr   = clrBlue;
   comment = "BUY";  
    
   _SendOrder(cmd, volume, price, sl, tp, comment, expire);
   
   cmd   = OP_SELLSTOP;
   price = NormalizeDouble(rates[0].low - offs, Digits());
   sl    = NormalizeDouble(price + stl,  Digits());
   tp    = NormalizeDouble(price - tkp,  Digits());
   clr   = clrBlue;
   comment = "SELL";
   
   _SendOrder(cmd, volume, price, sl, tp, comment, expire);
   
   level = 2;
   return;
}

////////////////////////////////////////////////////////////////////
//                           level = 2                            //
//                          FirstStep()                           //
//                                                                //
//    Если два отложенника, то level = 2                          //
//    Если только один отложенник и один открытый ордер, то       //
//    удаляем отложенник и level = 3

void FirstStep(void){
   //Print("FirstStep()");
   if(OrdersTotal() == 0){
      level = 0;
      return;
   }
   
   int pTicket = 0;         //тикет отложенников (одного из двух)
   int cTicket = 0;     //тикет рыночного ордера
   bool cur    = false; //наличие рыночных ордеров
   bool pend   = false; //наличие отложенников
   ZeroMemory(pTicket);
   
   for(int i = 0; i < OrdersTotal(); i++){
      _OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cur = true;
            cTicket = OrderTicket();
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
            pend = true;
            pTicket = OrderTicket();
         }
      }
   }
   
   if(!cur && pend){
      level = 2;
      return;
   }
   
   if(cur && pend){
      _DeleteOrder(pTicket);
      level = 3;
      return;
   }
   
}

////////////////////////////////////////////////////////////////////
//                           level = 3                            //
//                             Jump()                             //
//                                                                //
//    

/*void Jump_old(void){
   
   if(OrdersTotal() == 0){
      level = 0;
      return;
   }
   
   static datetime cTime = 0;
   if(cTime == Time[0])
      return;
   cTime = Time[0];
   
   int pTicket = 0;        //тикет отложенников (одного из двух)
   int cTicket = 0;        //тикет рыночного ордера
   bool cur    = false;    //наличие рыночных ордеров
   bool pend   = false;    //наличие отложенников
   double slPrice = 0.0;   //цена sl
   double openPrice = 0.0; //цена открытия
   double pOpenPrice = 0.0;
   double pSLPrice   = 0.0;
   string pComment = NULL;
   double vol;
   string comment = NULL;  //комментарий выставленного ордера
   
   ZeroMemory(pTicket);
   
   for(int i = 0; i < OrdersTotal(); i++){
      _OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cur = true;
            cTicket     = OrderTicket();
            comment     = OrderComment();
            openPrice   = OrderOpenPrice();
            slPrice     = OrderStopLoss();
            vol         = OrderLots() * 2;
            
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYLIMIT){
            pend = true;
            pTicket = OrderTicket();
            pOpenPrice = OrderOpenPrice(); 
            pSLPrice   = OrderStopLoss(); 
            pComment   = OrderComment();  
            vol        = OrderLots() * 2;        
         }
      }
   }
   
   if(cur && !pend){
      _SendPending(openPrice, slPrice, vol, comment);
      level = 3;
      return;
   }
   
   if(cur && pend){
      level = 3;
      return;
   }
  
   
   
   if(!cur && !pend){
      level = 0;
      return;
   }
   
   if(!cur && pend){
   _DeleteOrder(pTicket);
   level = 0;
   return;
      /*if(OrdersHistoryTotal() > 0){
         for(int j = OrdersHistoryTotal() - 1; j > 0; j--){
            OrderSelect(j, SELECT_BY_POS, MODE_HISTORY);
            if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
               if(OrderStopLoss() == pOpenPrice){
                  level = 3;
                  return;
               }
               else{
                  
                  level = 0;
                  return;
               }
            }
         }
      }     
   }

}
*/
//+---------------------------------------------------------+
//|                        Jump()                           |
//|   Не выставляет отложенники                             |
//|   Если ордер закрылся по Стоплосу, то по этой же цене   |
//|   выставляется следующий ордер с двойным лотом          |
//+---------------------------------------------------------+
void Jump(){
   
   //Если открыт хоть один ордер, то выходим из функции
   if(OrdersTotal() > 0){
      for(int i = 0; i < OrdersTotal(); i++){
         _OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            level = 3;
            return;
         }         
      }
   }
   
   //Если ордеров нет, то смотрим, как закрылся последний ордер в истории
   //Если с минусом, то level = 3 и ставим следующий ордер
   //Если с плюсом,  то level = 0 и выходим
   
   for(int j = OrdersHistoryTotal() - 1; j > 0; j--){
      OrderSelect(j, SELECT_BY_POS, MODE_HISTORY);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderClosePrice() != OrderStopLoss()){
            level = 0;
            return;
         }
         else{
            level = 3;
            _SendPending(OrderLots()*2, OrderComment());
            return;
         }
      }
   }   
}


void _OrderSelect(int i, int pool){
   ResetLastError();
   if(!OrderSelect(i, pool)){
      Print("Ошибка выбора ордера. ", GetLastError());
      return;
   }
}

void _SendOrder(int _cmd, double _vol, double _price, double _sl, double _tp, string _comment, int _expire){
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   int slp = (int)(tick.ask - tick.bid);
   int expire = _expire;
   
   ResetLastError();
   if(!OrderSend(Symbol(), _cmd, _vol, _price, slp, _sl, _tp, _comment, magic, expire)){
      Print("Ошибка отправки ордера. ", GetLastError());
      return;
   }
}

void _DeleteOrder(int ticket){
   
   ResetLastError();
   if(!OrderDelete(ticket)){
      Print("Ошибка удаления ордера. ", GetLastError());
      return;
   }
}

void _SendPending_old(double _open, double _sl, double vol, string _comment){
   
   int    cmd     = -1;
   double price   = 0.0;
   double sl      = 0.0;
   double tp      = 0.0;
   string comment = NULL;
   
   if(_comment == "BUY"){     //0
      cmd      = OP_BUY;
      price    = NormalizeDouble(_sl,       Digits());
      sl       = NormalizeDouble(_sl - (_open - _sl), Digits());
      tp       = NormalizeDouble(_open,               Digits());
      comment  = "BUYLIMIT";
   }
   if(_comment == "SELL"){    //1
      cmd      = OP_SELL;
      price    = NormalizeDouble(_sl,       Digits());
      sl       = NormalizeDouble(_sl + (_sl - _open), Digits());
      tp       = NormalizeDouble(_open,               Digits()); 
      comment  = "SELLLIMIT";
   }
    if(_comment == "BUYLIMIT"){//2
      cmd      = OP_SELL;
      price    = NormalizeDouble(_sl,       Digits());
      tp       = NormalizeDouble(_sl - (_open - _sl), Digits());
      sl       = NormalizeDouble(_open,               Digits());
      comment  = "SELLSTOP";
   }
   if(_comment == "SELLLIMIT"){//3
      cmd      = OP_BUY;
      price    = NormalizeDouble(_sl,       Digits());
      tp       = NormalizeDouble(_sl + (_sl - _open), Digits());
      sl       = NormalizeDouble(_open,               Digits());
      comment  = "BUYSTOP";
   }
   if(_comment == "BUYSTOP"){ //4
      cmd      = OP_BUY;
      price    = NormalizeDouble(_sl,       Digits());
      sl       = NormalizeDouble(_sl - (_open - _sl), Digits());
      tp       = NormalizeDouble(_open,               Digits());
      comment  = "BUYLIMIT";
   }
   if(_comment == "SELLSTOP"){ //5
      cmd      = OP_SELL;
      price    = NormalizeDouble(_sl,       Digits());
      sl       = NormalizeDouble(_sl + (_sl - _open), Digits());
      tp       = NormalizeDouble(_open,               Digits()); 
      comment  = "SELLLIMIT";
   }
   
   //Print("from ",_comment," to ",comment);
   _SendOrder(cmd, vol, price, sl, tp, comment, 0);
}

void _SendPending(double vol, string _comment){
   
   int    cmd     = -1;
   double price   = 0.0;
   double sl      = 0.0;
   double tp      = 0.0;
   string comment = NULL;
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   if(_comment == "BUY[sl]"){     //0
      cmd      = OP_BUY;
      price    = NormalizeDouble(tick.ask,    Digits());
      sl       = NormalizeDouble(price - stl, Digits());
      tp       = NormalizeDouble(price + stl, Digits());
      comment  = "BUYLIMIT";
   }
   if(_comment == "SELL[sl]"){    //1
      cmd      = OP_SELL;
      price    = NormalizeDouble(tick.bid,    Digits());
      sl       = NormalizeDouble(price + stl, Digits());
      tp       = NormalizeDouble(price - stl, Digits()); 
      comment  = "SELLLIMIT";
   }
    if(_comment == "BUYLIMIT[sl]"){//2
      cmd      = OP_SELL;
      price    = NormalizeDouble(tick.bid,    Digits());
      sl       = NormalizeDouble(price + stl, Digits());
      tp       = NormalizeDouble(price - stl, Digits()); 
      comment  = "SELLSTOP";
   }
   if(_comment == "SELLLIMIT[sl]"){//3
      cmd      = OP_BUY;
      price    = NormalizeDouble(tick.ask,    Digits());
      sl       = NormalizeDouble(price - stl, Digits());
      tp       = NormalizeDouble(price + stl, Digits());
      comment  = "BUYSTOP";
   }
   if(_comment == "BUYSTOP[sl]"){ //4
      cmd      = OP_BUY;
      price    = NormalizeDouble(tick.ask,    Digits());
      sl       = NormalizeDouble(price - stl, Digits());
      tp       = NormalizeDouble(price + stl, Digits());
      comment  = "BUYLIMIT";
   }
   if(_comment == "SELLSTOP[sl]"){ //5
      cmd      = OP_SELL;
      price    = NormalizeDouble(tick.bid,    Digits());
      sl       = NormalizeDouble(price + stl, Digits());
      tp       = NormalizeDouble(price - stl, Digits());  
      comment  = "SELLLIMIT";
   }
   
   Print("from ",_comment," to ",comment);
   _SendOrder(cmd, vol, price, sl, tp, comment, 0);
}
