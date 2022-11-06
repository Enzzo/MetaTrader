
#include <Rails_v3.mqh>

Rs rs;
R_inputs  R_inp;

int            R_magic        = 0;     //магик для Rails
input ushort   expiration     = 4;     //время экспирации (часы)
input double   R_volume       = 0.1;   //объем
input ushort   R_slippage     = 5;     //проскальзывание
input int      _sl            = 50;    //СЛ
input double   tp_mtp         = 1.61;  //множитель ТП
input double   vol_mtp        = 2.0;   //Множитель встречного объема
input ulong    pSeedPoints    = 1000;  //пункты для расчета рельс         
input ushort   cMinCandle     = 50;    //минимальная свеча в процентах
input ushort   cMinBody       = 50;    //минимальное тело свечи в процентах
input ushort   cMaxOffset     = 10;    //максимальный сдвиг относительно свечей

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
      R_inp.slippage    = R_slippage;
      R_inp.volume      = R_volume;
      R_inp._sl         = _sl;
      R_inp.tp_mtp      = tp_mtp;
      R_inp.expire      = expiration;
      
      rs.Init(R_inp);
  
   return(INIT_SUCCEEDED);
}

//------------------------------------------------------------------------
//                                OnTick()
//------------------------------------------------------------------------
void OnTick(){
   rs.Action();
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