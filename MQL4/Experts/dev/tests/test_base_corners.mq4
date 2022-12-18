//+------------------------------------------------------------------+
//|                                            test_base_corners.mq4 |
//|                                                           Sergey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <custom/gui.mqh>

string pref = "test_corner";

input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER;

RectLabelObject rect("test", 60, 60, 50, 50, clrRed, 2, CORNER);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   // RectLabelCreate(pref, 60, 60, 50, 50, clrRed, 2, CORNER);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectsDelete();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

//Удаляет все объекты, используемые этим советником
// ot = общее количество всех объектов
// on = имя объекта
void ObjectsDelete(){
   int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, pref)!= -1) ObjectDelete(ChartID(), on);
      }
   }
}
