//---------------------includes------------------------->
#include <InsideBar.mqh>
#include <ExternalBar.mqh>
#include <Rails.mqh>
//#include <Breakeven_persent.mqh>

InsBar insBar;
ExtBar extBar;
Rs rs;

IB_inputs IB_inp;
EB_inputs EB_inp;
R_inputs  R_inp;

//----------------------inputs-------------------------->

string   noteIB         = "���������� ���";
int      IB_magic       = 1654;              //����� ��� IB
bool     InsideBar      = false;             //������������ ���������� ���
session  Open_Session   = h6;                //�������� ������
session  Close_Session  = h15;               //�������� ������
ushort   IB_TP          = 30;                //����������
ushort   IB_SL          = 30;                //��������
ushort   IB_slippage    = 5;                 //���������������
double   IB_volume      = 0.1;               //�����
string   noteMA         = "��������� ��� MA";
int      MA_period      = 13;
int      MA_shift       = 0;
string commentIB = "Inside bar: OFF";

string   noteEB         = "����������";
int      EB_magic       = 2654;              //����� ��� EB
bool     ExternalBar    = false;             //������������ ������� ���
//input ushort   EB_TP          = 30;
//input ushort   EB_SL          = 30;
ushort   EB_slippage    = 5;
double   EB_volume      = 0.1;
string commentEB = "External bar: OFF";

 string   noteR          = "������";
 int      R_magic        = 0;              //����� ��� Rails
input bool     Rails          = false;             //������������ ������
//input bool     R_inversion    = false;             //��������
input ushort   expiration     = 4;                 //����� ���������� (����)
input double   R_volume       = 0.1;               //�����
input ushort   R_slippage     = 5;                 //���������������
input double   sl_mtp         = 1.61;              //��������� ��
input double   tp_mtp         = 1.61;              //��������� ��
input ushort   min_candle     = 1;                //����� ����� �������
input ushort   min_body_percent = 50;              //������� ���� ����� �� ����� �������� ���� �����
input ushort   offset         = 2;                 //����� ������ ������������ ���� �����

//breakeven parameters
//input ushort   percent        = 100;
//input ushort   points         = 20;
//**************************************

string commentRails = "Rails: OFF";
//---------------------variables------------------------->
string symbol = Symbol();
ENUM_TIMEFRAMES period = PERIOD_CURRENT;

datetime time;
datetime cTime[1];

//------------------------------------------------------------------------
//                                OnInit()
//------------------------------------------------------------------------
int OnInit(){

   if(InsideBar){
      IB_inp.magic      = IB_magic;
      IB_inp.symbol     = symbol;
      IB_inp.period     = period;
      IB_inp.oSession   = Open_Session;
      IB_inp.cSession   = Close_Session;
      IB_inp.TP         = IB_TP;
      IB_inp.SL         = IB_SL;
      IB_inp.slippage   = IB_slippage;
      IB_inp.volume     = IB_volume;
      IB_inp.MA_period  = MA_period;
      IB_inp.MA_shift   = MA_shift;
      
      insBar.Init(IB_inp);
      
      commentIB = "Inside bar: ON";
   }
   else
      commentIB = "Inside bar: OFF";
   
   if(ExternalBar){
      EB_inp.magic      = EB_magic;
      EB_inp.symbol     = symbol;
      EB_inp.period     = period;
      //EB_inp.TP         = EB_TP;
      //EB_inp.SL         = EB_SL;
      EB_inp.slippage   = EB_slippage;
      EB_inp.volume     = EB_volume;
      
      extBar.Init(EB_inp);
      
      commentEB = "External bar: ON";
   }
   else
      commentEB = "External bar: OFF";
   
   if(Rails){
      R_inp.magic       = R_magic;
      R_inp.period      = period;
      R_inp.symbol      = symbol;
      R_inp.min_candle  = min_candle;
      R_inp.min_body    = min_body_percent;
      R_inp.offset      = offset;
      R_inp.slippage    = R_slippage;
      R_inp.volume      = R_volume;
      R_inp.sl_mtp      = sl_mtp;
      R_inp.tp_mtp      = tp_mtp;
      //R_inp.inversion   = R_inversion;
      R_inp.expire      = expiration;
      
      rs.Init(R_inp);
      
      commentRails = "Rails: ON";
   }
   else
      commentRails = "Rails: OFF";

   return(INIT_SUCCEEDED);
}

//------------------------------------------------------------------------
//                                OnTick()
//------------------------------------------------------------------------
void OnTick(){
   /*Breakeven(percent, points);
   Comment(commentIB+"\n"+commentEB+"\n"+commentRails);
   */
   if(InsideBar){
      insBar.Action();
   }
   
   if(ExternalBar){
      extBar.Action();
   }
   
   if(Rails){
      rs.Action();
   }
   
   return;
}
