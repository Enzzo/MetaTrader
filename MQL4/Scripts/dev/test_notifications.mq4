//+------------------------------------------------------------------+
//|                                                    test_dtor.mq4 |
//|                                                   Sergey Vasilev |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property strict

#include <utils/mt4_adaptor.mqh>

#include <terminal/scripts/test_notifications.mqh>

TestNotifications tn;

void OnStart(){
    tn.OnStart();
}