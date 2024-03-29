//+------------------------------------------------------------------+
//|                                       create_file_for_equity.mq4 |
//|                                                           Sergey |
//|                              https://www.mql5.com/ru/users/enzzo |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
//---
   WriteBalanceEquity("test-file.csv");
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| WriteBalanceEquity                                               |
//| Функция записывает в конец файла время, баланс и эквити          |
//+------------------------------------------------------------------+
void WriteBalanceEquity(const string filename){
   
   int handle = FileOpen(filename, FILE_READ|FILE_WRITE|FILE_CSV);
   
   if(handle == INVALID_HANDLE){
      Alert("File "+filename+" was failed");
      return;
   }
   if(FileSeek(handle, 0, SEEK_END) == true){
      FileWrite(handle, TimeCurrent(), AccountBalance(), DoubleToString(AccountEquity() - AccountBalance(),2));
   }
   
   FileClose(handle);
}