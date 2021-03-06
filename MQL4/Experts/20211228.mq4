#property copyright "Sergey_Vasilev"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <trade.mqh>

CTrade trade;

struct Info{
   string fields[];
   
   void AddField(const string field){
      ArrayResize(fields, ArraySize(fields) + 1);
      fields[ArraySize(fields)-1] = field;
   }

   void UpdateField(const string field, string new_value){
      for(int i = 0; i < ArraySize(fields); ++i){
         if(StringFind(fields[i], field) != -1){
            fields[i] = field + ": " + new_value;
            return;
         }
      }
      AddField(field + ": "+new_value);
   }
      
   string ToString()const{
      string inf;
      for(int i = 0; i < ArraySize(fields); ++i){
         inf+=fields[i]+"\n";
      }
      return inf;
   }
}info;

input int      MAGIC             = 12345;
input bool     BROKERLSECN       = true;
input string   TRADE_TIME_START  = "12:00";  //Установка ордеров (начало работы)
input string   C1                = "";       //---------------------------------
input bool     CLOSE_POSITIONS   = true;     //Принудительное закрытие позиций
input string   TRADE_TIME_END    = "21:00";  //Закрытие открытых позиций
input string   C2                = "";       //---------------------------------
input bool     CLOSE_PENDINGS    = true;     //Принудительное закрытие ордеров
input string   PENDINGS_TIME_END = "23:00";  //Закрытие несработавших ордеров
input string   C3                = "";       //---------------------------------

double pivot = 0.0;
ushort state;

int OnInit(){
   EventSetTimer(1);
   trade.SetExpertMagic(MAGIC);
   info.UpdateField("Current time", TimeToString(GetCurrentTime()));
   info.UpdateField("Magic", IntegerToString(MAGIC));
   info.UpdateField("Broker ECN", BROKERLSECN);
   info.UpdateField("Open time", TRADE_TIME_START);
   info.UpdateField("Positions close", PENDINGS_TIME_END + " - " + CLOSE_PENDINGS);
   info.UpdateField("Trade time end", TRADE_TIME_END + " - " + CLOSE_POSITIONS);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   EventKillTimer();
   Comment("");
}

void OnTick(){
   
   state = TradingState();
   
   info.UpdateField("state", state);
   
   if((state & 7) == 1){ //0b00000001 & 0b00000111 == 0b00000001 - только открытие. За открытие отвечает первый бит state
      //OPEN_STATE
      info.UpdateField("test_field", "OPEN");
      
      //Рисуем pivot и pivot-level для выставления ордеров
      if(pivot < Point()){
         MqlRates rates[];
         CopyRates(Symbol(), PERIOD_H1, 0, 23, rates);
         for(int i = 0; i < ArraySize(rates); ++i){
            if(rates[i].time == StringToTime(TRADE_TIME_START)){
               pivot = NormalizeDouble(rates[i].close, Digits());
               Print(rates[i].time+" "+StringToTime(TRADE_TIME_START));
               break;
            }
         }         
      }
      //Ставим отложки
      info.UpdateField("pivot", DoubleToString(pivot));
   }
   else if((state & 2) == 2){
      //CLOSE_TRADES_STATE
      info.UpdateField("test_field", "CLOSE");
      pivot = 0.0;
   }
   else if((state & 4) == 4){
      //CLOSE_PENDINGS_STATE
      info.UpdateField("test_field", "PENDING CLOSE");
      pivot = 0.0;
   }   
}

void OnTimer(){
   info.UpdateField("Current time", TimeToString(GetCurrentTime()));
   Comment(info.ToString());
}

const unsigned short TradingState(){
   //----------------------------------
   //    ^          ^           ^
   //   open      close       close
   //             trades      pendings
   //----------------------------------
   
   //----------------------------------
   //    ^          ^           ^
   //   open      close       close
   //             pendings    trades
   //----------------------------------
   
   
   const datetime hour           = GetCurrentTime();
   const datetime open           = StringToTime(TRADE_TIME_START);
   const datetime close_trades   = StringToTime(PENDINGS_TIME_END);
   const datetime close_pendings = StringToTime(TRADE_TIME_END);
   
   unsigned short result = 0;
   
   if(hour >= open)                             result |= 1;
   if(hour >= close_trades && CLOSE_POSITIONS)  result |= 2;
   if(hour >= close_pendings && CLOSE_PENDINGS) result |= 4;
   return result;
}

const inline datetime GetCurrentTime(){
   return (BROKERLSECN)?TimeCurrent():TimeLocal();
}