#property copyright "Enzzo"
#property link      "https://vk.com/id29520847"
#property strict

#include "time_duration.mqh"
//
// SetExpertMagic(магик)                                                         - Устанавливает магик для всех ордеров, которые обрабатываются через эту библиотеку
// SetExpertComment(комментарий)                                                 - Устанавливает комментарий для всех ордеров, которые обрабатываются через эту библиотеку

// Buy   (символ, лот, стоплос, тейкпрофит, комментарий)                         - Торговый приказ на BUY (тейкпрофит и стоплос в пунктах)
// Sell  (символ, лот, стоплос, тейкпрофит, комментарий)                         - Торговый приказ на SELL (тейкпрофит и стоплос в пунктах)
// Buy   (символ, лот, стоплос, тейкпрофит, комментарий)                         - Торговый приказ на BUY (тейкпрофит и стоплос в ценах)
// Sell  (символ, лот, стоплос, тейкпрофит, комментарий)                         - Торговый приказ на SELL (тейкпрофит и стоплос в ценах)

// BuyLimit  (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);  - Отложенный ордер BUYLIMIT(тейкпрофит и стоплос в пунктах)
// SellLimit (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);  - Отложенный ордер SELLLIMIT(тейкпрофит и стоплос в пунктах)
// BuyLimit  (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);  - Отложенный ордер BUYLIMIT(тейкпрофит и стоплос в ценах)
// SellLimit (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);  - Отложенный ордер SELLLIMIT(тейкпрофит и стоплос в ценах)

// BuyStop  (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);   - Отложенный ордер BUYSTOP(тейкпрофит и стоплос в пунктах)
// SellStop (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);   - Отложенный ордер SELLSTOP(тейкпрофит и стоплос в пунктах)
// BuyStop  (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);   - Отложенный ордер BUYSTOP(тейкпрофит и стоплос в ценах)
// SellStop (символ, лот, цена, стоплос, тейкпрофит, экспирация, комментарий);   - Отложенный ордер SELLSTOP(тейкпрофит и стоплос в ценах)

// CloseBuy();                                                                   - Закрывает рыночные ордера на BUY
// CloseSell();                                                                  - Закрывает рыночные ордера на SELL
// CloseTrades();                                                                - Закрывает все рыночные ордера по магику

// DeleteType(тип ордера);                                                       - Удаляет отложенный ордер по типу
// DeletePending(тикет);                                                         - Удаляет отложенныц ордер по тикету
// DeletePendings();                                                             - Удаляет все отложенные ордера по магику

// TralPointsGeneral(трал-шаг, трал-стоп);                                       - Тралит все ордера по магику
// TralPoints(int, int);
// TralCandles(ushort, ushort);

// Breakeven(int, int);

class CTrade{
private:
   int _magic;
   string _symbol;
   string _comment;   

public:

   CTrade(const int magic = 0, const string symbol = "", const string comment = ""): _magic(magic), _symbol(symbol), _comment(comment){
      if(symbol == ""){
         _symbol = Symbol();
      }
   };
   
   void SetExpertMagic(const int);
   void SetExpertSymbol(const string);
   void SetExpertComment(const string);
   const string GetExpertComment() const ;
   
   bool Buy(      const string, const double, const int,    const int,    const int,    const string)const;
   bool Sell(     const string, const double, const int,    const int,    const int,    const string)const;
   bool Buy(      const string, const double, const double, const double, const int,    const string)const;
   bool Sell(     const string, const double, const double, const double, const int,    const string)const;
   bool BuyLimit( const string, const double, const double, const int,    const int,    datetime, const string)const;
   bool SellLimit(const string, const double, const double, const int,    const int,    datetime, const string)const;
   bool BuyLimit( const string, const double, const double, const double, const double, datetime, const string)const;
   bool SellLimit(const string, const double, const double, const double, const double, datetime, const string)const;
   bool BuyStop(  const string, const double, const double, const int,    const int,    datetime, const string)const;
   bool SellStop( const string, const double, const double, const int,    const int,    datetime, const string)const;
   bool BuyStop(  const string, const double, const double, const double, const double, datetime, const string)const;
   bool SellStop( const string, const double, const double, const double, const double, datetime, const string)const;
   bool CloseBuy()const;
   bool CloseSell()const;
   bool CloseTrades()const;
   bool DeleteType(const int)const;
   bool DeletePendings()const;
   bool DeletePending(const int)const;
   
   void TralPointsGeneral(const int, const int)const;
   void TralPoints(const int, const int, const int)const;
   void Breakeven(const int, const int)const;
   void TralCandles(ushort, ushort)const;

   const uint TradesTotal() const;

private:
   string SetComment(const string comment)const;   
   bool CheckMoneyForTrade(const string, int, const double)const;
   const double TrueVolume(const string, const double)const;
};

void CTrade::SetExpertMagic(const int m = 0){
   _magic = m;
}

void CTrade::SetExpertSymbol(const string s){
   _symbol = s;
}
void CTrade::SetExpertComment(const string c){
   _comment = c;
}

bool CTrade::Buy(const string symbol = "", const double volume = 0.01, const int _SL = 0, const int _TP = 0, const int slp = 5, const string comment = "")const{
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);   
   const string cmnt = SetComment(comment);
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(s, tick);
   
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
   
   const double p  = tick.ask;
   const double sl = _SL == 0 ? 0.0 :NormalizeDouble(tick.ask - _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 :NormalizeDouble(tick.ask + _TP*Point()*_mtp, Digits());
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUY, v, p, slp, sl, tp, cmnt, _magic)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::Sell(const string symbol = "", const double volume = 0.01, const int _SL = 0, const int _TP = 0, const int slp = 5, const string comment = "")const{
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   string cmnt = SetComment(comment);
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(s, tick);
   
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
   
   const double p  = tick.bid;
   const double sl = _SL == 0 ? 0.0 : NormalizeDouble(tick.bid + _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 : NormalizeDouble(tick.bid - _TP*Point()*_mtp, Digits());
   
   ResetLastError();
   
   if(CheckMoneyForTrade(s, OP_SELL, v))if(!OrderSend(s, OP_SELL, v, p, slp, sl, tp, cmnt, _magic)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::Buy(const string symbol = "", const double volume = 0.01, const double _SL = 0.0, const double _TP = 0.0, const int slp = 5, const string comment = "")const{
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   
   string cmnt = SetComment(comment);
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(s, tick);
   
   const double p = tick.ask;
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUY, v, p, slp, _SL, _TP, cmnt, _magic)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::Sell(const string symbol = "", const double volume = 0.01,  const double _SL = 0.0, const double _TP = 0.0, const int slp = 5, const string comment = "")const{
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   
   string cmnt = SetComment(comment);
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(s, tick);
   
   const double p = tick.bid;
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_SELL, v, p, slp, _SL, _TP, cmnt, _magic)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::BuyLimit(const string symbol = "",const double volume = 0.01, const double price = 0.0, const int _SL = 0, const int _TP = 0, datetime expir = 0, const string comment = "")const{
   
   if(price == 0.0){
      Alert("Не указана цена для BUYLIMIT");
      return false;
   }
   string cmnt = SetComment(comment);
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
      
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0 ? 0.0 : NormalizeDouble(price - _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 : NormalizeDouble(price + _TP*Point()*_mtp, Digits());
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUYLIMIT, v, price, 5, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::BuyLimit(const string symbol = "",const double volume = 0.01, const double price = 0.0, const double _SL = 0.0, const double _TP = 0.0, datetime expir = 0, const string comment = "")const{
   
   if(price == 0.0){
      Alert("Не указана цена для BUYLIMIT");
      return false;
   }
   string cmnt = SetComment(comment);
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUYLIMIT, v, price, 5, _SL, _TP, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::BuyStop(const string symbol = "",const double volume = 0.01, const double price = 0.0, const int _SL = 0, const int _TP = 0, datetime expir = 0, const string comment = "")const{
   
   if(price == 0.0){
      Alert("Не указана цена для BUYLSTOP");
      return false;
   }
   string cmnt = SetComment(comment);
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
      
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0 ? 0.0 : NormalizeDouble(price - _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 : NormalizeDouble(price + _TP*Point()*_mtp, Digits());
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUYSTOP, v, price, 5, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::BuyStop(const string symbol = "",const double volume = 0.01, const double price = 0.0, const double _SL = 0.0, const double _TP = 0.0, datetime expir = 0, const string comment = "")const{
   
   if(price == 0.0){
      Alert("Не указана цена для BUYLSTOP");
      return false;
   }
   string cmnt = SetComment(comment);
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0.0 ? 0.0 : NormalizeDouble(_SL, Digits());
   const double tp = _TP == 0.0 ? 0.0 : NormalizeDouble(_TP, Digits());
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_BUY, v))if(!OrderSend(s, OP_BUYSTOP, v, price, 5, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::SellLimit(const string symbol = "", const double volume = 0.01, const double price = 0.0, const int _SL = 0, const int _TP = 0, datetime expir = 0, const string comment = "")const{
   if(price == 0.0){
      Alert("Не указана цена для SELLLIMIT");
      return false;
   }
   string cmnt = SetComment(comment);
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
      
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0 ? 0.0 : NormalizeDouble(price + _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 : NormalizeDouble(price - _TP*Point()*_mtp, Digits());
   
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_SELL, v))if(!OrderSend(s, OP_SELLLIMIT, v, price, 5, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::SellLimit(const string symbol = "", const double volume = 0.01, const double price = 0.0, const double _SL = 0.0, const double _TP = 0.0, datetime expir = 0, const string comment = "")const{
   if(price == 0.0){
      Alert("Не указана цена для SELLLIMIT");
      return false;
   }
   string cmnt = SetComment(comment);
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   
   int slp = (int)(MarketInfo(s, MODE_SPREAD));
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_SELL, v))if(!OrderSend(s, OP_SELLLIMIT, v, price, slp, _SL, _TP, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}


bool CTrade::SellStop(const string symbol = "", const double volume = 0.01, const double price = 0.0, const int _SL = 0, const int _TP = 0, datetime expir = 0, const string comment = "")const{
   if(price == 0.0){
      Alert("Не указана цена для SELLSTOP");
      return false;
   }
   string cmnt = SetComment(comment);
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
      
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0 ? 0.0 : NormalizeDouble(price + _SL*Point()*_mtp, Digits());
   const double tp = _TP == 0 ? 0.0 : NormalizeDouble(price - _TP*Point()*_mtp, Digits());
   
   int slp = (int)(MarketInfo(s, MODE_SPREAD));
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_SELL, v))if(!OrderSend(s, OP_SELLSTOP, v, price, slp, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::SellStop(const string symbol = "", const double volume = 0.01, const double price = 0.0, const double _SL = 0.0, const double _TP = 0.0, datetime expir = 0, const string comment = "")const{
   if(price == 0.0){
      Alert("Не указана цена для SELLSTOP");
      return false;
   }
   string cmnt = SetComment(comment);
   
   const string s = (symbol == "")?Symbol():symbol;
   const double v = TrueVolume(s, volume);
   const double sl = _SL == 0.0 ? 0.0 : NormalizeDouble(_SL, Digits());
   const double tp = _TP == 0.0 ? 0.0 : NormalizeDouble(_TP, Digits());
   
   int slp = (int)(MarketInfo(s, MODE_SPREAD));
   ResetLastError();
   if(CheckMoneyForTrade(s, OP_SELL, v))if(!OrderSend(s, OP_SELLSTOP, v, price, slp, sl, tp, cmnt, _magic, expir)){
      Print(__FUNCTION__,"  ",GetLastError());
      return false;
   }
   return true;
}

bool CTrade::CloseBuy()const{
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
   
   for(int i = total - 1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__,"  ",GetLastError());
         return false;
      }
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            ResetLastError();
            if(!OrderClose(OrderTicket(), OrderLots(), tick.bid, slp)){
               Print(__FUNCTION__,"  ",GetLastError());
               return false;
            }
         }
      }
   }
   
   return true;
}

bool CTrade::CloseSell()const{
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
   
   for(int i = total - 1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__,"  ",GetLastError());
         return false;
      }
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_SELL){
            ResetLastError();
            if(!OrderClose(OrderTicket(), OrderLots(), tick.ask, slp)){
               Print(__FUNCTION__,"  ",GetLastError());
               return false;
            }
         }
      }
   }
   
   return true;
}

bool CTrade::CloseTrades()const{
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   bool t = false;
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            t = OrderClose(OrderTicket(), OrderLots(), tick.bid, 5);
         }
         if(OrderType() == OP_SELL){
            t = OrderClose(OrderTicket(), OrderLots(), tick.ask, 5);
         }
      }
   }
   return true;
}

bool CTrade::DeleteType(int t = -1)const{
   if(OrdersTotal() == 0 || t == 0 || t == 1)
      return true;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if((OrderType() == t || t == -1) && OrderType() > 1){
            x = OrderDelete(OrderTicket());
         }
      }
   }   
   return true;
}

bool CTrade::DeletePendings(void)const{
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   bool t = false;
   for(int i = total - 1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
            t = OrderDelete(OrderTicket());
      }
   }
   return true;
}

bool CTrade::DeletePending(int t = 0)const{
   if(t == 0)
      return false;
   bool x = false;
   x = OrderDelete(t);
   return x;
}

void CTrade::TralPointsGeneral(const int _step = 10, const int _stop = 30)const{
   if(OrdersTotal() == 0)
      return;
   
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   
   bool x = false;
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
      
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_SELL && (OrderStopLoss() > NormalizeDouble(tick.ask + (_stop + _step)*_mtp*Point(), Digits()) || OrderStopLoss() == 0))
            x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(tick.ask + _stop*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());
         if(OrderType() == OP_BUY && OrderStopLoss() < NormalizeDouble(tick.bid - (_stop + _step)*_mtp*Point(), Digits()))
            x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(tick.bid - _stop*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());
      }
   }
}

void CTrade::TralPoints(const int ticket, const int _step = 10, const int _stop = 30)const{
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
   
   bool x = false;
      
   x = OrderSelect(ticket, SELECT_BY_TICKET);
   if(OrderType() == OP_SELL && (OrderStopLoss() > NormalizeDouble(Ask + (_stop + _step)*_mtp*Point(), Digits()) || OrderStopLoss() == 0))
      x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + _stop*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());
   if(OrderType() == OP_BUY && OrderStopLoss() < NormalizeDouble(Bid - (_stop + _step)*_mtp*Point(), Digits()))
      x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - _stop*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());  
}

//Безубыток
void CTrade::Breakeven(int ticket, int t = 0)const{
   if(t == 0.0)
      return;
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      _mtp = 10;
   
   bool x = false;
   
   x = OrderSelect(ticket, SELECT_BY_TICKET);
   if(OrderType() == OP_SELL && ((OrderStopLoss() > OrderOpenPrice() || OrderStopLoss() == 0.0) && OrderOpenPrice() > NormalizeDouble(Ask + (t+2)*_mtp*Point(), Digits())))
      x = OrderModify(ticket, OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - 2*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());
   if(OrderType() == OP_BUY && OrderStopLoss() < OrderOpenPrice() && OrderOpenPrice() < NormalizeDouble(Bid - (t+2)*_mtp*Point(), Digits()))
      x = OrderModify(ticket, OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + 2*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());  
}

//Трал по свечам
//n - номер свечи, по которой тралим
//о - сдвиг от high/low свечи
void CTrade::TralCandles(ushort n = 1, ushort o = 0)const{
   if(n < 1)Comment(__FUNCTION__+" не правильный номер свечи для трала.");
   if(OrdersTotal() == 0)return;
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), PERIOD_CURRENT, n, 1, rates);
   if(ArraySize(rates)<1)
      return;
      
   int _mtp = 1;
   if(Digits() == 5 || Digits() == 3) _mtp = 10;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY && OrderStopLoss() < NormalizeDouble(rates[0].low - o*_mtp*Point(), Digits()) && NormalizeDouble(rates[0].low - o*_mtp*Point(), Digits()) < Bid)
            x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(rates[0].low - o*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());
         if(OrderType() == OP_SELL && OrderStopLoss() != 0.0 && OrderStopLoss() > NormalizeDouble(rates[0].high + o*_mtp*Point(), Digits()) && NormalizeDouble(rates[0].high + o*_mtp*Point(), Digits()) > Ask)
            x = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(rates[0].high + o*_mtp*Point(), Digits()), OrderTakeProfit(), OrderExpiration());

      }
   }
}

const double CTrade::TrueVolume(const string s, const double v)const{
   if(v > MarketInfo(s, MODE_MAXLOT))
      return MarketInfo(s, MODE_MAXLOT);
   if(v < MarketInfo(s, MODE_MINLOT))
      return MarketInfo(s, MODE_MINLOT);
   return v;
}

bool CTrade::CheckMoneyForTrade(const string s, const int op, const double v)const{
   
   double freemargin = AccountFreeMarginCheck(s, op, v);
   if(freemargin < 0.0){
      if(!IsTesting())Alert("Не достаточно средств");
      return false;
   }
   return true;
}

string CTrade::SetComment(const string comment)const{
   string cmnt = _comment;
   if(StringLen(_comment) > 0 && StringLen(comment) > 0){
      cmnt += "_" + comment;
   }
   else if(StringLen(comment) > 0){
      cmnt = comment;
   }
   return cmnt;
}

string CTrade::GetExpertComment() const {
   return _comment;
}

const uint CTrade::TradesTotal()const {
   #ifdef DEBUG
   TIMER;
   #endif
   uint total = 0;
   for(int i = OrdersTotal()-1; i >= 0; --i){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == _symbol){
         ++total;
      }
   }
   return total;   
};