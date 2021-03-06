//+------------------------------------------------------------------+
//|                                                     PingStop.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#include <trade.mqh>

CTrade PS;

input int MG   = 23978; //Магик
input int N    = 1000;    //Отступ лимитников от текущей цены
input double STARTLOT = 0.01;  //Стартовый лот
input int TP   = 20;    //Стоплосс
input int SL   = 10;    //Тейкпрофит
input int CNT  = 10;    //Количество ордеров
input double PROFIT = 1000.0;//максимальная целевая прибыль
input double LOSS = -1000.0; //максимальный общий убыток
input double MULTIPLER = 2.0; //множитель лота

string pref = "PS"; //Преффикс для графических объектов
int counter = 0;
double bLevel = N==0?0.0:NormalizeDouble(Ask + N * Point(), Digits());
double sLevel = N==0?0.0:NormalizeDouble(Bid - N * Point(), Digits());

bool trade = false;
int type = -1;

double pr = 0.0;  //Профит по торгам
double vl = 0.0;   //Лот

int mg = MG;
double pAsk = 0.0;
double pBid = 0.0;

int sl = SL;
int tp = TP;

double profit = PROFIT;
double loss = LOSS;
int cnt = CNT;
double startLot = STARTLOT;
double multipler = MULTIPLER;

int fileHandle = -1;
string fName = Symbol()+WindowExpertName()+".csv";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   ChartSetInteger(ChartID(), CHART_EVENT_MOUSE_MOVE, 1);
   PS.SetExpertMagic(mg);
   /*
   if(Digits() == 3 || Digits() == 5)
      mtp = 10;
   */
   pAsk = Ask;
   pBid = Bid;
   
   if(FileIsExist(fName)){
      fileHandle = FileOpen(fName, FILE_READ|FILE_CSV);
      if(fileHandle != INVALID_HANDLE){
         //TODO: ВБИВАЕМ ПАРАМЕТРЫ ИЗ ФАЙЛА В ЭТОТ СОВЕТНИК
         FileReadString(fileHandle);
         mg = StringToInteger(FileReadString(fileHandle));
         FileReadString(fileHandle);
         sl = StringToInteger(FileReadString(fileHandle));
         FileReadString(fileHandle);
         tp = StringToInteger(FileReadString(fileHandle));
         FileReadString(fileHandle);
         profit = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         loss = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         cnt = StringToInteger(FileReadString(fileHandle));
         FileReadString(fileHandle);
         startLot = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         multipler = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         bLevel = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         sLevel = StringToDouble(FileReadString(fileHandle));
         FileReadString(fileHandle);
         trade = FileReadBool(fileHandle);
         /*
         magic
         sl
         tp
         profit
         loss
         total
         lot
         multipler
         уровень buy
         уровень sell
         режим работы (вкл/выкл)
         */
         FileClose(fileHandle);
      }
   }
   //ПОЛУЧАЕМ ПАРАМЕТРЫ ПРОШЛОЙ РАБОТЫ СОВЕТНИКА
   //RectLabelCreate(pref+"R_LB", 100, 100, 90, 90, 13282647, 0, 3);
   //ButtonCreate(pref+"_MODE", 100, 100, 50, 18);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, pref)!= -1) ObjectDelete(ChartID(), on);
      }
   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   //Тут забиваются все элементы интерфейса, которые не влияют на работу советника
   //секция INPUTS:
   RectLabelCreate(pref+"_R_INP", 135, 220, 130, 230, 13282647, 0, 3);
   
   ButtonCreate(pref+"_CLOSE", 130, 30, 120, 20, 3, "ЗАКРЫТЬ СДЕЛКИ", "Arial", 10, clrYellow, clrRed);
   
   EditCreate(pref+"_eMTP",   80, 78,  70, 18, DTS(multipler,1));
   EditCreate(pref+"_eLOT",   80, 98, 70, 18, DTS(startLot,2));
   EditCreate(pref+"_eTOTAL", 80, 118, 70, 18, ITS(cnt));
   EditCreate(pref+"_eLOSS",  80, 138, 70, 18, DTS(loss, 2));
   EditCreate(pref+"_ePROF",  80, 158, 70, 18, DTS(profit,2));
   EditCreate(pref+"_eTP",    80, 178, 70, 18, ITS(tp));
   EditCreate(pref+"_eSL",    80, 198, 70, 18, ITS(sl));
   
   LabelCreate(pref+"_lilTITLEC", 50, 200, 3, "INPUTS");   
   LabelCreate(pref+"_liMTP",   80, 60, 3, "MTP: ");
   LabelCreate(pref+"_liLOT",   80, 80, 3, "start lot: ");
   LabelCreate(pref+"_liTOTAL",80, 100, 3, "total: ");
   LabelCreate(pref+"_liLOSS", 80, 120, 3, "loss: ");
   LabelCreate(pref+"_liPROF", 80, 140, 3, "profit: ");
   LabelCreate(pref+"_liTP",   80, 160, 3, "TP: ");
   LabelCreate(pref+"_liSL",   80, 180, 3, "SL: ");
   
   //секция STATUS:
   RectLabelCreate(pref+"_R_STS", 315, 220, 180, 230, 13282647, 0, 3);
   LabelCreate(pref+"_lsTITLES", 200, 200, 3, "STATUS");
   LabelCreate(pref+"_lsCUR",   200,  60, 3, "Прибыль: ");
   LabelCreate(pref+"_lsLOSS",  200,  80, 3, "Макс. убыток: ");
   LabelCreate(pref+"_lsPROF",  200, 100, 3, "Макс. прибыль: ");
   LabelCreate(pref+"_lsMTP",   200, 120, 3, "Множитель: ");
   LabelCreate(pref+"_lsSTART", 200, 140, 3, "Стартовый лот: ");
   LabelCreate(pref+"_lsCNT",   200, 160, 3, "Ордеров: ");
   
   LabelCreate(pref+"_lsCUR2",  140,  60, 3, ""); LabelChange(pref+"_lsCUR2", DTS(pr,2));
   LabelCreate(pref+"_lsLOSS2", 140,  80, 3, ""); LabelChange(pref+"_lsLOSS2", DTS(loss, 2));
   LabelCreate(pref+"_lsPROF2",  140, 100, 3, "");LabelChange(pref+"_lsPROF2", DTS(profit,2));
   LabelCreate(pref+"_lsMTP2",   140, 120, 3, "");LabelChange(pref+"_lsMTP2", DTS(multipler,1));
   LabelCreate(pref+"_lsSTART2", 140, 140, 3, "");LabelChange(pref+"_lsSTART2", DTS(startLot,2));
   LabelCreate(pref+"_lsCNT2",   140, 160, 3, "");LabelChange(pref+"_lsCNT2", ITS(counter));
   LabelCreate(pref+"_lsSTATUS", 190, 180, 3, "");LabelChange(pref+"_lsSTATUS", trade?"РАБОТАЕТ":"ОСТАНОВЛЕН");
   
   //TODO: кнопка режима и линии забиваются из файла. Если файла нет, то всё идёт из настроек советника
   HLineCreate(pref+"_B_LV", bLevel, clrGreen, "B_level");
   HLineCreate(pref+"_S_LV", sLevel, clrRed, "S_level");
   ButtonCreate(pref+"_MODE", 130, 55, 120, 20, 3, trade?"STOP":"START", "Arial", 10, clrYellow, trade?clrRed:clrGreen);
   Check(vl, pr, counter, type);
//---
   
   if(profit <= pr || pr <= loss){
      trade = false;
      PS.CloseTrades();
      PS.DeletePendings();
      ButtonChange(pref+"_MODE", "START", clrGreen);
   }   
   
   if(ObjectGetInteger(ChartID(), pref+"_MODE", OBJPROP_STATE)){
      if(ObjectGetString(0, pref+"_MODE", OBJPROP_TEXT)=="START"){
         
         trade = true;
         bLevel = ObjectGetDouble(0, pref+"_B_LV", OBJPROP_PRICE1);
         sLevel = ObjectGetDouble(0, pref+"_S_LV", OBJPROP_PRICE1);
         
         //ЗАНОСИМ ВСЕ НАСТРОЙКИ В ФАЙЛ
         ResetLastError();
         fileHandle = FileOpen(fName, FILE_WRITE|FILE_CSV);
         if(fileHandle != INVALID_HANDLE){
            
            string sSL =         ObjectGetString(0, pref+"_eSL",     OBJPROP_TEXT);
            string sTP =         ObjectGetString(0, pref+"_eTP",     OBJPROP_TEXT);
            string sProfit =     ObjectGetString(0, pref+"_ePROF",   OBJPROP_TEXT);
            string sLoss =       ObjectGetString(0, pref+"_eLOSS",   OBJPROP_TEXT);
            string sTotal =      ObjectGetString(0, pref+"_eTOTAL",  OBJPROP_TEXT);
            string sStartLot =   ObjectGetString(0, pref+"_eLOT",    OBJPROP_TEXT);
            string sMTP =        ObjectGetString(0, pref+"_eMTP",    OBJPROP_TEXT);
            
            StringReplace(sProfit, ",", ".");
            StringReplace(sLoss, ",", ".");
            StringReplace(sStartLot, ",", ".");
            StringReplace(sMTP, ",", ".");
            
            sl = StringToInteger(sSL);
            tp = StringToInteger(sTP);
            profit = NormalizeDouble(StringToDouble(sProfit), 2);
            loss = NormalizeDouble(StringToDouble(sLoss), 2);
            cnt = StringToInteger(sTotal);
            startLot = NormalizeDouble(StringToDouble(sStartLot), 2);
            multipler = NormalizeDouble(StringToDouble(sMTP), 2);
            
            FileWrite(fileHandle, "Magic", mg);
            FileWrite(fileHandle, "SL", sl);
            FileWrite(fileHandle, "TP", tp);
            FileWrite(fileHandle, "PROFIT", profit);
            FileWrite(fileHandle, "LOSS", loss);
            FileWrite(fileHandle, "TOTAL", cnt);
            FileWrite(fileHandle, "STARTLOT", startLot);
            FileWrite(fileHandle, "MULTIPLER", multipler);
            FileWrite(fileHandle, "BUYLEVEL", bLevel);
            FileWrite(fileHandle, "SELLLEVEL", sLevel);
            FileWrite(fileHandle, "MODE", trade);            
            FileClose(fileHandle);
         }
         ButtonChange(pref+"_MODE", "STOP!", clrRed);
      }
      else{
         trade = false;
         //ЗАНОСИМ ВСЕ НАСТРОЙКИ В ФАЙЛ
         ResetLastError();
         fileHandle = FileOpen(fName, FILE_WRITE|FILE_CSV);
         if(fileHandle != INVALID_HANDLE){
         
            string sSL =         ObjectGetString(0, pref+"_eSL",     OBJPROP_TEXT);
            string sTP =         ObjectGetString(0, pref+"_eTP",     OBJPROP_TEXT);
            string sProfit =     ObjectGetString(0, pref+"_ePROF",   OBJPROP_TEXT);
            string sLoss =       ObjectGetString(0, pref+"_eLOSS",   OBJPROP_TEXT);
            string sTotal =      ObjectGetString(0, pref+"_eTOTAL",  OBJPROP_TEXT);
            string sStartLot =   ObjectGetString(0, pref+"_eLOT",    OBJPROP_TEXT);
            string sMTP =        ObjectGetString(0, pref+"_eMTP",    OBJPROP_TEXT);
            
            StringReplace(sProfit, ",", ".");
            StringReplace(sLoss, ",", ".");
            StringReplace(sStartLot, ",", ".");
            StringReplace(sMTP, ",", ".");
            
            sl = StringToInteger(sSL);
            tp = StringToInteger(sTP);
            profit = NormalizeDouble(StringToDouble(sProfit), 2);
            loss = NormalizeDouble(StringToDouble(sLoss), 2);
            cnt = StringToInteger(sTotal);
            startLot = NormalizeDouble(StringToDouble(sStartLot), 2);
            multipler = NormalizeDouble(StringToDouble(sMTP), 2);
            
            FileWrite(fileHandle, "Magic", mg);
            FileWrite(fileHandle, "SL", sl);
            FileWrite(fileHandle, "TP", tp);
            FileWrite(fileHandle, "PROFIT", profit);
            FileWrite(fileHandle, "LOSS", loss);
            FileWrite(fileHandle, "TOTAL", cnt);
            FileWrite(fileHandle, "STARTLOT", startLot);
            FileWrite(fileHandle, "MULTIPLER", multipler);
            FileWrite(fileHandle, "BUYLEVEL", bLevel);
            FileWrite(fileHandle, "SELLLEVEL", sLevel);
            FileWrite(fileHandle, "MODE", trade);            
            FileClose(fileHandle);
         }
         
         ButtonChange(pref+"_MODE", "START", clrGreen);
      }
      ObjectSetInteger(ChartID(), pref+"_MODE", OBJPROP_STATE, false);
   }
   
   if(ObjectGetInteger(ChartID(), pref+"_CLOSE", OBJPROP_STATE)){
      PS.CloseTrades();
      PS.DeletePendings();
      ObjectSetInteger(ChartID(), pref+"_CLOSE", OBJPROP_STATE, false);
   }
   
   //ЕСЛИ РАЗРЕШЕНО ТОРГОВАТЬ, ТО ОТСЛЕЖИВАЕМ ПЕРВЫЙ ОРДЕР
   
   if(trade){
      if(counter == 0){
         if((pAsk <= bLevel && Ask >= bLevel) ||
            (pAsk >= bLevel && Ask <= bLevel)){
               PS.Buy(Symbol(), startLot, sl, tp);
            }
         if((pBid <= sLevel && Bid >= sLevel) ||
            (pBid >= sLevel && Bid <= sLevel)){
               PS.Sell(Symbol(), startLot, sl, tp);
            }
      }
      else if(counter < cnt){
         if(type == OP_BUY &&
            ((pBid <= sLevel && Bid >= sLevel) ||
            (pBid >= sLevel && Bid <= sLevel))){
               PS.Sell(Symbol(), vl*2, sl, tp);
         }
         if(type == OP_SELL &&
            ((pAsk <= bLevel && Ask >= bLevel) ||
            (pAsk >= bLevel && Ask <= bLevel))){
               PS.Buy(Symbol(), vl*2, sl, tp);
         }
      }
   }
   pAsk = Ask;
   pBid = Bid;
}

void OnChartEvent(const int id,         // идентификатор события   
                  const long& lparam,   // параметр события типа long 
                  const double& dparam, // параметр события типа double 
                  const string& sparam){// параметр события типа string 
   
   if(trade)return;
   static bool b_move = false;
   static bool s_move = false;
   static datetime time;
   static double price = 0.0;
   static int window = 0;
   static bool tweaking = true;
   
   //Если нажали клавишу B и двигаем мышкой, то перемещается линия buy_level
   //Если нажали клавишу S и двигаем мышкой, то перемещается линия sell_level
   //Если нажали ЛКМ, то линия привязывается к текущему уровню и флаги B и S сбрасываются
   ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, window, time, price);
   if(id == CHARTEVENT_KEYDOWN){
      tweaking = true;
      if(lparam == 66){b_move = true;s_move = false;}
      else if(lparam == 83){b_move = false;s_move = true;}
   }
   if(id == CHARTEVENT_MOUSE_MOVE){            
      if(b_move){
         ObjectMove(0,pref+"_B_LV",0,0,price);
      }
      if(s_move){
         ObjectMove(0,pref+"_S_LV",0,0,price);
      }      
   }
   
   if(id == CHARTEVENT_CLICK && (b_move || s_move)){
      b_move = false;
      s_move = false;
      tweaking = false;
   }   
}
//+------------------------------------------------------------------+

bool HLineCreate(const string          name="HLine",      // имя линии
                 double                price=0,           // цена линии 
                 const color           clr=clrRed,        // цвет линии 
                 const string          text="",           // описание линии
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии 
                 const int             width=1,           // толщина линии 
                 const bool            back=false,        // на заднем плане 
                 const bool            selection=false,   // выделить для перемещений 
                 const bool            hidden=true,       // скрыт в списке объектов 
                 const long            z_order=0){        // приоритет на нажатие мышью 
//--- если цена не задана, то установим ее на уровне текущей цены Bid 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      
   ResetLastError(); 
//--- создадим горизонтальную линию 
   if(ObjectFind(ChartID(), name)!= -1)return true;
   
   const long chart_ID = 0;
   const int sub_window = 0;
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price)){ 
      Print(__FUNCTION__, 
            ": не удалось создать горизонтальную линию! Код ошибки = ",GetLastError()); 
      return(false); 
   }   
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID, name,OBJPROP_TEXT, text);
   return(true); 
}

bool RectLabelCreate(const string           name="RectLabel",         // имя метки
                     const int              x=0,                      // координата по оси X 
                     const int              y=0,                      // координата по оси Y 
                     const int              width=50,                 // ширина 
                     const int              height=18,                // высота 
                     const color            back_clr=C'87,173,202',   // цвет фона 
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы 
                     const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                     const color            clr=clrGray,              // цвет плоской границы (Flat) 
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы 
                     const int              line_width=1,             // толщина плоской границы 
                     const bool             back=false,               // на заднем плане 
                     const bool             selection=false,          // выделить для перемещений 
                     const bool             hidden=true,              // скрыт в списке объектов 
                     const long             z_order=0)                // приоритет на нажатие мышью 
  { 
  if(ObjectFind(ChartID(), name)!= -1)return true;
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим прямоугольную метку 
   const long chart_ID = 0;
   const int sub_window = 0;
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)){ 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольную метку! Код ошибки = ",GetLastError()); 
      return(false); 
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true); 
}
bool LabelCreate(const string            name="Label",             // имя метки 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                 const string            text="Label",             // текст 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrBlack,             // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_RIGHT_LOWER,// способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
{
   if(ObjectFind(ChartID(), name)!= -1)return true;
   const long chart_ID = 0;
   const int sub_window = 0;
   ResetLastError(); 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)){ 
      Print(__FUNCTION__, 
            ": не удалось создать текстовую метку! Код ошибки = ",GetLastError()); 
      return(false); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true); 
}

bool EditCreate(const string           name="Edit",              // имя объекта 
                const int              x=0,                      // координата по оси X 
                const int              y=0,                      // координата по оси Y 
                const int              width=50,                 // ширина 
                const int              height=18,                // высота 
                const string           text="Text",              // текст 
                const string           font="Arial",             // шрифт 
                const int              font_size=10,             // размер шрифта 
                const ENUM_ALIGN_MODE  align=ALIGN_RIGHT,        // способ выравнивания 
                const bool             read_only=false,          // возможность редактировать 
                const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                const color            clr=clrBlack,             // цвет текста 
                const color            back_clr=clrWhite,        // цвет фона 
                const color            border_clr=clrNONE,       // цвет границы 
                const bool             back=false,               // на заднем плане 
                const bool             selection=false,          // выделить для перемещений 
                const bool             hidden=true,              // скрыт в списке объектов 
                const long             z_order=0)                // приоритет на нажатие мышью 
{
   if(ObjectFind(ChartID(), name)!= -1)return true;
   const long chart_ID = 0;
   const int sub_window = 0;
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим поле ввода 
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать объект \"Поле ввода\"! Код ошибки = ",GetLastError()); 
      return(false); 
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true); 
  }
  
bool ButtonCreate(const string            name="Button",            // имя кнопки 
                  const int               x=0,                      // координата по оси X 
                  const int               y=0,                      // координата по оси Y 
                  const int               width=50,                 // ширина кнопки 
                  const int               height=18,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                  const string            text="Button",            // текст 
                  const string            font="Arial",             // шрифт 
                  const int               font_size=10,             // размер шрифта 
                  const color             clr=clrBlack,             // цвет текста 
                  const color             back_clr=C'236,233,216',  // цвет фона 
                  const color             border_clr=clrNONE,       // цвет границы 
                  const bool              state=false,              // нажата/отжата 
                  const bool              back=false,               // на заднем плане 
                  const bool              selection=false,          // выделить для перемещений 
                  const bool              hidden=true,              // скрыт в списке объектов 
                  const long              z_order=0)                // приоритет на нажатие мышью 
{
   if(ObjectFind(ChartID(), name)!= -1)return true;
   const long chart_ID = 0;
   const int sub_window = 0;
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим кнопку 
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать кнопку! Код ошибки = ",GetLastError()); 
      return(false); 
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true); 
}
bool ButtonChange(const string name, const string text, const color clr){
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
   return true;
};

bool LabelChange(const string name, const string text){
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   return true;
}

void Check(double& l, double& p, int& cntr, int& t){
   l = 0.0;
   p = 0.0;
   cntr = 0;
   t = -1;
   for(int i = OrdersTotal()-1; i >= 0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == mg){
         if(l == 0.0) l = OrderLots();
         if(t == -1) t = OrderType();
         p += NormalizeDouble(OrderProfit(), 2);
         cntr++;
      }
   }
}

string DTS(const double d, const int c){
   return DoubleToString(d, c);
}
string ITS(const int i){
   return IntegerToString(i);
}