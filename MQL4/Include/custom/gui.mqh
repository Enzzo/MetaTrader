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
class GUIObject{
   string      _label;
   int         _x_position, _y_position, 
               _width, _height;
   int         _subobjects_count;
   
   ENUM_OBJECT _object;
   GUIObject   _subobject[];

public:
   GUIObject() = delete;
   ~GUIObject(){
      for(int i = 0; i < _subobjects_count; ++i){
         _subobject[i].Delete();
      }
      this.Delete();
   }
   
   void Delete(){
      if(ObjectFind(ChartID(), GetLabel());
      ObjectDelete(ChartID(),this.GetLabel());
   }
   
private:
   string GetLabel() const {
      return _label;
   }
};

//--------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------
class TextLabelObject : public GUIObject{
public:
   TextLabelObject();
};

class BitmabObject : public GUIObject{
   
};