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

typedef int (*SignalFunc)();

class Expert{
   CTrade      _trade;
   SignalFunc  _signals[];
   int         _magic;
   string      _symbol;
   string      _comment;
   int         _sl, _tp;
   double      _volume;
   
public:

   Expert(const int magic, const string& symbol, const string& comment) : _magic(magic), _symbol(symbol), _comment(comment){
      Init();
   }
   
   Expert() : _magic(0), _symbol(Symbol()), _comment(""){
      Init();
   }  
   
   
   Expert* SetSignal(SignalFunc Func){
      int size = ArraySize(_signals);
      ArrayResize(_signals, size + 1);
      _signals[size] = Func;
      return &this;
   }
   
   Expert* SetStopLoss(const int s){
      _sl = s;
      return &this;
   }
   
   Expert* SetTakeProfit(const int t){
      _tp = t;
      return &this;
   }
   
   Expert* SetVolume(const double volume){
      _volume = volume;
      return &this;
   }
   
   // Выполняет один из видов выставления ордеров
   void Run() const{
      int buy = 0, sell = 0; // -1 - no signal; 0 - buy signal; 1 - sell signal
      static int last_deal = -1;
      
      // TODO: Переделать, чтобы проверял ордера только по заданному магику и символу!!!
      // Это временный вариант. Только для проверки
      if(OrdersTotal() == 0) last_deal = -1; 
      
      for(int i = 0; i < ArraySize(_signals); ++i){
         
         short s = _signals[i]();
         if(s == 0) ++buy;
         if(s == 1) ++sell;
      }
      
      if(sell < buy && last_deal != OP_BUY){
         if(_trade.Buy(_symbol, _volume, _sl, _tp, 5, _comment)){
            last_deal = OP_BUY;
         }
      }
      else if(buy < sell && last_deal != OP_SELL){
         if(_trade.Sell(_symbol, _volume, _sl, _tp, 5, _comment)){
            last_deal = OP_SELL;
         }
      }
   }
private:
   void Init(){
      _trade.SetExpertMagic(_magic); _trade.SetExpertComment(_comment);
   }
};