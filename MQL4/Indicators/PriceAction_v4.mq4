#property copyright "Scriptong"
#property link "http://autograf.dp.ua"

#property indicator_chart_window                   // Отображение в окне графика цен
#property indicator_buffers 1                      // Состоит из шести буферов
#property indicator_color1 Black                   // Цвет 1-го буфера

extern string A1 = "======= Общие настройки для подписи паттернов =========";
extern string A1_1 = "Отображать ли текстовую надпись";
extern bool   showPatternDescription = false;
extern string A2 = "Размер текста надписи";
extern int    textSize = 7;
extern string A3 = "Цвет текста надписи";
extern color  textColor = White;
extern string A4 = "Имя шрифта надписи";
extern string fontName = "Tahoma";
extern string A5 = "=======================================================";
extern string A6 = "======= Паттерн Внутренний бар =========";
extern string A7 = "Включение/выключение поиска паттерна";
extern bool   showIBpattern = false;
extern string A8 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertIBpattern = false;
extern string soundIBpattern = "AG_SoundLevel_1.wav";
extern string A9 = "Цвет паттерна IB";
extern color  colorIB = DarkOrchid;
extern string A10 = "=======================================================";
extern string A11 = "======= Паттерны DBHLC и DBLHC =========";
extern string A12 = "Включение/выключение поиска паттерна";
extern bool   showDBpattern = false;
extern string A13 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertDBpattern = false;
extern string soundDBpattern = "AG_SoundLevel_2.wav";
extern string A14 = "Пределы в пунктах, считающихся равными";
extern int    equalPipsDB = 3;
extern string A15 = "Цвета бычьего и медвежьего паттернов DB";
extern color  colorDBLHC = Blue;
extern color  colorDBHLC = Red;
extern string A16 = "=======================================================";
extern string A17 = "======= Паттерны TBH И TBL =========";
extern string A18 = "Включение/выключение поиска паттерна";
extern bool   showTBpattern = false;
extern string A19 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertTBpattern = false;
extern string soundTBpattern = "AG_SoundLevel_3.wav";
extern string A20 = "Пределы в пунктах, считающихся равными";
extern int    equalPipsTB = 3;
extern string A21 = "Цвета бычьего и медвежьего паттернов TB";
extern color  colorTBL = Goldenrod;
extern color  colorTBH = Goldenrod;
extern string A22 = "=======================================================";
extern string A23 = "======= Паттерн Рельсы ==============";
extern string A24 = "Включение/выключение поиска паттерна";
extern bool   showRAILSpattern = false;
extern string A25 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertRAILSpattern = false;
extern string soundRAILSpattern = "AG_SoundLevel_4.wav";
extern string A26 = "Максимальное превосходство тел одной из свечей, в %";
extern double bodyGreatPercents = 10;
extern string A27 = "Минимальная доля тела свечи в общей высоте свечи, в %";
extern double bodyToHeightPercents = 20;
extern string A28 = "Цвета бычьего и медвежьего паттернов Рельсы";
extern color  colorBullsRails = DodgerBlue;
extern color  colorBearsRails = FireBrick;
extern string A29 = "=======================================================";
extern string A30 = "======= Паттерны BUOVB и BEOVB ==============";
extern string A31 = "Включение/выключение поиска паттерна";
extern bool   showOVBpattern = false;
extern string A32 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertOVBpattern = false;
extern string soundOVBpattern = "AG_SoundLevel_5.wav";
extern string A33 = "Цвета паттернов BUOVB и BEOVB";
extern color  colorBUOVB = RoyalBlue;
extern color  colorBEOVB = Crimson;
extern string A34 = "=======================================================";
extern string A35 = "======= Паттерн PPR ==============";
extern string A36 = "Включение/выключение поиска паттерна";
extern bool   showPPRpattern = false;
extern string A37 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertPPRpattern = false;
extern string soundPPRpattern = "AG_SoundLevel_6.wav";
extern string A38 = "Цвета бычьего и медвежьего паттернов PPR";
extern color  colorBullsPPR = DeepSkyBlue;
extern color  colorBearsPPR = MediumVioletRed;
extern string A39 = "=======================================================";
extern string A40 = "======= Паттерн HR ==============";
extern string A41 = "Включение/выключение поиска паттерна";
extern bool   showHRpattern = false;
extern string A42 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertHRpattern = false;
extern string soundHRpattern = "AG_SoundLevel_7.wav";
extern string A43 = "Близость цен закрытия и открытия к мин и макс, в пунктах";
extern int    openCloseToHighLowPointsHR = 3;
extern string A44 = "Цвета бычьего и медвежьего паттернов HR";
extern color  colorBullsHR = MediumTurquoise;
extern color  colorBearsHR = Maroon;
extern string A45 = "=======================================================";
extern string A46 = "======= Паттерн CPR ==============";
extern string A47 = "Включение/выключение поиска паттерна";
extern bool   showCPRpattern = false;
extern string A48 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertCPRpattern = false;
extern string soundCPRpattern = "AG_TimeNews.wav";
extern string A49 = "Близость цен закрытия и открытия к мин и макс, в пунктах";
extern int    openCloseToHighLowPoints = 3;
extern string A50 = "Минимальная величина гепа, в пунктах";
extern int    gapPoints = 2;
extern string A51 = "Цвета бычьего и медвежьего паттернов CPR";
extern color  colorBullsCPR = SkyBlue;
extern color  colorBearsCPR = IndianRed;
extern string A52 = "=======================================================";
extern string A53 = "======= Паттерн Pin Bar ==============";
extern string A54 = "Включение/выключение поиска паттерна";
extern bool   showPINBARpattern = false;
extern string A55 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertPINBARpattern = false;
extern string soundPINBARpattern = "AG_Sound.wav";
extern string A56 = "Близость цены закрытия к мин или макс, в пунктах";
extern int    closeToHighLowPoints = 3;
extern string A57 = "Минимальное отношение тени (носа) к телу свечи";
extern double shadowToBodyKoef = 3.0;
extern string A58 = "Минимальная часть носа, выступающая за предыдущий бар, в %";
extern double noseOutsidePercent = 75.0;
extern string A59 = "Цвета бычьего и медвежьего паттернов Pin Bar";
extern color  colorBullsPINBAR = CadetBlue;
extern color  colorBearsPINBAR = Tomato;
extern string A60 = "=======================================================";
extern string A61 = "======= Паттерн MCM ==============";
extern string A62 = "Включение/выключение поиска паттерна";
extern bool   showMCMpattern = false;
extern string A63 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertMCMpattern = false;
extern string soundMCMpattern = "AG_Transform.wav";
extern string A64 = "Близость цен закрытия и открытия первой свечи к мин или макс, в пунктах";
extern int    openCloseToHighLowPointsMCM = 3;
extern string A65 = "Максимальное отношение высоты сигнальной свечи к первой, в %";
extern double signalToFirstPercents = 35.0;
extern string A66 = "Цвета бычьего и медвежьего паттернов MCM";
extern color  colorBullsMCM = PaleTurquoise;
extern color  colorBearsMCM = Plum;
extern string A68 = "=======================================================";
extern string A69 = "======= Паттерн Island Reversal ==============";
extern string A70 = "Включение/выключение поиска паттерна";
extern bool   showIRpattern = false;
extern string A71 = "Включение/выключение звукового сигнала при нахождении паттерна";
extern bool   alertIRpattern = false;
extern string soundIRpattern = "AG_Tuning.wav";
extern string A72 = "Величина первого (слева по графику) гепа в пунктах";
extern int    firstGap = 1;
extern string A73 = "Величина второго (справа по графику) гепа в пунктах";
extern int    secondGap = 1;
extern string A74 = "Цвета бычьего и медвежьего паттернов Island Reversal";
extern color  colorBullsIR = LightSeaGreen;
extern color  colorBearsIR = PaleVioletRed;
extern string A75 = "=======================================================";
extern string Z1 = "Количество баров отображения индикатора. Все - 0";
extern int    indBarsCount = 500;


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

#define PREFIX          "PRIACT_"                  // Префикс имен графических объектов

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

#define BULL_BAR        1                          // Идентификатор бычьих баров
#define BEAR_BAR        -1                         // Идентификатор медвежьих баров

#define FIRST_PART      "_1_"                      // Части имен объектов для..
#define SECOND_PART     "_2_"                      // ..установления различия объектов,..
#define THIRD_PART      "_3_"                      // ..относящихся к одному паттерну

#define DBHLC_DESCRIPTION "DBHLC"                  // Текстовое описание паттерна DBHLC
#define DBLHC_DESCRIPTION "DBLHC"                  // Текстовое описание паттерна DBLHC

#define TBH_DESCRIPTION "TBH"                      // Текстовое описание паттерна TBH
#define TBL_DESCRIPTION "TBL"                      // Текстовое описание паттерна TBL

#define RAILS_DESCRIPTION "Rails"                  // Текстовое описание паттерна Рельсы

#define CPR_DESCRIPTION "CPR"                      // Текстовое описание паттерна CPR

#define HR_DESCRIPTION "HR"                        // Текстовое описание паттерна HR

#define BUOVB_DESCRIPTION "BUOVB"                  // Текстовое описание паттерна BUOVB
#define BEOVB_DESCRIPTION "BEOVB"                  // Текстовое описание паттерна BEOVB

#define PPR_DESCRIPTION "PPR"                      // Текстовое описание паттерна PPR

#define PINBAR_DESCRIPTION "Pin Bar"               // Текстовое описание паттерна Pin Bar

#define MCM_DESCRIPTION "MCM"                      // Текстовое описание паттерна MCM

#define IR_DESCRIPTION "IR"                        // Текстовое описание паттерна IR

//+-------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                            |
//+-------------------------------------------------------------------------------------+
int init()
{
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                          |
//+-------------------------------------------------------------------------------------+
int deinit()
{
   DeleteAllObjects();
   return(0);
}
//+-------------------------------------------------------------------------------------+
//| Удаление всех объектов, созданных индикатором                                       |
//+-------------------------------------------------------------------------------------+
void DeleteAllObjects()
{
   for (int i = ObjectsTotal()-1; i >= 0; i--)     
      if (StringSubstr(ObjectName(i), 0, StringLen(PREFIX)) == PREFIX)
         ObjectDelete(ObjectName(i));
}
//+-------------------------------------------------------------------------------------+
//| Определение индекса бара, с которого необходимо производить перерасчет              |
//+-------------------------------------------------------------------------------------+
int GetRecalcIndex(int& total)
{
   int counted_bars = IndicatorCounted();          // Сколько баров уже посчитано
   total = Bars - 1;                               // Определение первого бара истории
   if (indBarsCount > 0 && indBarsCount < total)   // Если не нужно рассчитывать всю..
      total = indBarsCount;                        // ..историю, то начнем с указанного..
                                                   // ..бара - indBarsCount
   if (counted_bars == 0)                          // Кол-во посчитанных баров - 0. 
   {
      DeleteAllObjects();                          // Не забудем удалить все созданные..
                                                   // ..объекты
      return(total);                               // Нужно пересчитать всю историю
   }
   return(Bars - counted_bars - 1);                // Начинаем с первого непосчитанного..
                                                   // ..бара
}
//+-------------------------------------------------------------------------------------+
//| Подача звукового сигнала об образовании паттерна                                    |
//+-------------------------------------------------------------------------------------+
void PatternAlert(bool doAlert, int index, datetime& lastAlert, string soundFileName)
{
   if (!doAlert)                                   // Звуковое оповещение не требуется
      return;
   if (index != 1)                                 // Оповещение только для крайнего..
      return;                                      // ..правого по графику паттерна
   if (lastAlert >= Time[0])                       // На текущем баре оповещение уже..
      return;                                      // ..производилось
      
   PlaySound(soundFileName);                       // Воспроизведение звука
   lastAlert = Time[0];                            // Запомним, что оповещение..
                                                   // ..произведено
}
//+-------------------------------------------------------------------------------------+
//| Отображение графического объекта - прямоугольника                                   |
//+-------------------------------------------------------------------------------------+
void ShowRectangle(string name, datetime time1, double price1, datetime time2, 
                   double price2, string description, color clr)
{
   if (ObjectFind(name) < 0)                       // Если объект не существует
   {
      ObjectCreate(name, OBJ_RECTANGLE,            // Создадим его
                   0, time1, price1, time2, price2); 
      ObjectSet(name, OBJPROP_COLOR, clr);         // Установим цвет,..
      ObjectSet(name, OBJPROP_BACK, true);         // ..положение относительно другой..
                                                   // ..графики..
      ObjectSetText(name, "Pattern " + description, 0);// ..и описание
      return;
   }
   
   ObjectMove(name, 0, time1, price1);             // Перемещение существующего объекта
   ObjectMove(name, 1, time2, price2);             // Перемещение существующего объекта
}
//+-------------------------------------------------------------------------------------+
//| Отображение графического объекта - текстовой надписи                                |
//+-------------------------------------------------------------------------------------+
void ShowText(string name, datetime time1, double price1, string description)
{
   if (ObjectFind(name) < 0)                       // Если объект не существует
   {
      ObjectCreate(name, OBJ_TEXT, 0, time1, price1);// Создадим его и..
      ObjectSetText(name, description, textSize,   // ..выведем надпись
                    fontName, textColor);
      return;                            
   }
   
   ObjectMove(name, 0, time1, price1);             // Перемещение существующего объекта
}
//+-------------------------------------------------------------------------------------+
//| Отображение паттерна, состоящего из прямоугольника и текстовой надписи              |
//+-------------------------------------------------------------------------------------+
void ShowTypicalPattern(int startIndex, int endIndex, color clr, string patternType, 
                        string description)
{
// - 1 - == Поиск верхней и нижней границ паттерна ======================================
   double lowPrice = Low[iLowest(NULL, 0, MODE_LOW,// Нижняя граница паттерна
                         startIndex - endIndex + 1, endIndex)];
   double highPrice = High[iHighest(NULL, 0,       // Верхняя граница паттерна
                           MODE_HIGH, startIndex - endIndex + 1, endIndex)];
// - 1 - == Окончание блока =============================================================

// - 2 - == Отображение прямоугольника ==================================================
   datetime leftTime = Time[startIndex];           // Начальное время паттерна
   datetime rightTime  = Time[endIndex];           // Конечное время паттерна
   string name = PREFIX + patternType +            // Имя объекта паттерна
                 FIRST_PART + rightTime;           
   ShowRectangle(name, leftTime, lowPrice,         // Отображение объекта
                 rightTime, highPrice, description, clr);
// - 2 - == Окончание блока =============================================================

// - 3 - == Подпись паттерна ============================================================
   if (!showPatternDescription)                    // Если текстовую надпись отображать..
      return;                                      // ..не следует, то уходим
   name = PREFIX + patternType + SECOND_PART +     // Имя объекта паттерна
          rightTime;
   ShowText(name, Time[(startIndex + endIndex)/2], // Отображение объекта
            lowPrice, description);
// - 3 - == Окончание блока =============================================================
}           
//+-------------------------------------------------------------------------------------+
//| Удаление объекта                                                                    |
//+-------------------------------------------------------------------------------------+
void DeleteObject(string name)
{
   if (ObjectFind(name) == 0)
      ObjectDelete(name);
}
//+-------------------------------------------------------------------------------------+
//| Определение типа паттерна, находящего на указанном баре                             |
//+-------------------------------------------------------------------------------------+
string GetTypeOfExistsPattern(datetime time)
{
   int total = ArraySize(typesOfPatterns);         // Количество типов паттернов
   for (int i = 0; i < total; i++)                 // Проверка всех типов паттернов
   {
      string name = PREFIX + typesOfPatterns[i] +  // Достаточно найти хотя бы первую..
                    FIRST_PART + time;             // ..часть паттерна - прямоугольник
      if (ObjectFind(name) == 0)                   // Надпись (вторая часть), скорее..
         return(typesOfPatterns[i]);               // ..всего, тоже существует
   }
   return("");                                     // Ни один из паттернов не найден
}
//+-------------------------------------------------------------------------------------+
//| Удаление любого паттерна, отображаемого индикатором, в указанном диапазоне          |
//+-------------------------------------------------------------------------------------+
void DeleteAnyPattern(int index, int patternStart)
{
   for (int i = index; i < patternStart; i++)
   {
      datetime time = Time[i];
      string type = GetTypeOfExistsPattern(time);     
      if (type == "")                              // Ни один паттерна не найден
         continue;
      DeleteObject(PREFIX + type + FIRST_PART + time);// Удаление прямоугольника паттерна
      DeleteObject(PREFIX + type + SECOND_PART + time);// Удаление подписи паттерна
      i--;                                         // Повторяем поиск паттернов на этом..
                                                   // ..баре - вдруг их больше одного
   }
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
   while(IsSimpleIB(patternStart) &&               // Поиск элементарных паттернов подряд
         patternStart < total)
      patternStart++;
      
   if (patternStart == index)                      // Ни один паттерн не найден
      return(false);   
      
   return(true);                                   // Паттерн найден
}
//+-------------------------------------------------------------------------------------+
//| Поиск и отображение паттернов Внутренний бар                                        |
//+-------------------------------------------------------------------------------------+
void FindAndShowIB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;

   if (!IsIBPattern(index, total, patternStart))   // Обнаружение и отображение паттерна
      return;

   DeleteAnyPattern(index, patternStart);          // Удаление перекрытых паттернов
   string description = "I" + 
                        DoubleToStr(patternStart - index + 1, 0) +
                        "B";
   ShowTypicalPattern(patternStart, index,         // Отображение паттерна
                      colorIB, typesOfPatterns[IB_INDEX], description);
   PatternAlert(alertIBpattern, index,             // Звуковое оповещение о нахождении..
                lastAlert, soundIBpattern);        // ..паттерна
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
//| Поиск и отображение паттернов DBHLC и DBLHC                                         |
//+-------------------------------------------------------------------------------------+
void FindAndShowDB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;
// - 1 - == Паттерн DBHLC ===============================================================
   if (IsDBHLCPattern(index, total, patternStart)) // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение паттерна
                         colorDBHLC, 
                         typesOfPatterns[DB_INDEX], DBHLC_DESCRIPTION);
      PatternAlert(alertDBpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundDBpattern);     // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Паттерн DBLHC ===============================================================
   if (IsDBLHCPattern(index, total, patternStart)) // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение паттерна
                         colorDBLHC, 
                         typesOfPatterns[DB_INDEX], DBLHC_DESCRIPTION);
      PatternAlert(alertDBpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundDBpattern);     // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттернов TBH и TBL                                             |
//+-------------------------------------------------------------------------------------+
void FindAndShowTB(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index;
// - 1 - == Паттерн TBH =================================================================
   if (IsTBHPattern(index, total, patternStart))   // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение паттерна TBH
                         colorTBH,
                         typesOfPatterns[TB_INDEX], TBH_DESCRIPTION);
      PatternAlert(alertTBpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundTBpattern);     // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Паттерн DBLHC ===============================================================
   if (IsTBLPattern(index, total, patternStart))   // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение паттерна TBL
                         colorTBL,
                         typesOfPatterns[TB_INDEX], TBL_DESCRIPTION);
      PatternAlert(alertTBpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundTBpattern);     // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна Рельсы                                                 |
//+-------------------------------------------------------------------------------------+
void FindAndShowRAILS(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == Бычий паттерн Рельсы ========================================================
   if (IsBullsRailsPattern(index, total))          // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение бычьего паттерна..
                         colorBullsRails,          // ..Рельсы
                         typesOfPatterns[RAILS_INDEX], RAILS_DESCRIPTION);
      PatternAlert(alertRAILSpattern, index,       // Звуковое оповещение о нахождении..
                   lastAlert, soundRAILSpattern);  // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн Рельсы =====================================================
   if (IsBearsRailsPattern(index, total))          // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение медвежьего паттерна..
                         colorBearsRails,          // ..Рельсы
                         typesOfPatterns[RAILS_INDEX], RAILS_DESCRIPTION);
      PatternAlert(alertRAILSpattern, index,       // Звуковое оповещение о нахождении..
                   lastAlert, soundRAILSpattern);  // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттернов BUOVB и BEOVB                                         |
//+-------------------------------------------------------------------------------------+
void FindAndShowOVB(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == Паттерн BUOVB ===============================================================
   if (IsBUOVBPattern(index, total))               // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение паттерна BUOVB
                         colorBUOVB,               
                         typesOfPatterns[OVB_INDEX], BUOVB_DESCRIPTION);
      PatternAlert(alertOVBpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundOVBpattern);    // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Паттерн BEOVB ===============================================================
   if (IsBEOVBPattern(index, total))               // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение паттерна BEOVB
                         colorBEOVB,               
                         typesOfPatterns[OVB_INDEX], BEOVB_DESCRIPTION);
      PatternAlert(alertOVBpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundOVBpattern);    // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна PPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowPPR(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == Бычий паттерн PPR ===========================================================
   if (IsBullsPPRPattern(index, total))            // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+2);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 2, index,         // Отображение бычьего паттерна PPR
                         colorBullsPPR,               
                         typesOfPatterns[PPR_INDEX], PPR_DESCRIPTION);
      PatternAlert(alertPPRpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundPPRpattern);    // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн PPR ========================================================
   if (IsBearsPPRPattern(index, total))            // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+2);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 2, index,         // Отображение медвежьего паттерна PPR
                         colorBearsPPR,               
                         typesOfPatterns[PPR_INDEX], PPR_DESCRIPTION);
      PatternAlert(alertPPRpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundPPRpattern);    // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна HR                                                     |
//+-------------------------------------------------------------------------------------+
void FindAndShowHR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index+1;
// - 1 - == Бычий паттерн HR ============================================================
   if (IsBullsHRPattern(index, total, patternStart))//Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение бычьего паттерна..
                         colorBullsHR,             // ..HR
                         typesOfPatterns[HR_INDEX], HR_DESCRIPTION);
      PatternAlert(alertHRpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundHRpattern);    // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн HR =========================================================
   if (IsBearsHRPattern(index, total, patternStart))//Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение медвежьего паттерна..
                         colorBearsHR,             // ..HR
                         typesOfPatterns[HR_INDEX], HR_DESCRIPTION);
      PatternAlert(alertHRpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundHRpattern);     // ..паттерна
      return;
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна CPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowCPR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index+1;
// - 1 - == Бычий паттерн CPR ===========================================================
   if (IsBullsCPRPattern(index, total, patternStart))//Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение бычьего паттерна..
                         colorBullsCPR,            // ..CPR
                         typesOfPatterns[CPR_INDEX], CPR_DESCRIPTION);
      PatternAlert(alertCPRpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundCPRpattern);    // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн CPR ========================================================
   if (IsBearsCPRPattern(index, total, patternStart))//Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение медвежьего паттерна..
                         colorBearsCPR,            // ..CPR
                         typesOfPatterns[CPR_INDEX], CPR_DESCRIPTION);
      PatternAlert(alertCPRpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundCPRpattern);    // ..паттерна
      return;
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна PPR                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowPINBAR(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == Бычий паттерн Pin Bar =======================================================
   if (IsBullsPINBARPattern(index, total))         // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение бычьего паттерна..
                         colorBullsPPR,            // ..Pin Bar
                         typesOfPatterns[PINBAR_INDEX], PINBAR_DESCRIPTION);
      PatternAlert(alertPINBARpattern, index,      // Звуковое оповещение о нахождении..
                   lastAlert, soundPINBARpattern); // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн Pin Bar ====================================================
   if (IsBearsPINBARPattern(index, total))         // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение бычьего паттерна..
                         colorBearsPPR,            // ..Pin Bar
                         typesOfPatterns[PINBAR_INDEX], PINBAR_DESCRIPTION);
      PatternAlert(alertPINBARpattern, index,      // Звуковое оповещение о нахождении..
                   lastAlert, soundPINBARpattern); // ..паттерна
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна MCM                                                    |
//+-------------------------------------------------------------------------------------+
void FindAndShowMCM(int index, int total)
{
   static datetime lastAlert = 0;
// - 1 - == Бычий паттерн MCM ===========================================================
   if (IsBullsMCMPattern(index, total))            // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение бычьего паттерна..
                         colorBullsMCM,            // ..MCM
                         typesOfPatterns[MCM_INDEX], MCM_DESCRIPTION);
      PatternAlert(alertMCMpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundMCMpattern);    // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн MCM ========================================================
   if (IsBearsMCMPattern(index, total))            // Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, index+1);            // Удаление перекрытых паттернов
      ShowTypicalPattern(index + 1, index,         // Отображение медвежьего паттерна..
                         colorBearsMCM,            // ..MCM
                         typesOfPatterns[MCM_INDEX], MCM_DESCRIPTION);
      PatternAlert(alertMCMpattern, index,         // Звуковое оповещение о нахождении..
                   lastAlert, soundMCMpattern);    // ..паттерна
      return;
   }
// - 2 - == Окончание блока =============================================================
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
//| Поиск и отображение паттерна Island Reversal                                        |
//+-------------------------------------------------------------------------------------+
void FindAndShowIR(int index, int total)
{
   static datetime lastAlert = 0;
   int patternStart = index + 2;
// - 1 - == Бычий паттерн Island Reversal ===============================================
   if (IsBullsIRPattern(index, total, patternStart))// Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение бычьего паттерна..
                         colorBullsIR,             // ..Island Reversal
                         typesOfPatterns[IR_INDEX], IR_DESCRIPTION);
      PatternAlert(alertIRpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundIRpattern);     // ..паттерна
      return;
   }
// - 1 - == Окончание блока =============================================================

// - 2 - == Медвежий паттерн Island Reversal ============================================
   if (IsBearsIRPattern(index, total, patternStart))// Обнаружение и отображение паттерна
   {
      DeleteAnyPattern(index, patternStart);       // Удаление перекрытых паттернов
      ShowTypicalPattern(patternStart, index,      // Отображение бычьего паттерна..
                         colorBearsIR,             // ..Island Reversal
                         typesOfPatterns[IR_INDEX], IR_DESCRIPTION);
      PatternAlert(alertIRpattern, index,          // Звуковое оповещение о нахождении..
                   lastAlert, soundIRpattern);     // ..паттерна
      return;
   }
// - 2 - == Окончание блока =============================================================
}
//+-------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                 |
//+-------------------------------------------------------------------------------------+
int start()
{
// - 1 - == Организационные действия ====================================================
   int total;                                      // Индекс наиболее раннего в истории..
                                                   // ..бара
   int limit = GetRecalcIndex(total);              // Определим первый расчетный бар
// - 1 - == Окончание блока =============================================================
  
// - 2 - == Расчет значений буферов и отображение паттернов =============================
   for (int i = limit; i > 0; i--)                 // Обработаем все новые бары
   {
      if (showIBpattern)                           // Если разрешено обрабатывать..
         FindAndShowIB(i, total);                  // ..паттерн DB, то отобразим его

      if (showDBpattern)                           // Если разрешено обрабатывать..
         FindAndShowDB(i, total);                  // ..паттерн DB, то отобразим его

      if (showTBpattern)                           // Если разрешено обрабатывать..
         FindAndShowTB(i, total);                  // ..паттерн TB, то отобразим его

      if (showRAILSpattern)                        // Если разрешено обрабатывать..
         FindAndShowRAILS(i, total);               // ..паттерн Рельсы, то отобразим его

      if (showOVBpattern)                          // Если разрешено обрабатывать..
         FindAndShowOVB(i, total);                 // ..паттерны BUOVB и BEOVB, то..
                                                   // ..отобразим их

      if (showPPRpattern)                          // Если разрешено обрабатывать..
         FindAndShowPPR(i, total);                 // ..паттерн PPR, то отобразим его

      if (showHRpattern)                           // Если разрешено обрабатывать..
         FindAndShowHR(i, total);                  // ..паттерн HR, то отобразим его

      if (showCPRpattern)                          // Если разрешено обрабатывать..
         FindAndShowCPR(i, total);                 // ..паттерн CPR, то отобразим его

      if (showPINBARpattern)                       // Если разрешено обрабатывать..
         FindAndShowPINBAR(i, total);              // ..паттерн Pin Bar, то отобразим его

      if (showMCMpattern)                          // Если разрешено обрабатывать..
         FindAndShowMCM(i, total);                 // ..паттерн MCM, то отобразим его

      if (showIRpattern)                           // Если разрешено обрабатывать..
         FindAndShowIR(i, total);                  // ..паттерн IR, то отобразим его
   }
// - 2 - == Окончание блока =============================================================
      
   WindowRedraw();
   
   return(0);
}

