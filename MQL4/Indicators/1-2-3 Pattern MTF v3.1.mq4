//+------------------------------------------------------------------+
//|                                                    1-2-3 Pattern |
//|                         Copyright © 2008 Kirill, Barry_Stander_4 |
//|               StockProgrammer@mail.ru, Barry_Stander_4@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008 Kirill, Barry_Stander_4"
#property link      "StockProgrammer@mail.ru, Barry_Stander_4@yahoo.com"

#property  indicator_chart_window
#property  indicator_buffers 8
#property  indicator_color1  Black
#property  indicator_color2  Black
#property  indicator_color3  Black
#property  indicator_color4  Black
#property  indicator_color5  Black
#property  indicator_color6  Black
#property  indicator_color7  Black
#property  indicator_color8  Black


extern   int      period       =  0;       //период для расчёта. Не может быть меньше периода графика.
extern   int      LineWidth = 3;
extern   int      Hi_Low_Mode = 1;
extern   int      Fibo_Mode = 1;
extern   int      Enable_Target = 1;
extern   double   Fibo_Target = 1.618;
int      var_116 = 200;
double   var_120;
double   var_128;
double   arr_136[5];
double   arr_140[5];
double   arr_144[5];
double   arr_148[5];
string   var_152;
int      var_160;
int      var_164;
int      var_168;
int      var_172;
int      var_176;
int      var_180;
int      var_184;
int      var_188;
int      var_192;
int      var_196;
extern   color    Pattern_High = Blue;
extern   color    TradeLine_High = Red;
extern   color    Pattern_Low = Yellow;
extern   color    TradeLine_Low = Green;
extern   color    Fibo = Black;
double   var_220;
double   var_228;
double   var_236;
double   var_244;
int      var_252 = 5;
int      var_256 = 0;
double   arr_260[];
double   arr_264[];
double   arr_268[];
double   arr_272[];
double   arr_276[];
double   arr_280[];
double   arr_284[];
double   arr_288[];
double   var_292 = 0;
double   var_300 = 0;
double   var_308 = 0;
double   var_316 = 0;

string name;
//+------------------------------------------------------------------+

int init()
{
name = WindowExpertName();

var_152 = "1-2-3 Pattern";
IndicatorShortName(var_152);
SetIndexLabel(0,var_152);
IndicatorBuffers(8);
SetIndexStyle(0,DRAW_NONE);
SetIndexStyle(1,DRAW_NONE);
SetIndexStyle(2,DRAW_NONE);
SetIndexStyle(3,DRAW_NONE);
SetIndexStyle(4,DRAW_NONE);
SetIndexStyle(5,DRAW_NONE);
SetIndexStyle(6,DRAW_NONE);
SetIndexStyle(7,DRAW_NONE);
SetIndexLabel(0,"Stop");
SetIndexLabel(1,"Enter");
SetIndexLabel(2,"Trade_Down");
SetIndexLabel(3,"Stop");
SetIndexLabel(4,"Enter");
SetIndexLabel(5,"Trade_UP");
SetIndexLabel(6,"D_Retrace");
SetIndexLabel(7,"U_Retrace");
SetIndexBuffer(0,arr_260);
SetIndexBuffer(1,arr_264);
SetIndexBuffer(2,arr_268);
SetIndexBuffer(3,arr_272);
SetIndexBuffer(4,arr_276);
SetIndexBuffer(5,arr_280);
SetIndexBuffer(6,arr_284);
SetIndexBuffer(7,arr_288);
SetIndexDrawBegin(0,0);
SetIndexDrawBegin(1,0);
SetIndexDrawBegin(2,0);
SetIndexDrawBegin(3,0);
SetIndexDrawBegin(4,0);
SetIndexDrawBegin(5,0);
SetIndexDrawBegin(6,0);
SetIndexDrawBegin(7,0);
DeleteObj();
}

//+------------------------------------------------------------------+

int deinit()
{
DeleteObj();
}

//+------------------------------------------------------------------+

int DeleteObj()
{
int var_DeleteObj_0;

ObjectDelete("HH0" + DoubleToStr(period, 0));
ObjectDelete("LL0" + DoubleToStr(period, 0));
ObjectDelete("HH1" + DoubleToStr(period, 0));
ObjectDelete("HH2" + DoubleToStr(period, 0));
ObjectDelete("HH3" + DoubleToStr(period, 0));
ObjectDelete("LL1" + DoubleToStr(period, 0));
ObjectDelete("LL2" + DoubleToStr(period, 0));
ObjectDelete("LL3" + DoubleToStr(period, 0));
ObjectDelete("EntryL" + DoubleToStr(period, 0));
ObjectDelete("TargetL" + DoubleToStr(period, 0));
ObjectDelete("TargetP" + DoubleToStr(period, 0));
ObjectDelete("EntryH" + DoubleToStr(period, 0));
ObjectDelete("TargetH" + DoubleToStr(period, 0));
return(0);
}

//+------------------------------------------------------------------+
bool alertflag = 0;
int start()
{

if(period == Period() || period == 0)
{
   alertflag = 0;

   double var_start_0;
   double var_start_8;
   int    i;
   int    var_start_20;
   int    counted_bars;
   double spread;
   double var_start_36;
   int    var_start_44;
   double var_start_48;
   int    var_start_56;
   double var_start_60;
   int    var_start_68;
   double var_start_72;
   int    var_start_80;
   double var_start_84;
   double var_start_92;
   double var_start_100;
   double var_start_108;
   double var_start_116;
   double var_start_124;


   counted_bars = IndicatorCounted();
   if (counted_bars < 0) return(-1);

   spread = MarketInfo(Symbol(),MODE_SPREAD);
   if (spread == 0.0) spread = (Ask - Bid) / Point;

   var_192 = 0;
   var_196 = 0;
   DeleteObj();

   for (i = var_116; i >= 0; i--)
      {
      if (Hi_Low_Mode == 1)
         {
         var_120 = iFractals(NULL,0,MODE_UPPER,i);
         if (var_120 > 0.0)
            {
            arr_136[1] = arr_136[3];
            arr_136[3] = var_120;
            arr_140[1] = arr_140[3];
            arr_140[3] = i;
            arr_140[2] = Lowest(NULL,0,MODE_LOW,arr_140[1] - arr_140[3] - 1.0,arr_140[3] + 1.0);
            arr_136[2] = Low[Lowest(NULL,0,MODE_LOW,arr_140[1] - arr_140[3] - 1.0,arr_140[3] + 1.0)];
            arr_140[4] = arr_140[3] - (arr_140[1] - arr_140[2]);
            if (arr_140[4] < 0.0) arr_140[4] = 0;
            arr_136[4] = arr_136[2];
            }
         var_128 = iFractals(NULL,0,MODE_LOWER,i);
         if (var_128 > 0.0)
            {
            arr_144[1] = arr_144[3];
            arr_144[3] = var_128;
            arr_148[1] = arr_148[3];
            arr_148[3] = i;
            arr_148[2] = Highest(NULL,0,MODE_HIGH,arr_148[1] - arr_148[3] - 1.0,arr_148[3] + 1.0);
            arr_144[2] = High[Highest(NULL,0,MODE_HIGH,arr_148[1] - arr_148[3] - 1.0,arr_148[3] + 1.0)];
            arr_148[4] = arr_148[3] - (arr_148[1] - arr_148[2]);
            if (arr_148[4] < 0.0) arr_148[4] = 0;
            arr_144[4] = arr_144[2];
            }
         }
      if (Hi_Low_Mode == 2)
         {
         if ((High[i - 1] < High[i]) && (High[i - 2] < High[i]) && (High[i - 2] < High[i - 1]) && (High[i + 1] < High[i]) && (High[i + 2] < High[i]) && (High[i + 2] < High[i + 1]))
            {
            arr_136[1] = arr_136[3];
            arr_136[3] = High[i];
            arr_140[1] = arr_140[3];
            arr_140[3] = i;
            arr_140[2] = Lowest(NULL,0,MODE_LOW,arr_140[1] - arr_140[3] - 1.0,arr_140[3] + 1.0);
            arr_136[2] = Low[Lowest(NULL,0,MODE_LOW,arr_140[1] - arr_140[3] - 1.0,arr_140[3] + 1.0)];
            arr_140[4] = arr_140[3] - (arr_140[1] - arr_140[2]);
            if (arr_140[4] < 0.0) arr_140[4] = 0;
            arr_136[4] = arr_136[2];
            }
         if ((Low[i - 1] > Low[i]) && (Low[i - 2] > Low[i]) && (Low[i - 2] > Low[i - 1]) && (Low[i + 1] > Low[i]) && (Low[i + 2] > Low[i]) && (Low[i + 2] > Low[i + 1]))
            {
            arr_144[1] = arr_144[3];
            arr_144[3] = Low[i];
            arr_148[1] = arr_148[3];
            arr_148[3] = i;
            arr_148[2] = Highest(NULL,0,MODE_HIGH,arr_148[1] - arr_148[3] - 1.0,arr_148[3] + 1.0);
            arr_144[2] = High[Highest(NULL,0,MODE_HIGH,arr_148[1] - arr_148[3] - 1.0,arr_148[3] + 1.0)];
            arr_148[4] = arr_148[3] - (arr_148[1] - arr_148[2]);
            if (arr_148[4] < 0.0) arr_148[4] = 0;
            arr_144[4] = arr_144[2];
            }
         }
      var_160 = arr_140[1];
      var_164 = arr_140[2];
      var_168 = arr_140[3];
      var_172 = arr_140[4];
      var_176 = arr_148[1];
      var_180 = arr_148[2];
      var_184 = arr_148[3];
      var_188 = arr_148[4];
      if ((arr_136[1] >= arr_136[3]) && (arr_136[1] > arr_136[2]))
         {
         ObjectDelete("HH0" + DoubleToStr(period, 0));
         ObjectDelete("LL0" + DoubleToStr(period, 0));
         ObjectDelete("HH1" + DoubleToStr(period, 0));
         ObjectDelete("HH2" + DoubleToStr(period, 0));
         ObjectDelete("HH3" + DoubleToStr(period, 0));
         ObjectDelete("LL1" + DoubleToStr(period, 0));
         ObjectDelete("LL2" + DoubleToStr(period, 0));
         ObjectDelete("LL3" + DoubleToStr(period, 0));
         ObjectDelete("EntryL" + DoubleToStr(period, 0));
         ObjectDelete("TargetL" + DoubleToStr(period, 0));
         ObjectDelete("EntryH" + DoubleToStr(period, 0)); 
         ObjectDelete("TargetH" + DoubleToStr(period, 0));
         ObjectDelete("TargetP" + DoubleToStr(period, 0));
         ObjectCreate("HH1" + DoubleToStr(period, 0) + var_start_20,OBJ_TREND,0,Time[var_160],arr_136[1],Time[var_164],arr_136[2]);
         ObjectCreate("HH2" + DoubleToStr(period, 0) + var_start_20,OBJ_TREND,0,Time[var_164],arr_136[2],Time[var_168],arr_136[3]);
         if ((High[Highest(NULL,0,MODE_HIGH,arr_140[1] - 1.0,1)] < arr_136[1]) && (arr_136[3] > Bid))
            {
            if (Fibo_Mode == 1) ObjectCreate("HH0" + DoubleToStr(period, 0),OBJ_FIBO,0,Time[var_164],arr_136[2],Time[var_160],arr_136[1]);
            if (Fibo_Mode == 2) ObjectCreate("HH0" + DoubleToStr(period, 0),OBJ_EXPANSION,0,Time[var_160],arr_136[1],Time[var_164],arr_136[2],Time[var_168],arr_136[3]);
            ObjectCreate("HH1" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_160],arr_136[1],Time[var_164],arr_136[2]);
            ObjectCreate("HH2" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_164],arr_136[2],Time[var_168],arr_136[3]);
            ObjectCreate("HH3" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_168],arr_136[3],Time[var_172],arr_136[4]);
            if (Fibo_Mode == 1)
               {
               var_start_8 = arr_136[1] - arr_136[2];
               if (arr_136[3] > NormalizeDouble(arr_136[2] + var_start_8 * 0.764,4))
                  {
                  var_228 = NormalizeDouble(arr_136[2] - var_start_8 * 0.0,4);
                  }
               if ((arr_136[3] <= NormalizeDouble(arr_136[2] + var_start_8 * 0.764,4)) && (arr_136[3] > NormalizeDouble(arr_136[2] + var_start_8 * 0.618,4)))
                  {
                  var_228 = NormalizeDouble(arr_136[2] - var_start_8 * 0.27,4);
                  }
               if (arr_136[3] <= NormalizeDouble(arr_136[2] + var_start_8 * 0.618,4))
                  {
                  var_228 = NormalizeDouble(arr_136[2] - var_start_8 * 0.618,4);
                  }
               }
            if (Fibo_Mode == 2) var_228 = MathAbs(Fibo_Target * (arr_136[1] - arr_136[2]) - arr_136[3]);
            var_236 = var_228 + (spread + 2.0) * Point;
            if ((var_228 < arr_136[2]) && (arr_136[2] - var_236 >= var_252 * Point) && (Enable_Target == 1))
               {
               ObjectCreate("EntryH" + DoubleToStr(period, 0),OBJ_HLINE,0,0,arr_136[2] - Point * 1.0);
               ObjectCreate("TargetH" + DoubleToStr(period, 0),OBJ_HLINE,0,0,var_236);
               ObjectCreate("TargetP" + DoubleToStr(period, 0),OBJ_TEXT,0,CurTime() + 100,0);
               ObjectSetText("TargetP" + DoubleToStr(period, 0),DoubleToStr((arr_136[2] - Point * 1.0 - var_236) / Point,0),10,"Arial",Blue);
               ObjectMove("TargetP" + DoubleToStr(period, 0),0,CurTime() + Period() * 100,var_236);
               }
            }
         }
      if ((arr_144[1] <= arr_144[3]) && (arr_144[1] < arr_144[2]))
         {
         ObjectDelete("HH0" + DoubleToStr(period, 0));
         ObjectDelete("LL0" + DoubleToStr(period, 0));
         ObjectDelete("HH1" + DoubleToStr(period, 0));
         ObjectDelete("HH2" + DoubleToStr(period, 0));
         ObjectDelete("HH3" + DoubleToStr(period, 0));
         ObjectDelete("LL1" + DoubleToStr(period, 0));
         ObjectDelete("LL2" + DoubleToStr(period, 0));
         ObjectDelete("LL3" + DoubleToStr(period, 0));
         ObjectDelete("EntryH" + DoubleToStr(period, 0));
         ObjectDelete("TargetH" + DoubleToStr(period, 0));
         ObjectDelete("EntryL" + DoubleToStr(period, 0));
         ObjectDelete("TargetL" + DoubleToStr(period, 0));
         ObjectDelete("TargetP" + DoubleToStr(period, 0));
         ObjectCreate("LL1" + DoubleToStr(period, 0) + var_start_20,OBJ_TREND,0,Time[var_176],arr_144[1],Time[var_180],arr_144[2]);
         ObjectCreate("LL2" + DoubleToStr(period, 0) + var_start_20,OBJ_TREND,0,Time[var_180],arr_144[2],Time[var_184],arr_144[3]);
         if ((Low[Lowest(NULL,0,MODE_LOW,arr_148[1] - 1.0,1)] > arr_144[1]) && (arr_144[3] < Bid))
            {
            if (Fibo_Mode == 1) ObjectCreate("LL0" + DoubleToStr(period, 0),OBJ_FIBO,0,Time[var_180],arr_144[2],Time[var_176],arr_144[1]);
            if (Fibo_Mode == 2) ObjectCreate("LL0" + DoubleToStr(period, 0),OBJ_EXPANSION,0,Time[var_176],arr_144[1],Time[var_180],arr_144[2]);
            ObjectCreate("LL1" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_176],arr_144[1],Time[var_180],arr_144[2]);
            ObjectCreate("LL2" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_180],arr_144[2],Time[var_184],arr_144[3]);
            ObjectCreate("LL3" + DoubleToStr(period, 0),OBJ_TREND,0,Time[var_184],arr_144[3],Time[var_188],arr_144[4]);
            if (Fibo_Mode == 1)
               {
               var_start_0 = (arr_144[2] - arr_144[1]) / 100.0;
               if (arr_144[3] < NormalizeDouble(arr_144[2] - var_start_0 * 76.4,4))
                  {
                  var_220 = NormalizeDouble(arr_144[2] + var_start_0 * 0.0,4);
                  }
               if ((arr_144[3] >= NormalizeDouble(arr_144[2] - var_start_0 * 76.4,4)) && (arr_144[3] < NormalizeDouble(arr_144[2] - var_start_0 * 61.8,4)))
                  {
                  var_220 = NormalizeDouble(arr_144[2] + var_start_0 * 27.0,4);
                  }
               if (arr_144[3] >= NormalizeDouble(arr_144[2] - var_start_0 * 61.8,4))
                  {
                  var_220 = NormalizeDouble(arr_144[2] + var_start_0 * 61.8,4);
                  }
               }
            if (Fibo_Mode == 2) var_220 = MathAbs(Fibo_Target * (arr_144[2] - arr_144[1]) + arr_144[3]);
            var_220 = var_220 - 2 * Point;
            var_244 = arr_144[2] + (spread + 1.0) * Point;
            if ((var_220 > var_244) && (var_220 - arr_144[2] >= var_252 * Point) && (Enable_Target == 1))
               {
               ObjectCreate("EntryL" + DoubleToStr(period, 0),OBJ_HLINE,0,0,var_244);
               ObjectCreate("TargetL" + DoubleToStr(period, 0),OBJ_HLINE,0,0,var_220);
               ObjectCreate("TargetP" + DoubleToStr(period, 0),OBJ_TEXT,0,CurTime() + 100,0);
               ObjectSetText("TargetP" + DoubleToStr(period, 0),DoubleToStr((var_220 - var_244) / Point,0),10,"Arial",Red);
               ObjectMove("TargetP" + DoubleToStr(period, 0),0,CurTime() + Period() * 200,var_220);
               }
            }
         }
      var_start_36 = ObjectGet("HH1" + DoubleToStr(period, 0),OBJPROP_PRICE1);
      var_start_44 = ObjectGet("HH1" + DoubleToStr(period, 0),OBJPROP_TIME1);
      var_start_48 = ObjectGet("HH1" + DoubleToStr(period, 0),OBJPROP_PRICE2);
      var_start_56 = ObjectGet("HH1" + DoubleToStr(period, 0),OBJPROP_TIME2);
      var_start_60 = ObjectGet("LL1" + DoubleToStr(period, 0),OBJPROP_PRICE1);
      var_start_68 = ObjectGet("LL1" + DoubleToStr(period, 0),OBJPROP_TIME1);
      var_start_72 = ObjectGet("LL1" + DoubleToStr(period, 0),OBJPROP_PRICE2);
      var_start_80 = ObjectGet("LL1" + DoubleToStr(period, 0),OBJPROP_TIME2);
      var_start_84 = ObjectGet("HH2" + DoubleToStr(period, 0),OBJPROP_PRICE2);
      var_start_92 = ObjectGet("LL2" + DoubleToStr(period, 0),OBJPROP_PRICE2);
      arr_260[i] = var_start_36;
      arr_264[i] = var_start_48;
      arr_272[i] = var_start_60;
      arr_276[i] = var_start_72;
      arr_284[i] = var_start_84;
      arr_288[i] = var_start_92;
      if ((var_start_44 > 0) && (var_start_56 > 0))
         {
         var_start_100 = (CurTime() - var_start_44) / 60 / Period();
         var_start_108 = arr_264[i] + (arr_264[i] - arr_260[i]) / 2;
         if (var_start_100 < 1.0) var_start_100 = 1;
         var_300 = High[Highest(NULL,0,MODE_HIGH,var_start_100,0)];
         var_292 = Low[Lowest(NULL,0,MODE_LOW,var_start_100,0)];
         }
            else
         {
         var_292 = 0;
         var_300 = 0;
         }
      if ((var_start_68 > 0) && (var_start_80 > 0))
         {
         var_start_116 = (CurTime() - var_start_68) / 60 / Period();
         var_start_124 = arr_276[i] + (arr_276[i] - arr_272[i]) / 2;
         if (var_start_116 < 1.0) var_start_116 = 1;
         var_316 = High[Highest(NULL,0,MODE_HIGH,var_start_116,0)];
         var_308 = Low[Lowest(NULL,0,MODE_LOW,var_start_116,0)];
         }
            else
         {
         var_308 = 0;
         var_316 = 0;
         }
      if ((var_292 <= arr_260[i]) && (var_300 >= arr_264[i]) && (arr_260[i] > 0) && (arr_264[i] > 0) && (var_292 > var_start_108))
         {
         arr_268[i] = 1;
         var_192 = 1;
         }
            else
         {
         arr_268[i] = 0;
         var_192 = 0;
         }
      if ((var_308 >= arr_272[i]) && (var_316 <= arr_276[i]) && (arr_272[i] > 0) && (arr_276[i] > 0) && (var_308 < var_start_124))
         {
         arr_280[i] = 1;
         var_196 = 1;
         }
            else
         {
         arr_280[i] = 0;
         var_196 = 0;
         }
      ObjectSet("HH0" + DoubleToStr(period, 0),OBJPROP_COLOR,Fibo);
      ObjectSet("LL0" + DoubleToStr(period, 0),OBJPROP_COLOR,Fibo);
      ObjectSet("HH0" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("LL0" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("HH0" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      ObjectSet("LL0" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      ObjectSet("HH1" + DoubleToStr(period, 0),OBJPROP_COLOR,Pattern_High);
      ObjectSet("HH2" + DoubleToStr(period, 0),OBJPROP_COLOR,Pattern_High);
      ObjectSet("HH3" + DoubleToStr(period, 0),OBJPROP_COLOR,TradeLine_High);
      ObjectSet("LL1" + DoubleToStr(period, 0),OBJPROP_COLOR,Pattern_Low);
      ObjectSet("LL2" + DoubleToStr(period, 0),OBJPROP_COLOR,Pattern_Low);
      ObjectSet("LL3" + DoubleToStr(period, 0),OBJPROP_COLOR,TradeLine_Low);
      ObjectSet("HH1" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("HH2" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("HH3" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("LL1" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("LL2" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("LL3" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("HH0" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("HH1" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("HH2" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("HH3" + DoubleToStr(period, 0),OBJPROP_RAY,1);
      ObjectSet("LL0" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("LL1" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("LL2" + DoubleToStr(period, 0),OBJPROP_RAY,0);
      ObjectSet("LL3" + DoubleToStr(period, 0),OBJPROP_RAY,1);
      ObjectSet("HH1" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("HH2" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("HH3" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("LL1" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("LL2" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("LL3" + DoubleToStr(period, 0),OBJPROP_WIDTH,LineWidth);
      ObjectSet("EntryH" + DoubleToStr(period, 0),OBJPROP_COLOR,Blue);
      ObjectSet("EntryL" + DoubleToStr(period, 0),OBJPROP_COLOR,Blue);
      ObjectSet("EntryH" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DASHDOTDOT);
      ObjectSet("EntryL" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DASHDOTDOT);
      ObjectSet("EntryH" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      ObjectSet("EntryL" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      ObjectSet("TargetH" + DoubleToStr(period, 0),OBJPROP_COLOR,Blue);
      ObjectSet("TargetL" + DoubleToStr(period, 0),OBJPROP_COLOR,Blue);
      ObjectSet("TargetH" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DASHDOTDOT);
      ObjectSet("TargetL" + DoubleToStr(period, 0),OBJPROP_STYLE,STYLE_DASHDOTDOT);
      ObjectSet("TargetH" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      ObjectSet("TargetL" + DoubleToStr(period, 0),OBJPROP_WIDTH,0);
      if (var_start_20 < 6)
         {
         ObjectDelete("HH1" + DoubleToStr(period, 0) + var_start_20);
         ObjectDelete("HH2" + DoubleToStr(period, 0) + var_start_20);
         ObjectDelete("HH3" + DoubleToStr(period, 0) + var_start_20);
         ObjectDelete("LL1" + DoubleToStr(period, 0) + var_start_20);
         ObjectDelete("LL2" + DoubleToStr(period, 0) + var_start_20);
         ObjectDelete("LL3" + DoubleToStr(period, 0) + var_start_20);
         }
      ObjectDelete("HH1" + DoubleToStr(period, 0) + var_start_20);
      ObjectDelete("HH2" + DoubleToStr(period, 0) + var_start_20);
      ObjectDelete("HH3" + DoubleToStr(period, 0) + var_start_20);
      ObjectDelete("LL1" + DoubleToStr(period, 0) + var_start_20);
      ObjectDelete("LL2" + DoubleToStr(period, 0) + var_start_20);
      ObjectDelete("LL3" + DoubleToStr(period, 0) + var_start_20);
      if ((var_120 > 0) || (var_128 > 0)) var_start_20++;
      }
   if (Seconds() < 10) var_256 = 0;
}

else if(period < Period() && period != 0)
{
   if(alertflag == 0) {Alert("Parameter \"period\" is less than period of current graph. Please enter different period"); alertflag = 1;}
   return(0);
}

else     //тут начинается МОЗГ !
{
   alertflag = 0;
   
   datetime period_time_0;   
   int error = 0;
   static bool alerted = 0;

   period_time_0 = iTime(NULL, period, 0);
   error=GetLastError();
   if(alerted==0 && error==4066)
   {
      Alert("Error 4066: Data for period = ", period, " not loaded. Loading data... Indicator will be redrawn as soon as data is loaded.");
      alerted = 1;
   }
      
   iCustom(NULL, period, name, period, LineWidth, Hi_Low_Mode, Fibo_Mode, Enable_Target, Fibo_Target, 0, 0);  

}

}