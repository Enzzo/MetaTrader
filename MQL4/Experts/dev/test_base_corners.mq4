//+------------------------------------------------------------------+
//|                                            test_base_corners.mq4 |
//|                                                           Sergey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <custom/gui.mqh>

GUI_Object obj;

string pref = "test_corner";

input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   RectLabelCreate(pref, 60, 60, 50, 50, clrRed, 2, CORNER);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   ObjectsDelete();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   
}
//+------------------------------------------------------------------+

//Удаляет все объекты, используемые этим советником
// ot = общее количество всех объектов
// on = имя объекта
void ObjectsDelete(){
   int ot = ObjectsTotal();
   string on = "";
   if(ot > 0){
      for(int i = ot-1; i>=0; i--){
         on = ObjectName(ChartID(), i);
         if(StringFind(on, pref)!= -1) ObjectDelete(ChartID(), on);
      }
   }
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