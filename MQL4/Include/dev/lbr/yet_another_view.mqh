//+------------------------------------------------------------------+
//|                                             yet_another_view.mqh |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property strict
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

#include <dev/observer.mqh>
#include <dev/lbr/lbr_model.mqh>

class yet_another_view : public observer{
   lbr_model* _model;
   string _name;
   
public:
   
   yet_another_view(lbr_model* model) : _model(model), _name("another view"){
      _model.add_observer(&this);
   }

   void update() override{
      Print(__FUNCTION__ + " yet_another_view " + DoubleToString(_model.get_price(), 3));
   }
};