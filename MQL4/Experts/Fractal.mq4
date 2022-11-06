//+------------------------------------------------------------------+
//|                                                     Fractals.mq4 |
//|                                                               TO |
//|                         http://www.forex-tradexperts-to.narod.ru |
//+------------------------------------------------------------------+
#property copyright "TO"
#property link      "http://www.forex-tradexperts-to.narod.ru"

//#include <WinUser32.mqh>
#include <Breakeven.mqh>
extern int magic = 2599;
extern int TP_Fract_11=1000;
extern int SL_Fract_11=1000;
extern int custom_period_for_fract_11 = 21;
extern ushort BUcent = 100;      //�������� ��� ����������� ���������
extern ushort BUpoint = 5;       //�� ����� ������ ������������ ���������
extern int RSI_Top = 60;
extern int RSI_Bottom = 40;
extern ushort RSI_Period = 14;
extern int tofract=10;           //������ �� ��������, �� ������� ������������ �����
extern double lots=0.1;
int ID = 5452;            //����������� � ������

string symbol;
string com;    //����������� � ������
double spread; //�����
int custom;    //������ ��� ���������� ��������
int check;
datetime time;

double RSI;    //����� ���������� RSI

int init()
{
   time = 0;
   symbol = Symbol();
   com=DoubleToStr(ID,0);                          //�����������
   spread=MarketInfo(Symbol(),MODE_SPREAD)*Point;  //�����
   custom = custom_period_for_fract_11;            //������ ��� ���������� ��������
   check = (custom-1)/2+1;
   return(0);
}

int deinit()
{
   return(0);
}


bool order(double price,int type,string c,int m)
{
   int i;
   for(i=OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES); 
      if(OrderComment()==c && OrderMagicNumber()==m && OrderOpenPrice()==price && OrderType()==type)
         return(false);
      if(i==0)
         return(true);
   }   
   if(OrdersTotal()==0)
      return(true);
   return false;
}

int start(){
      if(time == Time[0])
         return;
      else
         time = Time[0];
      int i;
      RSI = iRSI(Symbol(), Period(), RSI_Period, PRICE_CLOSE, 1);       //������������� ����� ����������
      int fract_buy_11=iHighest(Symbol(), Period(),MODE_HIGH,custom,1);
      int fract_sell_11=iLowest(Symbol(), Period(),MODE_LOW,custom,1);            
      
     
      if(fract_buy_11==check)
      {
         if(OrdersTotal()==0)
            if(order(High[fract_buy_11]+tofract*Point+spread,4,com,magic) && RSI > RSI_Top)
               OrderSend(Symbol(),OP_BUYSTOP,lots,High[fract_buy_11]+tofract*Point+spread,10,High[fract_buy_11]+tofract*Point-SL_Fract_11*Point,High[fract_buy_11]+tofract*Point+spread+TP_Fract_11*Point,com,magic);

         for(i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);            
            if(i==0 && RSI > RSI_Top)if(order(High[fract_buy_11]+tofract*Point+spread,4,com,magic))
            {                  
               OrderSend(Symbol(),OP_BUYSTOP,lots,High[fract_buy_11]+tofract*Point+spread,10,High[fract_buy_11]+tofract*Point-SL_Fract_11*Point,High[fract_buy_11]+tofract*Point+spread+TP_Fract_11*Point,com,magic);
            }
         }      
      }      
      if( fract_sell_11==check)
      {
         if(OrdersTotal()==0)
            if(order(Low[fract_sell_11]-tofract*Point,5,com,magic) && RSI < RSI_Bottom)
               OrderSend(Symbol(),OP_SELLSTOP,lots,Low[fract_sell_11]-tofract*Point,10,Low[fract_sell_11]+spread-tofract*Point+SL_Fract_11*Point,Low[fract_sell_11]-tofract*Point-TP_Fract_11*Point,com,magic);
         
         for(i=OrdersTotal()-1;i>=0;i--)
         {
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(i==0 && RSI < RSI_Bottom)if(order(Low[fract_sell_11]-tofract*Point,5,com,magic)) 
            {                
               OrderSend(Symbol(),OP_SELLSTOP,lots,Low[fract_sell_11]-tofract*Point,10,Low[fract_sell_11]+spread-tofract*Point+SL_Fract_11*Point,Low[fract_sell_11]-tofract*Point-TP_Fract_11*Point,com,magic);
            }
         }      
      }      
      Breakeven(magic, BUcent, BUpoint);
   return(0);
}