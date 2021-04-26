//+------------------------------------------------------------------+
//|                                                    eaWebtest.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

string url = "https://www.forexfactory.com/calendar.php";
string headers;
string cookies = NULL;
int timeout = 5000;
int res;
char post[1];
char result[1];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---

   res = WebRequest("GET", url, cookies, NULL, timeout, post, 0, result, headers);
   if(res != -1)Print(result[0]);
   else Print("error "+res);
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
