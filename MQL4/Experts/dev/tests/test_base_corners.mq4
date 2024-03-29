//+------------------------------------------------------------------+
//|                                            test_base_corners.mq4 |
//|                                                           Sergey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// Должен проверять и перерисовывать объекты, если они удалены случайно
// Для этого создаём объект в global scope, а отрисовываем его в OnTick()
// В OnInit мы задаём параметры отрисовки черзе функцию SetProps()
// Так же через SetProps будем менять положение объекта в функции OnTick()
// например, сменить парковку окна

#property copyright "Sergey"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <custom/gui.mqh>

input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER;

RectLabelObject rect();

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   EventSetTimer(1);
   rect.SetProps("test", 60, 60, 100, 250, clrBlue, 2, CORNER);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

void OnTimer(){
   rect.Redraw();
}