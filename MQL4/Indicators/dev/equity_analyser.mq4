//+------------------------------------------------------------------+
//|                                              equity_analyser.mq4 |
//|                                                           Sergey |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property strict
#property indicator_chart_window

input int FREQ    = 1;  // Частота обновления (сек)
input int PERIOD  = 30; // Периодичность (мин)

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   EventSetTimer(FREQ);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

void OnTimer(){
   MqlDateTime time;
   TimeLocal(time);
   
   if(time.min % PERIOD == 0 && time.sec == 0){     
      //Print(time.hour+":"+time.min+":"+time.sec);
      WriteBalanceEquity("balance-equity.csv");
   }
}

void OnDeinit(const int reason){
   EventKillTimer();
   Comment("");
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| WriteBalanceEquity                                               |
//| Функция записывает в конец файла время, баланс и эквити          |
//+------------------------------------------------------------------+
void WriteBalanceEquity(const string filename){
   string folder = "analyse\\"+ITS(AccountNumber())+"\\";
   int handle = FileOpen(folder + filename, FILE_READ|FILE_WRITE|FILE_CSV);
   
   if(handle == INVALID_HANDLE){
      Alert("File "+filename+" was failed");
      return;
   }
   
   static int day_of_week = -1;
   MqlDateTime time;
   TimeLocal(time);
   
   if(FileSeek(handle, 0, SEEK_END) == true){
      if(day_of_week == -1 || day_of_week != time.day_of_week){
         FileWrite(handle, DayOfWeekToString(time.day_of_week));
         day_of_week = time.day_of_week;
      }
      FileWrite(handle, "", ITS(time.hour) + ":" + ITS(time.min), AccountBalance(), DoubleToString(AccountEquity(),3), DoubleToString(AccountEquity() - AccountBalance(),3));
   }
   
   FileClose(handle);
}

string DayOfWeekToString(int day){
   switch(day){
      case 0: return "Воскресенье";
      case 1: return "Понедельник"; 
      case 2: return "Вторник"; 
      case 3: return "Среда";
      case 4: return "Четверг";
      case 5: return "Пятница";
      case 6: return "Суббота";
   }
   return "";
}

string ITS(int i){
   return IntegerToString(i);
}