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
input int N    = 50;    //Отступ лимитников от текущей цены
input double STARTLOT = 0.01;  //Стартовый лот
input int TP   = 50;    //Тейкпрофит
input int SL   = 0;    //Стоплосс
input int CNT  = 10;    //Количество ордеров
input double PROFIT = 1000.0;//максимальная целевая прибыль
input double LOSS = -1000.0; //максимальный общий убыток
input double MULTIPLER = 2.0; //множитель лота

string pref = "PS"; //Преффикс для графических объектов
string inps = "INP";//Преффикс для графических объектов из окна INPUTS. Если автоторговля включена, то это окно удаляется

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

bool isAutoTrading = false;

int fileHandle = -1;
string fName = Symbol()+WindowExpertName()+".csv";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   PS.SetExpertMagic((int)mg);
   pAsk = Ask;
   pBid = Bid;
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   DeleteObjects(pref);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   
   HLineCreate(pref+"_B_LV", bLevel, clrGreen, "B_level");
   HLineCreate(pref+"_S_LV", sLevel, clrRed, "S_level");
   
   Check(vl, pr, counter, type);
//---
   static int prev = 0;
   
   if(((profit <= pr && profit != 0)|| 
       (pr <= loss && loss != 0)) ||
      (prev > counter)){
      PS.CloseTrades();
      PS.DeletePendings();
      bLevel = N==0?0.0:NormalizeDouble(Ask + N * Point(), Digits());
      sLevel = N==0?0.0:NormalizeDouble(Bid - N * Point(), Digits());
      ObjectMove(0,pref+"_B_LV",0,0,bLevel);
      ObjectMove(0,pref+"_S_LV",0,0,sLevel);
   }   
   prev = counter;
         
   //ЕСЛИ РАЗРЕШЕНО ТОРГОВАТЬ, ТО ОТСЛЕЖИВАЕМ ПЕРВЫЙ ОРДЕР
   
   if(counter == 0){
      if((pAsk <= bLevel && Ask >= bLevel) ||
         (pAsk >= bLevel && Ask <= bLevel)){
            PS.Buy(Symbol(), Lot(startLot), sl, tp);
         }
      if((pBid <= sLevel && Bid >= sLevel) ||
         (pBid >= sLevel && Bid <= sLevel)){
            PS.Sell(Symbol(), Lot(startLot), sl, tp);
         }
   }
   else if(counter < cnt){
      if(type == OP_BUY &&
         ((pBid <= sLevel && Bid >= sLevel) ||
         (pBid >= sLevel && Bid <= sLevel))){
            PS.Sell(Symbol(), Lot(vl*2), sl, tp);
      }
      if(type == OP_SELL &&
         ((pAsk <= bLevel && Ask >= bLevel) ||
         (pAsk >= bLevel && Ask <= bLevel))){
            PS.Buy(Symbol(), Lot(vl*2), sl, tp);
      }
   }
   pAsk = Ask;
   pBid = Bid;
}

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
  
bool LabelChange(const string name, const string text){
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   return true;
}

//функция заполняет лот, цену, тип последнего ордера и количество ордеров
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

double Lot(const double v){
   double l = v;
   if(l > MarketInfo(Symbol(), MODE_MAXLOT))l = MarketInfo(Symbol(), MODE_MAXLOT);
   if(l < MarketInfo(Symbol(), MODE_MINLOT))l = MarketInfo(Symbol(), MODE_MINLOT);
   return l;
}

void DeleteObjects(const string& p){
   int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, p)!= -1) ObjectDelete(ChartID(), on);
      }
   }
}