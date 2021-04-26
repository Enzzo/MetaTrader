//+------------------------------------------------------------------+
//|                                                         Ping.mq4 |
//|                                                             Enzo |
//|                                       "https://vk.com/id29520847"|
//+------------------------------------------------------------------+
//

#property copyright "Enzo"
#property link      "https://vk.com/id29520847"
#property version   "1.07"
#property strict

enum session{
   h0,      //0:00
   h1,      //1:00
   h2,      //2:00
   h3,      //3:00
   h4,      //4:00
   h5,      //5:00
   h6,      //6:00
   h7,      //7:00
   h8,      //8:00
   h9,      //9:00
   h10,     //10:00
   h11,     //11:00
   h12,     //12:00
   h13,     //13:00
   h14,     //14:00
   h15,     //15:00
   h16,     //16:00
   h17,     //17:00
   h18,     //18:00
   h19,     //19:00
   h20,     //20:00
   h21,     //21:00
   h22,     //22:00
   h23      //23:00
};

enum days{
   d0,      //Воскресенье
   d1,      //Понедельник
   d2,      //Вторник
   d3,      //Среда
   d4,      //Четверг
   d5,      //Пятница
   d6       //Суббота
};

input int      magic    = 9999;     //Магик
input session  oSession  = 0;       //Открытие сессии
input session  cSession  = 23;      //Закрытие сессии
input days     day1 = d1;           //Начало торговли
input days     day2 = d4;           //Завершение торговли
input int      levels   = 300;      //Расстояние уровней ордеров (пункты)
input int      tpBuy  = 300;        //уровень ТП для BUY(пункты)
input int      tpSell = 300;        //уровень ТП для SELL(пункты)
input double   profit = 0.0;        //профит закрытия первого ордера
input double   volume   = 0.01;     //Объем лота
input double   multipler = 2;       //множитель объема
//-------------------------------------------------------------//
// action - триггер работы советника. Если true, 
//          то не выставляем открытых торговых позиций//
// cmd    - тип торговой операции операции
//
// level1 - верхний уровень (тейкпрофиты ордеров BUY)
// level2 - второй уровень  (ордера BUY)
// level3 - третий уровень  (ордера SELL)
// level4 - нижний уровень  (тейкпрофиты ордеров SELL)
string   symbol;     //символ
string   string_day; //название дня
int      mgc;        //магик
int      cmd;        //тип ордера
int      slp;        //проскальзывание
int      lvl;        //пункты между ордерами
int      tpb;        //пункты ТП для buy
int      tps;        //пункты ТП для sell
int      day;        //день недели терминала
double   level1;     //ТП баевских ордеров
double   level2;     //цена баевских ордеров
double   level3;     //цена селовских ордеров
double   level4;     //ТП селовских ордеров
double   vol;        //объем
double   mtp;        //множитель объема
bool     action;     //партия
datetime time;

MqlDateTime GMT;

///////////////////////////////////////////////////////////////////
//                                                               //
//                            OnInit()                           //
//                                                               //
//  Init() - инициализация параметров                            //
//  mgc    - магик                                               //
//  symbol - символ                                              //
//  lvl    - расстояние между ордерами в пунктах                 //
//  tpb    - ТП для ордеров Buy                                  //
//  tps    - ТП для ордеров Sell                                 //
//  mtp    - множитель объема (умножает объем отложенника)       //
//                                                               // 
//  Если найдены ордера с таким же символом и магиком, то        //
//  устанавливает уровни (lvl, tpb, tps) по выставленным ордерам //
//                                                               //
///////////////////////////////////////////////////////////////////
int OnInit(){
   time     = 0;
   Init();
   mgc      = magic;
   symbol   = Symbol();   
   lvl      = levels;
   tpb      = tpBuy;
   tps      = tpSell;
   mtp      = multipler;
   
   if(OldSameSet()){
      action = true;
      SetLevels();
   }
   return(INIT_SUCCEEDED);
}

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              OnTick()                                //
//                                                                      //
// day      - день недели                                               //
// GMT      - часы по GMT                                               //
//                                                                      //
// Если action = false, то запускаем функцию Start()                    //
// Если action = true,  то запускаем функцию Continue()                 //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
void OnTick(){
   
   if(time == Time[0])
      return;
   time = Time[0];
   
   day = DayOfWeek();
   
   switch(day){
      case 0: string_day = "Воскресенье";break;
      case 1: string_day = "Понедельник";break;
      case 2: string_day = "Вторник";    break;
      case 3: string_day = "Среда";      break;
      case 4: string_day = "Четверг";    break;
      case 5: string_day = "Пятница";    break;
      case 6: string_day = "Суббота";    break;
   };
   
   TimeGMT(GMT);
   //если триггер выключен, выставляем открытую позицию
   Comment("GMT ",GMT.hour,":",GMT.min,"\n",string_day);
   
   if(GMT.hour < oSession || GMT.hour >= cSession)
      action = true;
   
   if(day < day1 || day >= day2)
      action = true;
   
   if(!action){
      Start();
   }
   else
      Continue();
}


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                              Init()                                  \\
//                                                                      \\
// action   - работа партии (если выключена, то выставляем новый        \\
//            рыночный ордер и включаем значение)                       \\
// vol      - объем (лоты)                                              \\
// price    - цена выставления                                          \\
// sl       - СЛ                                                        \\
// tp       - ТП                                                        \\
//                                                                      \\
// Сбрасывает параметры отправки ордера и выключает партию, если она    \\
// включена                                                             \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Init(){
   action   = false;   
   vol      = volume;
   //tp       = 0.0;   
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                              Start()                                 \\
//                                                                      \\
// slp   - проскальзывание (высчитывается (ask - bid)/points)           \\
// level1 - ТП для buy                                                  \\
// level2 - цена открытия ордера buy  / buystop                         \\
// level3 - цена открытия ордера sell / sellstop                        \\
// level4 - ТП для sell                                                 \\
//                                                                      \\
// Если ASK выше закрытия предыдущей свечи - то ордер на BUY            \\
// Если BID ниже закрытия предыдущей свечи - то ордер на SELL           \\
//                                                                      \\
// Открывает один рыночный ордер и переключает action в true            \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Start(){
   Init();
   double   price = 0.0;
   double   tp    = 0.0;
   double   sl    = 0.0;
   MqlTick  lastTick;
   RefreshRates();
   SymbolInfoTick(symbol, lastTick);
   //если свеча бычья, то ставим ордер на BUY, включаем триггер
   if(lastTick.ask > Close[1]){
      level1   = NormalizeDouble(lastTick.ask + tpb*Point(), Digits());
      level2   = NormalizeDouble(lastTick.ask, Digits());
      level3   = NormalizeDouble(lastTick.ask - lvl*Point(),Digits());
      level4   = NormalizeDouble(lastTick.ask - tps*Point()*2, Digits());
      price    = level2;
      tp       = level1;
      sl       = level3;
      cmd      = OP_BUY;
      action   = true;
   }   
   //если свеча медвежья, то ставим ордер на SELL и включаем триггер
   else if (lastTick.bid < Close[1]){
      level1   = NormalizeDouble(lastTick.bid + tpb*Point()*2,Digits());
      level2   = NormalizeDouble(lastTick.bid + lvl*Point(),Digits());
      level3   = NormalizeDouble(lastTick.bid,Digits());
      level4   = NormalizeDouble(lastTick.bid - tps*Point(), Digits());
      sl       = level2;
      price    = level3;
      tp       = level4;
      cmd      = OP_SELL;
      action   = true;
   }
   RefreshRates();
   slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
   ResetLastError();
   if(!OrderSend(symbol, cmd, vol, price, slp, sl, tp, NULL, mgc)){
      Print(__FUNCTION__," Ошибка отправки ордера: ",GetLastError());
      return;
   };
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                            Continue()                                \\
//                                                                      \\
// total    - Всего ордеров                                             \\
// pTicket  - тикет отложенного ордера                                  \\
// type     - тип рыночного ордера                                      \\
// cur      - наличие рыночного ордера                                  \\
// pend     - наличие отложенного ордера                                \\
//                                                                      \\
// 1. Если ордеров нет, то выключаем партию (action = false) и выходим  \\
//    из функции.                                                       \\
//                                                                      \\
// 2. Если есть какие-то ордера, то определяем, есть ли рыночные и      \\
//    есть ли отложенные (cur и pend).                                  \\
//                                                                      \\
// 3. Если нашли отложенник, то присваиваем переменной pTicket          \\
//    тикет отложенника.                                                \\
//                                                                      \\
// 4. Если cur == true и pend == false, выставляем стоповый             \\
//    противоположный отложенник, запускаем CheckOrders() и выходим.    \\
//                                                                      \\
// 5. Если cur == true и pend == true, запускаем CheckOrders()          \\
//    и выходим.                                                        \\
//                                                                      \\
// 6. Если cur == false и pend == true, удаляем отложенник по тикету    \\
//    pTicket, запускаем CheckOrders(), запускаем Init()                \\
//                                                                      \\
// 7. Если cur == false и pend == false, запускаем Init() и выходим     \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Continue(){  
   int total   = OrdersTotal();
   int pTicket = 0;
   int type    = 0;
   bool cur    = false;
   bool pend   = false;
   
   if(total == 0){
      action = false;
      return;
   }
   
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == mgc){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            type = OrderType();
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
      
      if(type == OP_BUY){
         lCmd = OP_SELLSTOP;
         lSL    = level2;
         lPrice = level3;
         lTP    = level4;
      }
      
      else if(type == OP_SELL){
         lCmd = OP_BUYSTOP;
         lPrice = level2;
         lSL    = level3;
         lTP    = level1;
      }
      if(lPrice != 0.0){
      
         vol *= mtp;
         RefreshRates();
         slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
         ResetLastError();
         if(!OrderSend(symbol, lCmd, vol, lPrice, slp, lSL, lTP, NULL, mgc)){
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
      Init();
   }
   if(!cur && !pend){
      Init();
   }   
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                           OldSameSet()                               \\
//                                                                      \\
// Функция используется в инициализации советника для того, чтобы не    \\
// дублировать ордера. Если находит ордера с похожими символом          \\
// и магиком, то возвращает true и новые ордера не выставляются.        \\
// Можно безопасно переключаться между таймфреймами. Ордера дублиро-    \\
// ваться не будут.                                                     \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
bool OldSameSet(){
   if(OrdersTotal() > 0)
      
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
            return false;
         }
         if(OrderSymbol() == symbol && OrderMagicNumber() == mgc)
            return true;
      }
      
   return false;
}


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                            SetLevels()                               \\
//                                                                      \\
// Функция используется в инициализации советника, если OldSameSet()    \\
// вернул true (т.е. если выставлены ордера с такими же символом и      \\
// магиком)                                                             \\
// В этой функции выстваляются границы (level1, level2, level3, level4),\\
// в пределах которых работает партия (action)                          \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void SetLevels(){
   int total = OrdersTotal();
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," Ошибка выбора ордера: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == mgc){
         if(OrderType() == OP_BUY){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
            level3 = OrderStopLoss();
            vol    = OrderLots();
         }
         
         if(OrderType() == OP_SELL){
            level2 = OrderStopLoss();
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit();
            vol    = OrderLots();
         }
         
         if(OrderType() == OP_BUYSTOP){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
            level3 = OrderStopLoss();
         }
         
         if(OrderType() == OP_SELLSTOP){
            level2 = OrderStopLoss();
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit(); 
         }         
      }      
   }
}
//Если нет пары buy/sell - значит какая-то половина по тейку сработала. Если так, то закрываем все ордера
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                           CheckOrders()                              \\
//                                                                      \\
// isBuy  - открытые BUY  и/или BUYSTOP                                 \\
// isSell - открытые SELL и/или SELLSTOP                                \\
// ticket - тикет ордера, который будет удален                          \\
// _lots  - объем удаляемого рыночного ордера                           \\
// _price - цена, по которой будет закрыт рыночный ордер                \\
//                                                                      \\
// Если функция видит только ордера BUY  и/или BUYSTOP                  \\
//                      ИЛИ                                             \\
// Если функция видит только ордера SELL и/или SELLSTOP                 \\
//             то все ордера по символу и магику удаляются              \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void CheckOrders(){
   bool isBuy = false;     //начилие баевских
   bool isSell = false;    //наличие селовских
   int ticket = 0;
   double _lots =  0.0;
   double _price = 0.0;
   
   int total = OrdersTotal();
   
   if (total == 0)
      return;
      
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ошибка выбора ордера для проверки." ,GetLastError());
         return;
      }
      
      if(OrderMagicNumber() == mgc && OrderSymbol() == symbol){
         if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP)
            isBuy = true;
         if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP)
            isSell = true;
////////////////////////////////////////////////////////////////////////////////       
         if(OrderLots() == volume && OrderProfit() >= profit && profit != 0.0){
            if(OrderType() == OP_BUY){
               RefreshRates();
               _price = MarketInfo(symbol, MODE_ASK);//last.ask;
            }
            if(OrderType() == OP_SELL){
               RefreshRates();
               _price = MarketInfo(symbol, MODE_BID);//last.bid;
            }
            _lots = OrderLots();
            
            RefreshRates();
            slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
            if(!OrderClose(OrderTicket(), OrderLots(), _price, slp)){
               Print(__FUNCTION__," ошибка удаления ордера. " ,GetLastError());
               return;
            }
            return;
         }
////////////////////////////////////////////////////////////////////////////////
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
         
         if(OrderMagicNumber() == mgc && OrderSymbol() == symbol){
            
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
                  _price = MarketInfo(symbol, MODE_ASK);//last.ask;
               }
               if(OrderType() == OP_SELL){
                  RefreshRates();
                  _price = MarketInfo(symbol, MODE_BID);//last.bid;
               }
               _lots = OrderLots();
               
               RefreshRates();
               slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
               if(!OrderClose(ticket, _lots, _price, slp)){
                  Print(__FUNCTION__," ошибка удаления ордера. " ,GetLastError());
                  return;
               }
            }
         }
      }
      Init();
   }
}
   /*
  RefreshRates();
  Price[0]=MarketInfo(OrderSymbol(),MODE_ASK);
  Price[1]=MarketInfo(OrderSymbol(),MODE_BID);
  double dPoint=MarketInfo(OrderSymbol(),MODE_POINT);
  if(dPoint==0) return(false);
  giSlippage=(Price[0]-Price[1])/dPoint;
  */