//+------------------------------------------------------------------+
//|                                               Mindhero_robot.mq4 |
//|                                     Copyright © 2010, ENSED Team |
//|                                             http://www.ensed.org |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, ENSED Team"
#property link      "http://www.ensed.org"

extern int    SL            = 150, //величина Stop Loss (в пунктах)
              TP            = 150; //величина Take Profit (в пунктах)
extern double Lots          = 0.1; //рабочий лот
extern string Order_Comment = "Mindhero_robot"; //комментарий, которым снабжаются ордера
extern int    Slipage       = 5; //уровень максимально допустимого проскальзывания (в пунктах)
extern int    Magic_Number  = 876376; //магическое число - метра ордеров для робота (чтобыы отличал "свои" сделки)
extern bool   Play_Sound    = true; //воспроизведение звука при открытии: true - разрешено, false - запрещено

//------------
extern int TF_1  = 15; //15 минут
extern int TF_2  = 240; //240 минут (4 часа)

extern int period_1 = 10;
extern int fiboLevel_1 = 1;
extern bool alertMode_1 = false;
extern string Prefix_1       = "AK";
extern bool   ReverseSignal_1 = False;

extern int period_2 = 10;
extern int fiboLevel_2 = 1;
extern bool alertMode_2 = false;
extern string Prefix_2       = "AK";
extern bool   ReverseSignal_2 = False;


//------------

//+----------------------------------------------------------------------+
//+                           трейлинг-стоп                              +
extern bool UseTrailing  = true; //включение/выключение T-SL
extern int  TrailingStop = 50;   // Фиксированный размер трала
extern int  TrailingStep = 1;    // Шаг трала
//+                           трейлинг-стоп                              +
//+----------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                          функция. которая выполняется при инициализации программы                                 |
void init() {
  if(GlobalVariableCheck("this_bar"+Symbol()+Period()))
    GlobalVariableDel("this_bar"+Symbol()+Period());
  return;
}
//|                          функция. которая выполняется при инициализации программы                                 |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                         функция. которая выполняется при деинициализации программы                                |
void deinit() {
  if(GlobalVariableCheck("this_bar"+Symbol()+Period()))
    GlobalVariableDel("this_bar"+Symbol()+Period());   
  return;
}
//|                         функция. которая выполняется при деинициализации программы                                |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                         функция поиска торгового сигнала                                          |
int fsignals() {
  if(
      ((iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,0)<iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,0)) 
        && (iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,1)>iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,1)))
       &&
      ((iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,0)<iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,0)) 
        && (iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,1)>iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,1)))   
    ) 
    return(0); //сигнал на открытие покупки

  if(
      ((iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,0)>iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,0)) 
        && (iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,0,1)<iCustom(NULL,TF_1,"FiboBars",period_1, fiboLevel_1, alertMode_1, Prefix_1, ReverseSignal_1,1,1)))
       &&
      ((iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,0)>iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,0)) 
        && (iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,0,1)<iCustom(NULL,TF_2,"FiboBars",period_2, fiboLevel_2, alertMode_2, Prefix_2, ReverseSignal_2,1,1)))   
    ) 
    return(1); //сигнал на открытие продажи
  return(-1); //отсутствие сигнала
} //end int fsignals()
//|                                         функция поиска торгового сигнала                                          |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                            функция отслеживания факта отработки робота на данном баре                             |
bool this_bar() {
  if(
      (!GlobalVariableCheck("this_bar"+Symbol()+Period()))
      || (GlobalVariableGet("this_bar"+Symbol()+Period())!=Time[0])
    ) {
    GlobalVariableSet("this_bar"+Symbol()+Period(),Time[0]);
    return(false);
  } else {
    return(true);
  } //end if (.. (!GlobalVariableCheck("this_bar"+Symbol()+Period()))
} //end bool this_bar()
//|                            функция отслеживания факта отработки робота на данном баре                             |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                        функция поиска ордеров данного типа                                        |
bool find_orders(int magic=-1, int type=-1, string symb="NULL") {
  /* возвращает истину, если найден хотя бы один ордер данного типа с данным магическим номером по данному символу */
  for (int i=OrdersTotal()-1; i>=0; i--) {
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
    if(((OrderType()==type) || (type==-1))
       && ((OrderMagicNumber()==magic) || (magic==-1))
       && ((OrderSymbol()==Symbol() || (symb=="NONE")))) {
      //если ордер найден, то возвращаем true и выходим из цикла
      return(true);
      break;
    } //end if((OrderType()==type) && (OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()))
  } //end for (int i2=OrdersTotal()-1; i2>=0; i2--)

  return(false); //возвращаем false
} //end bool find_orders(int magic, int type)
//|                                        функция поиска ордеров данного типа                                        |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                  функция расчета величины Stop Loss для ордеров                                   |
double sl(int sl_value, int type, double price=0.0, string symb="NONE", int rmode=1) {
  //type=0 -> рыночные покупки
  //type=1 -> рыночные продажи
  if(symb=="NONE") symb=Symbol();
  if(type==0) price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==1) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  if(sl_value<=0) return(0);
  if(rmode==1) {
    if((type==0) || (type==2) || (type==4))     return(MarketInfo(symb,MODE_ASK)-sl_value*MarketInfo(symb,MODE_POINT)); //для покупок
    if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_BID)+sl_value*MarketInfo(symb,MODE_POINT)); //для продаж
  }
  if(rmode==2) {
    if((type==0) || (type==2) || (type==4))     return(MarketInfo(symb,MODE_BID)-sl_value*MarketInfo(symb,MODE_POINT)); //для покупок
    if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_ASK)+sl_value*MarketInfo(symb,MODE_POINT)); //для продаж
  }
} //end double sl(int sl_value, int type, double price=0.0, string symb="NONE", int rmode=1)
//|                                  функция расчета величины Stop Loss для ордеров                                   |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                 функция расчета величины Take Profit для ордеров                                  |
double tp(int tp_value, int type, double price=0.0, string symb="NONE") {
  //type=0 -> рыночные покупки
  //type=1 -> рыночные продажи
  if(symb=="NONE") symb=Symbol();
  if(type==0) price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS));
  if(type==1) price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS));
  if(tp_value<=0) return(0);
  if((type==0) || (type==2) || (type==4))     return(price+tp_value*MarketInfo(symb,MODE_POINT)); //для покупок
  if((type==1) || (type==3) || (type==5))     return(MarketInfo(symb,MODE_BID)-tp_value*MarketInfo(symb,MODE_POINT)); //для продаж
} //end double tp(int tp_value, int type, double price=0.0, string symb="NONE")
//|                                 функция расчета величины Take Profit для ордеров                                  |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                              функция открытия ордеров                                             |
void open_positions(int signal, double lot, double price=0.0, string symb="NONE") {
  //signal=0 -> сигнал на открытие покупки
  //signal=1 -> сигнал на открытие продажи
  /* extern */ int Count_Of_Trade_Try=5, Pause_Of_Trade_Try=5;

  int    i   = 0; //переменная для счётчика цикла
  int    err = 0;

  if(symb=="NONE") symb=Symbol();
  if(signal==0)
    price=NormalizeDouble(MarketInfo(symb,MODE_ASK),MarketInfo(symb,MODE_DIGITS)); //цена открытия для покупок
  if(signal==1)
    price=NormalizeDouble(MarketInfo(symb,MODE_BID),MarketInfo(symb,MODE_DIGITS)); //цена открытия для продаж

  while(i<=Count_Of_Trade_Try) {
    //сама функия открытия ордера (встроенная). Для удобства восприятия параметры разнесены на разные строки:
    int ticket = OrderSend(Symbol(),      //символ
                           signal,        //тип ордера
                           lot,           //объем
                           price,         //цена открытия
                           Slipage,       //уровень допустимого реквота
                           sl(SL,signal), //величина Stop Loss
                           tp(TP,signal), //величина Take Profit
                           Order_Comment, //комментарий ордера
                           Magic_Number,  //магическое число
                           0,             //срок истечения (используется при отложенных ордерах)
                           CLR_NONE);     //цвет отображаемой стрелки на графике (CLR_NONE - стрелка не рисуется)
    if(ticket!=-1) //если открытие произошло успешно, наносим графический объект и выходим из цикла
      break;
    err=GetLastError(); 
    if(err!=0) Print("Ошибка: "+Market_Err_To_Str(err));
    i++;
    Sleep(Pause_Of_Trade_Try*1000); //в случае ошибки делаем паузу перед новой попыткой
  } //end while(i<=count)
} //end void open_positions(int signal, double lot, double price=0.0, string symb="NONE")
//|                                              функция открытия ордеров                                             |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------+
//|                                      функция расшифровки кодов ошибок                                 |
string Market_Err_To_Str(int err) {
/* функция охватывает только коды ошибок торговых операций */
  switch(err) {
    case(0):   return("Нет ошибки");
    case(1):   return("Нет ошибки, но результат неизвестен");
    case(2):   return("Общая ошибка");
    case(3):   return("Неправильные параметры");
    case(4):   return("Торговый сервер занят");
    case(5):   return("Старая версия клиентского терминала");
    case(6):   return("Нет связи с торговым сервером");
    case(7):   return("Недостаточно прав");
    case(8):   return("Слишком частые запросы");
    case(9):   return("Недопустимая операция нарушающая функционирование сервера");
    case(64):  return("Счет заблокирован");
    case(65):  return("Неправильный номер счета");
    case(128): return("Истек срок ожидания совершения сделки");
    case(129): return("Неправильная цена");
    case(130): return("Неправильные стопы");
    case(131): return("Неправильный объём");
    case(132): return("Рынок закрыт");
    case(133): return("Торговля запрещена");
    case(134): return("Недостаточно денег для совершения операции");
    case(135): return("Цена изменилась");
    case(136): return("Нет цен");
    case(137): return("Брокер занят");
    case(138): return("Новые цены");
    case(139): return("Ордер заблокирован и уже обрабатывается");
    case(140): return("Разрешена только покупка");
    case(141): return("Слишком много запросов");
    case(145): return("Модификация запрещена, т.к. ордер слишком близок к рынку");
    case(146): return("Подсистема торговли занята");
    case(147): return("Использование даты истечения запрещено брокером");
    case(148): return("Количество открытых и отложенных ордеров достигло предела, установленного брокером");
    case(149): return("Попытка открыть противоположную позицию к уже существующей в случае, если хеджирование запрещено");
    case(150): return("Попытка закрыть позицию по инструменту в противоречии с правилом FIFO");
   
    default:   return("");
  } //end switch(err)
} //end string Err_To_Str(int err)
//|                                      функция расшифровки кодов ошибок                                 |
//+-------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------+
//|                                         Операции закрытия сделок                                      |
//+----------------------------------------------------------------------------------------------------+
//|                           функция закрытия ордера по её номеру (тикету)                            |


bool close_by_ticket(int c_ticket, int slipage) {
  /*
     функция закрытия сделки по её номеру (тикету).
     При закрытии рыночного ордера учитывается уровень максимально допустимого проскальзывания (slipage)
  */
/* extern */ int Count_Of_Trade_Try=5, Pause_Of_Trade_Try=5;

int    i       = 0;     //переменная для счетчика цикла
int    err     = 0;
bool   ticket  = false; //перменная для обозначения (не)успешности факта закрытия сделки
double price   = 0.0; //цена для закрываемой сделки (для рыночных ордеров)
  if(OrderSelect(c_ticket,SELECT_BY_TICKET,MODE_TRADES)) { //выбираем ордер по тикету
    if(OrderType()==OP_BUY)  price = NormalizeDouble(Bid,Digits); //цена для покупок
    if(OrderType()==OP_SELL) price = NormalizeDouble(Ask,Digits); //цена для продаж
    for(i=0;i<=Count_Of_Trade_Try;i++) {
      if(OrderType()<=1) //если рыночный ордер - закрываем его, если отложенный - удаляем
        ticket=OrderClose(OrderTicket(),OrderLots(),price,slipage,CLR_NONE);
      else
        ticket=OrderDelete(OrderTicket());

      if(ticket) { //если закрытие или удаление прошло успешно - возвращаем true и выходим из цикла
        return(true);
        break;
      } //end if(ticket)
      err=GetLastError();
      if(err!=0) Print("Ошибка: "+Market_Err_To_Str(err));
      Sleep(Pause_Of_Trade_Try*1000); //в случае ошибки делаем паузу перед новой попыткой
    } //end for(i=0;i<=Count_Of_Trade_Try;i++)
  } //end if(OrderSelect(c_ticket,SELECT_BY_TICKET,MODE_TRADES))

  return(false); //возвращаем false
} //end bool close_by_ticket(int c_ticket)
//|                           функция закрытия ордера по её номеру (тикету)                            |
//+----------------------------------------------------------------------------------------------------+

bool cbm(int magic, int slipage, int type) {
  /*
    close by magic (закрытие всех ордеров данного типа с данным MagicNumber)
    Учитывается максимально допустимое проскальзывание (slipage)
    Используется функция close_by_ticket.
  */
  int n = 0;
  while (find_orders(magic, type))
    for (int i2=OrdersTotal()-1; i2>=0; i2--) {
      if (!OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)) break;

      if ((OrderType()==type) && (OrderMagicNumber()==magic)) {
        close_by_ticket(OrderTicket(), slipage);
        n++;
      } //end if (((OrderType()==OP_BUY) || (OrderType()==OP_SELL)) && (OrderMagicNumber()==magic))
    } //end for (int i2=OrdersTotal()-1; i2>=0; i2--)

  if(n>0)   
    return(true);

  return(false);
} //end bool cbm(int magic, int slipage, int type)
//|                                         Операции закрытия сделок                                      |
//+-------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                 трейлинг стоп лосс                                                |
void T_SL() {
  if(!UseTrailing) return;
  int i = 0;
  for(i=0; i<OrdersTotal(); i++) {
    if(!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue;
    if(OrderSymbol() != Symbol() || OrderMagicNumber()!=Magic_Number) continue;       

    if(OrderType()==OP_BUY) {
      if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)>NormalizeDouble(TrailingStop*Point,Digits)) {
        if(NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-(TrailingStop+TrailingStep-1)*Point,Digits))
          OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid-TrailingStop*Point,Digits), OrderTakeProfit(), 0, CLR_NONE);
      } //end if(NormalizeDouble(Bid-OrderOpenPrice(),Digits)>NormalizeDouble(TrailingStop*Point,Digits))
    } //end if(OrderType()==OP_BUY)

    if(OrderType()==OP_SELL) {
      if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)>NormalizeDouble(TrailingStop*Point,Digits)) {
        if(NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(Ask+(TrailingStop+TrailingStep-1)*Point,Digits))
          OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask+TrailingStop*Point,Digits), OrderTakeProfit(), 0, CLR_NONE);
      } //end if(NormalizeDouble(OrderOpenPrice()-Ask,Digits)>NormalizeDouble(TrailingStop*Point,Digits))
    } //end if(OrderType()==OP_SELL)
  } //end for(i=0; i<OrdersTotal(); i++)
} //end void T_SL()
//|                                                 трейлинг стоп лосс                                                |
//+-------------------------------------------------------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------------+
//|                                                   главная функция                                                 |
void start() {

  int sig = fsignals();

  if(!find_orders(Magic_Number)) {
    if((sig!=-1)) {
      if(!this_bar()) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      }
    } //end if((sig!=-1) && (!this_bar()))
  } else {
    if(sig==0) {
      if(cbm(Magic_Number, Slipage, 1)) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      } //end if(cbm(Magic_Number, Slipage, 1))
    } //end if(sig==0)
    if(sig==1) {
      if(cbm(Magic_Number, Slipage, 0)) {
        open_positions(sig, Lots);
        if(Play_Sound)
          PlaySound("alert.wav");
      } //end if(cbm(Magic_Number, Slipage, 0))
    } //end if(sig==1)
    T_SL();
  } //end if(!find_orders(Magic_Number)) (else)
  return;
}
//|                                                   главная функция                                                 |
//+-------------------------------------------------------------------------------------------------------------------+