//+------------------------------------------------------------------+
//|                                                       expert.mqh |
//|                                                           Sergey |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property strict

#include <custom\trade.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
// Structure Signal                                                  |
// идентификатор сигнала для того, чтобы не обрабатывать один и тот  |
// же сигнал по несколько раз                                        |
// сам сигнал -1,0,1                                                 |
//+------------------------------------------------------------------+
struct Signal{
   int id;
   ENUM_ORDER_TYPE type;
};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
// enumerator ENUM_STRATEGY                                          |
// Виды выставления ордеров                                          |
//+------------------------------------------------------------------+
enum ENUM_STRATEGY{
   EVER_SIGNAL,                     // На каждом сигнале, даже если они в одном направлении
   EVER_SIGNAL_OPPOSITE_POSITIONS,  // На каждой противоположной позиции (ести стоит бай, то ищем сигналы только на селл)
   EVERY_CROSS_CLOSE,               // Выставлять ордер и закрывать противоположную позицию
   POSITIVE_CROSS_CLOSE             // Выставлять ордер только если противоположная позиция не отрицательна и закрывать её
};
//+------------------------------------------------------------------+

// ---Указатель на функцию, возвращающую сигнал -1,0 или 1
typedef Signal (*SignalFunc)();

// ---Указатель на функцию, возвращающую уровень для стоплосса, или тейкпрофита
typedef double (*StopLimitFunc)();

typedef const int cint;
// Expert - это оболочка для торговых стратегий
// Для сигналов используются специальные функции, возвращающие -1,0,1, где -1 - нет сигнала, 0 - buy, 1 - sell
// Для выставления SL TP используются два типа функций.
//    Один - для фиксированных
//    Второй - для значений, рассчитанных специальными функциями

class Expert{

   // Структура итоговых сумм сигналов
   // Суммарное количество сигналов на buy и sell
   struct Direction{
      short buy, sell;
   };
   
   CTrade         _trade;
   
   SignalFunc     _signals[];
   StopLimitFunc  _stop_loss_buffers[];
   StopLimitFunc  _take_profit_buffers[];
   
   ENUM_STRATEGY  _strategy;
   int            _magic;
   string         _symbol;
   string         _comment;
   int            _sl, _tp;
   double         _sld,_tpd;
   double         _volume;
   
   int            _mtp;
   int            _digits;
   
public:

   Expert(const int magic, const string symbol, const string comment) : _magic(magic), _symbol(symbol), _comment(comment){
      Init();
   }
   
   Expert() : _magic(0), _symbol(Symbol()), _comment(""){
      Init();
   }  
   
   Expert* SetStrategy(ENUM_STRATEGY strategy);
   Expert* SetSignal(SignalFunc Func);
   Expert* SetStopLoss(const int s);
   Expert* SetTakeProfit(const int t);
   Expert* SetStopLoss(StopLimitFunc s);   
   Expert* SetTakeProfit(StopLimitFunc t); 
   Expert* SetVolume(const double volume);
   
   // Выполняет один из видов выставления ордеров
   void Run() const;
   
private:
   void Init();   
   void EverSignalStrategy() const;
   void EverSignalOppositeDealStrategy() const;
   void EveryCrossClose() const;
   
   const double GetBuySL() const;
   const double GetBuyTP() const;
   const double GetSellSL() const;
   const double GetSellTP() const;
   
   const double GetAsk() const;
   const double GetBid() const;
   
   const int GetLastDeal() const;
   
   const Direction GetDirections() const;
   const int SignalsCount() const;
};

//------------------------------------------------------------
// SetStrategy
//
// Устанавливает одну из выбранных стратегий выставления
// ордеров
//------------------------------------------------------------
Expert* Expert::SetStrategy(ENUM_STRATEGY strategy){
   _strategy = strategy;
   return &this;
}

//------------------------------------------------------------
// SetSignal
//
// Добавляет функцию, расчитывающую сигнал в коллекцию функций
//------------------------------------------------------------   
Expert* Expert::SetSignal(SignalFunc Func){
   int size = ArraySize(_signals);
   ArrayResize(_signals, size+1);
   _signals[size] = Func;
   return &this;
}

//------------------------------------------------------------
// SetStopLoss
//
// Устанавливает фиксированный стоплосс
//------------------------------------------------------------
Expert* Expert::SetStopLoss(const int s){
   _sl = s;
   return &this;
}

//+-----------------------------------------------------------+
// SetTakeProfit
//
// Устанавливает тейкпрофит по буферам индикатора
//+-----------------------------------------------------------+
Expert* Expert::SetTakeProfit(StopLimitFunc Func){
   int size = ArraySize(_take_profit_buffers);
   ArrayResize(_take_profit_buffers, size + 1);
   _take_profit_buffers[size] = Func;
   return &this;
}

//+-----------------------------------------------------------+
// SetStopLoss
//
// Устанавливает стоплосс по буферам индикатора
//+-----------------------------------------------------------+
Expert* Expert::SetStopLoss(StopLimitFunc Func){
   int size = ArraySize(_stop_loss_buffers);
   ArrayResize(_stop_loss_buffers, size + 1);
   _stop_loss_buffers[size] = Func;
   return &this;
}

//------------------------------------------------------------
// SetTakeProfit
//
// Устанавливает фиксированный тейкпрофит
//------------------------------------------------------------
Expert* Expert::SetTakeProfit(const int t){
   _tp = t;
   return &this;
}

//------------------------------------------------------------
// SetVolume
//
// Устанавливает фиксированный объём
//------------------------------------------------------------
Expert* Expert::SetVolume(const double volume){
   _volume = volume;
   return &this;
}

//------------------------------------------------------------
// Run
//
// Выполняет один из видов выставления ордеров
//------------------------------------------------------------
void Expert::Run() const{
   switch(_strategy){
      case EVER_SIGNAL:{
         EverSignalStrategy();
         break;
      }
      case EVER_SIGNAL_OPPOSITE_POSITIONS:{
         EverSignalOppositeDealStrategy();
         break;
      }
      case EVERY_CROSS_CLOSE:{
         EveryCrossClose();
         break;
      }
   }
}

//------------------------------------------------------------
// Init
//
// Устанавливаем значения полей _digits, _mtp и magic, comment
// для советника
//------------------------------------------------------------
void Expert::Init(){
   _trade.SetExpertMagic(_magic); _trade.SetExpertComment(_comment);
   _digits = (int)MarketInfo(_symbol, MODE_DIGITS);
   _mtp = (_digits == 5 || _digits == 3)?10:1;
}

// Возвращает StopLoss для ордера Buy
const double Expert::GetBuySL() const{
   // Сначала проверяем, привязаны ли буферы индикаторов к стоплосам:
   int size = ArraySize(_stop_loss_buffers);
   double sl = .0;
   
   if(size > 0){
      for(int i = 0; i < size; ++i){
         if(sl > GetAsk() || sl > _stop_loss_buffers[i]() || sl == .0){
            sl = _stop_loss_buffers[i]();
         }
      }
   }
   else if(_sl > .0){
      sl = GetAsk() - NormalizeDouble((_sl * _mtp * Point()),_digits);
   }
   return sl;
};

// Возвращает TakeProfit для ордера Buy
const double Expert::GetBuyTP() const{
   // Сначала проверяем, привязаны ли буферы индикаторов к стоплосам:
   int size = ArraySize(_take_profit_buffers);
   double tp = .0;
   
   if(size > 0){
      for(int i = 0; i < size; ++i){
         if(tp < GetAsk() || tp < _take_profit_buffers[i]() || tp == .0){
            tp = _take_profit_buffers[i]();
         }
      }
   }
   else if(_tp > .0){
      tp = GetAsk() + NormalizeDouble((_tp * _mtp * Point()),_digits);
   }
   return tp;
};

// Возвращает StopLoss для ордера Sell
const double Expert::GetSellSL() const{
   int size = ArraySize(_stop_loss_buffers);
   double sl = .0;
   
   if(size > 0){
      for(int i = 0; i < size; ++i){
         if(sl < GetBid() || sl < _stop_loss_buffers[i]() || sl == .0){
            sl = _stop_loss_buffers[i]();
         }
      }
   }
   
   else if(_sl > .0){
      sl = GetBid() + NormalizeDouble((_sl * _mtp * Point()),_digits);
   }
   return sl;
};

// Возвращает TakeProfit для ордера Sell
const double Expert::GetSellTP() const{
   int size = ArraySize(_take_profit_buffers);
   double tp = .0;
   
   if(size > 0){
      for(int i = 0; i < size; ++i){
         if(tp > GetBid() || tp > _take_profit_buffers[i]() || tp == .0){
            tp = _take_profit_buffers[i]();
         }
      }
   }
   
   else if(_tp > .0){
      tp = GetBid() - NormalizeDouble((_tp * _mtp * Point()),_digits);
   }
   return tp;
};

// Возвращает Ask
const double Expert::GetAsk() const{
   return NormalizeDouble(MarketInfo(_symbol, MODE_ASK), _digits);
};

// Возвращает Bid
const double Expert::GetBid() const{
   return NormalizeDouble(MarketInfo(_symbol, MODE_BID), _digits);
};

//------------------------------------------------------------
// GetDirections
//
// Возвращает количество сигналов на buy и sell
//------------------------------------------------------------
const Direction Expert::GetDirections(void)const{
   Direction d;
   d.buy = 0;
   d.sell = 0;
   
   
   static int id[];
   
   if(ArraySize(id) < SignalsCount()) ArrayResize(id, SignalsCount());
   
   for(int i = 0; i < SignalsCount(); ++i){
      
      string debug = IntegerToString(id[i]);
      
      Signal s = _signals[i]();
      debug += " "+IntegerToString(s.id);
      if(s.id != id[i] && s.id != 0){
         if(s.type == OP_BUY) ++d.buy;
         if(s.type == OP_SELL) ++d.sell;
         id[i] = s.id;
      }
      // Print(debug);
   }
   return d;
};

const int Expert::SignalsCount() const{
   return ArraySize(_signals);
}
//------------------------------------------------------------
// EverSignalStrategy
//
// Выставляет ордера на КАЖДОМ сигнале
//------------------------------------------------------------
void Expert::EverSignalStrategy()const{
   Direction d = GetDirections();
   
   if(d.sell < d.buy){
      _trade.Buy(_symbol, _volume, GetBuySL(), GetBuyTP(), 5, _comment);
   }
   else if(d.buy < d.sell){
      _trade.Sell(_symbol, _volume, GetSellSL(), GetSellTP(), 5, _comment);
   }
}

//------------------------------------------------------------
// EverSignalStrategyOppositeDeal
//
// Выставляет ордера по сигналу, если нет предыдущего ордера
// в том же направлении
//------------------------------------------------------------
void Expert::EverSignalOppositeDealStrategy()const{
   Direction d = GetDirections();
     
   if(d.sell < d.buy && GetLastDeal() != OP_BUY){
      _trade.Buy(_symbol, _volume, _sl, _tp, 5, _comment);
   }
   else if(d.buy < d.sell && GetLastDeal() != OP_SELL){
      _trade.Sell(_symbol, _volume, _sl, _tp, 5, _comment);
   }
}

//------------------------------------------------------------
// EveryCrossClose
//
// Выставляет ордера на КАЖДОМ сигнале
//------------------------------------------------------------
void Expert::EveryCrossClose()const{
   Direction d = GetDirections();
   
   if(d.sell < d.buy){
      _trade.CloseSell();
      _trade.Buy(_symbol, _volume, GetBuySL(), GetBuyTP(), 5, _comment);
   }
   else if(d.buy < d.sell){
      _trade.CloseBuy();
      _trade.Sell(_symbol, _volume, GetSellSL(), GetSellTP(), 5, _comment);
   }
}


//------------------------------------------------------------
// GetLastDeal
//
// Возвращает тип последней открытой сделки по магику и символу
//------------------------------------------------------------
const int Expert::GetLastDeal(void)const{
   
   for(int i = OrdersTotal()-1; i >= 0; --i){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == _magic && OrderSymbol() == _symbol)
         return OrderType();
   }
   
   return -1;
}