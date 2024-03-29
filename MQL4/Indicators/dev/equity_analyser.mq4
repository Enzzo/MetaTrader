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

enum ENUM_DELIMITER{
   DELIM_HOUR,    // По часам
   DELIM_DAY,  // по дням
   // DELIM_WEEK, // по неделям
   DELIM_MONTH // по месяцам
};

input int FREQ    = 1;  // Частота обновления (сек)
input int PERIOD  = 30; // Периодичность (мин)
input ENUM_DELIMITER DELIMITER = 0;

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
   
   if(time.min % PERIOD == 0 && time.sec == 0 && time.day_of_week != 0 && time.day_of_week != 6){     
            
      string delim = "";
      switch(DELIMITER){
         case DELIM_HOUR:  delim = ITS(time.year)+"\\"+MonthToString(time.mon)+"\\"+ITS(time.day)+"\\"+ITS(time.hour); break;
         case DELIM_DAY:   delim = ITS(time.year)+"\\"+MonthToString(time.mon)+"\\"+ITS(time.day); break;
         // case DELIM_WEEK:  delim = time.year+"\\"+time.mon+"\\"+time.; break;
         case DELIM_MONTH: delim = ITS(time.year)+"\\"+MonthToString(time.mon); break;
      }
      WriteBalanceEquity(delim + "_["+ITS(PERIOD)+"].csv");
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
      string content = "";
      
      if(day_of_week == -1 || day_of_week != time.day_of_week){
         content += DayOfWeekToString(time.day_of_week);
         day_of_week = time.day_of_week;
      }
      
      string balance = DoubleToString(AccountBalance(), 2);
      string equity  = DoubleToString(AccountEquity(),  2);
      string profit  = DoubleToString(AccountProfit(),  2);
      StringReplace(balance, ".", ",");
      StringReplace(equity, ".", ",");
      StringReplace(profit, ".", ",");
           
      FileWrite(handle, ITS(time.day)+"."+ITS(time.mon), ITS(time.hour) + ":" + ITS(time.min), balance, equity, profit);
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

string MonthToString(int month){
   switch(month){      
      case 1: return "[01] Январь"; 
      case 2: return "[02] Февраль"; 
      case 3: return "[03] Март";
      case 4: return "[04] Апрель";
      case 5: return "[05] Май";
      case 6: return "[06] Июнь";
      case 7: return "[07] Июль";
      case 8: return "[08] Август";
      case 9: return "[09] Сентябрь";
      case 10:return "[10] Октябрь";
      case 11:return "[11] Ноябрь";
      case 12:return "[12] Декабрь";
   }
   return "";
}

string ITS(int i){
   return IntegerToString(i);
}