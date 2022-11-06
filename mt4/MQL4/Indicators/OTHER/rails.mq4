//+------------------------------------------------------------------+
//|                                                        rails.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input ushort min_candle       = 50;    //минимальная длина свечи
input ushort min_body_percent = 20;    //минимальный объем тела в процентах
input ushort offset           = 20;    //сдвиг свечей относительно друг друга

long     chart_ID;
double   nCandle;       //минимальная длина свечи, переведенная в пункты
double   nOffset;       //сдвиг свечей в пунктах
ushort   bars;          //количество баров для поиска рельсов
datetime lTime;         //для определения нового бара
ushort   type;          //направление
datetime time1;         //координаты прямоугольника
datetime time2;         //координаты прямоугольника
double   price1;        //координаты прямоугольника
double   price2;        //координаты прямоугольника

bool isNewRails(int i){
   /*if(i<2)
      return false;*/
   //nMinCandle  = 0;
   //nOffset     = 0;
   double lBody   = 0;
   double rBody   = 0;
   double lCandle = 0;
   double rCandle = 0;
   
   /*
   if(nMinCandle == 0 && nOffset == 0){
   	nMinCandle = NormalizeDouble((min_candle*Point()),Digits());
   	nOffset = NormalizeDouble((offset*Point()),Digits());
   }
   */
   type = 0;	//none
   
   //размеры тел свечей для рельсов
   if(Close[i] < Open[i] && Close[i+1] > Open[i+1]){
   	type = 2; //down
   	rBody = NormalizeDouble(Open[i] - Close[i],Digits());
   	lBody = NormalizeDouble(Close[i+1] - Open[i+1],Digits());
   }   
   else if(Open[i] < Close[i] && Close[i+1] < Open[i+1]){
   	type = 1; //up
   	rBody = NormalizeDouble(Close[i] - Open[i],Digits());
   	lBody = NormalizeDouble(Open[i+1] - Close[i+1],Digits());
   }
   else
      return false;   
   //размеры свечей общие для рельсов
   rCandle = NormalizeDouble(High[i] - Low[i],Digits());
   lCandle = NormalizeDouble(High[i+1] - Low[i+1],Digits());
   
   if(lCandle == 0 || rCandle == 0)
      return false;
   //пригодность свечей для рельсов
   if(rCandle < nCandle)
   	return false;	//no rails
   if(lCandle < nCandle)
   	return false;	//no rails
   //определяем размер тела
   if((int)(rBody*100/rCandle) < min_body_percent)
   	return false;	//no rails
   if((int)(lBody*100/lCandle) < min_body_percent)
   	return false;	//no rails
   
   //определяем расстояние между пределами двух свечей
   if((High[i] > (High[i+1] + nOffset)) || (High[i] < (High[i+1] - nOffset)))
   	return false;	//no rails
   if((Low[i] > (Low[i+1] + nOffset)) || (Low[i] < (Low[i+1] - nOffset)))
   	return false;	//no rails
   
   if(High[i] > High[i+1])
      price1 = NormalizeDouble(High[i],Digits());
   else
      price1 = NormalizeDouble(High[i+1],Digits());
   
   if(Low[i] < Low[i+1])
      price2 = NormalizeDouble(Low[i],Digits());
   else
      price2 = NormalizeDouble(Low[i+1],Digits());
   time1    = Time[i+1];
   time2    = Time[i];
   
   return true;
};

void DrawRails(){
   static uint n = 0;
   string name = "rails_"+IntegerToString(n);
   long clr = 0;
   
   switch(type){
      case  1: n++; clr = clrBlue; break; //up
      case  2: n++; clr = clrRed; break; //down
      default: return;
   }
   //Print(name,": time1 = ",time1," time2 = ",time2," price1 = ",price1, " price2 = ",price2);
   ObjectCreate(chart_ID, name, OBJ_RECTANGLE, 0, time1, price1, time2, price2);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
};

int OnInit(){
   chart_ID = ChartID();
   bars  = 0;
   lTime = 0;
   nCandle = NormalizeDouble(min_candle*Point(),Digits());
   nOffset = NormalizeDouble(offset  *  Point(),Digits());
   return(INIT_SUCCEEDED);
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
   
   if(lTime == 0)
      for(int i = rates_total-2; i > 0; i--)
         if(isNewRails(i))
            DrawRails(); 
            
   if(lTime == time[0])
      return rates_total;
       
   lTime = time[0];
   
   if(isNewRails(1))
      DrawRails();
   
   return(rates_total);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name;
   for(int i = 0; i<total; i++){
      name = "rails_"+IntegerToString(i);
         if(ObjectFind(chart_ID, name)!= -1)
            ObjectDelete(chart_ID, name);

   }
}