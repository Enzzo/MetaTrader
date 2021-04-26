
#include <Rails_v3.mqh>
#include <InsideBar.mqh>
#include <ExternalBar.mqh>
#include <Breakeven_persent.mqh>

Rs rs;
ExtBar eb;
InsBar ib;

R_inputs  R_inp;
EB_inputs EB_inp;
IB_inputs IB_inp;

input bool     rails          = false; //Рельсы (вкл)
input bool     inside         = false; //Внутренний бар (вкл)
input bool     external       = false; //Поглощение (вкл)
input string   comment0       = "";
input string   comment1       = "++++++++ РЕЛЬСЫ ++++++++";
input int      R_magic        = 323232;//магик для Rails
input ushort   expiration     = 4;     //время экспирации (часы)
input double   R_volume       = 0.1;   //объем
ushort   slippage     = 5;     //проскальзывание
input int      _sl            = 50;    //СЛ
input double   tp_mtp         = 1.61;  //множитель ТП
input double   vol_mtp        = 2.0;   //Множитель встречного объема
input ulong    pSeedPoints    = 1000;  //пункты для расчета рельс         
input ushort   cMinCandle     = 50;    //минимальная свеча (%)
input ushort   cMinBody       = 50;    //минимальное тело свечи (%)
input ushort   cMaxOffset     = 10;    //максимальный сдвиг относительно свечей (%)
input string   comment2       = "";
input string   comment3       = "++++++++ ВНУТРЕННИЙ БАР ++++++++";
input int      IB_magic       = 333333;//магик для Inside bar
//input session  open           = 6;     //открытие сессии
//input session  close          = 15;    //закрытие сессии
input double   IB_volume      = 0.01;  //объем
input int      MA_period      = 14;    //Период МА
input int      MA_shift       = 0;     //сдвиг МА
input string   comment4       = "";
input string   comment5       = "++++++++ ПОГЛОЩЕНИЕ ++++++++";
input int      EB_magic       = 3434343;//магик для поглощения
input int      EB_SL          = 25;    //не помню, что и как используется
input double   EB_volume      = 0.01;  //объем
input string   comment6       = "++++++++ БЕЗУБЫТОК ++++++++";
input ushort   cent           = 50;    //достижение цены для выставления БУ
input ushort   pts            = 5;     //уровень БУ

string pref = "Rail_";

//---------------------variables------------------------->
string symbol = Symbol();
ENUM_TIMEFRAMES period = PERIOD_CURRENT;


//------------------------------------------------------------------------
//                                OnInit()
//------------------------------------------------------------------------
int OnInit(){
      R_inp.magic       = R_magic;
      R_inp.symbol      = symbol;      
      R_inp.pSeedPoints = pSeedPoints;
      R_inp.cMinCandle  = cMinCandle;
      R_inp.vol_mtp     = vol_mtp;
      R_inp.cMinBody    = cMinBody;
      R_inp.cMaxOffset  = cMaxOffset;
      R_inp.slippage    = slippage;
      R_inp.volume      = R_volume;
      R_inp._sl         = _sl;
      R_inp.tp_mtp      = tp_mtp;
      R_inp.expire      = expiration;
      
      IB_inp.magic      = IB_magic;
      IB_inp.symbol     = symbol;
      IB_inp.period     = period;
      //IB_inp.oSession   = open;
      //IB_inp.cSession   = close;
      IB_inp.slippage   = slippage;
      IB_inp.volume     = IB_volume;
      IB_inp.MA_period  = MA_period;
      IB_inp.MA_shift   = MA_shift;
      
      EB_inp.magic      = EB_magic;
      EB_inp.symbol     = symbol;
      EB_inp.slippage   = slippage;
      EB_inp.SL         = EB_SL;
      EB_inp.period     = period;
      EB_inp.volume     = EB_volume;
      
      rs.Init(R_inp);
      ib.Init(IB_inp);
      eb.Init(EB_inp);
  
   return(INIT_SUCCEEDED);
}

//------------------------------------------------------------------------
//                                OnTick()
//------------------------------------------------------------------------
void OnTick(){
   if(rails)
      rs.Action();
   if(external)
      eb.Action();
   if(inside)
      ib.Action();
   Breakeven(cent, pts, symbol, IB_magic);
   return;
}


void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name;
   for(int i = 0; i<total; i++){
      name = pref+IntegerToString(i);
         if(ObjectFind(ChartID(), name)!= -1)
            ObjectDelete(ChartID(), name);

   }
}