//+------------------------------------------------------------------+
//|                                                  DkzNkzMaker.mq4 |
//|                                           Author: Sergey Pekshev |
//|       Contact Information: icq: 345-961-467, skype: alllance.com |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
struct   InfoStruct { string name; double percent; int NKZ; datetime bankTime; double bankPercent; };

// Список таймфреймов -> OBJ_PERIOD_M1, OBJ_PERIOD_M5, OBJ_PERIOD_M5, OBJ_PERIOD_M30, OBJ_PERIOD_H1, OBJ_PERIOD_H4, OBJ_PERIOD_D1, OBJ_PERIOD_W1, OBJ_PERIOD_MN1, OBJ_ALL_PERIODS
// Примеры:
// double DKZ_timeframe = OBJ_ALL_PERIODS;                            // Показывать на всех таймфреймах
// double DKZ_timeframe = OBJ_PERIOD_M15;                             // Показывать на таймфрейме M15
// double DKZ_timeframe = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15; // Показывать на таймфреймах M1 и M5 и M15

//////////////////////////////////////////////////////////////////////
                                         
InfoStruct Info[]      = {                  
// { Название инструмента, % ставка, НКЗ в пунктах, Время Б.уровня, % ставка для Б.уровня }   НКЗ = маржа / цена пункта;
                                              // % ставки -> http://www.global-rates.com/interest-rates/central-banks/central-banks.aspx
   { "EURUSD", 0.30, 2480, "10:30", 0.30 },   // 3100 12.5 http://www.cmegroup.com/trading/fx/g10/euro-fx_performance_bonds.html
   { "GBPUSD", 0.75, 2800, "10:30", 0.63 },   // 1750 6.25 http://www.cmegroup.com/trading/fx/g10/british-pound_performance_bonds.html
   { "USDJPY", 0.35, 2400 },                  // 3000 12.5 http://www.cmegroup.com/trading/fx/g10/japanese-yen_performance_bonds.html#sortField=exchange&sortAsc=true&sector=FX&exchange=CME&clearingCode=J1
   { "USDCAD", 1.00, 1670 },                  // 1670 10   http://www.cmegroup.com/trading/fx/g10/canadian-dollar_performance_bonds.html#sortField=exchange&sortAsc=true&sector=FX&exchange=CME&clearingCode=C1
   { "AUDUSD", 2.75, 2200 },                  // 2200 10   http://www.cmegroup.com/trading/fx/g10/australian-dollar_performance_bonds.html
   { "NZDUSD", 3.75, 2100 },                  // 2100 10   http://www.cmegroup.com/trading/fx/g10/new-zealand-dollar_performance_bonds.html
   
   { "XAUUSD", 0,    4000 },                  // 4000 http://www.cmegroup.com/trading/fx/g10/euro-fx_performance_bonds.html#sortField=exchange&sortAsc=true&exchange=CMX&sector=METALS&clearingCode=GC
   { "#NQ100", 0,    1800 },                  // 18000 25 0.25 http://www.cmegroup.com/trading/equity-index/us-index/nasdaq-100_performance_bonds.html
   { "#SP500", 0,    920  },                  // 23000 25 0.1 http://www.cmegroup.com/trading/equity-index/us-index/sandp-500_contract_specifications.html
};

// Горячие клавиши
int      HotKey1         = 49;                // Клавиша 1 для рисования ДКЗ по процентной ставке
int      HotKey2         = 50;                // Клавиша 2 для рисования ДКЗ по НКЗ / 2
int      HotKey3         = 51;                // Клавиша 3 для рисования НКЗ
int      HotKey4         = 16;                // Клавиша Shift удаление зоны, указатель мыши должен быть наведен на зону
int      HotKey5         = 82;                // Клавиша R выравнивание выделенной трендовой линии по горизонтали (повторное нажатие для выровненной линии снимает выделение)
int      HotKey6         = 66;                // Клавиша B нарисовать банковский уровень
int      HotKey7         = 53;                // Клавиша 5 рисование/удаление уровней средненевного хода цены, от мин. дня вверх на ATR и от макс. дня вниз на ATR. Уровни текущего дня корректируются автоматически
int      HotKey8         = 54;                // Клавиша 6 рисование/удаление уровней Hi и Low дня.
int      HotKey9         = 17;                // Клавиша Ctrl двойное нажатие включает режим рисования паттернов, одинарное выключает, Esc - отменяет нарисованное
int      HotKey10        = 52;                // Клавиша 4 рисование угла Ганна, курсор должен быть под или над пиком
int      HotKey11        = 55;                // Клавиша 7 установка уровня, для отслеживания коррекции
int      HotKey12        = 56;                // Клавиша 8 рисование уровней закрытия Америки
int      HotKey13        = 9;                 // Клавиша Tab удлинить зону находящуюся под указателем мыши на кол. секунд заданое в int ZonaLengthPlus
int      HotKey14        = 89;                // Клавиша Y замена Ctrl-Y для вкл./выкл. отображения разделителей периодов
int      HotKey15        = 85;                // Клавиша U вкл./выкл. торговых уровней. Если вы выключили их и забыли, то через 30 секунд, они сами включатся (на всякий случай)

//--------------------------------------------------------------------

int      ZonaAlert       = 1;                 // 1 - сигнализировать при заходе в зону, 0 - не сигнализировать (при повторном заходе сигнал будет только если цена выходила из зоны на высоту зоны)
int      ZonaLengthPlus  = 20000;             // Количество секунд для удлинения зоны под указателем мыши по горячей клавише HotKey13

// ДКЗ зона
int      DKZ_color       = clrDarkOrange;     // Цвет
int      DKZ_length      = 100000;            // Длина (смещение по времени в секундах)
int      DKZ_angle       = 5000;              // Угол наклона линии (смещение по времени в секундах)
int      DKZ_timeframe   = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// НКЗ зона
int      NKZ_color       = clrMediumSeaGreen; // Цвет НКЗ
int      NKZ_length      = 300000;            // Длина (смещение по времени в секундах)
int      NKZ_angle       = 10000;             // Угол наклона линии (смещение по времени в секундах)
int      NKZ_timeframe   = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры
int      NKZ_mode        = 0;                 // 0 - рисовать наружу 5% и во внутрь 5%, 1 - рисовать зону 10% наружу, 2 - рисовать зону 10% во внутрь 
int      NKZd_color      = C'123,210,163';    // Цвет дробных зоны НКЗ
double   NKZd_list[]     = {0.25, 0.5};       // Список дробных зон


// Банковский уровень
int      B_auto          = 1;                 // Автоматически рисовать Б.уровни 1 - да, 0 - нет (учитывается список допустимых дней)
int      B_manual        = 1;                 // При ручном рисовании Б.уровня, учитывать ли список допустимых дней недели (список см. ниже) 1 - да, 0 - нет, рисовать уровень в любой день
int      B_days[]        = {3, 4, 5};         // Список допустимых дней для рисования Б.уровень (0-воскресенье, 1, 2, 3, 4, 5, 6-суббота) 
int      B_length        = 0;                 // Длина (смещение по времени в секундах), если 0 - то рисовать до конца текущего дня
int      B_orderZ        = 4;                 // Колличество зон от Б.уровня 
int      B_colorZ        = clrOrange;         // Цвет зоны от Б.уровня
int      B_color         = clrBlue;           // Цвет линии
int      B_width         = 2;                 // Толщина линии
int      B_style         = 0;                 // Стиль линии
int      B_back          = 1;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      B_timeframe     = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// ATR уровни
int      ATR_hist        = 30;                // Количество дней для расчета ATR
int      ATR_W1          = 1;                 // Пропускать последнюю неделю 1 - да, 0 - нет
int      ATR_colorH      = clrRed;            // Цвет нижней линни идущей от хая вниз
int      ATR_colorL      = clrGreen;          // Цвет верхней линни идущей от лоу вверх
int      ATR_width       = 1;                 // Толщина линии
int      ATR_style       = 1;                 // Стиль линии
int      ATR_back        = 1;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      ATR_timeframe   = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// Hi Low дня
int      HiLow_count     = 100;               // Количество дней для отображения
int      HiLow_color     = clrSteelBlue;      // Цвет
int      HiLow_colorF    = clrRed;            // Цвет пятницы
int      HiLow_width     = 2;                 // Толщина линии
int      HiLow_style     = 0;                 // Стиль линии
int      HiLow_back      = 1;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      HiLow_timeframe = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// Линия для рисования паттернов
int      Zigzag_color    = clrSteelBlue;      // Цвет
int      Zigzag_width    = 5;                 // Толщина линии
int      Zigzag_style    = 0;                 // Стиль линии
int      Zigzag_back     = 1;                 // Рисовать линию на заднем плане - 1, на переднем - 0

// Линия Ганна
int      Gann_length     = 100000;            // Смещение второй точки в секундах (первая точка на пике)
double   Gann_Scale[]    = {0.25, 0.50, 1};   // Список углов (*10 для пятизнака)
int      Gann_change     = 1;                 // Менять углы - 1, добавлять по очереди - 0
int      Gann_color      = clrBlue;           // Цвет
int      Gann_width      = 2;                 // Толщина линии
int      Gann_style      = 0;                 // Стиль линии
int      Gann_back       = 0;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      Gann_timeframe  = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// Уровень коррекции
int      Correct_length  = 7000;              // На сколько дальше протягивать линию от текущей цены (в секундах)
int      Correct_time    = 60 * 5;            // Колличество секунд между сигналами если цена то заходит, то выходит за уровень 50% коррекции
int      Correct_color1  = clrBlue;           // Цвет линни 
int      Correct_width1  = 1;                 // Толщина линии
int      Correct_style1  = 2;                 // Стиль линии
int      Correct_back1   = 0;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      Correct_color2  = clrRed;            // Цвет уровня
int      Correct_width2  = 2;                 // Толщина уровня
int      Correct_style2  = 0;                 // Стиль уровня
int      Correct_back2   = 0;                 // Рисовать уровень на заднем плане - 1, на переднем - 0

//Уровни закрытия Америки
datetime A_time          = "23:00";           // Время закрытия Американской сессии по терминальному времени
int      A_count         = 100;               // Количество дней
int      A_length1       = 86400;             // Длинна линии в секундах
int      A_color1        = clrRed;            // Цвет линни (Горизонтальная линия)
int      A_width1        = 3;                 // Толщина линии
int      A_style1        = 0;                 // Стиль линии
int      A_back1         = 0;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      A_color2        = clrOrangeRed;      // Цвет линни (наклонная линия соединяющая закрытия сессий)
int      A_width2        = 2;                 // Толщина линии
int      A_style2        = 0;                 // Стиль линии
int      A_back2         = 0;                 // Рисовать линию на заднем плане - 1, на переднем - 0
int      A_timeframe     = OBJ_ALL_PERIODS;   // Таймфрэймы на которых отображать, см. выше примеры

// Звуковое оповещение
int      sound           = 1;                 // Звуковое оповещение 1 - включено, 0 - выключено
string   sound_Error     = "expert.wav";      // Звук при ошибке
string   sound_Zona      = "tick.wav";        // Звук при создании и удалении зоны
string   sound_Blevel    = "alert2.wav";      // Звук при создании банковского уровня
string   sound_Correct   = "wait.wav ";       // Звук когда цена зашла за 50% коррекции или в зону

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

int      MouseX          = 0; 
int      MouseY          = 0;
int      InfoKey         = -1;   // Индекс текущего инструмента в массиве инструментов (валютные пары)
datetime BankTime        = NULL;
int      ModeDkzNkz      = 0;
int      ModeZigzag      = 0;

struct   ListRectStruct { string name; double price; datetime time;};
ListRectStruct ListRect[];

int      AtrFL           = 1;
int      HiLowFL         = 1;
int      CorrectFL       = 1;
int      RectFL          = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
{
   ///////////////////////////////////////////////////////////////////////////////////////////////
   if (AccountInfoInteger(ACCOUNT_LOGIN) == 278402 || AccountInfoInteger(ACCOUNT_LOGIN) == 78757)
   {
      for (int i = ArraySize(Info) - 1; i >= 0; i--) Info[i].name = Info[i].name + "_m";
      //NKZ_mode   = 0;              // 1 - рисовать зону 10% наружу, 0 - рисовать наружу 5% и во внутрь 5%
      DKZ_color  = C'255,198,128'; // Цвет ДКЗ
      NKZ_color  = C'123,210,163'; // Цвет НКЗ
      NKZd_color = C'123,210,163'; // Цвет дробных НКЗ
      B_colorZ   = C'128,191,255'; // Цвет зоны от Б.уровня
   }
   ///////////////////////////////////////////////////////////////////////////////////////////////
   
   ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE, 1);
   ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, 1);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);
   if (UninitializeReason() != REASON_CHARTCHANGE) // При смене таймфрэйма не выполняем
   {
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, true); 
      InitRect("ALL_OBJECTS_RECT_CORRECT");
   }

   // Поиск нужного инструмента в списке инструментов и получения bankTime
   for (int i = ArraySize(Info) - 1; i >= 0; i--)
   {
      if (Info[i].name == _Symbol) 
      {
         BankTime = Info[i].bankTime;
         InfoKey = i;
         break;
      }
   }
   if (ObjectGetString(0, "MouseInfo", OBJPROP_TEXT) == "DkzNkzMaker") ModeDkzNkz = 1;
   if (ObjectGetString(0, "MouseInfo", OBJPROP_TEXT) == "/\\/\\/\\")   ModeZigzag = 1;
   if (ObjectCreate(0, "MouseInfo", OBJ_LABEL, 0, 0, 0)) ObjectSetString(0, "MouseInfo", OBJPROP_TEXT, " ");
   ObjectSet("MouseInfo", OBJPROP_BACK, false);                    // Рисовать объект в фоне
   ObjectSet("MouseInfo", OBJPROP_SELECTED, false);                // Снять выделение с объекта
   ObjectSet("MouseInfo", OBJPROP_SELECTABLE, false);              // Запрет на редактирование
   ObjectSet("MouseInfo", OBJPROP_FONT, "Arial");
   ObjectSet("MouseInfo", OBJPROP_FONTSIZE, 10);
   ObjectSet("MouseInfo", OBJPROP_COLOR, clrRed);
   ObjectSet("MouseInfo", OBJPROP_HIDDEN, true);                   // Скроем (true) или отобразим (false) имя графического объекта в списке объектов
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (reason == REASON_REMOVE) // Если удаляем индикатор
   {
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, true);
      GlobalVariableDel("DN_" + WindowHandle(_Symbol, 0));
      ObjectDelete("MouseInfo");
      DeleteByPrefix("LR_");
   }
}
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
{
   if (BankTime && B_auto && ArraySize(B_days))
   {
      BankTime = datetime(TimeHour(BankTime) + ":" + TimeMinute(BankTime));
      if (TimeCurrent() >= BankTime)
      {
         int dW = TimeDayOfWeek(BankTime);
         int ok = 0;
         for (int i = ArraySize(B_days) - 1; i >= 0; i--)
            if (dW == B_days[i]) { ok = 1; break; }
         if (ok)
         {
            ok = iBarShift(NULL, PERIOD_M1, BankTime, true);
            if (ok != -1) DrawBank(BankTime, iOpen(NULL, PERIOD_M1, ok), Info[InfoKey].bankPercent);
         }
      }
   }
   if (AtrFL)     DrawATR();
   if (HiLowFL)   DrawHiLow();
   if (CorrectFL) DrawCorrect();
   if (RectFL)    AlertRect();
}

void OnTimer()
{
   ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, true);
   EventKillTimer();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Обработка событий ChartEvent                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // идентификатор события  
                  const long& lparam,   // параметр события типа long
                  const double& dparam, // параметр событ3ия типа double
                  const string& sparam  // параметр события типа string
                 )
{
   int sub_window;
   static datetime ZigzagTime  = 0;
   static double   ZigzagPrice = 0;
   static string   ZigzagName  = "";
   static int      ZigzagIndex = 0;

   
   if (id == CHARTEVENT_OBJECT_CREATE) InitRect(sparam);
   if (id == CHARTEVENT_OBJECT_DELETE) InitRect();
   if (id == CHARTEVENT_OBJECT_DRAG)   InitRect(sparam);
   if (id == CHARTEVENT_OBJECT_CHANGE)
   {
      InitRect(sparam);
      if (StringSubstr(sparam, 0, 5) == "Bank_")
      {
         DrawBank(datetime(StringSubstr(sparam, 5, 0)), 0, Info[InfoKey].bankPercent);
         return;
      }
   }
      
   if (id == CHARTEVENT_MOUSE_MOVE)
   {
      MouseY = dparam;
      MouseX = lparam;
      DrawMouseInfo();
      if (ModeZigzag && ZigzagPrice)
      {
         datetime time;
         double price;
         ChartXYToTimePrice(0, MouseX, MouseY + 1, sub_window, time, price);
         if (!sub_window && price)
         {
            ObjectSet(ZigzagName, OBJPROP_TIME2, time);
            ObjectSet(ZigzagName, OBJPROP_PRICE2, price);
         }
      }
      return;
   }
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if (ModeZigzag)
      {
         static string name;
         ChartXYToTimePrice(0, MouseX, MouseY + 1, sub_window, ZigzagTime, ZigzagPrice);
         if (!ZigzagIndex) name = "Zigzag_" + GetTickCount() + "_";
         ZigzagName = name + ZigzagIndex++;
         ObjectCreate(ZigzagName, OBJ_TREND, 0, ZigzagTime, ZigzagPrice, ZigzagTime, ZigzagPrice);
         ObjectSet(ZigzagName, OBJPROP_COLOR, Zigzag_color);          // Цвет
         ObjectSet(ZigzagName, OBJPROP_WIDTH, Zigzag_width);          // Толщина
         ObjectSet(ZigzagName, OBJPROP_STYLE, Zigzag_style);          // Стиль
         ObjectSet(ZigzagName, OBJPROP_BACK, Zigzag_back);            // Рисовать объект в фоне
         ObjectSet(ZigzagName, OBJPROP_RAY, false);                   // Рисовать не луч
      }
      return;
   }
   
   if (id == CHARTEVENT_KEYDOWN)
   {
      //Comment("Код клавиши: " + lparam); PlaySound("stops.wav"); return;
      datetime time1;                  // Время вершинки
      double   price1;                 // Цена вершинки
      double   price2, price3, price4; // Цены для зоны
      int      HiLow;                  // 1 - Hi, -1 - Low

      Comment("");
      ChartXYToTimePrice(0, MouseX, MouseY + 1, sub_window, time1, price1);
      
      // Удлинение зоны
      if (lparam == HotKey13)
      {
         string name;
         int total = ObjectsTotal();
         for (int i = 0; i < total; i++)
         {
            if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE)
            {   
               if (price1 <= ObjectGet(name, OBJPROP_PRICE1) && price1 >= ObjectGet(name, OBJPROP_PRICE2) && time1 >= ObjectGet(name, OBJPROP_TIME1) && time1 <= ObjectGet(name, OBJPROP_TIME2))
               {
                  ObjectSet(name, OBJPROP_TIME2, correctWeekend(ObjectGet(name, OBJPROP_TIME2), ObjectGet(name, OBJPROP_TIME2) + ZonaLengthPlus));
                  return;
               }
            }
         }
      }
      
      /// Для совместной работы с рискменеджером ////////////////////////////////////////////////////////////////////
      if (GlobalVariableCheck("RM_" + WindowHandle(_Symbol, 0)))
      {
         if (lparam == 9)
         {
            if (!ModeDkzNkz) ModeDkzNkz = 1; else ModeDkzNkz = 0;
            GlobalVariableSet("DN_" + WindowHandle(_Symbol, 0), ModeDkzNkz);
            ModeZigzag = 0;
         }
      }
      else
      {
         ModeDkzNkz = 1;  
      }
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
      // Рисование зигзага
      if (lparam == HotKey9)
      {
         static int ttt;
         if (GetTickCount() - ttt < 400) 
         {
            ModeZigzag = 1;
            ModeDkzNkz = 0;
         }
         else
         {
            ttt = GetTickCount();
            ModeZigzag = ZigzagPrice = ZigzagIndex = 0;
            ObjectDelete(ZigzagName);
         }
      }
      DrawMouseInfo();
      
      // Нажали ESC
      if (lparam == 27)
      {
         if (ModeZigzag)
         {
            int k;
            if ((k = StringFind(ZigzagName, "_", 7)) != -1) DeleteByPrefix(StringSubstr(ZigzagName, 0, k));
            ZigzagIndex = 0;
         }
      }

      // Рисование зон, линии ганна, уровня коррекции
      if ((lparam == HotKey1 || lparam == HotKey2 || lparam == HotKey3 || lparam == HotKey10) && ModeDkzNkz || lparam == HotKey11)
      {
         if (InfoKey == -1 && lparam != HotKey11)
         {
            Comment("Нет информации по инструменту в настройках индикатора!");
            if (sound) PlaySound(sound_Error);
            return;
         }
         
         // Проверим на обновление зоны когда указатель на редактируемой зоне
         string name;
         int zonaUpdate = 0;
         double zonaUpdateInfo = 0;
         for (int i = ObjectsTotal() - 1; i >= 0; i--)
         {
            if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE)
            {   
               if (ObjectGet(name, OBJPROP_SELECTED) && price1 <= ObjectGet(name, OBJPROP_PRICE1) && price1 >= ObjectGet(name, OBJPROP_PRICE2) && time1 >= ObjectGet(name, OBJPROP_TIME1) && time1 <= ObjectGet(name, OBJPROP_TIME2))
               {
                  if (StringSubstr(name, 0, 4) == "DKZ_") zonaUpdate = 1;
                  if (StringSubstr(name, 0, 3) == "NKZ")  zonaUpdate = 2;
                  if (StringSubstr(name, 0, 4) == "NKZ_") zonaUpdate = 3;
                  if (zonaUpdate)
                  {
                     price1 = ObjectGet(StringSubstr(name, 0, 24), OBJPROP_PRICE1);
                     time1 = datetime(StringSubstr(name, 5, 19));
                     zonaUpdateInfo = StringSubstr(name, 27, 0);
                     if (StringSubstr(name, 25, 1) == "H") HiLow = 1;
                     if (StringSubstr(name, 25, 1) == "L") HiLow = -1;
                     break;
                  }
               }
            }
         }
         
         if (zonaUpdate)
         {
            if (!HiLow || !price1 || !zonaUpdateInfo)
            {
               Comment("Не получается! Наверное зона построена старой версией индикатора");
               if (sound) PlaySound(sound_Error);
               return;
            }
         }

         // Определяем указатель мыши над максимумом или над минимум 
         if (!zonaUpdate)
         {
            double price_H, price_L;
            int shift_H, shift_L, shift;
            price_H = price_L = shift_H = shift_L = HiLow = NULL;
            shift = iBarShift(NULL, 0, time1, false);
            shift_L = iLowest(NULL, 0, MODE_LOW, 10 * 2, shift - 10);
            price_L = iLow(NULL, 0, shift_L);
            shift_H = iHighest(NULL, 0, MODE_HIGH, 10 * 2, shift - 10);
            price_H = iHigh(NULL, 0, shift_H);
            if (price1 > price_H) 
            {
               price1 = price_H;                // Цена
               time1 = iTime(NULL, 0, shift_H); // Время
               HiLow = 1;                       // Hi
               
            }
            else if (price1 < price_L)
            {
               price1 = price_L;                // Цена
               time1 = iTime(NULL, 0, shift_L); // Время
               HiLow = -1;                      // Low
            }
            else
            {
               Comment("Указатель мыши должен, находиться выше максимума, либо ниже минимума!");
               if (sound) PlaySound(sound_Error);
               return;
            }
   
            // Подкорректируем время вершинки с младшего таймфрейма
            datetime time2 =  time1 + _Period * 60;
            if (time2 > TimeCurrent()) time2 = TimeCurrent();
            int tm[] = {1, 5, 15 , 30, 60, 240, 14400, 10080, 43200};
            for (int i = 0; i < ArraySize(tm); i++)
            {
               shift_L = iBarShift(NULL, tm[i], time1, true);
               shift_H = iBarShift(NULL, tm[i], time2, true);
               if (shift_L != -1 && shift_H != -1)
               {
                  if (HiLow == -1)
                     time1 = iTime(NULL, tm[i], iLowest(NULL, tm[i], MODE_LOW, shift_L - shift_H, shift_H + 1)); // Время
                  else
                     time1 = iTime(NULL, tm[i], iHighest(NULL, tm[i], MODE_HIGH, shift_L - shift_H, shift_H + 1)); // Время
                  break;
               }
            }
            
            // Попробуем найти зону и взять из нее данные, вдруг это повторное создание зоны с вершинки
            string prefix;
            if (lparam == HotKey1) prefix = "DKZ__";
            if (lparam == HotKey3) prefix = "NKZ__";
            prefix += time1;
            for (int i = ObjectsTotal() - 1; i >= 0; i--)
            {
               if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE)
               {
                  if (lparam == HotKey2)
                  {
                     if (StringSubstr(name, 5, 19) == time1 && StringSubstr(name, 0, 3) == "NKZ")
                     {
                        zonaUpdateInfo = StringSubstr(name, 27, 0);
                        break;
                     }                  
                  }
                  else if (StringFind(name, prefix, 0) == 0)
                  {
                     zonaUpdateInfo = StringSubstr(name, 27, 0);
                     break;
                  }
               }
            }
         }
         
         // ДКЗ по процентной ставке
         if (lparam == HotKey1 && !zonaUpdate || zonaUpdate == 1)
         {
            if (!zonaUpdateInfo) zonaUpdateInfo = Info[InfoKey].percent;
            double DKZ = price1 * zonaUpdateInfo / 100;
            if (DKZ == 0)
            {
               Comment("Процентная ставка не задана!");
               if (sound) PlaySound(sound_Error);
               return;
            }
            price2 = price1 - DKZ * HiLow;
            price4 = price2 + DKZ / 10 * HiLow;
            DrawZone("DKZ__", "Дкз - " + MathFloor(DKZ * MathPow(10, _Digits)) + "п. (" + DoubleToString(zonaUpdateInfo, 2) + "%)", time1, price1, time1 + DKZ_angle, price2, price2, price4, DKZ_length, DKZ_color, DKZ_timeframe, zonaUpdateInfo);
            return;
         }

         // Дробные НКЗ
         if (lparam == HotKey2 && !zonaUpdate || zonaUpdate == 2)
         {
            if (!zonaUpdateInfo) zonaUpdateInfo = Info[InfoKey].NKZ;
            double NKZ = zonaUpdateInfo;
            if (NKZ == 0)
            {
               Comment("Недельная зона не задана!");
               if (sound) PlaySound(sound_Error);
               return;
            }
            for (int i = ArraySize(NKZd_list) - 1; i >=0; i--)
            {
               if (!NKZd_list[i]) continue;
               NKZ = zonaUpdateInfo * NKZd_list[i];
               price2 = price1 - NKZ * _Point * HiLow;
               if (NKZ_mode == 1)
               {
                  price3 = price2 - NKZ * _Point * 0.1 * HiLow;  // Вычисляем высоту зоны, 10% наружу
                  price4 = price2;                               // Вычисляем высоту зоны, 10% наружу
               }
               else if (NKZ_mode == 2)
               {
                  price3 = price2 + NKZ * _Point * 0.1 * HiLow;  // Вычисляем высоту зоны, 10% во внутрь
                  price4 = price2;                               // Вычисляем высоту зоны, 10% во внутрь
               }
               else
               {
                  price3 = price2 + NKZ * _Point * 0.05 * HiLow; // Вычисляем высоту зоны, по 5% в обе стороны
                  price4 = price2 - NKZ * _Point * 0.05 * HiLow; // Вычисляем высоту зоны, по 5% в обе стороны
               }
               DrawZone("NKZ" + i + "_", "Нкз " + NKZd_list[i] + " - " + NKZ + "п.", time1, price1, time1 + NKZ_angle, price2, price3, price4, NKZ_length / 2, NKZd_color, NKZ_timeframe, zonaUpdateInfo);
            }
            return;
         }
      
         // НКЗ
         if (lparam == HotKey3 && !zonaUpdate || zonaUpdate == 3)
         {
            if (!zonaUpdateInfo) zonaUpdateInfo = Info[InfoKey].NKZ;
            double NKZ = zonaUpdateInfo;
            if (NKZ == 0)
            {
               Comment("Недельная зона не задана!");
               if (sound) PlaySound(sound_Error);
               return;
            }
            price2 = price1 - NKZ * _Point * HiLow;
            if (NKZ_mode == 1)
            {
               price3 = price2 - NKZ * _Point * 0.1 * HiLow;  // Вычисляем высоту зоны, 10% наружу
               price4 = price2;                               // Вычисляем высоту зоны, 10% наружу
            }
            else if (NKZ_mode == 2)
            {
               price3 = price2 + NKZ * _Point * 0.1 * HiLow;  // Вычисляем высоту зоны, 10% во внутрь
               price4 = price2;                               // Вычисляем высоту зоны, 10% во внутрь
            }
            else
            {
               price3 = price2 + NKZ * _Point * 0.05 * HiLow; // Вычисляем высоту зоны, по 5% в обе стороны
               price4 = price2 - NKZ * _Point * 0.05 * HiLow; // Вычисляем высоту зоны, по 5% в обе стороны
            }
            DrawZone("NKZ__", "Нкз - " + NKZ + "п.", time1, price1, time1 + NKZ_angle, price2, price3, price4, NKZ_length, NKZ_color, NKZ_timeframe, zonaUpdateInfo);
            return;
         }

         // Линия Ганна
         if (lparam == HotKey10)
         {
            datetime time2 = correctWeekend(time1, time1 + Gann_length);
            static datetime timegann;
            static int i = 0;
            name = "Gann_" + time1;
            if (timegann != time1) i = 0;
            timegann = time1;
            if (i == ArraySize(Gann_Scale))
            {
               i = 0;
               ObjectDelete(name);
            }
            else
            {
               HiLow *= -1;
               if (!Gann_change) name += Gann_Scale[i] * HiLow;
               ObjectDelete(name);
               ObjectCreate(0, name, OBJ_GANNLINE, 0, time1, price1, time2, 0);
               ObjectSetDouble(0, name, OBJPROP_SCALE, Gann_Scale[i] * HiLow);
               ObjectSetText(name, "   " + Gann_Scale[i] * HiLow);
               ObjectSet(name, OBJPROP_TIMEFRAMES, Gann_timeframe); // Таймфрейм для отображения
               ObjectSet(name, OBJPROP_WIDTH, Gann_width);          // Толщина
               ObjectSet(name, OBJPROP_STYLE, Gann_style);          // Стиль
               ObjectSet(name, OBJPROP_COLOR, Gann_color);          // Цвет
               i++;
            }
            if (sound) PlaySound(sound_Zona);
            return;
         }
         // Уровень коррекции
         if (lparam == HotKey11) DrawCorrect(time1, price1, HiLow);
      }

      // Банковский уровень 
      if (lparam == HotKey6 && ModeDkzNkz)
      {
         if (BankTime)
         {
            MqlDateTime date;
            TimeToStruct(time1, date);
            datetime BankTimeManual = datetime(date.year + "." + date.mon + "." + date.day + " " + TimeHour(BankTime) + ":" + TimeMinute(BankTime));
            if (B_manual)
            {
               int dW = TimeDayOfWeek(BankTimeManual);
               int ok = 0;
               for (int i = ArraySize(B_days) - 1; i >= 0; i--)
                  if (dW == B_days[i]) { ok = 1; break; }
               if (!ok)
               {
                  Comment("В этот день недели запрещено в настройках строить банковский уровень! Установите параметр B_manual = 0;");
                  if (sound) PlaySound(sound_Error);
                  return;
               }
            }
            if (TimeCurrent() >= BankTimeManual)
            {
               int shift, tm[] = {1, 5, 15 , 30, 0};
               for (int i = 0; i < ArraySize(tm); i++)
               {
                  shift = iBarShift(NULL, tm[i], BankTimeManual, true);
                  if (shift != -1)
                  {
                     DrawBank(BankTimeManual, iOpen(NULL, tm[i], shift), Info[InfoKey].bankPercent);
                     if (sound) PlaySound(sound_Blevel);
                     break;
                  }
               }
            }
            else
            {
               Comment("Еще не время рисовать банковский уровень!");
               if (sound) PlaySound(sound_Error);
            }
         }
         return;
      }
      
      // Удаление объектов (разные циклы в место одного, что бы удалять в порядке приоритета)
      if (lparam == HotKey4)
      {
         string name;
         int total = ObjectsTotal();
         
         // Удаление линии банковского уровня/Atr уровня/HiLow уровня
         for (int i = 0; i < total; i++)
         {
            if (
                  ObjectType(name = ObjectName(i)) == OBJ_TREND 
                  && 
                  (
                     StringSubstr(name, 0, 5) == "Bank_"
                     || StringSubstr(name, 0, 4) == "ATR_"
                     || StringSubstr(name, 0, 6) == "HiLow_"
                     || StringSubstr(name, 0, 7) == "Zigzag_"
                     || StringSubstr(name, 0, 7) == "Correct"
                  )
               )
            {
               int x, x1, x2, x3, y, y1, y2, y3;
               ChartTimePriceToXY(0, 0, ObjectGet(name, OBJPROP_TIME1), ObjectGet(name, OBJPROP_PRICE1), x1, y1);
               ChartTimePriceToXY(0, 0, ObjectGet(name, OBJPROP_TIME2), ObjectGet(name, OBJPROP_PRICE2), x2, y2);
               ChartTimePriceToXY(0, 0, time1, price1, x3, y3);
               if (x1 > x2) { x = x1; x1 = x2; x2 = x; }
               if (y1 > y2) { y = y1; y1 = y2; y2 = y; }
               int p = 8;
               if (x3 >= x1 - p && x3 <= x2 + p && y3 >= y1 - p && y3 <= y2 + p)
               {
                  ChartTimePriceToXY(0, 0, ObjectGet(name, OBJPROP_TIME1), ObjectGet(name, OBJPROP_PRICE1), x1, y1);
                  ChartTimePriceToXY(0, 0, ObjectGet(name, OBJPROP_TIME2), ObjectGet(name, OBJPROP_PRICE2), x2, y2);
                  double d = 2 * MathAbs(x2*(y1-y3)+x1*(y3-y2)+x3*(y2-y1))/2 / MathSqrt(MathPow(x2 - x1, 2) + MathPow(y2 - y1, 2));    
                  if (d <= p)
                  {
                     ObjectDelete(name);
                     if (StringSubstr(name, 0, 7) == "Correct")
                     {
                        ObjectDelete("Correct1");
                        ObjectDelete("Correct2");
                        
                     }
                     if (StringSubstr(name, 0, 7) == "Zigzag_")
                     {
                        int k;
                        if ((k = StringFind(name, "_", 7)) != -1) DeleteByPrefix(StringSubstr(name, 0, k));
                     }
                     if (StringSubstr(name, 0, 5) == "Bank_") DeleteByPrefix("BankZ_" + StringSubstr(name, 5, 24));
                     if (sound) PlaySound(sound_Zona);
                     return;
                  }
               }
            }
         }

         // Удаление зон Дкз, Нкз и зон банковского уровня и всех зон
         for (int i = 0; i < total; i++)
         {
            if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE)
            {   
               if (price1 <= ObjectGet(name, OBJPROP_PRICE1) && price1 >= ObjectGet(name, OBJPROP_PRICE2) && time1 >= ObjectGet(name, OBJPROP_TIME1) && time1 <= ObjectGet(name, OBJPROP_TIME2))
               {
                  // Удаление зон банковского уровня
                  if (StringSubstr(name, 0, 6) == "BankZ_")
                  {
                     DeleteByPrefix(StringSubstr(name, 0, 24));
                     if (sound) PlaySound(sound_Zona);
                     return;
                  }
                  // Удаление остальных зон
                  ObjectDelete(name);                      // Удал. зоны 
                  ObjectDelete(StringSubstr(name, 0, 24)); // Удал. линии зоны если есть
                  if (sound) PlaySound(sound_Zona);
                  return;
               }
            }
         }
         Comment("Не найден объект для удаления!");
         if (sound) PlaySound(sound_Error);
         return;
       }

      // Выравнивание трендовой линии
      if (lparam == HotKey5)
      {
         string name;
         for (int i = ObjectsTotal() - 1; i >= 0; i--)
         {
            name = ObjectName(i);
            if (ObjectGetInteger(0, name, OBJPROP_SELECTED))
            {
               if (ObjectType(name) == OBJ_TREND)
               { 
                  if (ObjectGet(name, OBJPROP_PRICE1) == ObjectGet(name, OBJPROP_PRICE2)) 
                     ObjectSetInteger(0, name, OBJPROP_SELECTED, 0);
                  else
                     ObjectSet(name, OBJPROP_PRICE2, ObjectGet(name, OBJPROP_PRICE1));
               }
               if (ObjectType(name) == OBJ_RECTANGLE)
               { 
                     ObjectSetInteger(0, name, OBJPROP_SELECTED, 0);
               }
            }
         }
      }      
      
      // ATR уровни
      if (lparam == HotKey7) DrawATR(time1);

      // HiLow уровни
      if (lparam == HotKey8) DrawHiLow(1);

      // Уровни закрытия Америки
      if (lparam == HotKey12) DrawAlevel();
      
      if (lparam == HotKey14) ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, bool(ChartGetInteger(0, CHART_SHOW_PERIOD_SEP) - 1));
      if (lparam == HotKey15) 
      {
         ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, bool(ChartGetInteger(0, CHART_SHOW_TRADE_LEVELS) - 1));
         EventSetTimer(30);
      }
   }
}

//+------------------------------------------------------------------+
//| Корректировка времени если есть выходные дни                     |
//+------------------------------------------------------------------+
datetime correctWeekend(datetime time1, datetime time2)
{
   datetime time = time1;
   int d3 = TimeDayOfYear(time2);
   for (int i = TimeDayOfYear(time1); i <= d3; i++)
   {
      if (TimeDayOfWeek(time) == 6 || TimeDayOfWeek(time) == 0) time2 += 86400 * 2; // Если попали на выходные, добавим еще два дня к длине зоны
      if (TimeDayOfWeek(time) == 6)
      {
         i++;
         time += 86400;
      }
      time += 86400;
   }
   return time2;
}

//+------------------------------------------------------------------+
//| Рисование текста около курсора мышки                             |
//+------------------------------------------------------------------+
void DrawMouseInfo()
{
   if(MouseY) ObjectSet("MouseInfo", OBJPROP_YDISTANCE, MouseY);
   if(MouseX) ObjectSet("MouseInfo", OBJPROP_XDISTANCE, MouseX + 13);
   if (ModeDkzNkz == 1 && GlobalVariableCheck("RM_" + WindowHandle(_Symbol, 0)))
      ObjectSetString(0, "MouseInfo", OBJPROP_TEXT, "DkzNkzMaker");
   else if (ModeZigzag == 1) 
      ObjectSetString(0, "MouseInfo", OBJPROP_TEXT, "/\\/\\/\\");
   else
      ObjectSetString(0, "MouseInfo", OBJPROP_TEXT, " ");
}

//+------------------------------------------------------------------+
//| Удаление объектов по префиксу                                    |
//+------------------------------------------------------------------+
int DeleteByPrefix(string o_prefix)
{
   string name;
   int result = 0;
   for (int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      name = ObjectName(i);
      if (StringFind(name, o_prefix, 0) == 0) 
      {
         ObjectDelete(name);   
         result = 1;
      }
   }
   return result;
}

//+------------------------------------------------------------------+
//| Рисование зоны                                                   |
//+------------------------------------------------------------------+
void DrawZone(string name, string descr, datetime time1, double price1, datetime time2, double price2, double price3, double price4, int length, int clr, int timeframe, double info)
{
   // Рисуем линию
   name += time1;
   ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
   ObjectSet(name, OBJPROP_TIME1, time1);
   ObjectSet(name, OBJPROP_PRICE1, price1);
   if (!ObjectGet(name, OBJPROP_TIME2))                  // Если time2 не задан у объекта, тогда задаем, т.к. это новый объект (для редктирования угла наклона)
      ObjectSet(name, OBJPROP_TIME2, time2);
   else   
      time2 = ObjectGet(name, OBJPROP_TIME2);            // Подкорректируем time2 взяв значение из линни (с отредактированным углом наклона) 
   ObjectSet(name, OBJPROP_PRICE2, price2);
   ObjectSet(name, OBJPROP_COLOR, clr);                  // Цвет
   ObjectSet(name, OBJPROP_TIMEFRAMES, timeframe);       // Таймфрейм для отображения
   ObjectSet(name, OBJPROP_BACK, true);                  // Рисовать объект в фоне
   ObjectSet(name, OBJPROP_SELECTED, false);             // Снять выделение с объекта
   ObjectSet(name, OBJPROP_RAY, false);                  // Рисовать не луч
   ObjectSet(name, OBJPROP_STYLE, 0);                    // Стиль
   ObjectSet(name, OBJPROP_WIDTH, 1);                    // Толщина
   
   // Рисуем зону
   if (price1 > price2) name += "_H"; else name += "_L";
   name += "_" + info;
   if (price3 < price4) { price1 = price3; price3 = price4; price4 = price1; }
   ObjectCreate(name, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
   ObjectSet(name, OBJPROP_TIME1, time2);
   ObjectSet(name, OBJPROP_PRICE1, price3);
   if (!ObjectGet(name, OBJPROP_TIME2)) 
      ObjectSet(name, OBJPROP_TIME2, correctWeekend(time2, time2 + length)); // Если time2 не задан у объекта, тогда задаем, т.к. это новый объект (иначе у зоны отредктирована длина)
   ObjectSet(name, OBJPROP_PRICE2, price4);
   ObjectSetText(name, descr);                           // Описание
   ObjectSet(name, OBJPROP_COLOR, clr);                  // Цвет
   ObjectSet(name, OBJPROP_TIMEFRAMES, timeframe);       // Таймфрейм для отображения
   ObjectSet(name, OBJPROP_SELECTED, false);             // Снять выделение с объекта
   ObjectSet(name, OBJPROP_BACK, true);                  // Рисовать объект в фоне

   string prefix = StringSubstr(name, 1, 3);
   if (sound && (prefix == "KZ_" || prefix == "KZ1")) PlaySound(sound_Zona);
   InitRect();
}

//+------------------------------------------------------------------+
//| Рисование банковского уровня                                     |
//+------------------------------------------------------------------+
void DrawBank(datetime time1, double price1, double percent)
{
   // Рисуем линию
   int newBank = 0;
   string descr = "Банк", name = "Bank_" + time1;          // Название Bank_ не менять, используется в обработчике событий
   datetime time2 = time1 +  B_length;
   if (!B_length)
   {
      MqlDateTime date;
      TimeToStruct(time1, date);
      time2 = datetime(date.year + "." + date.mon + "." + date.day + " 23:59");
   }
   time2 = correctWeekend(time1, time2);
   if (ObjectFind(name) == -1) 
   {
      if (sound) PlaySound(sound_Blevel);
      newBank = 1;
   }
   else
   {
      string pr = ObjectDescription(name);
      StringReplace(pr, descr, "");
      StringReplace(pr, ", ", ".");
      percent = double(pr);
   }
   ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
   ObjectSet(name, OBJPROP_TIME1, time1);
   if (!price1) price1 = ObjectGet(name, OBJPROP_PRICE1); // Если price1 не задан, вызов пришел после редактирования описания Б.уровня. Возьмем цену из линии
   ObjectSet(name, OBJPROP_PRICE1, price1);
   if (!ObjectGet(name, OBJPROP_TIME2))                   // Если time2 не задан у объекта, тогда задаем, т.к. это новый объект
      ObjectSet(name, OBJPROP_TIME2, time2);
   else   
      time2 = ObjectGet(name, OBJPROP_TIME2);             // Подкорректируем time2 взяв значение из Б.уровня (с отредактированной длинной)
   ObjectSet(name, OBJPROP_PRICE2, price1);
   ObjectSetText(name, descr + " " + percent + "%");    // Описание         
   ObjectSet(name, OBJPROP_TIMEFRAMES, B_timeframe);      // Таймфрейм для отображения
   ObjectSet(name, OBJPROP_COLOR, B_color);               // Цвет
   ObjectSet(name, OBJPROP_WIDTH, B_width);               // Толщина
   ObjectSet(name, OBJPROP_STYLE, B_style);               // Стиль   
   ObjectSet(name, OBJPROP_BACK, B_back);                 // Рисовать объект в фоне
   //ObjectSet(name, OBJPROP_SELECTED, false);            // Снять выделение с объекта
   ObjectSet(name, OBJPROP_RAY, false);                   // Рисовать не луч


   // Нарисуем зоны
   double priceZ1, priceZ2, indentZ, heightZ;
   int k;
   heightZ = price1 * percent / 100 / 10;
   for(int i = 1; i <= B_orderZ * 2; i++)
   {
      k = i;
      name = "BankZ_" + time1 + " " + i;
      if (i > B_orderZ) k = -(i - B_orderZ);
      priceZ1 = price1 + price1 * percent * k / 100;
      priceZ2 = priceZ1 - heightZ * k / MathAbs(k);
      if (priceZ1 < priceZ2) { double price = priceZ1; priceZ1 = priceZ2; priceZ2 = price; }
      descr = DoubleToString((percent * k), 2) + "%";
      if (newBank) ObjectCreate(name, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
      ObjectSet(name, OBJPROP_TIME1, time1);
      ObjectSet(name, OBJPROP_PRICE1, priceZ1);
      ObjectSet(name, OBJPROP_TIME2, time2);
      ObjectSet(name, OBJPROP_PRICE2, priceZ2);
      ObjectSetText(name, descr);                         // Описание
      ObjectSet(name, OBJPROP_COLOR, B_colorZ);           // Цвет
      ObjectSet(name, OBJPROP_TIMEFRAMES, B_timeframe);   // Таймфрейм для отображения
      ObjectSet(name, OBJPROP_SELECTED, false);           // Снять выделение с объекта
      ObjectSet(name, OBJPROP_BACK, true);                // Рисовать объект в фоне
   }
   InitRect();
 }
 
//+------------------------------------------------------------------+
//| Рисование ATR уровнеей                                           |
//+------------------------------------------------------------------+
void DrawATR(datetime time1 = 0)
{
   static int ATR = 0, day = 0, summ = 0;
   int update = 0;

   // Рассчет ATR
   if (day != TimeDay(TimeCurrent()) || !ATR) // Что бы не пересчитывать каждый раз
   {
      int finish;
      day = TimeDay(TimeCurrent());
      if (ATR_W1) finish = iBarShift(NULL, PERIOD_D1, iTime(NULL, PERIOD_W1, 0), false) + 1;
      else finish = 1;
      for (int i = ATR_hist - 1 + finish; i >= finish; i--)
         summ += (iHigh(NULL, PERIOD_D1, i) - iLow(NULL, PERIOD_D1, i)) / _Point;
      ATR = summ / ATR_hist;
   }
   if (!time1)
   {
      time1 = TimeCurrent();
      update = 1;
   }
   if (!update && sound) PlaySound(sound_Zona);
   MqlDateTime date;
   TimeToStruct(time1, date);
   time1 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   TimeToStruct(time1 + 86400, date);
   datetime time2 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   
   int shift = iBarShift(NULL, PERIOD_D1, time1, false);
   double price1 = iLow(NULL, PERIOD_D1, shift) + ATR * _Point;
   double price2 = iHigh(NULL, PERIOD_D1, shift) - ATR * _Point;
   
   // Рисуем линию
   string descr;
   int clr;
   for (int i = 1; i <= 2; i++)
   {
      descr = "ATR от Low " + ATR + "п.";
      clr = ATR_colorL;
      if (i == 2)
      {
         price1 = price2;
         descr = "ATR от Hi " + ATR + "п.";
         clr = ATR_colorH;
      }
      string name = "ATR_" + time1 + " " + i;                  // Название ATR_ не менять, используется в обработчике событий
      
      if (!update && ObjectFind(name) != -1)
      { 
         ObjectDelete("ATR_" + time1 + " 1");
         ObjectDelete("ATR_" + time1 + " 2");
         return;
      }
      if (!update) ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(name, OBJPROP_TIME1, time1);
      ObjectSet(name, OBJPROP_PRICE1, price1);
      ObjectSet(name, OBJPROP_TIME2, time2);
      ObjectSet(name, OBJPROP_PRICE2, price1);
      ObjectSetText(name, descr);                              // Описание         
      ObjectSet(name, OBJPROP_TIMEFRAMES, ATR_timeframe);      // Таймфрейм для отображения
      ObjectSet(name, OBJPROP_WIDTH, ATR_width);               // Толщина
      ObjectSet(name, OBJPROP_STYLE, ATR_style);               // Стиль
      ObjectSet(name, OBJPROP_COLOR, clr);                     // Цвет
      ObjectSet(name, OBJPROP_BACK, ATR_back);                 // Рисовать объект в фоне
      ObjectSet(name, OBJPROP_SELECTED, false);                // Снять выделение с объекта
      ObjectSet(name, OBJPROP_SELECTABLE, false);              // Запрет на редактирование
      ObjectSet(name, OBJPROP_RAY, false);                     // Рисовать не луч
   }
   TimeToStruct(TimeCurrent(), date);
   time1 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   if (ObjectFind("ATR_" + time1 + " 1") != -1 || ObjectFind("ATR_" + time1 + " 2") != -1) AtrFL = 1; else AtrFL = 0;
}

//+------------------------------------------------------------------+
//| Рисование Hi Low уровнеей                                        |
//+------------------------------------------------------------------+
void DrawHiLow(datetime time1 = 0)
{
   int update = 0;
   if (!time1) update = 1;
   
   if (!update)
   {
      if (sound) PlaySound(sound_Zona);
      if (DeleteByPrefix("HiLow_"))  // Зашли по клавише и удаляем объекты
      {
         HiLowFL = 0;
         return; 
      }
   }
   static datetime timeOld;
   time1 = TimeCurrent();
   datetime time2 = time1 + 86400;
   MqlDateTime date;
   TimeToStruct(time1, date);
   time1 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   TimeToStruct(time2, date);
   time2 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   timeOld = time1 ;
   double price1, price2;
   int shift, clr;
   for (int j = 0; j < HiLow_count; j++)
   {
      shift = iBarShift(NULL, PERIOD_D1, time1, true);
      if (shift != -1)
      {
         price1 = iLow(NULL, PERIOD_D1, shift);
         price2 = iHigh(NULL, PERIOD_D1, shift);
         clr = HiLow_color;
         if (TimeDayOfWeek(time1) == 5) clr = HiLow_colorF;
         // Рисуем линии
         for (int i = 1; i <= 2; i++)
         {
            if (i == 2) price1 = price2;
            string name = "HiLow_" + time1 + " " + i;             // Название HiLow_ не менять, используется в обработчике событий      
            if (!update) ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSet(name, OBJPROP_TIME1, time1);
            ObjectSet(name, OBJPROP_PRICE1, price1);
            ObjectSet(name, OBJPROP_TIME2, time2);
            ObjectSet(name, OBJPROP_PRICE2, price1);
            ObjectSet(name, OBJPROP_TIMEFRAMES, HiLow_timeframe); // Таймфрейм для отображения
            ObjectSet(name, OBJPROP_WIDTH, HiLow_width);          // Толщина
            ObjectSet(name, OBJPROP_STYLE, HiLow_style);          // Стиль
            ObjectSet(name, OBJPROP_COLOR, clr);                  // Цвет
            ObjectSet(name, OBJPROP_BACK, HiLow_back);            // Рисовать объект в фоне
            ObjectSet(name, OBJPROP_SELECTED, false);             // Снять выделение с объекта
            //ObjectSet(name, OBJPROP_SELECTABLE, false);         // Запрет на редактирование
            ObjectSet(name, OBJPROP_RAY, false);                  // Рисовать не луч
         }
      }
      if (update) break;
      time2 = time1;
      time1 -= 86400;
   }
   TimeToStruct(TimeCurrent(), date);
   time1 = datetime(date.year + "." + date.mon + "." + date.day + " 00:00");
   if (ObjectFind("HiLow_" + time1 + " 1") != -1 || ObjectFind("HiLow_" + time1 + " 2") != -1) HiLowFL = 1; else HiLowFL  = 0;
}

//+------------------------------------------------------------------+
//| Рисование коррекционного уровня                                  |
//+------------------------------------------------------------------+
void DrawCorrect(datetime time1 = 0, double price1 = 0, int HiLow = 0)
{  
   static int CorrectAlert, CorrectAlertTime;
   double price2, price3;
   datetime time2;
   string name = "Correct1";
   string name1 = "Correct2";
   int update = 0;

   if (!time1)
   {
      update = 1;
      time1 = ObjectGet(name, OBJPROP_TIME1);
      price1 = ObjectGet(name, OBJPROP_PRICE1);
      if  (price1 > ObjectGet(name, OBJPROP_PRICE2)) HiLow = 1; else HiLow = -1;
      if (!price1)
      {
         CorrectFL = 0; // Нет уровня на графике, а значит нет смысла каждый тик заходить в эту функцию
         return;
      } 
   }
   if (update || time1 != ObjectGet(name, OBJPROP_TIME1)) 
   {
      int shift = iBarShift(NULL, 0, time1, false);
      if (HiLow  == 1)
      {
         int shift = iLowest(NULL, 0, MODE_LOW, shift, 0);
         price2 = iLow(NULL, 0, shift);
         time2 = iTime(NULL, 0, shift);
         price3 = price1 - (price1 - price2) / 2;
      }
      else
      {
         shift = iHighest(NULL, 0, MODE_HIGH, shift, 0);
         price2 = iHigh(NULL, 0, shift);
         time2 = iTime(NULL, 0, shift);
         price3 = price1 + (price2 - price1) / 2;
      }
      price3 = price3;

      if (update)
         price1 = ObjectGet(name, OBJPROP_PRICE1);
      else
         CorrectAlert = CorrectAlertTime = 0; // Только что нарисовали, обнулим счетчик
      ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(name, OBJPROP_TIME1, time1);
      ObjectSet(name, OBJPROP_PRICE1, price1);
      ObjectSet(name, OBJPROP_TIME2, time2);
      ObjectSet(name, OBJPROP_PRICE2, price2);
      ObjectSet(name, OBJPROP_RAY, false);                  // Рисовать не луч
      ObjectSet(name, OBJPROP_COLOR, Correct_color1);       // Цвет
      ObjectSet(name, OBJPROP_STYLE, Correct_style1);       // Стиль
      ObjectSet(name, OBJPROP_WIDTH, Correct_width1);       // Толщина
      ObjectSet(name, OBJPROP_BACK, Correct_back1);         // Рисовать объект в фоне
      
      ObjectCreate(name1, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(name1, OBJPROP_TIME1, time1);
      ObjectSet(name1, OBJPROP_PRICE1, price3);
      ObjectSet(name1, OBJPROP_TIME2, correctWeekend(TimeCurrent(), TimeCurrent() + Correct_length)); // Если time2 не задан у объекта, тогда задаем, т.к. это новый объект (иначе у зоны отредктирована длина)
      ObjectSet(name1, OBJPROP_PRICE2, price3);
      ObjectSetText(name1, "50%");                           // Описание
      ObjectSet(name1, OBJPROP_RAY, false);                  // Рисовать не луч
      ObjectSet(name1, OBJPROP_COLOR, Correct_color2);       // Цвет
      ObjectSet(name1, OBJPROP_STYLE, Correct_style2);       // Стиль
      ObjectSet(name1, OBJPROP_WIDTH, Correct_width2);       // Толщина
      ObjectSet(name1, OBJPROP_BACK, Correct_back2);         // Рисовать объект в фоне
      CorrectFL = 1;
   }
   else
   {
      ObjectDelete(name);
      ObjectDelete(name1);
      CorrectFL = 0;
   }
   if (CorrectFL && (HiLow == 1 && Bid >= price3) || (HiLow == -1 && Bid <= price3))
   {
      if (!CorrectAlert && TimeCurrent() - CorrectAlertTime >= Correct_time)
      {
         Alert("50%>>>  " + _Symbol);
         CorrectAlert = 1;
         CorrectAlertTime = TimeCurrent();
         PlaySound(sound_Correct);
         return;
      }
   }
   else
      CorrectAlert = 0;
   if (!update && sound) PlaySound(sound_Zona);
}

//+------------------------------------------------------------------+
//| Рисование уровнеей закрытия Америки                              |
//+------------------------------------------------------------------+
void DrawAlevel()
{
   if (sound) PlaySound(sound_Zona);
   int fl = 0;
   if (DeleteByPrefix("Alevel1_"))
   {
      fl = 1;
      if (DeleteByPrefix("Alevel2_")) return;
   }
   datetime time1 = TimeCurrent(), time2, time3;
   MqlDateTime date;
   TimeToStruct(time1, date);
   time1 = datetime(date.year + "." + date.mon + "." + date.day + " "+ A_time);
   time2 = time1 + A_length1;
   double price1, price3;
   string name;
   int shift;
   for (int j = 0; j < A_count; j++)
   {
      shift = iBarShift(NULL, 0, time1, true);
      if (shift != -1)
      {
         price1 = iClose(NULL, 0, shift);
         // Подкорректируем цену с младшего таймфрэйма
         int shift, tm[] = {1, 5, 15 , 30, 60, 240, 14400, 10080, 43200};
         for (int i = 0; i < ArraySize(tm); i++)
         {
            shift = iBarShift(NULL, tm[i], time1, true);
            if (shift != -1)
            {
               price1 = iClose(NULL, tm[i], shift);
               break;
            }
         }
         if (price1)
         {
            name = "Alevel1_" + time1;
            time2 = correctWeekend(time1, time2);
            ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSet(name, OBJPROP_TIME1, time1);
            ObjectSet(name, OBJPROP_PRICE1, price1);
            ObjectSet(name, OBJPROP_TIME2, time2);
            ObjectSet(name, OBJPROP_PRICE2, price1);
            ObjectSet(name, OBJPROP_TIMEFRAMES, A_timeframe); // Таймфрейм для отображения
            ObjectSet(name, OBJPROP_WIDTH, A_width1);         // Толщина
            ObjectSet(name, OBJPROP_STYLE, A_style1);         // Стиль
            ObjectSet(name, OBJPROP_COLOR, A_color1);         // Цвет
            ObjectSet(name, OBJPROP_BACK, true);              // Рисовать объект в фоне
            ObjectSet(name, OBJPROP_SELECTED, false);         // Снять выделение с объекта
            //ObjectSet(name, OBJPROP_SELECTABLE, false);     // Запрет на редактирование
            ObjectSet(name, OBJPROP_RAY, false);              // Рисовать не луч
            if (time3 && fl)
            {
               name = "Alevel2_" + time1;
               ObjectCreate(name, OBJ_TREND, 0, 0, 0, 0, 0);
               ObjectSet(name, OBJPROP_TIME1, time1);
               ObjectSet(name, OBJPROP_PRICE1, price1);
               ObjectSet(name, OBJPROP_TIME2, time3);
               ObjectSet(name, OBJPROP_PRICE2, price3);
               ObjectSet(name, OBJPROP_TIMEFRAMES, A_timeframe); // Таймфрейм для отображения
               ObjectSet(name, OBJPROP_WIDTH, A_width2);         // Толщина
               ObjectSet(name, OBJPROP_STYLE, A_style2);         // Стиль
               ObjectSet(name, OBJPROP_COLOR, A_color2);         // Цвет
               ObjectSet(name, OBJPROP_BACK, true);              // Рисовать объект в фоне
               ObjectSet(name, OBJPROP_SELECTED, false);         // Снять выделение с объекта
               //ObjectSet(name, OBJPROP_SELECTABLE, false);     // Запрет на редактирование
               ObjectSet(name, OBJPROP_RAY, false);              // Рисовать не луч
            }
            time3 = time1;
            price3 = price1;
         }
      }
      time2 = time1;
      time1 -= 86400;
   }
}

//+------------------------------------------------------------------+
//| Корректирует координаты цены и времени если нужно для зон        |
//+------------------------------------------------------------------+
void CorrectRect(string name)
{
   datetime time;
   double price;
   if (ObjectGet(name, OBJPROP_TIME1) > ObjectGet(name, OBJPROP_TIME2))
   {
      time = ObjectGet(name, OBJPROP_TIME1);
      ObjectSet(name, OBJPROP_TIME1, ObjectGet(name, OBJPROP_TIME2));
      ObjectSet(name, OBJPROP_TIME2, time);
   }
   if (ObjectGet(name, OBJPROP_PRICE1) < ObjectGet(name, OBJPROP_PRICE2))
   {
      price = ObjectGet(name, OBJPROP_PRICE1);
      ObjectSet(name, OBJPROP_PRICE1, ObjectGet(name, OBJPROP_PRICE2));
      ObjectSet(name, OBJPROP_PRICE2, price);
   }
}

//+------------------------------------------------------------------+
//| Ищет зоны в диапазоне цены                                       |
//+------------------------------------------------------------------+
void InitRect(string nameP = "")
{
   RectFL = 0;
   if (!ZonaAlert) return;
   string name;

   if (nameP == "ALL_OBJECTS_RECT_CORRECT")
   {
      for (int i = ObjectsTotal() - 1; i >= 0; i--)
         if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE) CorrectRect(name);
   }
   else if (nameP != "")
   {
      if (ObjectType(nameP) == OBJ_RECTANGLE) CorrectRect(nameP);
   }

   ArrayResize(ListRect, 0);
   for (int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      if (ObjectType(name = ObjectName(i)) == OBJ_RECTANGLE)
      {
         if (ObjectGet(name, OBJPROP_TIME1) <= TimeCurrent() && ObjectGet(name, OBJPROP_TIME2) >= TimeCurrent())
         {
            ArrayResize(ListRect, ArraySize(ListRect) + 1); 
            ListRect[ArraySize(ListRect) - 1].name = name;
            ListRect[ArraySize(ListRect) - 1].time = ObjectGet("LR_" + name, OBJPROP_TIME1);
            RectFL = 1;
         }
      }
   }
   //string t; for (int i = 0; i < ArraySize(ListRectName); i++) t += " " + ListRectName[i]; Alert(t);
}

//+------------------------------------------------------------------+
//| Сигнализирует о том что цена зашла в зону                        |
//+------------------------------------------------------------------+
void AlertRect()
{
   string name;
   string sss = "";
   double price_L, price_H, hight;
   int shift;
   for (int i = ArraySize(ListRect) - 1; i >= 0; i--)
   {
      name = ListRect[i].name;
/*
         if (ListRect[i].time)
         {
            int shift = iBarShift(NULL, 0, ListRect[i].time, false);
            if (shift)
            {
               price_L = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, shift, 0));
               price_H = iHigh(NULL, 0, iHighest(NULL, 0, MODE_HIGH, shift, 0));
            }
            else
            {
               price_H = ObjectGet(name, OBJPROP_PRICE1);
               price_L = ObjectGet(name, OBJPROP_PRICE2);
            }
            
            hight = ObjectGet(name, OBJPROP_PRICE1) - ObjectGet(name, OBJPROP_PRICE2);
             
            /////////////////
            string k;
            if (price_H - ObjectGet(name, OBJPROP_PRICE1) >= hight || ObjectGet(name, OBJPROP_PRICE2) - price_L >= hight) 
            k = "";
            else
            k = "\r\n ||||||||||||||||||||||| ЗАПРЕЩЕН! |||||||||||||||||||||||";
            
            sss +=
            "\r\n-----------------------------------------------------------------------------------" +
            + k +
            "\r\n name: " + name +
            "\r\n time: " + ListRect[i].time +
            "\r\n shift: " + shift +
            "\r\n price_L: " + price_L +
            "\r\n price_H: " + price_H +
            "\r\n hight: " + DoubleToStr(hight * 100000, 0) +
            "\r\n hightH: " + DoubleToStr((price_H - ObjectGet(name, OBJPROP_PRICE1)) * 100000, 0) +
            "\r\n hightH: " + DoubleToStr((ObjectGet(name, OBJPROP_PRICE2) - price_L) * 100000, 0);
         }
         else
         {
            sss +=
            "\r\n-----------------------------------------------------------------------------------" +
            "\r\n name: " + name;
         }
*/        
      if (ObjectGet(name, OBJPROP_PRICE1) >= Bid && ObjectGet(name, OBJPROP_PRICE2) <= Bid)
      {
         if (ListRect[i].time)
         {
            int shift = iBarShift(NULL, 0, ListRect[i].time, false);
            if (shift)
            {
               price_L = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, shift, 0));
               price_H = iHigh(NULL, 0, iHighest(NULL, 0, MODE_HIGH, shift, 0));
            }
            else
            continue;
            hight = ObjectGet(name, OBJPROP_PRICE1) - ObjectGet(name, OBJPROP_PRICE2);
         }
         if (!ListRect[i].time || price_H - ObjectGet(name, OBJPROP_PRICE1) >= hight || ObjectGet(name, OBJPROP_PRICE2) - price_L >= hight)
         {
            ListRect[i].time = TimeCurrent();
            
            string descr = ObjectDescription(name);
            if(descr == "") descr = name;
            Alert("Заход " + _Symbol + " в зону  " + descr);
            PlaySound(sound_Correct);
            name = "LR_" + name;
            ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
            ObjectSet(name, OBJPROP_TIME1, ListRect[i].time);
            ObjectSet(name, OBJPROP_TIMEFRAMES , EMPTY);            
            ObjectSet(name, OBJPROP_HIDDEN, true);
         }
      }
   }
   //Comment(sss);
}