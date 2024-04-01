//+------------------------------------------------------------------+
//|                                                   observable.mqh |
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

#include <Arrays/ArrayObj.mqh>

#include <dev/observer.mqh>

class observable{
private:
   CArrayObj* observers;
   
public:
   
   observable(): observers(new CArrayObj){
      observers.FreeMode(true);
   }
   
   ~observable(){   
      
      if(observers != NULL){
         delete observers;
      }
   }
   
   void notify_update(){
      for(int i = 0; i < observers.Total(); ++i){
         observer* obs = observers.At(i);
         if(obs != NULL){
            obs.update();
         }
      }
   }
   
   void add_observer(observer* o){
      observers.Add(o);
   }   
};