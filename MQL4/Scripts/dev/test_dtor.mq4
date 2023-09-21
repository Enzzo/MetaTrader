//+------------------------------------------------------------------+
//|                                                    test_dtor.mq4 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

class some_class{
public:
   some_class() 
      : ptr = new int(1){};
      
  ~some_class();
   
private:
   int* ptr;
}

some_class::~some_class(){
   if(CheckPointer(ptr)){
      Print("+");
   }
   else{
      Print("-");
   }
}

void OnStart(){
//---
   some_class sc;
}
//+------------------------------------------------------------------+
