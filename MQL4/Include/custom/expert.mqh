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

// Структура сигнала
// идентификатор сигнала для того, чтобы не обрабатывать один и тот же сигнал по несколько раз
// сам сигнал -1,0,1
struct Signal{
   double id;
   ENUM_ORDER_TYPE type;
};

// Выставлять ордера
enum ENUM_STRATEGY{
   EVER_SIGNAL,                     // На каждом сигнале, даже если они в одном направлении
   EVER_SIGNAL_OPPOSITE_POSITIONS   // На каждой противоположной позиции (ести стоит бай, то ищем сигналы только на селл)
};

// Указатель на функцию, возвращающую сигнал -1,0 или 1
typedef Signal (*SignalFunc)();

// Указатель на функцию, возвращающую уровень для стоплосса, или тейкпрофита
typedef double (*StopLimitFunc)();

// Expert - это оболочка для торговых стратегий
// Для сигналов используются специальные функции, возвращающие -1,0,1, где -1 - нет сигнала, 0 - buy, 1 - sell
// Для выставления SL TP используются два типа функций.
//    Один - для фиксированных
//    Второй - для значений, рассчитанных специальными функциями

class Expert{
   CTrade         _trade;
   SignalFunc     _signals[];
   ENUM_STRATEGY  _strategy;
   int            _magic;
   string         _symbol;
   string         _comment;
   int            _sl, _tp;
   double         _volume;
   
public:

   Expert(const int magic, const string& symbol, const string& comment) : _magic(magic), _symbol(symbol), _comment(comment){
      Init();
   }
   
   Expert() : _magic(0), _symbol(Symbol()), _comment(""){
      Init();
   }  
   
   Expert* SetStrategy(ENUM_STRATEGY strategy);   
   Expert* SetSignal(SignalFunc Func);   
   Expert* SetStopLoss(const int s);   
   Expert* SetTakeProfit(const int t);   
   Expert* SetVolume(const double volume);
   
   // Выполняет один из видов выставления ордеров
   void Run() const;
   
private:
   void Init();   
   void EverSignalStrategy()const;
   void EverSignalStrategyOppositeSignal()const;
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
   ArrayResize(_signals, size + 1);
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
         EverSignalStrategyOppositeSignal();
         break;
      }
   }
}

void Expert::Init(){
   _trade.SetExpertMagic(_magic); _trade.SetExpertComment(_comment);
}
   
void Expert::EverSignalStrategy()const{
   int buy = 0, sell = 0; // -1 - no signal; 0 - buy signal; 1 - sell signal
   static int last_deal = -1;
   static double id = 0.0;
     
   // TODO: Переделать, чтобы проверял ордера только по заданному магику и символу!!!
   // Это временный вариант. Только для проверки
   if(OrdersTotal() == 0) last_deal = -1; 
     
   for(int i = 0; i < ArraySize(_signals); ++i){
      
      Signal s = _signals[i]();
      if(s.id != id){
         if(s.type == OP_BUY) ++buy;
         if(s.type == OP_SELL) ++sell;
         s.id = id;
      }
   }
   
   if(sell < buy && last_deal != OP_BUY){
      if(_trade.Buy(_symbol, _volume, _sl, _tp, 5, _comment)){
         // last_deal = OP_BUY;
      }
   }
   else if(buy < sell && last_deal != OP_SELL){
      if(_trade.Sell(_symbol, _volume, _sl, _tp, 5, _comment)){
         // last_deal = OP_SELL;
      }
   }
}
   
void Expert::EverSignalStrategyOppositeSignal()const{
   int buy = 0, sell = 0; // -1 - no signal; 0 - buy signal; 1 - sell signal
   static int last_deal = -1;
   static double id = 0.0;
    
   // TODO: Переделать, чтобы проверял ордера только по заданному магику и символу!!!
   // Это временный вариант. Только для проверки
   if(OrdersTotal() == 0) last_deal = -1; 
    
   for(int i = 0; i < ArraySize(_signals); ++i){
       
      Signal s = _signals[i]();
      if(s.id != id){
         if(s.type == OP_BUY) ++buy;
         if(s.type == OP_SELL) ++sell;
         s.id = id;
      }
   }
     
   if(sell < buy && last_deal != OP_BUY){
      if(_trade.Buy(_symbol, _volume, _sl, _tp, 5, _comment)){
         // last_deal = OP_BUY;
      }
   }
   else if(buy < sell && last_deal != OP_SELL){
      if(_trade.Sell(_symbol, _volume, _sl, _tp, 5, _comment)){
         // last_deal = OP_SELL;
      }
   }
}