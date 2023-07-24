//+------------------------------------------------------------------+
//|                                                    LotByRisk.mq4 |
//|                                                           Sergey |
//|                             https://www.mql5.com/ru/users/enzzo/ |
// version 1.05:
// - Переписал GUI. Теперь панель можно перетаскивать мышкой
// - Поправил ошибки с комментариями

// version 1.04:
// - Исправил ошибку с комментариями
// - Изменил комиссию по-умолчанию на 0.0, так как она у всех разная

// versoin 1.03:
// - Добавил возможность парковки панели
// - Сделал так, чтобы значение риска не пропадало при смене таймфреймов.

// versoin 1.02:
// + Добавил риск в настройки советника, чтобы можно было сохранять их
// + Изменил алгоритм расчёта лота. Добавил в него комиссию брокера
// по формуле lot = (balance * risk)/(comission + sl(pips))

// versoin 1.01:
// Внесены дополнения по просьбам пользователей с mql5.com
//
// TODO:
// - Перерисовать кнопки закрытия и сворачивания окна
// - добавить границы к окну
// - Добавить возможность ввода значений вручную
// - Добавить вертикальную линию, после которой открывается рыночный ордер
// - Добавить вертикальную линию, после которой ордер закроется
// - Добавить вертикальную линию, после которой будет экспирация отложенного ордера 
//   (если ордер сработал, то он не закрывается, а торгуется дальше)
// - Переписать под MT5
// - Сделать так, чтобы линии исчезали после выставления ордера
// - Расчёт риска для фондовых инструментов CFD

// - Разделить закрытие ордеров на закрытие рыночных и отложенных по отдельности
//+---------------------------------------------------------------------------------+
//| Советник выставляет сделку нажатии на кнопку TR (trade)                         |
//| Cтоплос должен быть заданы обязательно                                          |
//| Направление сделки определяется положением стоплоса                             |
//| Риск рассчитывается от свободной маржи                                          |
//+---------------------------------------------------------------------------------+
//| |
//| |
//| |
//| |
//+---------------------------------------------------------------------------------+

#property copyright "Sergey"
#property link      "https://www.mql5.com/ru/users/enzzo/"
#property version   "1.00"

#property description "The Lot by Risk trading panel is designed for manual trading."
#property description "This is an alternative means for sending orders."
#property description "The first feature of the panel is convenient placing of orders using control lines."
#property description "The second feature is the calculation of the order volume for a given risk and the presence of a stop loss line."

#include <Controls\Defines.mqh>

input int         MAGIC       = 111087;            // magic
input string      COMMENT     = "";                // comment
input int         FONT        = 7;
input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER; // base corner
input int         X_OFFSET    = 20;                // X - offset
input int         Y_OFFSET    = 20;                // Y - offset
input string      HK_TP       = "T";               // hotkey for TP
input string      HK_SL       = "S";               // hotkey for SL
input string      HK_PR       = "P";               // hotkey for PRICE
input int         SLIPPAGE    = 5;                 // slippage
input double      RISK        = 1.0;               // risk
input double      COMISSION   = 0.0;               // comission

#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG

#undef CONTROLS_DIALOG_COLOR_BORDER_LIGHT  
#undef CONTROLS_DIALOG_COLOR_BORDER_DARK   
#undef CONTROLS_DIALOG_COLOR_CLIENT_BORDER

#define CONTROLS_DIALOG_COLOR_BG             C'87,173,202'
#define CONTROLS_DIALOG_COLOR_CLIENT_BG      C'87,173,202'

#define CONTROLS_DIALOG_COLOR_BORDER_LIGHT  clrBlack
#define CONTROLS_DIALOG_COLOR_BORDER_DARK   C'0x00,0x00,0x00'
#define CONTROLS_DIALOG_COLOR_CLIENT_BORDER C'0x00,0x00,0x00'

#include <dev/lot_by_risk_panel.mqh>
#include <dev/Trade.mqh>
#include <Trade/SymbolInfo.mqh>

lot_by_risk panel;

CTrade trade;
CSymbolInfo smb;

#define PANEL_WIDTH  110
#define PANEL_HEIGHT 108

string pref = "LBR";

string t_line = pref + "_t_line";
string s_line = pref + "_s_line";
string p_line = pref + "_p_line";


int OnInit(){
   panel.SetRiskDefault(DoubleToString(RISK, 1));
   panel.SetCommentDefault(COMMENT);
   panel.SetFooTrade(Trade);
   panel.SetFooClose(CloseAll);

   if(!panel.Create(0, "LBR", 0, X_OFFSET, Y_OFFSET, PANEL_WIDTH, PANEL_HEIGHT, CORNER, FONT)){
      return (INIT_FAILED);
   }
   
   panel.Run();

   trade.SetExpertMagicNumber(MAGIC);
   trade.SetExpertComment(COMMENT);
   smb.Select(smb.Name(Symbol()));
//---
   return(INIT_SUCCEEDED);
}
//+---------------------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   panel.Destroy(reason);
}
//+---------------------------------------------------------------------------------+
void OnChartEvent(const int id,         // идентификатор события   
                  const long& lparam,   // параметр события типа long 
                  const double& dparam, // параметр события типа double 
                  const string& sparam){// параметр события типа string
   panel.ChartEvent(id, lparam, dparam, sparam);

   static bool t_move = false;
   static bool s_move = false;
   static bool p_move = false;
   
   static datetime time;
   static double price = 0.0;
   static int window = 0;
   
   //Если нажали клавишу P и двигаем мышкой, то перемещается линия price_level
   //Если нажали клавишу T и двигаем мышкой, то перемещается линия tp_level
   //Если нажали клавишу S и двигаем мышкой, то перемещается линия sl_level
   //Если нажали ЛКМ, то линия привязывается к текущему уровню и флаги P, T и S сбрасываются
   ChartXYToTimePrice(ChartID(), (int)lparam, (int)dparam, window, time, price);
   if(id == CHARTEVENT_KEYDOWN){
      if(lparam == StringToToken(HK_TP)){
         string n = t_line;
         t_move = true;s_move = false; p_move = false; 
         if(ObjectFind(ChartID(), n) != -1) ObjectDelete(ChartID(), n);
         else HLineCreate(n, price, clrGreen, "take profit");
      }
      else if(lparam == StringToToken(HK_SL)){
         string n = s_line;
         t_move = false;s_move = true;p_move = false;
         if(ObjectFind(ChartID(), n) != -1) ObjectDelete(ChartID(), n);
         else HLineCreate(n, price, clrRed ,"stop loss");
      }
      else if(lparam == StringToToken(HK_PR)){
         string n = p_line;
         t_move = false;s_move = false;p_move = true;
         if(ObjectFind(ChartID(), n) != -1) ObjectDelete(ChartID(), n);
         else HLineCreate(n, price, clrOrange, "price open");
      }      
   }
   if(id == CHARTEVENT_MOUSE_MOVE){            
      if(t_move){
         LineMove(t_line,price);
      }
      if(s_move){
         LineMove(s_line,price);
      }  
      if(p_move){
         LineMove(p_line,price);
      }     
   }
   
   if(id == CHARTEVENT_CLICK && (t_move || s_move || p_move)){
      t_move = false;
      s_move = false;
      p_move = false;
   }   
}
//+------------------------------------------------------------------+

long StringToToken(const string& s){
   if(s[0] == '0') return 48;
   if(s[0] == '1') return 49;
   if(s[0] == '2') return 50;
   if(s[0] == '3') return 51;
   if(s[0] == '4') return 52;
   if(s[0] == '5') return 53;
   if(s[0] == '6') return 54;
   if(s[0] == '7') return 55;
   if(s[0] == '8') return 56;
   if(s[0] == '9') return 57;
   if(s[0] == 'A' || s[0] == 'a') return 65;
   if(s[0] == 'B' || s[0] == 'b') return 66;
   if(s[0] == 'C' || s[0] == 'c') return 67;
   if(s[0] == 'D' || s[0] == 'd') return 68;
   if(s[0] == 'E' || s[0] == 'e') return 69;
   if(s[0] == 'F' || s[0] == 'f') return 70;
   if(s[0] == 'G' || s[0] == 'g') return 71;
   if(s[0] == 'H' || s[0] == 'h') return 72;
   if(s[0] == 'I' || s[0] == 'i') return 73;
   if(s[0] == 'J' || s[0] == 'j') return 74;
   if(s[0] == 'K' || s[0] == 'k') return 75;
   if(s[0] == 'L' || s[0] == 'l') return 76;
   if(s[0] == 'M' || s[0] == 'm') return 77;
   if(s[0] == 'N' || s[0] == 'n') return 78;
   if(s[0] == 'O' || s[0] == 'o') return 79;
   if(s[0] == 'P' || s[0] == 'p') return 80;
   if(s[0] == 'Q' || s[0] == 'q') return 81;
   if(s[0] == 'R' || s[0] == 'r') return 82;
   if(s[0] == 'S' || s[0] == 's') return 83;
   if(s[0] == 'T' || s[0] == 't') return 84;
   if(s[0] == 'U' || s[0] == 'u') return 85;
   if(s[0] == 'V' || s[0] == 'v') return 86;
   if(s[0] == 'W' || s[0] == 'w') return 87;
   if(s[0] == 'X' || s[0] == 'x') return 88;
   if(s[0] == 'Y' || s[0] == 'y') return 89;
   if(s[0] == 'Z' || s[0] == 'z') return 90;
   return -1;
}

//+------------------------------------------------------------------+
bool Trade(){   
   
   string cmnt = panel.GetComment() == trade.GetExpertComment() ? "" : panel.GetComment();
   double tp   = NormalizeDouble(ObjectGetDouble(ChartID(), t_line, OBJPROP_PRICE), Digits());
   double sl   = NormalizeDouble(ObjectGetDouble(ChartID(), s_line, OBJPROP_PRICE), Digits());
   double pr   = NormalizeDouble(ObjectGetDouble(ChartID(), p_line, OBJPROP_PRICE), Digits());

   double risk = sl == 0.0?0.0:panel.GetRisk();
   int    pts = 1;
   
   if(ObjectFind(ChartID(), t_line)!= -1)ObjectDelete(ChartID(), t_line);
   if(ObjectFind(ChartID(), s_line)!= -1)ObjectDelete(ChartID(), s_line);
   if(ObjectFind(ChartID(), p_line)!= -1)ObjectDelete(ChartID(), p_line);

    MqlTick tick;
    SymbolInfoTick(Symbol(), tick);

    double Ask = tick.ask;
    double Bid = tick.bid;

   //Рассчитаем количество пунктов до стоплосса
   if(sl != 0.0){
      //Если цена не задана и ордер будет рыночным, то
      if(pr == 0.0){
         if(sl < Bid) pts = (int)((Ask-sl)/Point());
         else if(sl > Ask) pts = (int)((sl-Bid)/Point());
      }
      //Если цена задана и будет отложенный ордер, то
      else{
         if(sl < pr) pts = (int)((pr-sl)/Point());
         else if(pr < sl)pts = (int)((sl- pr)/Point());
      }
   }
   
   //1, 2)
   if(tp == 0.0 && sl == 0.0){
      return Wrong("set a stop loss or take profit line");
   }
   
   //(3, 4, 7)
   if(pr == 0.0){
      
      //РИСКА НЕТ
      //3)
      if(sl == 0.0){
         if(tp > Ask) return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         if(tp < Bid) return trade.Sell(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         return Wrong("take profit can't be inside the spread");
      }
      
      //РИСК ЕСТЬ
      //4)
      if(tp == 0.0){
         if(sl < Bid) return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         if(sl > Ask) return trade.Sell(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         return Wrong("stop loss can't be inside the spread");
      }
      
      //7
      if(tp > Ask && sl > Ask){
         return Wrong("take profit and stop loss above the opening price");
      }
      if(tp < Bid && sl < Bid){
         return Wrong("take profit and stop loss below the opening price");
      }
      if(tp > Ask && sl < Bid) return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
      if(tp < Bid && sl > Ask) return trade.Sell(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
      return Wrong("7 E");
   }
   //(5, 6, 8)
   else{
   
      //РИСКА НЕТ
      //5
      if(sl == 0.0){
         if(tp > pr){
            if(pr > Ask)return trade.BuyStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr < Ask)return trade.BuyLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            
            if(pr == Ask)return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         }
         if(tp < pr){
            if(pr < Bid)return trade.SellStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr > Bid)return trade.SellLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr == Bid)return trade.Sell(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         }
         //5 D
         return Wrong("take profit cannot be equal to the opening price");         
      }
      
      //РИСК ЕСТЬ
      //6
      if(tp == 0.0){
         if(sl < pr){
            if(pr > Ask)return trade.BuyStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr < Ask)return trade.BuyLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr == Ask)return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         }
         if(sl > pr){
            if(pr < Bid)return trade.SellStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr > Bid)return trade.SellLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
            if(pr == Bid)return trade.Sell(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
         }
         //6 D
         return Wrong("stop loss cannot be equal to the opening price");
      }
      
      //8 ВСЕ ЛИНИИ НА ГРАФИКЕ
      if(tp == sl || tp == pr || sl == pr)return Wrong("control levels cannot be equal");
      if(tp > pr && sl > pr)return Wrong("take profit and stop loss above the opening price");
      if(tp < pr && sl < pr)return Wrong("take profit and stop loss below the opening price");
      if(tp > pr){
         if(pr > Ask)return trade.BuyStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
         if(pr < Ask)return trade.BuyLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
                     return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
      }
      if(tp < pr){
         if(pr > Bid)return trade.SellLimit(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
         if(pr < Bid)return trade.SellStop(Symbol(), AutoLot(risk, pts), pr, sl, tp, 0, cmnt);
                     return trade.Buy(Symbol(), AutoLot(risk, pts), sl, tp, cmnt);
      }
   }  

   return false;
}

bool CloseAll(){
   trade.CloseTrades();
   trade.DeletePendings();
   return (true);
}
//+------------------------------------------------------------------+
bool Wrong(const string msg){
   Alert(msg);
   return false;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//r - риск %, p - пункты до стоплосса
double AutoLot(const double r, const int p){
   // double l = MarketInfo(Symbol(), MODE_MINLOT);
   double l = .0;

   l = NormalizeDouble((AccountInfoDouble(ACCOUNT_BALANCE)/100*r/(COMISSION + p*smb.TickValue())), 2);
   
   if(l > SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX))l = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   if(l < SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN))l = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   return l;
}
//+------------------------------------------------------------------+
bool HLineCreate(const string          name="HLine",      // имя линии
                 double                price=0,           // цена линии 
                 const color           clr=clrRed,      // цвет линии 
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
   if(ObjectFind(ChartID(), name)!= -1)ObjectDelete(ChartID(), name);
   
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
//+------------------------------------------------------------------+
bool LineMove(const string name, const double price){
   ChartRedraw();
   return ObjectMove(0,name,0,0,price);
}