//+------------------------------------------------------------------+
//|                                               open_on_h1.mqh.mq5 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property description "бот для выставление двух отложенных Stop ордеров от текущей цены Bid"
#property description "на открытии нового часа (Н1) на определенном расстоянии"
#property description "от цены +/- N пунктов. Уровни Т/Р и S/L, треллинг стоп не уходящий в минус."
#property description "При открытии одного ордера – второй удаляется."

#include <dev\trailing_stop.mqh>

input int MAGIC = 9999;
input int TP = 30;
input int SL = 10;
input ENUM_TRAL_TYPE tral_type1 = NONE;
input ENUM_TRAL_TYPE tral_type2 = NONE;
input ENUM_TRAL_TYPE tral_type3 = NONE;
input ENUM_TRAL_TYPE tral_type4 = NONE;

TrailingStop* tral;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
  tral.SetTralType((ushort)(tral_type1 | tral_type2 | tral_type3 | tral_type4)).SetMagic(MAGIC).SetSymbol(Symbol());
  tral.Display();  
//---
  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+
