#property copyright "Scritong"
#property link      "http://autograf.dp.ua"

//---- input parameters
extern string    A1 = "Объем сделки. Если Lots = 0, то считается в процентах";
extern double    Lots = 0.1;
extern double    PercentOfDepo = 5;
extern string    A2 = "Профит в пунктах от цены открытия позиции";
extern int       defaultTP = 50;
extern string    A3 = "Стоп-приказ в пунктах от границы паттерна";
extern int       defaultSLOffset = 50;

extern string    A4_0 = "=== Автооптимизация ==============================";
extern string    A4_1 = "Вкл/откл автооптимизации";
extern bool      useOptimization = true;
extern string    A4_2 = "Значения стопа и профита от спреда и до.., пп.";
extern int       maxSLTP = 200;
extern string    A4_3 = "Шаг изменения стопа и профита, пп";
extern int       stepSLTP = 2;
extern string    A4_4 = "Расчетное матожидание, при котором совершается сделка";
extern double    minExpectation = 5.0; 
extern string    A4_5 = "Минимальное количество стат. сделок для открытия новой";
extern double    minStatDeals = 10; 
extern string    A4_6 = "Количество обрабатываемых баров";
extern int       optimizationBars = 500;
extern string    A4_7 = "==================================================";

extern string    A5_0 = "=== Паттерн Внутренний бар =======================";
extern string    A5_1 = "Включение/выключение поиска паттерна";
extern bool      useIBpattern = true;
extern string    A5_2 = "==================================================";
extern string    A6_0 = "=== Паттерны DBHLC и DBLHC =======================";
extern string    A6_1 = "Включение/выключение поиска паттерна";
extern bool      useDBpattern = true;
extern string    A6_2 = "Пределы в пунктах, считающихся равными";
extern int       equalPipsDB = 3;
extern string    A6_3 = "==================================================";
extern string    A7_0 = "=== Паттерны TBH И TBL ===========================";
extern string    A7_1 = "Включение/выключение поиска паттерна";
extern bool      useTBpattern = true;
extern string    A7_3 = "Пределы в пунктах, считающихся равными";
extern int       equalPipsTB = 3;
extern string    A7_4 = "==================================================";
extern string    A8_0 = "======= Паттерн Рельсы ==============";
extern string    A8_1 = "Включение/выключение поиска паттерна";
extern bool      useRAILSpattern = true;
extern string    A8_2 = "Максимальное превосходство тел одной из свечей, в %";
extern double    bodyGreatPercents = 10;
extern string    A8_3 = "Минимальная доля тела свечи в общей высоте свечи, в %";
extern double    bodyToHeightPercents = 20;
extern string    A8_4 = "=======================================================";
extern string    A9_0 = "======= Паттерны BUOVB и BEOVB ==============";
extern string    A9_1 = "Включение/выключение поиска паттерна";
extern bool      useOVBpattern = true;
extern string    A9_2 = "=======================================================";
extern string    A10_0 = "=== Паттерн PPR ======================================";
extern string    A10_1 = "Включение/выключение поиска паттерна";
extern bool      usePPRpattern = true;
extern string    A10_2 = "=======================================================";
extern string    A11_0 = "=== Паттерн HR ========================================";
extern string    A11_1 = "Включение/выключение поиска паттерна";
extern bool      useHRpattern = true;
extern string    A11_2 = "Близость цен закрытия и открытия к мин и макс, в пунктах";
extern int       openCloseToHighLowPointsHR = 3;
extern string    A11_3 = "=======================================================";
extern string    A12_0 = "=== Паттерн CPR =======================================";
extern string    A12_1 = "Включение/выключение поиска паттерна";
extern bool      useCPRpattern = true;
extern string    A12_2 = "Близость цен закрытия и открытия к мин и макс, в пунктах";
extern int       openCloseToHighLowPoints = 3;
extern string    A12_3 = "Минимальная величина гепа, в пунктах";
extern int       gapPoints = 2;
extern string    A12_4 = "=======================================================";
extern string    A13_0 = "=== Паттерн Pin Bar ===================================";
extern string    A13_1 = "Включение/выключение поиска паттерна";
extern bool      usePINBARpattern = true;
extern string    A13_2 = "Близость цены закрытия к мин или макс, в пунктах";
extern int       closeToHighLowPoints = 3;
extern string    A13_3 = "Минимальное отношение тени (носа) к телу свечи";
extern double    shadowToBodyKoef = 3.0;
extern string    A13_4 = "Минимальная часть носа, выступающая за предыдущий бар, в %";
extern double    noseOutsidePercent = 75.0;
extern string    A13_5 = "=======================================================";
extern string    A14_0 = "=== Паттерн MCM =======================================";
extern string    A14_1 = "Включение/выключение поиска паттерна";
extern bool      useMCMpattern = true;
extern string    A14_2 = "Близость цен закрытия и открытия первой свечи к мин или макс, в пунктах";
extern int       openCloseToHighLowPointsMCM = 3;
extern string    A14_3 = "Максимальное отношение высоты сигнальной свечи к первой, в %";
extern double    signalToFirstPercents = 35.0;
extern string    A14_4 = "=======================================================";
extern string    A15_0 = "=== Паттерн Island Reversal ===========================";
extern string    A15_1 = "Включение/выключение поиска паттерна";
extern bool      useIRpattern = true;
extern string    A15_2 = "Величина первого (слева по графику) гепа в пунктах";
extern int       firstGap = 1;
extern string    A15_3 = "Величина второго (справа по графику) гепа в пунктах";
extern int       secondGap = 1;
extern string    A15_4 = "=======================================================";

extern string    Z1 = "=== Прочие настройки ===";
extern string    OpenOrderSound = "ok.wav";
extern int       MagicNumber = 4738293;

int g_ticket,                                      // Тикет текущей позиции
    g_type;                                        // Тип текущей позиции 

bool g_activate,                                   // Признак успешной инициализации
     g_fatalError;                                 // Признак наличия фатальной ошибки
     
double g_tickSize,                                 // Размер минимального изменения цены
       g_spread,                                   // Величина спреда
       g_stopLevel,                                // Размер минимального уровня стопов
                                                   // ..в ценовой величине
       g_freezeLevel,                              // Размер коридора заморозки в..
                                                   // ..ценовой величине
       g_lotStep,
       g_minLot,                                   // Минимальный объем ордера
       g_maxLot,                                   // Максимальный объем ордера
       g_slBuyPrice,                               // Расчетная цена стоп-приказа ордера
                                                   // ..Buy
       g_slSellPrice;                              // Расчетная цена стоп-приказа ордера
                                                   // ..Sell
datetime g_lastBar;                                // Время открытия последнего бара, на
                                                   // ..котором были произведены все..
                                                   // ..необходимые расчеты и торговые..
                                                   // ..операции
                                                   
// Тип исполнения торговых приказов
#define EXE_MODE_NO       0                        // Не определен
#define EXE_MODE_MARKET   1                        // Market Execution
#define EXE_MODE_INSTANT  2                        // Instant Execution

#define BULL_BAR        1                          // Идентификатор бычьих баров
#define BEAR_BAR        -1                         // Идентификатор медвежьих баров

#define PATTERN_NO      0                          // Идентификатор отсутствия паттерна
#define PATTERN_BULL    1                          // Идентификатор наличия бычьего..
                                                   // ..паттерна
#define PATTERN_BEAR    -1                         // Идентификатор наличия медвежего..
                                                   // ..паттерна


string typesOfPatterns[] = {"DB_PATTERN_",         // Названия типов паттернов
                            "TB_PATTERN_",
                            "RAILS_PATTERN",
                            "CPR_PATTERN",
                            "IB_PATTERN",
                            "HR_PATTERN",
                            "OVB_PATTERN",
                            "PPR_PATTERN",
                            "PINBAR_PATTERN",
                            "MCM_PATTERN",
                            "IR_PATTERN"};                      


#define DB_INDEX        0                          // Индекс строкового представления..
                                                   // ..типа паттерна DB в массиве..
                                                   // ..typesOfPatterns
#define TB_INDEX        1                          // Индекс строкового представления..
                                                   // ..типа паттерна TB в массиве..
                                                   // ..typesOfPatterns

#define RAILS_INDEX     2                          // Индекс строкового представления..
                                                   // ..типа паттерна Рельсы в массиве..
                                                   // ..typesOfPatterns

#define CPR_INDEX       3                          // Индекс строкового представления..
                                                   // ..типа паттерна CPR в массиве..
                                                   // ..typesOfPatterns

#define IB_INDEX        4                          // Индекс строкового представления..
                                                   // ..типа паттерна IB в массиве..
                                                   // ..typesOfPatterns

#define HR_INDEX        5                          // Индекс строкового представления..
                                                   // ..типа паттерна HR в массиве..
                                                   // ..typesOfPatterns

#define OVB_INDEX       6                          // Индекс строкового представления..
                                                   // ..типа паттерна OVB в массиве..
                                                   // ..typesOfPatterns

#define PPR_INDEX       7                          // Индекс строкового представления..
                                                   // ..типа паттерна PPR в массиве..
                                                   // ..typesOfPatterns

#define PINBAR_INDEX    8                          // Индекс строкового представления..
                                                   // ..типа паттерна Pin Bar в массиве..
                                                   // ..typesOfPatterns

#define MCM_INDEX       9                          // Индекс строкового представления..
                                                   // ..типа паттерна MCM в массиве..
                                                   // ..typesOfPatterns

#define IR_INDEX        10                         // Индекс строкового представления..
                                                   // ..типа паттерна IR в массиве..
                                                   // ..typesOfPatterns


#include <stderror.mqh>
                                                   
//+-------------------------------------------------------------------------------------+
//| Функция инициализации эксперта                                                      |
//+-------------------------------------------------------------------------------------+
int init()
{
   g_fatalError = False;

   GetMarketInfo();                                // Сбор информации об условиях..
                                                   // ..торговли
    
   g_lastBar = 0;
   g_activate = True;                              // Все проверки успешно завершены,..
                                                   // ..возводим флаг активации эксперта
   
//----
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| Функция деинициализации эксперта                                                    |
//+-------------------------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| Получение рыночной информации                                                       |
//+-------------------------------------------------------------------------------------+
void GetMarketInfo()
{
   g_tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   g_spread = MarketInfo(Symbol(), MODE_SPREAD)*Point;
   g_stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL)*Point;
   g_freezeLevel = MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point;
   g_minLot = MarketInfo(Symbol(), MODE_MINLOT);   
   g_maxLot = MarketInfo(Symbol(), MODE_MAXLOT);   
   g_lotStep = MarketInfo(Symbol(), MODE_LOTSTEP); 
}
//+-------------------------------------------------------------------------------------+
//| Расчет объема сделки, исходя из свободных средств.                                  |
//+-------------------------------------------------------------------------------------+
double GetLots()
{
// - 2 - == Если открываемая позиция первая =============================================
   if (Lots == 0)                                  // Если значение Lots равно нулю, то
   {                                               // ..рассчитаем объем по имеющимся..
                                                   // ..свободным средствам
      double lot = (PercentOfDepo/100)*AccountFreeMargin()/
                                MarketInfo(Symbol(), MODE_MARGINREQUIRED);
      return(LotRound(lot));
   }
   else                                            // Если параметр не равен нулю, то..
      return(LotRound(Lots));                      // ..просто вернем его значение
// - 2 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Проверка объема на корректность и округление                                        |
//+-------------------------------------------------------------------------------------+
double LotRound(double L)
{
   return(MathRound(MathMin(MathMax(L, g_minLot), g_maxLot)/g_lotStep)*g_lotStep);
}
//+-------------------------------------------------------------------------------------+
//| Ожидание торгового потока. Если поток свободен, то результат True, иначе - False    |
//+-------------------------------------------------------------------------------------+  
bool WaitForTradeContext()
{
   int P = 0;
   while(IsTradeContextBusy() && P < 5)
   {
      P++;
      Sleep(1000);
   }
   if (P == 5)
     return(False);
   return(True);    
}
//+-------------------------------------------------------------------------------------+
//| Проверка достаточности вободных средств с выдачей сообщения об ошибке               |
//+-------------------------------------------------------------------------------------+
bool IsEnoughMoney(double lot)
{
   static bool freeMarginAlert = false;            // Флаг повторного сообщения. 
                                                   // Предотвращает выдачу сообщения..
                                                   // ..об ошибке на каждом тике

   if (AccountFreeMarginCheck(Symbol(), OP_BUY, lot) > 0 && // Средств достаточно
       GetLastError() != ERR_NOT_ENOUGH_MONEY) 
   {
      freeMarginAlert = false;                     // Сброс флага повторного сообщения
      return(true);                                // Нет ошибок
   }       
       
   if (!freeMarginAlert)                           // Сообщение еще не было выдано
   {
      Print("Недостаточно средств для открытия позиции. Free Margin = ", 
            AccountFreeMargin());
      freeMarginAlert = true;                      // В следующий раз не показываем..
                                                   // ..сообщение
   }  

   return(false);  
}
//+-------------------------------------------------------------------------------------+
//| Проверка правильности цен открытия, профита и стоп-приказа рыночного ордера         |
//+-------------------------------------------------------------------------------------+
bool IsMarketOrderParametersCorrect(int type, double& price, double& sl, double& tp, 
                                    bool redefinition)
{
   RefreshRates();

// - 1 - == Проверка параметров ордера Buy ==============================================
   if (type == OP_BUY)
   {
      price = NP(Ask);
      if (tp - Bid <= g_stopLevel && tp != 0)
         if (redefinition) 
            tp = NP(Bid + g_stopLevel + g_tickSize);
         else
            return(false);
      if (Bid - sl <= g_stopLevel)
         if (redefinition) 
            sl = NP(Bid - g_stopLevel - g_tickSize);
         else
            return(false);
      return(true);
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Проверка параметров ордера Sell =============================================
   price = NP(Bid);
   if (Ask - tp <= g_stopLevel) 
      if (redefinition) 
         tp = NP(Ask - g_stopLevel - g_tickSize);
      else
         return(false);
   if (sl - Ask <= g_stopLevel && sl != 0)
      if (redefinition) 
         sl = NP(Ask + g_stopLevel + g_tickSize);
      else
         return(false);
   return(true);
// - 2 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Определение типа исполнения торговых приказов                                       |
//+-------------------------------------------------------------------------------------+
int GetExecutionType()
{
   static int executionMode = EXE_MODE_NO;         // Тип исполнения торговых приказов
   
   if (executionMode != EXE_MODE_NO)               // Тип исполнения уже определен
      return(executionMode);
   
   if (IsTesting())                                // В тестере можно использовать..
   {                                               // ..Instant Execution
      executionMode = EXE_MODE_INSTANT;         
      return(executionMode);
   }
      
   executionMode = EXE_MODE_INSTANT;               // По умолчанию считаем, что Instant
   OrderSend(Symbol(), OP_BUY, 1, 0, 0, Point, 0); // Определение типа исполнения
   if (GetLastError() == ERR_INVALID_STOPS)        // Неправильные стопы - Market
      executionMode = EXE_MODE_MARKET;             // Вернем тип исполнения
   return(executionMode);  
}
//+-------------------------------------------------------------------------------------+
//| Приведение типа ордера к строковому эквиваленту                                     |
//+-------------------------------------------------------------------------------------+
string OrderTypeToString(int type)
{
   switch (type)
   {
      case OP_BUY: return("Buy");
      case OP_SELL: return("Sell");
      case OP_BUYLIMIT: return("Buy Limit");
      case OP_SELLLIMIT: return("Sell Limit");
      case OP_BUYSTOP: return("Buy Stop");
      case OP_SELLSTOP: return("Sell Stop");
   }
   return("Unknown order");
}
//+-------------------------------------------------------------------------------------+
//| Открытие ордера при типе исполнения Instant Execution, возвращает тикет             |
//+-------------------------------------------------------------------------------------+
int OpenOrderWithInstantMode(int type, double lot, double price, double sl, double tp, 
                              int magicNumber)
{
   ///////////////////////////////////////////////////////////////////////////////
   double tp2 = 0;
   if(type == OP_BUY)
      tp2 = NormalizeDouble((High[1]+(High[1]-Low[1])*1.61), Digits());
   if(type == OP_SELL)
      tp2 = NormalizeDouble((Low[1]-(High[1]-Low[1])*1.61), Digits());
   ///////////////////////////////////////////////////////////////////////////////
   string orderType = OrderTypeToString(type);
   Comment("Отправлен запрос на открытие ордера ", orderType, "...");  
   int ticket = OrderSend(Symbol(), type, lot,     // Открытие позиции
                          price, 3, sl, /*tp*/tp2, NULL, 
                          magicNumber, 0);
   
   if (ticket > 0)                                 // Успешное открытие ордера
   {                          
      Comment("Ордер ", orderType, " открыт успешно!"); 
      PlaySound(OpenOrderSound); 
      return(ticket); 
   }
                          
   int error = GetLastError();                     // Неудачное открытие ордера
   Comment("Ошибка открытия ордера ", orderType, ": ", error);
   return(ticket);
}
//+-------------------------------------------------------------------------------------+
//| Изменение цен стоп-приказа и профита в соответствии с текущими рыночными условиями  |
//+-------------------------------------------------------------------------------------+
void CorrectionOfStops(int type, double& sl, double& tp)
{
   RefreshRates();
   if (type == OP_BUY)
   {
      if (Bid - sl <= g_stopLevel)
         sl = NP(Bid - g_stopLevel - g_tickSize);
      if (tp - Bid <= g_stopLevel && tp != 0)
         tp = NP(Bid + g_stopLevel + g_tickSize);
      return;
   }
   if (sl - Ask <= g_stopLevel && sl != 0)
      sl = NP(Ask + g_stopLevel + g_tickSize);
   if (Ask - tp <= g_stopLevel)
      tp = NP(Ask - g_stopLevel - g_tickSize);
}
//+-------------------------------------------------------------------------------------+
//| Открытие ордера при типе исполнения Market Execution                                |
//+-------------------------------------------------------------------------------------+
bool OpenOrderWithMarketMode(int type, double lot, double price, double sl, double tp, 
                             int magicNumber)
{
   int ticket = OpenOrderWithInstantMode(type, lot, price, 0, 0, magicNumber);
   if (ticket <= 0)
      return(false);
    
   if (!OrderSelect(ticket, SELECT_BY_TICKET) || 
       OrderCloseTime() != 0)   
   {
      Alert("Фатальная ошибка при установке стопов и профитов нового ордера!");
      return(false);
   }
   
   Comment("Установка стоп-приказа и профита ордера...");
   int cnt = 0;
   while (!IsStopped())
   {
      while (!WaitForTradeContext()) {}
      CorrectionOfStops(type, sl, tp);
      if (OrderModify(ticket, 0, sl, tp, OrderExpiration()))
      {
         Comment("Стоп-приказ и профит успешно установлены!");
         return(true);
      }
      Sleep(1000);
   }
}
//+-------------------------------------------------------------------------------------+
//| Открытие рыночного ордера с автоматическим определением типа исполнения ордера      |
//+-------------------------------------------------------------------------------------+
bool OpenByMarket(int type, double lot, double sl, double tp, 
                  int magicNumber, bool redefinition = true)
// redefinition - при true доопределять параметры до минимально допустимых
//                при false - возвращать ошибку
{
// - 1 - == Проверка правильности типа ордера и достаточности свободных средств =========
   if (type > OP_SELL)
      return(false);
   
   if (!IsEnoughMoney(lot))
      return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Проверка свободности торгового потока и правильности параметров ордера ======
   if (!WaitForTradeContext())
   {
      Comment("Время ожидания освобождения торгового потока истекло!");
      return(false);
   }

   double price;                                   // Цена исполнения ордера
   if (!IsMarketOrderParametersCorrect(type, price, sl, tp, redefinition))
      return(false);
// - 2 - == Окончание блока =============================================================
 
// - 3 - == Открытие ордера с ожидание торгового потока =================================
   if (GetExecutionType() == EXE_MODE_INSTANT ||
       (sl == 0 && tp == 0))
      return(OpenOrderWithInstantMode(type, lot, price, sl, tp, magicNumber) > 0);
      
   return(OpenOrderWithMarketMode(type, lot, price, sl, tp, magicNumber));
}
//+-------------------------------------------------------------------------------------+
//| Приведение значений к точности одного тика                                          |
//+-------------------------------------------------------------------------------------+
double NP(double A)
{
   return(MathRound(A/g_tickSize)*g_tickSize);
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия элементарного паттерна Внутренний бар                           |
//+-------------------------------------------------------------------------------------+
bool IsSimpleIB(int index)
{
   if (Low[index] <= Low[index+1])                 // Минимум бара ниже минимума..
      return(false);                               // ..предыдущего бара - нет паттерна
      
   if (High[index] >= High[index+1])               // Максимум бара выше максимума..
      return(false);                               // ..предыдущего бара - нет паттерна

   double typeLast = Close[index] - Open[index];   // Тип бара index:
                                                   // ..>0 - бычий, <0 - медвежий
   double typePreLast = Close[index+1] - Open[index+1];// Тип предыдущего бара
   
   if ((typeLast >= 0 && typePreLast >= 0) ||      // Если бары одинакового типа, то..
       (typeLast <= 0 && typePreLast <= 0))        // ..паттерн не найден
      return(false);

   return(true);                                   // Паттерн найден
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна Внутренний бар                                         |
//+-------------------------------------------------------------------------------------+
bool IsIBPattern(int index, int total, int& patternStart)
{
   patternStart = index;
   while(IsSimpleIB(patternStart) &&               // Поиск элементарных паттернов подряд
         patternStart < total)
      patternStart++;
      
   if (patternStart == index)                      // Ни один паттерн не найден
      return(false);   
      
   return(true);                                   // Паттерн найден
}
//+-------------------------------------------------------------------------------------+
//| Подсчет количества баров с одинаковыми максимумами                                  |
//+-------------------------------------------------------------------------------------+
bool IsTwoEqualMax(int startIndex, int total, int equalPips, int& patternStart)
{
   for (int i = startIndex+1; i < total; i++)      //Поиск на разрешенном участке истории
      if (MathAbs(High[i] - High[i-1]) >           // Разность максимумов больше..
          equalPips*Point)                         // ..разрешенной величины - окончание
         break;                                    // ..цикла
   if (i - startIndex < 2)                         // Нет баров с одинаковыми максимумами
      return(false);      
   
   patternStart = i - 1;                           // Индекс первого бара паттерна
   return(true);                         
}
//+-------------------------------------------------------------------------------------+
//| Подсчет количества баров с одинаковыми минимумами                                   |
//+-------------------------------------------------------------------------------------+
bool IsTwoEqualMin(int startIndex, int total, int equalPips, int& patternStart)
{
   for (int i = startIndex+1; i < total; i++)      //Поиск на разрешенном участке истории
      if (MathAbs(Low[i] - Low[i-1]) >             // Разность минимумов больше..
          equalPips*Point)                         // ..разрешенной величины - окончание
         break;                                    // ..цикла
   if (i - startIndex < 2)                         // Нет баров с одинаковыми максимумами
      return(false);      
   
   patternStart = i - 1;                           // Индекс первого бара паттерна
   return(true);                         
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна DBHLC на указанном баре                                |
//+-------------------------------------------------------------------------------------+
bool IsDBHLCPattern(int index, int total, int& patternStart)
{
   if (Close[index] >= Low[index+1])               // Новый бар закрылся выше минимума..
      return(false);                               // ..предыдущего бара - нет паттерна

   if (!IsTwoEqualMax(index, total, equalPipsDB,   // Равны ли максимумы хотя бы у двух..
                      patternStart))               // ..баров подряд?
      return(false);                               // Если нет двух баров - нет паттерна

   return(true);
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна DBLHC на указанном баре                                |
//+-------------------------------------------------------------------------------------+
bool IsDBLHCPattern(int index, int total, int& patternStart)
{
   if (Close[index] <= High[index+1])              // Новый бар закрылся ниже максимума..
      return(false);                               // ..предыдущего бара - нет паттерна

   if (!IsTwoEqualMin(index, total, equalPipsDB,   // Равны ли минимумы хотя бы у двух..
                      patternStart))               // ..баров подряд?
      return(false);                               // Если нет двух баров - нет паттерна

   return(true);
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна TBH на указанном баре                                  |
//+-------------------------------------------------------------------------------------+
bool IsTBHPattern(int index, int total, int& patternStart)
{
   if (Low[index] < Open[index+1])                 // Новый бар не был поглощен..
       return(false);                              // ..предыдущим баром - нет паттерна
   
   if (Close[index+1] <= Open[index+1])            // Предыдущий бар не был бычьим
      return(false);                               // Нет паттерна

   if (!IsTwoEqualMax(index, total, equalPipsTB,   // Равны ли максимумы хотя бы у двух..
                      patternStart))               // ..баров подряд?
      return(false);                               // Если нет двух баров - нет паттерна
   
   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна TBL на указанном баре                                  |
//+-------------------------------------------------------------------------------------+
bool IsTBLPattern(int index, int total, int& patternStart)
{
   if (High[index] > Open[index+1])                // Новый бар не был поглощен..
       return(false);                              // ..предыдущим баром - нет паттерна
   
   if (Close[index+1] >= Open[index+1])            // Предыдущий бар не был медвежьим
      return(false);                               // Нет паттерна

   if (!IsTwoEqualMin(index, total, equalPipsTB,   // Равны ли минимумы хотя бы у двух..
                      patternStart))               // ..баров подряд?
      return(false);                               // Если нет двух баров - нет паттерна

   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение долей тел свечей в их высоте и соотношения длин тел свечей              |
//+-------------------------------------------------------------------------------------+
bool IsRails(int index, double body1, double body2)
{
   if (body1 <= 0)                                 // Последний бар не бычий/медвежий - 
      return(false);                               // ..выход

   if (body2 <= 0)                                 // Предпоследний бар не медвежий/бычий
      return(false);                               // .. - выход

   double height1 = High[index] - Low[index];      // Общая высота последней свечи
   if (body1/height1 < bodyToHeightPercents/100)   // Тело свечи относительно ее высоты..
      return(false);                               // ..слишком мало - выход

   double height2 = High[index+1] - Low[index+1];  // Общая высота предпоследней свечи
   if (body2/height2 < bodyToHeightPercents/100)   // Тело свечи относительно ее высоты..
      return(false);                               // ..слишком мало - выход

   double ratio = 100*                             // Отношение длины тела одной свечи к
                  (1 - MathMin(body1, body2)/MathMax(body1, body2));// ..к другой в %
   if (ratio > bodyGreatPercents)                  // Отношение длин тел свечей больше..
       return(false);                              // ..заданного - выход

   return(true);                                   // Паттерн Рельсы присутствует
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна Рельсы на указанном баре                       |
//+-------------------------------------------------------------------------------------+
bool IsBullsRailsPattern(int index, int total)
{
   double body1 = Close[index] - Open[index];      // Тело последней свечи
   double body2 = Open[index+1] - Close[index+1];  // Тело предпоследней свечи
   
   return (IsRails(index, body1, body2));          // Присутствует ли паттерн Рельсы?
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна Рельсы на указанном баре                    |
//+-------------------------------------------------------------------------------------+
bool IsBearsRailsPattern(int index, int total)
{
   double body1 = Open[index] - Close[index];      // Тело последней свечи
   double body2 = Close[index+1] - Open[index+1];  // Тело предпоследней свечи
   
   return (IsRails(index, body1, body2));          // Присутствует ли паттерн Рельсы?
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна OVB на указанном баре                                  |
//+-------------------------------------------------------------------------------------+
bool IsOVBPattern(int index, int type)
{
   if (High[index] <= High[index+1])               // Максимум предпоследней свечи не..
      return(false);                               // ..поглощен последней свечей - выход

   if (Low[index] >= Low[index+1])                 // Минимум предпоследней свечи не..
      return(false);                               // ..поглощен последней свечей - выход

   double body1 = Close[index] - Open[index];      // Тело последней свечи
   double body2 = Close[index+1] - Open[index+1];  // Тело предпоследней свечи
   
   if ((body1 >= 0 && body2 >= 0) ||               // Последние две свечи принадлежат..
       (body1 <= 0 && body2 <= 0))                 // ..одиному и тому же типу баров.
      return(false);                               // Паттерн не обнаружен
      
   return ((body1 > 0 && type == BULL_BAR) ||      // Паттерн сформирован, если последний
           (body1 < 0 && type == BEAR_BAR));       // ..бар относится к указанному типу
   
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна BUOVB на указанном баре                                |
//+-------------------------------------------------------------------------------------+
bool IsBUOVBPattern(int index, int total)
{
   if (Close[index] <= High[index+1])              // Максимум предыдущей свечи не пробит
      return(false);                               // Паттерн не сформирован

   return (IsOVBPattern(index, BULL_BAR));         // Наличие паттерна OVB
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия паттерна BEOVB на указанном баре                                |
//+-------------------------------------------------------------------------------------+
bool IsBEOVBPattern(int index, int total)
{
   if (Close[index] >= Low[index+1])               // Минимум предыдущей свечи не пробит
      return(false);                               // Паттерн не сформирован

   return (IsOVBPattern(index, BEAR_BAR));         // Наличие паттерна OVB
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна PPR на указанном баре                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsPPRPattern(int index, int total)
{
   if (Close[index] <= High[index+1])              // Максимум предыдущей свечи не пробит
      return(false);                               // Паттерн не сформирован
      
   if (Low[index+1] >= Low[index+2] ||             // Минимум предыдущего бара не..
       Low[index+1] >= Low[index])                 // ..является минимумом паттерна
      return(false);                               // Паттерн не сформирован
      
   if (Close[index+2] >= Open[index+2])            // Стартовый бар паттерна не является
      return(false);                               // ..медвежьим - выход

   return (true);                                  // Паттерн сформирован
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна PPR на указанном баре                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsPPRPattern(int index, int total)
{
   if (Close[index] >= Low[index+1])               // Минимум предыдущей свечи не пробит
      return(false);                               // Паттерн не сформирован
      
   if (High[index+1] <= High[index+2] ||           // Максимум предыдущего бара не..
       High[index+1] <= High[index])               // ..является максимумом паттерна
      return(false);                               // Паттерн не сформирован

   if (Close[index+2] <= Open[index+2])            // Стартовый бар паттерна не является
      return(false);                               // ..бычьим - выход

   return (true);                                  // Паттерн сформирован
}
//+-------------------------------------------------------------------------------------+
//| Приведение разности двух величин к целому значению (в пунктах)                      |
//+-------------------------------------------------------------------------------------+
int PD(double greater, double less)
{
   return(MathRound((greater - less)/Point));
}
//+-------------------------------------------------------------------------------------+
//| Относится ли свеча к определенному типу и малые ли тени у нее?                      |
//+-------------------------------------------------------------------------------------+
bool IsCandleTypeAndSmallShadows(int index, int openCloseToHL, double smaller, 
                                 double greater)
{
   if (greater <= smaller)                         // Свеча не заданного типа - выход
      return(false);
   
   if (PD(High[index], greater) > openCloseToHL)   // Большая цена тела свечи не около..
      return(false);                               // ..максимума - выход

   if (PD(smaller, Low[index]) > openCloseToHL)    // Меньшая цена тела свечи не около..
      return(false);                               // ..минимума - выход
      
   return(true);
}
//+-------------------------------------------------------------------------------------+
//| Поиск начала восходящего тренда                                                     |
//+-------------------------------------------------------------------------------------+
bool IsUpTrend(int index, int total, int& patternStart)
{
   while(High[patternStart+1] < High[patternStart] &&// Поиск начала восходящего тренда
         patternStart < total)
      patternStart++;
      
   if (patternStart < index+2)                     // Восходящий тренд состоит менее, чем
      return(false);                               // ..из двух баров - выход
      
   return(true);                                   // Есть восходящий тренд
}
//+-------------------------------------------------------------------------------------+
//| Поиск начала нисходящего тренда                                                     |
//+-------------------------------------------------------------------------------------+
bool IsDownTrend(int index, int total, int& patternStart)
{
   while(Low[patternStart+1] > Low[patternStart] &&// Поиск начала нисходящего тренда
         patternStart < total)
      patternStart++;
      
   if (patternStart < index+2)                     // Нисходящий тренд состоит менее, чем
      return(false);                               // ..из двух баров - выход
      
   return(true);                                   // Есть нисходящий тренд
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна HR на указанном баре                        |
//+-------------------------------------------------------------------------------------+
bool IsBearsHRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // Является ли свеча
                                    openCloseToHighLowPointsHR,
                                    Close[index],  // ..медвежьей с малыми тенями?
                                    Open[index]))
      return(false);                               

   if (!IsSimpleIB(index))                         // Два последних бара должны являть..
      return(false);                               // ..собой простейший паттерн..
                                                   // ..Внутренний бар

   if (!IsUpTrend(index, total, patternStart))     // Если не зафиксирован восходящий..
      return(false);                               // ..тренд, то паттерн не обнаружен
   
   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна HR на указанном баре                           |
//+-------------------------------------------------------------------------------------+
bool IsBullsHRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // Является ли свеча
                                    openCloseToHighLowPointsHR,
                                    Open[index],  // ..бычьей с малыми тенями?
                                    Close[index]))
      return(false);                               

   if (!IsSimpleIB(index))                         // Два последних бара должны являть..
      return(false);                               // ..собой простейший паттерн..
                                                   // ..Внутренний бар

   if (!IsDownTrend(index, total, patternStart))   // Если не зафиксирован нисходящий..
      return(false);                               // ..тренд, то паттерн не обнаружен
   
   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна CPR на указанном баре                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsCPRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // Является ли свеча
                                    openCloseToHighLowPoints,
                                    Open[index],   // ..бычьей с малыми тенями?
                                    Close[index]))
      return(false);                               

   if (PD(Close[index+1], Open[index]) < gapPoints)// Геп на последней свече меньше..
      return(false);                               // ..заданного - выход

   if (Close[index+1] >= Close[index])             // Закрытие последней свечи не пробило
      return(false);                               // ..закрытие предыдущей свечи - выход

   if (Open[index+1] <= Close[index+1])            // Последняя свеча не медвежья - выход
      return(false);

   if (!IsDownTrend(index, total, patternStart))   // Если не зафиксирован нисходящий..
      return(false);                               // ..тренд, то паттерн не обнаружен
   
   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна CPR на указанном баре                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsCPRPattern(int index, int total, int& patternStart)
{
   if (!IsCandleTypeAndSmallShadows(index,         // Является ли свеча
                                    openCloseToHighLowPoints,
                                    Close[index],  // ..медвежьей с малыми тенями?
                                    Open[index]))
      return(false);                               

   if (PD(Open[index], Close[index+1]) < gapPoints)// Геп на последней свече меньше..
      return(false);                               // ..заданного - выход

   if (Close[index+1] <= Close[index])             // Закрытие последней свечи не пробило
      return(false);                               // ..закрытие предыдущей свечи - выход

   if (Open[index+1] >= Close[index+1])            // Последняя свеча не бычья - выход
      return(false);

   if (!IsUpTrend(index, total, patternStart))     // Если не зафиксирован восходящий..
      return(false);                               // ..тренд, то паттерн не обнаружен
   
   return(true);                                   // Есть паттерн
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна Pin Bar на указанном баре                   |
//+-------------------------------------------------------------------------------------+
bool IsBullsPINBARPattern(int index, int total)
{
   if (Open[index] < Low[index+1])                 // Если бар открылся ниже минимума..
      return(false);                               // ..предыдущего, то это не пинбар

   if (Close[index] < Low[index+1])                // Если бар закрылся ниже минимума..
      return(false);                               // ..предыдущего, то это не пинбар

   if (Low[index] >= Low[index+1])                 // Если тень бара не пробила минимум
      return(false);                               // ..предыдущего, то это не пинбар

   if (PD(High[index], Close[index]) > closeToHighLowPoints)// Закрытие свечи должно быть
      return(false);                               // ..возле max бара. Иначе - не пинбар
    
   double shadow = MathMin(Open[index], Close[index]) - Low[index];// Нижняя тень свечи
   double body = MathAbs(Open[index] - Close[index]);// Тело свечи
   if (body == 0)
      body = Point;
   if (shadow/body < shadowToBodyKoef)             // Отношение верхней тени к телу свечи
       return(false);                              // ..меньше заданного - нет паттерна

   double noseOutside = Low[index+1] - Low[index]; // Выступающая часть носа пинбара
   if (noseOutside/shadow < noseOutsidePercent/100)// Выступающий нос бара недостаточно..
      return(false);                               // ..длинный - не пинбар

   return (true);                                  // Паттерн сформирован
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна Pin Bar на указанном баре                   |
//+-------------------------------------------------------------------------------------+
bool IsBearsPINBARPattern(int index, int total)
{
   if (Open[index] > High[index+1])                // Если бар открылся выше максимума..
      return(false);                               // ..предыдущего, то это не пинбар

   if (Close[index] > High[index+1])               // Если бар закрылся выше максимума..
      return(false);                               // ..предыдущего, то это не пинбар

   if (High[index] <= High[index+1])               // Если тень бара не пробила максимум
      return(false);                               // ..предыдущего, то это не пинбар

   if (PD(Close[index], Low[index]) > closeToHighLowPoints)// Закрытие свечи должно быть
      return(false);                               // ..возле min бара. Иначе - не пинбар
    
   double shadow = High[index] - MathMax(Open[index], Close[index]);// Верхняя тень свечи
   double body = MathAbs(Open[index] - Close[index]);// Тело свечи
   if (body == 0)
      body = Point;
   if (shadow/body < shadowToBodyKoef)             // Отношение верхней тени к телу свечи
       return(false);                              // ..меньше заданного - нет паттерна
       
   double noseOutside = High[index] - High[index+1];// Выступающая часть носа пинбара
   if (noseOutside/shadow < noseOutsidePercent/100)// Выступающий нос бара недостаточно..
      return(false);                               // ..длинный - не пинбар

   return (true);                                  // Паттерн сформирован
}
//+-------------------------------------------------------------------------------------+
//| Сравнение высот двух стоящих рядом свечей                                           |
//+-------------------------------------------------------------------------------------+
bool IsSignalCandleIsSmall(int signalIndex, double maxPercents)
{
   double heightFirst = High[signalIndex+1] - Low[signalIndex+1];// Высота первой свечи
   if (heightFirst == 0)                           // Свеча не должна быть нулевой высоты
      return(false);                               // Заодно и проверка деления на 0

   double heightSignal = High[signalIndex] - Low[signalIndex]; // Высота сигнальной свечи
   if (heightSignal/heightFirst > maxPercents/100) // Отношение высоты сигнальной свечи..
       return(false);                              // ..к высоте первой свечи не должно..
                                                   // ..быть больше определенной величины
   return(true);
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна MCM на указанном баре                          |
//+-------------------------------------------------------------------------------------+
bool IsBullsMCMPattern(int index, int total)
{
   if (High[index] <= High[index+1])               // Если сигнальный бар не пробил вверх
      return(false);                               // ..предыдущий бар, то это не MCM

   if (Close[index] >= Open[index])                // Если сигнальный бар не медвежий, то
      return(false);                               // ..это не МСМ

   if (!IsCandleTypeAndSmallShadows(index+1,       // Если первая свеча не является..
                                    openCloseToHighLowPointsMCM,// ..бычьей или не..
                                    Open[index+1], // ..имеет малые тени, то это не МСМ 
                                    Close[index+1]))
      return(false);                               
     
   return (IsSignalCandleIsSmall(index, signalToFirstPercents));
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна MCM на указанном баре                       |
//+-------------------------------------------------------------------------------------+
bool IsBearsMCMPattern(int index, int total)
{
   if (Low[index] >= Low[index+1])                 // Если сигнальный бар не пробил вниз
      return(false);                               // ..предыдущий бар, то это не MCM

   if (Close[index] <= Open[index])                // Если сигнальный бар не бычий, то..
      return(false);                               // ..это не МСМ

   if (!IsCandleTypeAndSmallShadows(index+1,       // Если первая свеча не является..
                                    openCloseToHighLowPointsMCM,// .. медвежьей или не..
                                    Close[index+1],// ..имеет малые тени, то это не МСМ 
                                    Open[index+1]))
      return(false);                               
      
   return (IsSignalCandleIsSmall(index, signalToFirstPercents));
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия бычьего паттерна IR на указанном баре                           |
//+-------------------------------------------------------------------------------------+
bool IsBullsIRPattern(int index, int total, int& patternStart)
{
   if (PD(Low[index], High[index+1]) < secondGap)  // Проверка наличия второго гепа
      return(false);

   if (PD(Low[index+2], High[index+1]) < firstGap) // Проверка наличия первого гепа
      return(false);

   return (IsDownTrend(index+1, total, patternStart));
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия медвежьего паттерна IR на указанном баре                        |
//+-------------------------------------------------------------------------------------+
bool IsBearsIRPattern(int index, int total, int& patternStart)
{
   if (PD(Low[index+1], High[index]) < secondGap)  // Проверка наличия второго гепа
      return(false);

   if (PD(Low[index+1], High[index+2]) < firstGap) // Проверка наличия первого гепа
      return(false);

   return (IsUpTrend(index+1, total, patternStart));
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна IB на указанном баре                                |
//+-------------------------------------------------------------------------------------+
int IBPatternDir(int index, int total, int& patternStart)
{
   if (!IsIBPattern(index, total, patternStart))
      return (PATTERN_NO);
      
   if (Close[index] >= Open[index])
      return (PATTERN_BULL);
   return (PATTERN_BEAR);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна DB на указанном баре                                |
//+-------------------------------------------------------------------------------------+
int DBPatternDir(int index, int total, int& patternStart)
{
   if (IsDBLHCPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsDBHLCPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна TB на указанном баре                                |
//+-------------------------------------------------------------------------------------+
int TBPatternDir(int index, int total, int& patternStart)
{
   if (IsTBLPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsTBHPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна Рельсы на указанном баре                            |
//+-------------------------------------------------------------------------------------+
int RAILSPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsRailsPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsRailsPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна CPR на указанном баре                               |
//+-------------------------------------------------------------------------------------+
int CPRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsCPRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsCPRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна HR на указанном баре                                |
//+-------------------------------------------------------------------------------------+
int HRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsHRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsHRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна OVB на указанном баре                               |
//+-------------------------------------------------------------------------------------+
int OVBPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBUOVBPattern(index, total))
      return (PATTERN_BULL);
   if (IsBEOVBPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна PPR на указанном баре                               |
//+-------------------------------------------------------------------------------------+
int PPRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsPPRPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsPPRPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна Pin Bar на указанном баре                           |
//+-------------------------------------------------------------------------------------+
int PINBARPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsPINBARPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsPINBARPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна MCM на указанном баре                               |
//+-------------------------------------------------------------------------------------+
int MCMPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 1;
   if (IsBullsMCMPattern(index, total))
      return (PATTERN_BULL);
   if (IsBearsMCMPattern(index, total))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка существования паттерна IR на указанном баре                                |
//+-------------------------------------------------------------------------------------+
int IRPatternDir(int index, int total, int& patternStart)
{
   patternStart = index + 2;
   if (IsBullsIRPattern(index, total, patternStart))
      return (PATTERN_BULL);
   if (IsBearsIRPattern(index, total, patternStart))
      return (PATTERN_BEAR);   
   return (PATTERN_NO);   
}
//+-------------------------------------------------------------------------------------+
//| Проверка наличия любого из разрешенных паттернов на указанном баре                  |
//+-------------------------------------------------------------------------------------+
int GetAnyPatternTypeAndDir(int index, int& patternDir, int& patternStart)
{
   int total = Bars - 2;
   if (useIRpattern)                               // Если разрешено обрабатывать..
   {                                               // ..паттерн IR, то определим его..
      patternDir = IRPatternDir(index, total, patternStart);// ..наличие
      if (patternDir != PATTERN_NO)
         return (IR_INDEX);
   }
   
   if (useMCMpattern)                              // Если разрешено обрабатывать..
   {                                               // ..паттерн MCM, то определим его..
      patternDir = MCMPatternDir(index, total, patternStart); // ..наличие
      if (patternDir != PATTERN_NO)
         return (MCM_INDEX);
   }
   
   if (usePINBARpattern)                           // Если разрешено обрабатывать..
   {                                               // ..паттерн Pin Bar, то определим..
      patternDir = PINBARPatternDir(index, total, patternStart); // ..его наличие
      if (patternDir != PATTERN_NO)
         return (PINBAR_INDEX);
   }

   if (useCPRpattern)                              // Если разрешено обрабатывать..
   {                                               // ..паттерн CPR, то определим его..
      patternDir = CPRPatternDir(index, total, patternStart); // ..его наличие
      if (patternDir != PATTERN_NO)
         return (CPR_INDEX);
   }
   
   if (useHRpattern)                               // Если разрешено обрабатывать..
   {                                               // ..паттерн HR, то определим его..
      patternDir = HRPatternDir(index, total, patternStart); // ..его наличие
      if (patternDir != PATTERN_NO)
         return (HR_INDEX);
   }
   
   if (usePPRpattern)                              // Если разрешено обрабатывать..
   {                                               // ..паттерн PPR, то определим его..
      patternDir = PPRPatternDir(index, total, patternStart); // ..наличие
      if (patternDir != PATTERN_NO)
         return (PPR_INDEX);
   }
   
   if (useOVBpattern)                              // Если разрешено обрабатывать..
   {                                               // ..паттерны BUOVB и BEOVB, то..
      patternDir = OVBPatternDir(index, total, patternStart); // ..определим его наличие
      if (patternDir != PATTERN_NO)
         return (OVB_INDEX);
   }
   
   if (useRAILSpattern)                            // Если разрешено обрабатывать..
   {                                               // ..паттерн Рельсы, то определим..
      patternDir = RAILSPatternDir(index, total, patternStart); // ..его наличие
      if (patternDir != PATTERN_NO)
         return (RAILS_INDEX);
   }
   
   if (useTBpattern)                               // Если разрешено обрабатывать..
   {                                               // ..паттерн TB, то определим его..
      patternDir = TBPatternDir(index, total, patternStart); // ..наличие
      if (patternDir != PATTERN_NO)
         return (TB_INDEX);
   }

   if (useDBpattern)                               // Если разрешено обрабатывать..
   {                                               // ..паттерн DB, то определим его..
      patternDir = DBPatternDir(index, total, patternStart); // ..наличие
      if (patternDir != PATTERN_NO)
         return (DB_INDEX);
   }

   if (useIBpattern)                               // Если разрешено обрабатывать..
   {                                               // ..паттерн IB, то определим его..
      patternDir = IBPatternDir(index, total, patternStart); // ..наличие
      if (patternDir != PATTERN_NO)
         return (IB_INDEX);
   }
   
   return (-1);                                    // Ни один из паттернов не определен
}
//+-------------------------------------------------------------------------------------+
//| Вычисление уровня стоп-приказа по направлению паттерна и его ширине                 |
//+-------------------------------------------------------------------------------------+
double GetPatternSL(int index, int patternStart, int patternDir, int offset)
{
   if (patternDir == PATTERN_BEAR)
      return (High[iHighest(NULL, 0, MODE_HIGH, patternStart - index + 1, index)] +
              offset*Point + g_spread);
              
   return (Low[iLowest(NULL, 0, MODE_LOW, patternStart - index + 1, index)] -
           offset*Point);
}
//+-------------------------------------------------------------------------------------+
//| Вычисление уровня профита по направлению паттерна и текущей цене                    |
//+-------------------------------------------------------------------------------------+
double GetTP(int patternDir, int tpSize)
{
   RefreshRates();
   if (patternDir == PATTERN_BEAR)
      return (Bid - tpSize*Point);
              
   return (Ask + tpSize*Point);
}
//+-------------------------------------------------------------------------------------+
//| Приведение значения к пунктам                                                       |
//+-------------------------------------------------------------------------------------+
int ToPoints(double value)
{
   return (MathRound(value/Point));
}
//+-------------------------------------------------------------------------------------+
//| Определение итога сделки (прибыль или убыток)                                       |
//+-------------------------------------------------------------------------------------+
int GetPatternProfit(int start, int finish, double openPrice, int direction,
                     double slPrice, int useTP, int useSLOffset)
{
// - 1 - == Расчет цен профита и стоп-приказа ===========================================
   if (direction == PATTERN_BULL)                  // Считаем все по Bid. Поэтому для..
   {                                               // ..длинных сделок уровень TP повышен
      double tpPrice = openPrice + Point*useTP + g_spread;// .. на спред
      slPrice -= useSLOffset*Point;                // Стоп-приказ и так по Bid
   }
   else                                            // Считаем все по Bid. Поэтому для..
   {                                               // ..коротких сделок уровни понижены
      tpPrice = openPrice - Point*useTP - g_spread;// ..на спред
      slPrice += useSLOffset*Point - g_spread;     // Стоп-приказ
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Расчет цен профита и стоп-приказа ===========================================
   for (int i = finish-1; i >= start; i--)         // Участок графика проходится слева..
   {                                               // ..направо
      if (direction == PATTERN_BULL)               // У длинных сделок стоп-приказ..
      {                                            // ..находится внизу, а профит -..
         if (Low[i] <= slPrice)                    // ..вверху
            return (-ToPoints(openPrice-slPrice+g_spread));
         if (High[i] >= tpPrice)
            return (useTP);
         continue;
      }

      if (High[i] >= slPrice)                      // У коротких сделок стоп-приказ..
         return (-ToPoints(slPrice-openPrice+g_spread));// ..находится вверху, а профит -
      if (Low[i] <= tpPrice)                       // ..внизу
         return (useTP);
   }
// - 2 - == Окончание блока =============================================================

// - 3 - == Сделка не закрыта ни по стопу, ни профиту ===================================
   double closePrice = Open[start-1];              // Цена закрытия позы - открытие бара
   if (direction == PATTERN_BULL)                  // Для длинных сделок итог один,..
      return (ToPoints(closePrice - openPrice - g_spread));
   return (ToPoints(openPrice - closePrice - g_spread));// ..для коротких - другой
// - 3 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Расчет статистических данных                                                        |
//+-------------------------------------------------------------------------------------+
void CalculateData(int patternCnt, int& patternIndex[], int& patternDir[], 
                   double& patternSL[], int& totalNetProfit,
                   int useTP, int useSLOffset)
{
   totalNetProfit = 0;
   
   for (int i = patternCnt-1; i >= 0; i--)         // По массиву паттернов
   {
      if (i > 0)                                   // Начало участка (справа по графику)
         int start = patternIndex[i-1];            // ..реакции на паттерн
      else
         start = 1;
      int finish = patternIndex[i];                // Конец участка реакции на паттерн
      double openPrice = Open[finish-1];           // Цена открытия сделки
      
      int netProfit = GetPatternProfit(start, finish,// Итог сделки
                                       openPrice, 
                                       patternDir[i], 
                                       patternSL[i], useTP, useSLOffset);

      totalNetProfit += netProfit;                 // Общий итог всех сделок
   }
}    
//+-------------------------------------------------------------------------------------+
//| Подбор наиболее оптимальных параметров для текущей ситуации и выдача совета         |
//+-------------------------------------------------------------------------------------+
void SelectParameters(int patternCnt, int& patternIndex[], int& patternDir[], 
                      double& patternSL[], int& totalNetProfit, int& bestSLOffset, 
                      int& bestTP)
{
   int bestNetProfit = -999999999;
   int twoSpreads = 2*MarketInfo(Symbol(), MODE_SPREAD);
   for (int slSize = 0; slSize <= maxSLTP; slSize += stepSLTP)
      for (int tpSize = twoSpreads; tpSize <= maxSLTP; tpSize += stepSLTP)
      {
         CalculateData(patternCnt, patternIndex,   // Расчет стат. данных
                       patternDir, patternSL, 
                       totalNetProfit, 
                       tpSize, slSize);
         if (totalNetProfit <= bestNetProfit)      // Новый результат хуже предыдущего
            continue;                              // Продолжаем поиск
   
         bestNetProfit = totalNetProfit;           // Новый результат лучше. Запоминаем..
         bestSLOffset = slSize;                    // ..данные
         bestTP = tpSize;
      }
   totalNetProfit = bestNetProfit;                 // Записываем реальное значение
}
//+-------------------------------------------------------------------------------------+
//| Определение наличия указанного паттерна на указанном баре                           |
//+-------------------------------------------------------------------------------------+
int GetPatternDirection(int index, int total, int patternType, int& patternStart)
{
   patternStart = index;
   switch (patternType)
   {
      case IB_INDEX: return (IBPatternDir(index, total, patternStart));
      case DB_INDEX: return (DBPatternDir(index, total, patternStart));
      case TB_INDEX: return (TBPatternDir(index, total, patternStart));
      case RAILS_INDEX: return (RAILSPatternDir(index, total, patternStart));
      case CPR_INDEX: return (CPRPatternDir(index, total, patternStart));
      case HR_INDEX: return (HRPatternDir(index, total, patternStart));
      case OVB_INDEX: return (OVBPatternDir(index, total, patternStart));
      case PPR_INDEX: return (PPRPatternDir(index, total, patternStart));
      case PINBAR_INDEX: return (PINBARPatternDir(index, total, patternStart));
      case MCM_INDEX: return (MCMPatternDir(index, total, patternStart));
      case IR_INDEX: return (IRPatternDir(index, total, patternStart));
   }
}

//+-------------------------------------------------------------------------------------+
//| Поиск паттернов указанного типа в истории                                           |
//+-------------------------------------------------------------------------------------+
void FindPatterns(int patternType, int total, int& patternCnt, 
                  int& patternIndex[], int& patternDir[], double& patternSL[])
{
   int patternStart;
   for (int i = 2; i < total; i++)                 // Идем справа налево по графику,..
   {                                               // ..проверяя наличие паттерна на..
      int direction = GetPatternDirection(i, total,// .. каждом баре
                                          patternType, patternStart);
      if (direction == PATTERN_NO)                 // Паттерна нет - идем дальше
         continue;
      patternIndex[patternCnt] = i;                // Паттерн есть - запишем номер бара,
      patternDir[patternCnt] = direction;          // ..направление паттерна,..
      if (direction == PATTERN_BULL)               // ..и рассчитаем уровень стоп-приказа
         patternSL[patternCnt] = Low[iLowest(NULL, 0, 
                                             MODE_LOW,
                                             patternStart - i + 1, i)]; 
      else
         patternSL[patternCnt] = High[iHighest(NULL, 0, 
                                               MODE_HIGH,
                                               patternStart - i + 1, i)];

      patternCnt++;                                // Количество паттернов увеличилось
   }
}

//+-------------------------------------------------------------------------------------+
//| Выполнение подбора оптимальных параметров для текущего сигнала                      |
//+-------------------------------------------------------------------------------------+
bool IsOptimalParameters(int patternType, int patternDir, int& bestSLOffset, int& bestTP)
{
// - 1 - == Нахождение всех подобных паттернов на выбранном участке истории =============
   int patternCnt = 0;
   int patternIndex[];                             // Индексы баров, на которых найдены..
                                                   // ..подобные паттерны
   int patternDirN[];                              // Направления паттернов
   double patternSL[];                             // Цена стоп-приказа паттерна
   ArrayResize(patternIndex, optimizationBars);    // Максимальное кол-во паттернов на..
   ArrayResize(patternDirN, optimizationBars);     // ..этом участке истории
   ArrayResize(patternSL, optimizationBars);
   FindPatterns(patternType, optimizationBars,  
                patternCnt, patternIndex, patternDirN, patternSL);
// - 1 - == Окончание блока =============================================================

// - 2 - == Проведение подбора параметров ===============================================
   int totalNetProfit;                             // Итог виртуальной торговли с..
                                                   // ..использованием оптимальных..
                                                   // ..параметров, в пп.
   SelectParameters(patternCnt, patternIndex,      // Рассчитаем оптимальные параметры
                    patternDirN, patternSL, totalNetProfit, 
                    bestSLOffset, bestTP);
// - 2 - == Окончание блока =============================================================

// - 3 - == Принятие решения о проведении сделки ========================================
   double expectation = 0;                         // Если есть виртуальные сделки, то..
   if (patternCnt != 0)                            // ..рассчитаем математическое..
      expectation = totalNetProfit/1.0/patternCnt; // ..ожидание
   if (patternCnt >= minStatDeals)                 // Оптимальные параметры найдены
      if (expectation >= minExpectation)            
         return (true);
// - 3 - == Окончание блока =============================================================

   return (false);                                 // Оптимальные параметры не найдены
}
//+-------------------------------------------------------------------------------------+
//| Генерация сигнала закрытия, покупки или продажи                                     |
//+-------------------------------------------------------------------------------------+
int GetSignal(double& sl, double& tp)
{
// - 1 - == Определение наличия паттерна на последнем баре ==============================
   int patternDir;                                 // Бычий или медвежий паттерн
   int patternStart;                               // Индекс бара начала паттерна
   int patternType = GetAnyPatternTypeAndDir(1, patternDir, patternStart);
   
   if (patternType < 0)                            // Паттерн не определен - сигнала нет
      return (PATTERN_NO);
// - 1 - == Окончание блока =============================================================
      
// - 2 - == Расчет умолчательных значений стоп-приказа и профита ========================
   if (!useOptimization)                           // Если оптимизация не требуется, то..
   {                                               // ..вычисляем умолчательные уровни..
      sl = GetPatternSL(1, patternStart,           //  позиции и уходим
                        patternDir, defaultSLOffset);
      tp = GetTP(patternDir, defaultTP);
      return (patternDir);                         
   }
// - 2 - == Окончание блока =============================================================
   
// - 3 - == Проведение подбора оптимальных параметров ===================================
   int bestSLOffset, bestTP;                       // Размеры SL и TP в пунктах
   if (!IsOptimalParameters(patternType, patternDir, bestSLOffset, bestTP))
      return (PATTERN_NO);                         // Нет торгового сигнала
      
   sl = GetPatternSL(1, patternStart, patternDir, bestSLOffset);
   tp = GetTP(patternDir, bestTP);
   
   return (patternDir);                            // Паттерн найден            
// - 3 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Функция поиска своих ордеров.                                                       |
//+-------------------------------------------------------------------------------------+
void FindOrders()
{
// - 1 - == Инициализация переменных перед поиском ======================================
   int total = OrdersTotal() - 1;
   g_type = -1;                                    // На текущий момент у нас нет позиций
// - 1 - == Окончание блока =============================================================
 
// - 2 - == Непосредственно поиск =======================================================
   for (int i = total; i >= 0; i--)                // Используется весь список ордеров
      if (OrderSelect(i, SELECT_BY_POS))           // Убедимся, что ордер выбран
         if (OrderMagicNumber() == MagicNumber &&  // Ордер открыт экспертом,
             OrderSymbol() == Symbol())            // ..который прикреплен к текущей паре
         {
            g_ticket = OrderTicket();// Запишем данные позиции
            g_type = OrderType();
         } 
// - 2 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Закрытие заданного рыночного ордера                                                 |
//+-------------------------------------------------------------------------------------+
bool CloseDeal(int ticket, double closeLots = 0) 
{                          
   if (OrderSelect(ticket, SELECT_BY_TICKET) &&    // Существует ордер с заданным.. 
       OrderCloseTime() == 0)                      // ..тикетом и ордер не закрыт
      if (WaitForTradeContext())                   // Свободен ли торговый поток?
      {
         double Price = MarketInfo(Symbol(), MODE_BID);// Если следует закрыть длинную..
                                                   // ..сделку, то применяется цена BID
         if (OrderType() == OP_SELL)               // Если следует закрыть короткую.. 
            Price = MarketInfo(Symbol(), MODE_ASK);// ..сделку, то применяется цена ASK
         if (closeLots == 0 ||                     // Если объем не указан..
             closeLots > OrderLots())              // ..или заказан большой объем, то..
            closeLots = OrderLots();               // ..закрываем все
         if (!OrderClose(OrderTicket(), closeLots, NP(Price), 3))// Если сделку не..
            return(False);                         // ..удалось закрыть, то результат..
                                                   // функции - False
      }    
      else
         return(false);
   return(True);                                   // Можно открывать следующую сделку
}  
//+-------------------------------------------------------------------------------------+
//| Изменение уровней профита и стопа указанной позиции                                 |
//+-------------------------------------------------------------------------------------+
bool ModifySLAndTP(int ticket, double sl, double tp)
{
   if (!(OrderSelect(ticket, SELECT_BY_TICKET) &&  // Выберем позицию по тикету и..
         OrderCloseTime() == 0))                   // ..удостоверимся, что она не закрыта
      return (true);                               // Уходим, если нет позиции
      
   if (MathAbs(sl - OrderStopLoss()) < g_tickSize &&// Проверим уровень стоп-приказа..
       MathAbs(tp - OrderTakeProfit()) < g_tickSize)// ..и профита
      return (true);                               // Уходим, если оба уровня двигать..
                                                   // ..не нужно
                                                   
   if ((OrderType() == OP_BUY && Bid - sl <= g_stopLevel) ||// Если цена слишком близка..
       (OrderType() == OP_SELL && sl - Ask <= g_stopLevel))// ..к новому уровню..
       return(false);                              // ..стоп-приказа - вернем ошибку
                                                      
   if ((OrderType() == OP_BUY && tp - Bid <= g_stopLevel) ||// Если цена слишком близка..
       (OrderType() == OP_SELL && Ask - tp <= g_stopLevel))// ..к новому уровню..
       return(false);                              // ..профита - вернем ошибку

   if (OrderModify(OrderTicket(), 0, sl, tp, 0))   // Изменяем стоп-приказ
      return (true);                               // Успешная модификация

   return(false);                                  // Неудачная модификация
}
//+-------------------------------------------------------------------------------------+
//| Открытие длинной позиции                                                            |
//+-------------------------------------------------------------------------------------+
bool OpenBuy(double sl, double tp)
{
// - 1 - == Закрытие противоположных позиций ============================================
   if (g_type == OP_SELL)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Модификация существующей позиции ============================================
   if (g_type == OP_BUY)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == Окончание блока =============================================================

// - 3 - == Покупка по рынку ============================================================
   return (OpenByMarket(OP_BUY, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Открытие короткой позиции                                                           |
//+-------------------------------------------------------------------------------------+
bool OpenSell(double sl, double tp)
{
// - 1 - == Закрытие противоположных позиций ============================================
   if (g_type == OP_BUY)
      if (!CloseDeal(g_ticket))
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Модификация существующей позиции ============================================
   if (g_type == OP_SELL)
      return (ModifySLAndTP(g_ticket, sl, tp));
// - 2 - == Окончание блока =============================================================

// - 3 - == Покупка по рынку ============================================================
   return (OpenByMarket(OP_SELL, GetLots(), sl, tp, MagicNumber, false));
// - 3 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Открытие позиций                                                                    |
//+-------------------------------------------------------------------------------------+
bool Trade(int signal, double sl, double tp)
{
// - 1 - == Открытие длинной позиции ====================================================
   if (signal == PATTERN_BULL)                     // Активен сигнал покупки
      if (!OpenBuy(sl, tp))                        // Открытие позиции
         return(false);
// - 1 - == Окончание блока =============================================================

// - 2 - == Открытие короткой позиции ===================================================
   if (signal == PATTERN_BEAR)                     // Активен сигнал продажи
      if (!OpenSell(sl, tp))                       // Открытие позиции
         return(false);
// - 2 - == Окончание блока =============================================================

   return(true);    
}
//+-------------------------------------------------------------------------------------+
//| Функция start эксперта                                                              |
//+-------------------------------------------------------------------------------------+
int start()
{
// - 1 - == Можно ли работать эксперту? =================================================
   if (!g_activate || g_fatalError) return(0);
// - 1 - == Окончание блока =============================================================

// - 2 - == Слежение за появлением нового бара в истории ================================
   if (g_lastBar == Time[0])
      return (0);
// - 2 - == Окончание блока =============================================================

// - 3 - == Слежение за изменением рыночного окружения ==================================
   if (!IsTesting())
      GetMarketInfo();
// - 3 - == Окончание блока =============================================================

// - 4 - == Расчет сигнала ==============================================================
   double sl, tp;
   int signal = GetSignal(sl, tp);                 // Определяем сигнал
// - 4 - == Окончание блока =============================================================
   
// - 5 - == Выполнение торговых операций ================================================
   FindOrders();                                   // Найдем свои позиции
   if (!Trade(signal, sl, tp))                     // Открытие/закрытие позиций
      return(0);                                   
// - 5 - == Окончание блока =============================================================

   g_lastBar = Time[0];

   return(0);
}


