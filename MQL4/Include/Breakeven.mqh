
//выставляет безубыток.
void Breakeven(int magic, ushort BUcent, ushort BUpoint){
   MqlTick last;
   
   double sl = 0.0;
   
   SymbolInfoTick(Symbol(), last);
   
   int total = OrdersTotal();
   double spread = 0.0;
   string cmnt = " none";
   for(int i = 0; i < total; i++){
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, "Ошибка выбора ордера: ", GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         
         if(OrderType() == OP_BUY && (last.ask - OrderOpenPrice()) >= BUcent*Point()){            
            sl = OrderOpenPrice() + BUpoint*Point();   
            spread = last.ask - OrderOpenPrice();  
            cmnt = " buy";                 
         }         
         if(OrderType() == OP_SELL && (OrderOpenPrice()-last.bid) >= BUcent*Point()){
            sl = OrderOpenPrice() - BUpoint*Point();
            spread = OrderOpenPrice() - last.bid;
            cmnt = " sell";
         }         
         
         if(sl != 0.0 && sl != OrderStopLoss()){
               Print("spread = ",spread, " ask = ",last.ask,"  bid = ",last.bid, "   OpenPrice = ",OrderOpenPrice()," type = ",cmnt);
               ResetLastError();
               if(!OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(),0)){
                  Print(__FUNCTION__," Ошибка установки безубытка. ",GetLastError());
                  return;
               };
         }
      }
   }
}