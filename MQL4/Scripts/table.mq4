//+------------------------------------------------------------------+
//|                                                        table.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

struct some{
   int x, y;
};

#import "stdlib.ex4"
string ErrorDescription(int error_code); 
#import "table.dll"
void ParseQuery(some&);
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
   string query;
   int i = 0;
   while(!FileIsEnding(fileHandle)){
      query += FileReadString(fileHandle) + " | ";
      /*
      if(str[StringLen(str)-1] == '\n'){
         Print("new line");
      }
      else Print("[",IntegerToString(i++),"] ", str);
      */
   }
   
   some s;
   ParseQuery(s);
   Print(s.x+" "+s.y);
}
//+------------------------------------------------------------------+