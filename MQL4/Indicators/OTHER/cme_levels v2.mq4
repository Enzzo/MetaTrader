//+------------------------------------------------------------------+
//|                                                   cme_levels.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window

input color  callColor = clrBlue;         //Цвет      уровня CALL
input ushort callWidth = 6;               //Ширина уровня CALL
input color  putColor  = clrDarkOrange;   //Цвет      уровня PUT
input ushort putWidth  = 6;               //Ширина уровня PUT
input color  posColor  = clrGreen;        //Цвет      уровня наброса позиций
input ushort posWidth  = 2;               //Ширина уровня наброса позиций
input color  negColor  = clrRed;          //Цвет      уровня сброса позиций
input ushort negWidth  = 2;               //Ширина уровня сброса позиций
input color  ftsColor  = clrMediumOrchid; //Цвет      уровня FUTURES
input ushort ftsWidth  = 2;               //Ширина уровня FUTURES
input color  strkColor = clrTurquoise     ;//Цвет      уровня STRIKE
input ushort strkWidth = 3;               //Ширина уровня STRIKE

string smb[] = {"AUD","CAD","CHF","EUR","GBP","JPY","RUB","USD","XAU","XAG"};
string indName = "Line ";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   BorderCreate(0, "RECT", 0, 150, 100, 150, 100, clrSilver, 2, CORNER_RIGHT_LOWER, clrBlue);
   ButtonCreate(0, "FTRS", 0, 50,  90,  40,  25,  CORNER_RIGHT_LOWER, "FTRS", "Arial", 10, clrBlack, ftsColor,     clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "STRK", 0, 50,  60,  40,  25,  CORNER_RIGHT_LOWER, "STRK", "Arial", 10, clrBlack, strkColor,    clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "PUT",  0, 95,  90,  40,  25,  CORNER_RIGHT_LOWER, "PUT",  "Arial", 10, clrBlack, putColor,     clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "NEG",  0, 95,  60,  40,  25,  CORNER_RIGHT_LOWER, "NEG",  "Arial", 10, clrBlack, negColor,     clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "CALL", 0, 140, 90,  40,  25,  CORNER_RIGHT_LOWER, "CALL", "Arial", 10, clrBlack, callColor,    clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "POS",  0, 140, 60,  40,  25,  CORNER_RIGHT_LOWER, "POS",  "Arial", 10, clrBlack, posColor,     clrBlack, true, false, false, true, 0);
   ButtonCreate(0, "CLR",  0, 140, 30,  130, 25,  CORNER_RIGHT_LOWER, "ОЧИСТИТЬ", "Arial", 10, clrBlack, clrWhite, clrBlack, false, false, false, true, 0);   
//---
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
//---
   //Clear();
   ObjectDelete(0, "CALL");
   ObjectDelete(0, "PUT");
   ObjectDelete(0, "NEG");
   ObjectDelete(0, "POS");
   ObjectDelete(0, "FTRS");
   ObjectDelete(0, "STRK");
   ObjectDelete(0, "CLR");
   ObjectDelete(0, "RECT");
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
   if(ObjectGetInteger(0, "CALL", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "CALL", OBJPROP_COLOR, clrYellow);
      Refresh("CALL");        
   }
   if(ObjectGetInteger(0, "CALL", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "CALL", OBJPROP_COLOR, clrBlack);
      Clear("CALL");
   } 
   
   if(ObjectGetInteger(0, "PUT", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "PUT", OBJPROP_COLOR, clrYellow);
      Refresh("PUT");
   }
   if(ObjectGetInteger(0, "PUT", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "PUT", OBJPROP_COLOR, clrBlack);
      Clear("PUT");
   } 
   
   if(ObjectGetInteger(0, "NEG", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "NEG", OBJPROP_COLOR, clrYellow);
      Refresh("NEG");      
   }
   if(ObjectGetInteger(0, "NEG", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "NEG", OBJPROP_COLOR, clrBlack);
      Clear("NEG");
   } 
   
   if(ObjectGetInteger(0, "POS", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "POS", OBJPROP_COLOR, clrYellow);
      Refresh("POS");
   }
   if(ObjectGetInteger(0, "POS", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "POS", OBJPROP_COLOR, clrBlack);
      Clear("POS");
   } 
   if(ObjectGetInteger(0, "FTRS", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "FTRS", OBJPROP_COLOR, clrYellow);
      Refresh("FTRS");
   }   
   if(ObjectGetInteger(0, "FTRS", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "FTRS", OBJPROP_COLOR, clrBlack);
      Clear("FTRS");
   } 
   
   if(ObjectGetInteger(0, "STRK", OBJPROP_STATE) == false){
      ObjectSetInteger(0, "STRK", OBJPROP_COLOR, clrYellow);
      Refresh("STRK");
   }
   if(ObjectGetInteger(0, "STRK", OBJPROP_STATE) == true){
      ObjectSetInteger(0, "STRK", OBJPROP_COLOR, clrBlack);
      Clear("STRK");
   } 
     
   if(ObjectGetInteger(0, "CLR", OBJPROP_STATE) == true){
      //Clear();
      ObjectSetInteger(0, "CALL",OBJPROP_STATE, true);
      ObjectSetInteger(0, "PUT", OBJPROP_STATE, true);
      ObjectSetInteger(0, "POS", OBJPROP_STATE, true);
      ObjectSetInteger(0, "NEG", OBJPROP_STATE, true);
      ObjectSetInteger(0, "FTRS",OBJPROP_STATE, true);
      ObjectSetInteger(0, "STRK",OBJPROP_STATE, true);
      ObjectSetInteger(0, "CLR", OBJPROP_STATE, false);   
   }
   ChartRedraw();
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

void Refresh(string _s){
   //Clear();
   ChartRedraw();
   int fHandle = FileOpen("cme.csv", FILE_CSV|FILE_READ);
   string cell = "";
   string s    = "";
   string type = "";
   string date = "";
   int i = 0;
   if(fHandle != INVALID_HANDLE){
      while(!FileIsEnding(fHandle)){
         cell = FileReadString(fHandle);      
         if(isSymbol(cell)){
            s = cell;
            continue;
         }
         if(s == Symbol() && s != ""){
            if(isType(cell)){
               type = cell;
               continue;
            }
            DrawGrid(type, cell, _s);
         }
      }
   }
   else Print("ERROR");
   FileClose(fHandle);
   ChartRedraw();
}

void Clear(const string nm = ""){
   ChartRedraw();
   for(int i = ObjectsTotal()-1; i>= 0; i--){
      if(StringFind(ObjectName(ChartID(), i), indName) != -1){
         if(nm == "")ObjectDelete(ChartID(), ObjectName(ChartID(), i));
         else if(nm != "" && StringFind(ObjectName(ChartID(), i), nm) != -1)ObjectDelete(ChartID(), ObjectName(ChartID(), i));
      }
      ChartRedraw();
   }
   
}

bool isSymbol(string s){
   for(int i = 0; i < ArraySize(smb); i++){
      if(StringFind(s, smb[i]) != -1)return true;
   }
   return false;
}

bool isType(string t){
   if(t == "CALL" || t == "PUT" || t == "POS" || t == "NEG" || t == "FTRS" || t == "STRK")return true;
   return false;
}

void DrawGrid(string t, string l, string s){
   //cad, chf, jpy
   double level = StringToDouble(l);
   if(level == 0.0)return;
   bool reverse = false;
   string subName = "";
   if(StringFind(Symbol(), "CAD") != -1 || StringFind(Symbol(), "CHF") != -1 || StringFind(Symbol(), "JPY") != -1 || StringFind(Symbol(), "RUB") != -1){
      reverse = true;
      level = NormalizeDouble(1/level, Digits());

   };
   static   int    n = 0;
            color  clr;
            int    width;            
   
   if(t == "CALL" && s == "PUT" && reverse){
      subName = "PUT";
      clr = putColor;          
      width = putWidth;
   }
   else if(t == "PUT" && s == "CALL" && reverse){
      subName = "CALL";
      clr = callColor;
      width = callWidth;
   }
   else if(t == "CALL" && s == "CALL" && !reverse){
      subName = "CALL";
      clr = callColor;
      width = callWidth; 
   }
   else if(t == "PUT" && s == "PUT" && !reverse){
      subName = "PUT";
      clr = putColor;          
      width = putWidth;
   }   
   else if(t == "NEG" && t == s){
      subName = "NEG";
      clr = negColor; 
      width = negWidth;
   }
   else if(t == "POS" && t == s){
      subName = "POS";
      clr = posColor; 
      width = posWidth;
   }
   else if(t == "FTRS" && t == s){
      subName = "FTRS";
      clr = ftsColor; 
      width = ftsWidth;
   }
   else if(t == "STRK" && t == s){
      subName = "STRK";
      clr = strkColor; 
      width = strkWidth;
   }
   
   else return;   
   
   //PrevRedraw(subName);
   if(!ConsistLevel(subName, level)){
      ObjectCreate(ChartID(),     indName + "_"+subName+"_" + IntegerToString(n), OBJ_HLINE, 0, 0, level);
      ObjectSetInteger(ChartID(), indName + "_"+subName+"_" + IntegerToString(n), OBJPROP_COLOR, clr);
      ObjectSetInteger(ChartID(), indName + "_"+subName+"_" + IntegerToString(n), OBJPROP_WIDTH, width);
      ObjectSetInteger(ChartID(), indName + "_"+subName+"_" + IntegerToString(n), OBJPROP_SELECTABLE, false);
      ObjectSetInteger(ChartID(), indName + "_"+subName+"_" + IntegerToString(n), OBJPROP_BACK,true); 
   }
   n++;
}

bool ConsistLevel(string n, double l){
   if(ObjectsTotal()>0)
      for(int i = ObjectsTotal()-1; i>= 0; i--){
         if(StringFind(ObjectName(ChartID(), i), n) != -1)
            if(NormalizeDouble(ObjectGetDouble(ChartID(), ObjectName(ChartID(), i), OBJPROP_PRICE),Digits()) == NormalizeDouble(l,Digits()))return true;
      }   
   return false;
}

bool ButtonCreate(const long              chart_ID=0,               // ID графика 
                  const string            name="Button",            // имя кнопки 
                  const int               sub_window=0,             // номер подокна 
                  const int               x=5,                      // координата по оси X 
                  const int               y=80,                     // координата по оси Y 
                  const int               width=80,                 // ширина кнопки 
                  const int               height=25,                // высота кнопки 
                  const ENUM_BASE_CORNER  corner=CORNER_RIGHT_LOWER,// угол графика для привязки 
                  const string            text="Старт",             // текст 
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
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим кнопку 
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать кнопку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты кнопки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размер кнопки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим текст 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
//--- установим шрифт текста 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
//--- установим размер шрифта 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
//--- установим цвет текста 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим цвет границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- переведем кнопку в заданное состояние 
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state); 
//--- включим (true) или отключим (false) режим перемещения кнопки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
} 

bool BorderCreate(const long             chart_ID=0,               // ID графика 
                  const string           name="RectLabel",         // имя метки 
                  const int              sub_window=0,             // номер подокна 
                  const int              x=0,                      // координата по оси X 
                  const int              y=0,                      // координата по оси Y 
                  const int              width=50,                 // ширина 
                  const int              height=18,                // высота 
                  const color            back_clr=C'236,233,216',  // цвет фона 
                  const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // тип границы 
                  const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                  const color            clr=clrRed,               // цвет плоской границы (Flat) 
                  const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы 
                  const int              line_width=1,             // толщина плоской границы 
                  const bool             back=false,               // на заднем плане 
                  const bool             selection=false,          // выделить для перемещений 
                  const bool             hidden=true,              // скрыт в списке объектов 
                  const long             z_order=0)                // приоритет на нажатие мышью 
  { 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим прямоугольную метку 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать прямоугольную метку! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
//--- установим координаты метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- установим размеры метки 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- установим цвет фона 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- установим тип границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border); 
//--- установим угол графика, относительно которого будут определяться координаты точки 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- установим цвет плоской рамки (в режиме Flat) 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- установим стиль линии плоской рамки 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- установим толщину плоской границы 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- включим (true) или отключим (false) режим перемещения метки мышью 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- успешное выполнение 
   return(true); 
  } 