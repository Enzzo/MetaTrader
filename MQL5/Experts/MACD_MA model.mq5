//+------------------------------------------------------------------+
//|                                                   MACD model.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Models\model_macd.mqh>
#include <Models\model_ma.mqh>
#include <Models\model_bollinger.mqh>

CList *list_model;
CTrade trade;
MqlTick new_tick,
        old_tick;
// --- Model Bollinger Param ----
input string   str_bollinger="";       // Parameters of Model Bollinger
input   int    period_bollinger = 20;  // Period Bollinger 
input   double dev_bollinger    = 2.0; // Deviation Bollinger
input   double k_ATR            = 2.0; // Rate ATR
input   double delta_risk       = 100; // Rate Delta (risk)
// --- Model MACD Param -----
input string str_macd="";              // Parameters of Model MACD
input uint Fast_MA        = 12;        // Fast Moving Average
input uint Slow_MA        = 26;        // Slow Moving Average
input double percent_risk = 5.0;       // Rate Risk in %
      uint Signal_MA = 9;              // Signal Moving Average
//bool is_testing=false;

bool macd_default=false;
bool macd_best=true;
bool bollinger_default=false;
bool bollinger_best=true;

int OnInit()
  {
   InitModels();
   EventSetTimer(30);
   return(0);
  }

void OnTimer()
  {
   CModel *model;                         // Создаем указатель на базовую модель
   for(int i=0;i<list_model.Total();i++){ // Перебираем все модели в списке моделей
      model=list_model.GetNodeAtIndex(i); // Направляем указатель базовой модели на текущую модель
      model.Processing();                 // Передаем управление на текущую модель
   }
  }

void OnDeinit(const int reason)
  {
   delete list_model;                     // Освобождаем память от списка моделей
  }
  
void InitModels()
{
   list_model = new CList;             // Инициализируем указатель списком моделей
   cmodel_macd *model_macd;            // Создаем указатель на модель MACD
   cmodel_bollinger *model_bollinger;  // Создаем указатель на модель Bollinger
   
//----------------------------------------MACD DEFAULT----------------------------------------
   if(macd_default==true&&macd_best==false){
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      // Загрузка параметров завершилась успешно
      if(model_macd.Init(129475, "Model macd M15", _Symbol, _Period, 0.0, Fast_MA,Slow_MA,Signal_MA)){ 
      
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{
                                 // Загрузка параметров завершилась не удачно
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
   }
//-------------------------------------------------------------------------------------------
//----------------------------------------MACD BEST------------------------------------------
   if(macd_best==true&&macd_default==false){
      // 1.1 EURUSD H30; FMA=20; SMA=24; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd H30", "EURUSD", PERIOD_M30, delta_risk, 20,24,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно                       
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
      // 1.2 EURUSD H3; FMA=8; SMA=12; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd H3", "EURUSD", PERIOD_H3, delta_risk, 8,12,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
      // 1.3 AUDUSD H1; FMA=10; SMA=18; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd M15", "AUDUSD", PERIOD_H1, delta_risk, 10,18,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно                       
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
      // 1.4 AUDUSD H4; FMA=14; SMA=15; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd H4", "AUDUSD", PERIOD_H4, delta_risk, 14,15,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
      // 1.5 GBPUSD H6; FMA=20; SMA=33; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd H6", "GBPUSD", PERIOD_H6, delta_risk, 20,33,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
      // 1.6 GBPUSD H12; FMA=12; SMA=30; 
      model_macd = new cmodel_macd; // Инициализиуруем указатель моделью MACD
      if(model_macd.Init(129475, "Model macd H6", "GBPUSD", PERIOD_H12, delta_risk, 12,30,9)){ 
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " was great  successfully");
         list_model.Add(model_macd);// Загружаем модель в список моделей
      }
      else{// Загрузка параметров завершилась не удачно
         Print("Print(Model ", model_macd.Name(), " with period = ", model_macd.Period(), 
         " on symbol ", model_macd.Symbol(), " great was failed");
      }
   }
//----------------------------------------------------------------------------------------------
//-------------------------------------BOLLINGER DEFAULT----------------------------------------
   if(bollinger_default==true&&bollinger_best==false){
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger",_Symbol,PERIOD_CURRENT,0,period_bollinger,dev_bollinger,0,14,k_ATR)){
         Print("Model ", model_bollinger.Name(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
   }
//----------------------------------------------------------------------------------------------
//--------------------------------------BOLLLINGER BEST-----------------------------------------
   if(bollinger_best==true&&bollinger_default==false){
      //2.1 Symbol: EURUSD M30; period: 15; deviation: 2,75; k_ATR=2,75;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","EURUSD",PERIOD_M30,percent_risk,15,2.75,0,14,2.75)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
      //2.2 Symbol: EURUSD H4; period: 30; deviation: 2.0; k_ATR=2.25;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","EURUSD",PERIOD_H4,percent_risk,30,2.00,0,14,2.25)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
      //2.3 Symbol: GBPUSD M15; period: 18; deviation: 2.25; k_ATR=3.0;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","GBPUSD",PERIOD_M15,percent_risk,18,2.25,0,14,3.00)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
      //2.4 Symbol: GBPUSD H1; period: 27; deviation: 2.25; k_ATR=3.75;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","GBPUSD",PERIOD_H1,percent_risk,27,2.25,0,14,3.75)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
      //2.5 Symbol: USDCAD M15; period: 18; deviation: 2.5; k_ATR=2.00;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","USDCAD",PERIOD_M15,percent_risk,18,2.50,0,14,2.00)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
      //2.6 Symbol: USDCAD M15; period: 21; deviation: 2.5; k_ATR=3.25;
      model_bollinger = new cmodel_bollinger;
      if(model_bollinger.Init(1829374,"Bollinger","USDCAD",PERIOD_H2,percent_risk,21,2.50,0,14,3.25)){
         Print("Model ", model_bollinger.Name(), "Period: ", model_bollinger.Period(),
         ". Symbol: ", model_bollinger.Symbol(), " was great  successfully");
         list_model.Add(model_bollinger);
      }
   }
//----------------------------------------------------------------------------------------------
}