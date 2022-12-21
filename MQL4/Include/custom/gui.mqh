//+------------------------------------------------------------------+
//|                                                          gui.mqh |
//|                                                           Sergey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Sergey"
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| GUIObject - абстрактный класс
//|                                                                  |
//| Представляет графический объект, содержащий дочерние графические |
//| объекты
//|  
//| Дочерние объекты имеют угол привязки, зависящий от родительского 
//| объекта
//| 
//+------------------------------------------------------------------+
class GUIObject{
   string      _label;                    // наименование объекта
   int         _x_position, _y_position,  // позиция объекта относительно родительского объекта, либо глобального окна, если это родитель
               _width, _height;           // ширина, высота (для текстовой метки тоже задаётся)
   int         _subobjects_count;         // количество дочерних объектов
   
   ENUM_OBJECT _object;                   
   GUIObject   _subobject[];

public:
   
   ~GUIObject(){
      for(int i = 0; i < _subobjects_count; ++i){
         _subobject[i].Delete();
      }
      this.Delete();
   }
   
   virtual void Delete(){
      if(ObjectFind(ChartID(), GetLabel()) != -1){
         ObjectDelete(ChartID(),GetLabel());
      }
   }
   
private:
   void SetLabel(const string label){
      _label = label;
   }
   
   virtual const string GetLabel() const {
      return _label;
   }
};

//+------------------------------------------------------------------+
//| 
//|                                                                  |
//| 
//| 
//+------------------------------------------------------------------+
class RectLabelObject : public GUIObject{
   string _id, _label;
   int _x, _y;
   int _w, _h;
   ENUM_BORDER_TYPE _border;
   color _color;
   ENUM_BASE_CORNER _corner;
   
public:
   RectLabelObject(){
      _id = IntegerToString(TimeCurrent());
   };
      
   ~RectLabelObject(){
      Delete();
   }
   
   void SetProps(const string label,
                 const int x,
                 const int y,
                 const int width,
                 const int height,
                 const color clr,
                 const ENUM_BORDER_TYPE border,
                 const ENUM_BASE_CORNER corner);
   void Redraw();
   
private:
   // void Delete() override;
   void Create();
   string const GetLabel() const override{
      return _label;
   }
};

void RectLabelObject::SetProps(  const string label,
                                 const int x,
                                 const int y,
                                 const int width,
                                 const int height,
                                 const color clr,
                                 const ENUM_BORDER_TYPE border,
                                 const ENUM_BASE_CORNER corner){
                                 
   Delete();
   
   _label = label + _id;
   _x = (corner == 1 || corner == 3) ? x + width : x;
   _y = (corner == 2 || corner == 3) ? y + height : y;
   _w = width;
   _h = height;
   _color = clr;
   _border = border;
   _corner = corner;
}

void RectLabelObject::Redraw(void){
   if(ObjectFind(ChartID(), _label) == -1){
      Create();
   }
}

//void RectLabelObject::Delete(void){
//   if(ObjectFind(ChartID(), _label) != -1){
//      ObjectDelete(_label);
//   }
//}

void RectLabelObject::Create(void){
   RectLabelCreate(_label, _x, _y, _w, _h, _color, _border, _corner, _color);
}

//--------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------
class TextLabelObject : public GUIObject{
public:
   TextLabelObject(const string label);
};

TextLabelObject::TextLabelObject(const string label){

}

class BitmabObject : public GUIObject{
   
};

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