bool Trade(int signal, double sl, double tp)
{
// - 1 - == �������� ������� ������� ====================================================
   if (signal == PATTERN_BULL)                     // ������� ������ �������
      if (!OpenBuy(sl, tp))                        // �������� �������
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� �������� ������� ===================================================
   if (signal == PATTERN_BEAR)                     // ������� ������ �������
      if (!OpenSell(sl, tp))                       // �������� �������
         return(false);
// - 2 - == ��������� ����� =============================================================

   return(true);    
}



bool OpenBuy(double sl, double tp)
{
// - 1 - == �������� ��������������� ������� ============================================
   if (g_type == OP_SELL)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == ����������� ������������ ������� ============================================
   if (g_type == OP_BUY)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������� �� ����� ============================================================
   return (OpenByMarket(OP_BUY, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == ��������� ����� =============================================================
}



bool OpenSell(double sl, double tp)
{
// - 1 - == �������� ��������������� ������� ============================================
   if (g_type == OP_BUY)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == ����������� ������������ ������� ============================================
   if (g_type == OP_SELL)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == ��������� ����� =============================================================

// - 3 - == ������� �� ����� ============================================================
   return (OpenByMarket(OP_SELL, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == ��������� ����� =============================================================
}


bool ModifySLAndTP(int ticket, double sl, double tp)
{
   if (!(OrderSelect(ticket, SELECT_BY_TICKET) &&  // ������� ������� �� ������ �..
         OrderCloseTime() == 0))                   // ..�������������, ��� ��� �� �������
      return (true);                               // ������, ���� ��� �������
      
   if (MathAbs(sl - OrderStopLoss()) < g_tickSize &&// �������� ������� ����-�������..
       MathAbs(tp - OrderTakeProfit()) < g_tickSize)// ..� �������
      return (true);                               // ������, ���� ��� ������ �������..
                                                   // ..�� �����
                                                   
   if ((OrderType() == OP_BUY && Bid - sl <= g_stopLevel) ||// ���� ���� ������� ������..
       (OrderType() == OP_SELL && sl - Ask <= g_stopLevel))// ..� ������ ������..
       return(false);                              // ..����-������� - ������ ������
                                                      
   if ((OrderType() == OP_BUY && tp - Bid <= g_stopLevel) ||// ���� ���� ������� ������..
       (OrderType() == OP_SELL && Ask - tp <= g_stopLevel))// ..� ������ ������..
       return(false);                              // ..������� - ������ ������

   if (OrderModify(OrderTicket(), 0, sl, tp, 0))   // �������� ����-������
      return (true);                               // �������� �����������

   return(false);                                  // ��������� �����������
}


bool OpenByMarket(int type, double lot, double sl, double tp, 
                  int magicNumber, bool redefinition = true)
// redefinition - ��� true ������������ ��������� �� ���������� ����������
//                ��� false - ���������� ������
{
// - 1 - == �������� ������������ ���� ������ � ������������� ��������� ������� =========
   if (type > OP_SELL)
      return(false);
   
   if (!IsEnoughMoney(lot))
      return(false);
// - 1 - == ��������� ����� =============================================================

// - 2 - == �������� ����������� ��������� ������ � ������������ ���������� ������ ======
   if (!WaitForTradeContext())
   {
      Comment("����� �������� ������������ ��������� ������ �������!");
      return(false);
   }

   double price;                                   // ���� ���������� ������
   if (!IsMarketOrderParametersCorrect(type, price, sl, tp, redefinition))
      return(false);
// - 2 - == ��������� ����� =============================================================
 
// - 3 - == �������� ������ � �������� ��������� ������ =================================
   if (GetExecutionType() == EXE_MODE_INSTANT ||
       (sl == 0 && tp == 0))
      return(OpenOrderWithInstantMode(type, lot, price, sl, tp, magicNumber) > 0);
      
   return(OpenOrderWithMarketMode(type, lot, price, sl, tp, magicNumber));
}