//+------------------------------------------------------------------+
//|                                                        table.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#import "stdlib.ex4"
string ErrorDescription(int error_code); 
#import

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
//---
   string path = "table.csv";
   int fileHandle = FileOpen(path, FILE_READ|FILE_CSV);
   
   if (fileHandle == INVALID_HANDLE){
      Print(ErrorDescription(GetLastError()));
      return;
   }
   
   int i = 0;
   while(!FileIsEnding(fileHandle)){
      string str = FileReadString(fileHandle, 10);
      Print("[",IntegerToString(i++),"] ", str);
   }
}
//+------------------------------------------------------------------+
