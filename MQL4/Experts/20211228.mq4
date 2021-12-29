#property copyright "Sergey_Vasilev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <trade.mqh>

CTrade trade;

enum ENUM_STATE{
   OPEN,
   DELETE_TRADES,
   DELETE_PENDINGS,
   CLOSE
};

input int      MAGIC             = 12345;
input bool     BROKERLSECN       = true;
input string   TRADE_TIME_START  = "12:00";  //Установка ордеров (начало работы)
input string   POSITION_TIME_END = "23:00";  //Закрытие несработавших ордеров
input string   TRADE_TIME_END    = "21:00";  //Закрытие открытых сделок

int OnInit(){
   EventSetTimer(60);
   trade.SetExpertMagic(MAGIC);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   EventKillTimer();
   Comment("");
}

void OnTick(){
   ENUM_STATE state = TradingState();
   switch(state){
      case OPEN:{
         Comment(TimeToString(GetCurrentTime())+" [OPEN]");
         break;
      }
      case DELETE_TRADES:{        
         Comment(TimeToString(GetCurrentTime())+" [DELETE_TRADES]");
         break;
      }
      case DELETE_PENDINGS:{
         Comment(TimeToString(GetCurrentTime())+" [DELETE_PENDINGS]");
         break;
      }
      case CLOSE:{
         Comment(TimeToString(GetCurrentTime())+" [CLOSE]");
         break;
      }
   }
}

void OnTimer(){
   
}

const ENUM_STATE TradingState(){
   //---------------------------------
   //    ^          ^           ^
   //   open      close       close
   //             trades      pendings
   
   const datetime hour           = GetCurrentTime();
   const datetime open           = StringToTime(TRADE_TIME_START);
   const datetime close          = StringToTime(POSITION_TIME_END);
   const datetime close_pendings = StringToTime(TRADE_TIME_END);
   
   if(hour >= open){
      if(hour >= close)          return ENUM_STATE::DELETE_TRADES;
      if(hour >= close_pendings) return ENUM_STATE::DELETE_PENDINGS;
      return ENUM_STATE::OPEN;
   }
   
   return ENUM_STATE::CLOSE;
}

const datetime GetCurrentTime(){
   return (BROKERLSECN)?TimeCurrent():TimeLocal();
}