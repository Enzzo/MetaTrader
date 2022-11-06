bool Trade(int signal, double sl, double tp)
{
// - 1 - == Открытие длинной позиции ====================================================
   if (signal == PATTERN_BULL)                     // Активен сигнал покупки
      if (!OpenBuy(sl, tp))                        // Открытие позиции
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Открытие короткой позиции ===================================================
   if (signal == PATTERN_BEAR)                     // Активен сигнал продажи
      if (!OpenSell(sl, tp))                       // Открытие позиции
         return(false);
// - 2 - == Окончание блока =============================================================

   return(true);    
}



bool OpenBuy(double sl, double tp)
{
// - 1 - == Закрытие противоположных позиций ============================================
   if (g_type == OP_SELL)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Модификация существующей позиции ============================================
   if (g_type == OP_BUY)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == Окончание блока =============================================================

// - 3 - == Покупка по рынку ============================================================
   return (OpenByMarket(OP_BUY, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == Окончание блока =============================================================
}



bool OpenSell(double sl, double tp)
{
// - 1 - == Закрытие противоположных позиций ============================================
   if (g_type == OP_BUY)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Модификация существующей позиции ============================================
   if (g_type == OP_SELL)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == Окончание блока =============================================================

// - 3 - == Покупка по рынку ============================================================
   return (OpenByMarket(OP_SELL, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == Окончание блока =============================================================
}


bool ModifySLAndTP(int ticket, double sl, double tp)
{
   if (!(OrderSelect(ticket, SELECT_BY_TICKET) &&  // Выберем позицию по тикету и..
         OrderCloseTime() == 0))                   // ..удостоверимся, что она не закрыта
      return (true);                               // Уходим, если нет позиции
      
   if (MathAbs(sl - OrderStopLoss()) < g_tickSize &&// Проверим уровень стоп-приказа..
       MathAbs(tp - OrderTakeProfit()) < g_tickSize)// ..и профита
      return (true);                               // Уходим, если оба уровня двигать..
                                                   // ..не нужно
                                                   
   if ((OrderType() == OP_BUY && Bid - sl <= g_stopLevel) ||// Если цена слишком близка..
       (OrderType() == OP_SELL && sl - Ask <= g_stopLevel))// ..к новому уровню..
       return(false);                              // ..стоп-приказа - вернем ошибку
                                                      
   if ((OrderType() == OP_BUY && tp - Bid <= g_stopLevel) ||// Если цена слишком близка..
       (OrderType() == OP_SELL && Ask - tp <= g_stopLevel))// ..к новому уровню..
       return(false);                              // ..профита - вернем ошибку

   if (OrderModify(OrderTicket(), 0, sl, tp, 0))   // Изменяем стоп-приказ
      return (true);                               // Успешная модификация

   return(false);                                  // Неудачная модификация
}


bool OpenByMarket(int type, double lot, double sl, double tp, 
                  int magicNumber, bool redefinition = true)
// redefinition - при true доопределять параметры до минимально допустимых
//                при false - возвращать ошибку
{
// - 1 - == Проверка правильности типа ордера и достаточности свободных средств =========
   if (type > OP_SELL)
      return(false);
   
   if (!IsEnoughMoney(lot))
      return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Проверка свободности торгового потока и правильности параметров ордера ======
   if (!WaitForTradeContext())
   {
      Comment("Время ожидания освобождения торгового потока истекло!");
      return(false);
   }

   double price;                                   // Цена исполнения ордера
   if (!IsMarketOrderParametersCorrect(type, price, sl, tp, redefinition))
      return(false);
// - 2 - == Окончание блока =============================================================
 
// - 3 - == Открытие ордера с ожидание торгового потока =================================
   if (GetExecutionType() == EXE_MODE_INSTANT ||
       (sl == 0 && tp == 0))
      return(OpenOrderWithInstantMode(type, lot, price, sl, tp, magicNumber) > 0);
      
   return(OpenOrderWithMarketMode(type, lot, price, sl, tp, magicNumber));
}