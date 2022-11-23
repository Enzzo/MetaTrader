//+------------------------------------------------------------------+
//|                                                          gui.mqh |
//|                                                           Sergey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com"
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


//--------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------
class GUI_Object{
   string      _label;
   int         _x_position, _y_position, 
               _width, _height;
   ENUM_OBJECT _object;
   GUI_Object  _sub_objects[];

public:
   GUI_Object(){}
   ~GUI_Object(){}
   
   void AttachSubObject(const GUI_Object&){
      ArrayResize(_sub_objects, ArraySize(_sub_objects)+1);
   };
   virtual void DetachSubObject(const GUI_Object&);
};

//--------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------
class Text_Object : public GUI_Object{   
};

struct Coordinates{
};